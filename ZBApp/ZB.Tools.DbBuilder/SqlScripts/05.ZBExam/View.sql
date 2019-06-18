USE [$(DatabaseName)]
GO

BEGIN TRANSACTION

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[WebExamExamineeCountView]'))
DROP VIEW [WebExamExamineeCountView]
GO
CREATE VIEW [WebExamExamineeCountView]
AS
SELECT				WebExamId,
					COUNT(*) AS WebExamineeCount
FROM				WebExaminee GROUP BY WebExamId
GO

print '--------------------��ѯ���翼����ͼ------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[SQ_ExamView]'))
DROP VIEW [dbo].[SQ_ExamView]
GO
CREATE VIEW [dbo].[SQ_ExamView]
AS
SELECT
			WebExam.Id,
			WebExam.ExamGroupName,															--������
			WebExam.ObjectName,																--��������
			WebExam.DeptId,																	--�������ڵĲ���
			WebExam.CreatorId,																--���Է�����Id
			WebExam.CreatorName,															--���Է���������
			WebExam.ExamMode,																--������ʽ(0��ͳһ���� 1���浽�濼)
			WebExam.ExamState,																--����״̬(0������ 1�������� 2���տ�)
			WebExam.StartTime,																--����ʱ��		
			WebExam.ExamTimeSpan,															--ʱ�������ӣ�
			WebExam.CloseTime,																--�տ�ʱ��
			ABS(DATEDIFF(Day,GetDate(),WebExam.StartTime)) AS RecIndex,						--��������
			ISNULL(WebExamExamineeCountView.WebExamineeCount,0) AS WebExamineeCount,		--��������
			dbo.WebExam.PaperMode,															--�þ�ʽ
			ISNULL(EmployeeBaseInfoView.EmployeeId,0) AS EmployeeId,
			(SELECT COUNT(1) FROM WebExamineePaper WP WHERE WP.WebExamId=WebExam.Id AND WP.PaperReplyState=30 AND (WP.Score+wp.AddedScore)>=WebExam.PassScore) AS PassCount,
			WorkId															
FROM		WebExam 
LEFT OUTER JOIN WebExamExamineeCountView ON WebExam.Id = WebExamExamineeCountView.WebExamId
LEFT JOIN EmployeeBaseInfoView ON WebExam.CreatorId =EmployeeBaseInfoView.EmployeeId
GO

print '--------------------��ѯ�������⿨��ͼ------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SQ_WebExamineePaperView]'))
DROP VIEW [SQ_WebExamineePaperView]
GO
CREATE VIEW [SQ_WebExamineePaperView]
AS
SELECT				WebExamineePaper.Id,										
					WebExamineePaper.WebExamineeId,																--��ԱId
					WebExamineePaper.WebExamId,																	--���翼��Id
					WebExamineePaper.JoinTime,																	--����ʱ��
					WebExamineePaper.SubmitTime,																--����ʱ��
					WebExamineePaper.ReplyTimeSpan,																--���ʱ��
					WebExamineePaper.PaperReplyState,															--����״̬
                    WebExamineePaper.Score,																		--�÷�
					WebExamineePaper.AddedScore,																--�ӷ�
					WebExamineePaper.CloseTime,																	--���Խ���ʱ��
					WebExaminee.EmployeeId,																		--��ԱId
					WebExaminee.EmployeeNO,																		--��Ա���
					WebExaminee.EmployeeName,																	--����
					WebExaminee.DeptFullPath,																	--����
					WebExaminee.PostName,																		--��λ
					WebExaminee.Age,																			--����
					WebExaminee.Sex,																			--�Ա�
					CASE WHEN (WebExamineePaper.Score + WebExamineePaper.AddedScore) > WebExamineePaper.WebExamTotalScore
					THEN WebExamineePaper.WebExamTotalScore
					ELSE (WebExamineePaper.Score + WebExamineePaper.AddedScore) END AS EmployeeTotalScore			--�ܷ�
FROM         WebExaminee INNER JOIN
             WebExamineePaper ON WebExaminee.Id = WebExamineePaper.WebExamineeId
GO

print '--------------------��ѯ׼���μӵĿ�����ͼ------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SQ_WaitingExamView]'))
DROP VIEW [SQ_WaitingExamView]
GO
CREATE VIEW [SQ_WaitingExamView]
AS
SELECT				WebExam.Id AS WebExamId,													--����Id
					WebExam.ObjectName,															--��������
					WebExam.ExamState,															--����״̬
					WebExam.DeptFullPath,														--����
					WebExam.StartTime,															--����ʱ��
					ABS(DATEDIFF(Day,GetDate(),WebExam.StartTime)) AS RecIndex,					--��������
					ISNULL(dbo.WebExamineePaper.CloseTime, dbo.WebExam.CloseTime) AS CloseTime,	--�տ�ʱ��
					WebExam.ExamTimeSpan,														--ʱ��
					WebExam.ExamMode,															--������ʽ
					WebExam.PaperMode,															--�þ�ʽ
					WebExam.IsNeedFaceMatch,													--�Ƿ���Ҫ���������ȶ�.
					WebExam.TotalScore,															--�Ծ��ܷ�
					WebExam.PassScore,															--�ϸ��
					WebExaminee.Id AS WebExamineeId,											--����Id
					WebExaminee.EmployeeId,														--��ԱId
					WebExaminee.EmployeeNO,														--�������Ժ�
					--��������
					(SELECT COUNT(*) FROM WebExaminee WHERE WebExamId = WebExam.Id) AS WebExamineeCount		
FROM			WebExam INNER JOIN 
				WebExaminee ON WebExam.Id = WebExaminee.WebExamId LEFT JOIN
				WebExamineePaper ON WebExamineePaper.WebExamineeId = WebExaminee.Id
				WHERE WebExam.ExamState = 0 or WebExamineePaper.PaperReplyState < 11
GO


print '--------------------�����ɼ���ͼ------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[WebExamineePaperView]'))
DROP VIEW [WebExamineePaperView]
GO
CREATE VIEW [WebExamineePaperView]
AS
SELECT				WebExamineePaper.WebExamineeId,															--����Id
					WebExamineePaper.WebExamId,
					WebExamineePaper.CloseTime,																--�տ�ʱ��
					CASE WHEN (WebExamineePaper.Score + WebExamineePaper.AddedScore) > WebExamineePaper.WebExamTotalScore 
					THEN WebExamineePaper.WebExamTotalScore 
					ELSE (WebExamineePaper.Score + WebExamineePaper.AddedScore) END AS EmployeeTotalScore,		--�����ܳɼ�
					WebExamineePaper.PaperReplyState														--����״̬
FROM			WebExamineePaper
GO

print '--------------------��ѯ�ѲμӵĿ�����ͼ------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SQ_JoinedExamView]'))
DROP VIEW [SQ_JoinedExamView]
GO
CREATE VIEW [SQ_JoinedExamView]
AS
SELECT				WebExam.Id AS WebExamId,													--����Id
					WebExam.ObjectName,															--��������
					WebExam.ExamState,															--����״̬
					WebExam.DeptFullPath,														--����
					WebExam.IsShowPaperResult,													--�Ƿ���������Ծ�
					WebExam.StartTime,															--����ʱ��
					WebExamineePaperView.CloseTime,												--�տ�ʱ��
					ABS(DATEDIFF(Day,GetDate(),WebExam.StartTime)) AS RecIndex,					--��������
					WebExam.ExamTimeSpan,														--ʱ��
					WebExam.ExamMode,															--������ʽ
					WebExam.PaperMode,															--�þ�ʽ
					WebExam.TotalScore,															--�Ծ��ܷ�
					WebExam.PassScore,															--�ϸ��
					WebExaminee.Id AS WebExamineeId,											--����Id
					WebExaminee.EmployeeId,														--��ԱId
					WebExaminee.EmployeeNO,														--�������Ժ�
					--��������
					(SELECT COUNT(*) FROM WebExaminee WHERE WebExamId = WebExam.Id) AS WebExamineeCount,
					--����״̬��ʾ
					(SELECT CASE WebExamineePaperView.PaperReplyState WHEN 20 THEN '�ľ���' WHEN 40 THEN 'ȱ��' WHEN 50 THEN '����' WHEN 60 THEN '����'
					ELSE Convert(NVARCHAR(20),WebExamineePaperView.EmployeeTotalScore) END) AS StateShow,
					--ƽ����
					(SELECT AVG(EmployeeTotalScore) FROM WebExamineePaperView WHERE WebExamId = WebExam.Id) AS AvgScore,
					--�ϸ���
					(SELECT (SELECT CONVERT(DECIMAL,COUNT(*)) FROM WebExamineePaperView WHERE WebExamId = WebExam.Id AND EmployeeTotalScore > WebExam.PassScore) / (SELECT COUNT(*) FROM WebExaminee WHERE WebExamId = WebExam.Id)) AS PassRate,
					--����(�������ɷ�ʽ:�ɼ��ظ�ʱ�������ο�ȱ)
					(SELECT CASE WHEN 
					(WebExamineePaperView.PaperReplyState = 20 OR WebExamineePaperView.PaperReplyState = 40 OR WebExamineePaperView.PaperReplyState = 50 OR WebExamineePaperView.PaperReplyState = 60) THEN -1 
					ELSE
					(SELECT b.px FROM (SELECT WebExamineeId, px = (SELECT COUNT(EmployeeTotalScore) FROM WebExamineePaperView WHERE WebExamineePaperView.PaperReplyState NOT IN(20,40,50,60) AND WebExamId = WebExam.Id AND EmployeeTotalScore > a.EmployeeTotalScore) + 1 FROM WebExamineePaperView a WHERE WebExamId = WebExam.Id) b WHERE b.WebExamineeId = WebExamineePaperView.WebExamineeId) 
					END) AS LevelSortIndex
FROM			WebExam INNER JOIN 
				WebExaminee ON WebExam.Id = WebExaminee.WebExamId INNER JOIN
				WebExamineePaperView ON WebExamineePaperView.WebExamineeId = WebExaminee.Id
				WHERE WebExamineePaperView.PaperReplyState > 10
GO

print '--------------------��ѯ�������Ŀ�����ͼ------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SQ_ManageExamView]'))
DROP VIEW [SQ_ManageExamView]
GO
CREATE VIEW [SQ_ManageExamView]
AS
SELECT				WebExam.Id AS WebExamId,													--����Id
					WebExam.ObjectName,															--��������
					WebExam.ExamState,															--����״̬
					WebExam.DeptFullPath,														--����
					WebExam.StartTime,															--����ʱ��
					WebExam.CloseTime,															--�տ�ʱ��
					ABS(DATEDIFF(Day,GetDate(),WebExam.StartTime)) AS RecIndex,					--��������
					WebExam.ExamTimeSpan,														--ʱ��
					WebExam.ExamMode,															--������ʽ
					WebExam.PaperMode,															--�þ�ʽ
					WebExam.TotalScore,															--�Ծ��ܷ�
					WebExam.PassScore,															--�ϸ��
					WebExamStaff.EmployeeId,													--������Ա����ԱId
					--��������
					(SELECT COUNT(*) FROM WebExaminee WHERE WebExamId = WebExam.Id) AS WebExamineeCount,
					--ƽ����
					(SELECT AVG(EmployeeTotalScore) FROM WebExamineePaperView WHERE WebExamId = WebExam.Id) AS AvgScore,
					--�ϸ���
					(SELECT (SELECT CONVERT(DECIMAL,COUNT(*)) FROM WebExamineePaperView WHERE WebExamId = WebExam.Id AND EmployeeTotalScore > WebExam.PassScore) / (CASE WHEN EXISTS(SELECT 1 FROM WebExaminee WHERE WebExamId = WebExam.Id) THEN (SELECT COUNT(*) FROM WebExaminee WHERE WebExamId = WebExam.Id) ELSE 1 END)) PassRate
FROM			WebExam INNER JOIN 
				WebExamStaff ON WebExam.Id = WebExamStaff.WebExamId
GO


print '--------------------�����μӿ��Ե���ϸ��Ϣ��ͼ���ṩ������ϵͳ�ӱ�ϵͳ��ȡ������Ϣ(��Ҫ���޸�)------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[ExamineeInfoView]'))
DROP VIEW [ExamineeInfoView]
GO
CREATE VIEW [ExamineeInfoView]
AS
	SELECT
	E.ObjectName AS '��������'
	,(CASE WHEN E.PaperMode = 0 THEN 'ͳһ����' ELSE '�浽�濼' END) AS '������ʽ'
	,(CASE WHEN E.ExamMode = 0 THEN '�����Ծ�' WHEN E.ExamMode = 1 THEN 'AB��' ELSE '���˶��' END) AS '�Ծ�����'
	,EX.EmployeeNO AS '����'
	,EX.EmployeeNO AS '��Ա���'
	,EX.EmployeeName AS '����'
	,EX.DeptFullPath AS '����'
	,EX.PostName AS '��λ'
	,EP.JoinTime AS '���⿪ʼʱ��'
	,EP.SubmitTime AS '�������ʱ��'
	,EP.CloseTime AS '�ӳ�����ʱ��'
	,(CASE PaperReplyState 
		WHEN 0 THEN '�ѱ���'
		WHEN 10 THEN '���ڴ���'
		WHEN 20 THEN '�ѽ���'
		WHEN 30 THEN '������'
		WHEN 40 THEN 'ȱ��'
		WHEN 50 THEN '����'
	  END
	 )AS '����״̬'
	,Score+AddedScore AS '����'
	,E.PassScore AS '�ϸ��'
	FROM WebExaminee EX
	JOIN WebExamineePaper EP ON EX.Id = EP.WebExamineeId
	JOIN WebExam E ON EX.WebExamId = E.Id
GO
print '--------------------֪ʶ��÷�����ͼ------------------------------------'
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SQ_WebExamineePaperReportView]'))
DROP VIEW [SQ_WebExamineePaperReportView]
GO
CREATE VIEW [SQ_WebExamineePaperReportView]
	AS		
	SELECT DV.FullPath AS DeptFullPath,DV.Depth,DV.FullPath+'/' AS DeptFullPath_Search, WEP.*,WE.EmployeeId FROM WebExamineePaper WEP
	JOIN WebExaminee WE ON WEP.WebExamineeId = WE.Id
	JOIN DeptView DV ON WE.DeptId = DV.Id
GO

COMMIT TRANSACTION