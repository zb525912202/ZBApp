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

print '--------------------查询网络考试视图------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[SQ_ExamView]'))
DROP VIEW [dbo].[SQ_ExamView]
GO
CREATE VIEW [dbo].[SQ_ExamView]
AS
SELECT
			WebExam.Id,
			WebExam.ExamGroupName,															--考试组
			WebExam.ObjectName,																--考试名称
			WebExam.DeptId,																	--考试所在的部门
			WebExam.CreatorId,																--考试发起人Id
			WebExam.CreatorName,															--考试发起人姓名
			WebExam.ExamMode,																--考试形式(0、统一开考 1、随到随考)
			WebExam.ExamState,																--考试状态(0、备考 1、进行中 2、闭考)
			WebExam.StartTime,																--开考时间		
			WebExam.ExamTimeSpan,															--时长（分钟）
			WebExam.CloseTime,																--闭考时间
			ABS(DATEDIFF(Day,GetDate(),WebExam.StartTime)) AS RecIndex,						--排序索引
			ISNULL(WebExamExamineeCountView.WebExamineeCount,0) AS WebExamineeCount,		--考生人数
			dbo.WebExam.PaperMode,															--用卷方式
			ISNULL(EmployeeBaseInfoView.EmployeeId,0) AS EmployeeId,
			(SELECT COUNT(1) FROM WebExamineePaper WP WHERE WP.WebExamId=WebExam.Id AND WP.PaperReplyState=30 AND (WP.Score+wp.AddedScore)>=WebExam.PassScore) AS PassCount,
			WorkId															
FROM		WebExam 
LEFT OUTER JOIN WebExamExamineeCountView ON WebExam.Id = WebExamExamineeCountView.WebExamId
LEFT JOIN EmployeeBaseInfoView ON WebExam.CreatorId =EmployeeBaseInfoView.EmployeeId
GO

print '--------------------查询考生答题卡视图------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SQ_WebExamineePaperView]'))
DROP VIEW [SQ_WebExamineePaperView]
GO
CREATE VIEW [SQ_WebExamineePaperView]
AS
SELECT				WebExamineePaper.Id,										
					WebExamineePaper.WebExamineeId,																--人员Id
					WebExamineePaper.WebExamId,																	--网络考试Id
					WebExamineePaper.JoinTime,																	--答题时间
					WebExamineePaper.SubmitTime,																--交卷时间
					WebExamineePaper.ReplyTimeSpan,																--答卷时长
					WebExamineePaper.PaperReplyState,															--考生状态
                    WebExamineePaper.Score,																		--得分
					WebExamineePaper.AddedScore,																--加分
					WebExamineePaper.CloseTime,																	--考试结束时间
					WebExaminee.EmployeeId,																		--人员Id
					WebExaminee.EmployeeNO,																		--人员编号
					WebExaminee.EmployeeName,																	--姓名
					WebExaminee.DeptFullPath,																	--部门
					WebExaminee.PostName,																		--岗位
					WebExaminee.Age,																			--年龄
					WebExaminee.Sex,																			--性别
					CASE WHEN (WebExamineePaper.Score + WebExamineePaper.AddedScore) > WebExamineePaper.WebExamTotalScore
					THEN WebExamineePaper.WebExamTotalScore
					ELSE (WebExamineePaper.Score + WebExamineePaper.AddedScore) END AS EmployeeTotalScore			--总分
FROM         WebExaminee INNER JOIN
             WebExamineePaper ON WebExaminee.Id = WebExamineePaper.WebExamineeId
GO

print '--------------------查询准备参加的考试视图------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SQ_WaitingExamView]'))
DROP VIEW [SQ_WaitingExamView]
GO
CREATE VIEW [SQ_WaitingExamView]
AS
SELECT				WebExam.Id AS WebExamId,													--考试Id
					WebExam.ObjectName,															--考试名称
					WebExam.ExamState,															--考试状态
					WebExam.DeptFullPath,														--部门
					WebExam.StartTime,															--开考时间
					ABS(DATEDIFF(Day,GetDate(),WebExam.StartTime)) AS RecIndex,					--排序索引
					ISNULL(dbo.WebExamineePaper.CloseTime, dbo.WebExam.CloseTime) AS CloseTime,	--闭考时间
					WebExam.ExamTimeSpan,														--时长
					WebExam.ExamMode,															--考试形式
					WebExam.PaperMode,															--用卷方式
					WebExam.IsNeedFaceMatch,													--是否需要进行人脸比对.
					WebExam.TotalScore,															--试卷总分
					WebExam.PassScore,															--合格分
					WebExaminee.Id AS WebExamineeId,											--考生Id
					WebExaminee.EmployeeId,														--人员Id
					WebExaminee.EmployeeNO,														--考生考试号
					--考生人数
					(SELECT COUNT(*) FROM WebExaminee WHERE WebExamId = WebExam.Id) AS WebExamineeCount		
FROM			WebExam INNER JOIN 
				WebExaminee ON WebExam.Id = WebExaminee.WebExamId LEFT JOIN
				WebExamineePaper ON WebExamineePaper.WebExamineeId = WebExaminee.Id
				WHERE WebExam.ExamState = 0 or WebExamineePaper.PaperReplyState < 11
GO


print '--------------------考生成绩视图------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[WebExamineePaperView]'))
DROP VIEW [WebExamineePaperView]
GO
CREATE VIEW [WebExamineePaperView]
AS
SELECT				WebExamineePaper.WebExamineeId,															--考生Id
					WebExamineePaper.WebExamId,
					WebExamineePaper.CloseTime,																--闭考时间
					CASE WHEN (WebExamineePaper.Score + WebExamineePaper.AddedScore) > WebExamineePaper.WebExamTotalScore 
					THEN WebExamineePaper.WebExamTotalScore 
					ELSE (WebExamineePaper.Score + WebExamineePaper.AddedScore) END AS EmployeeTotalScore,		--考生总成绩
					WebExamineePaper.PaperReplyState														--考生状态
FROM			WebExamineePaper
GO

print '--------------------查询已参加的考试视图------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SQ_JoinedExamView]'))
DROP VIEW [SQ_JoinedExamView]
GO
CREATE VIEW [SQ_JoinedExamView]
AS
SELECT				WebExam.Id AS WebExamId,													--考试Id
					WebExam.ObjectName,															--考试名称
					WebExam.ExamState,															--考试状态
					WebExam.DeptFullPath,														--部门
					WebExam.IsShowPaperResult,													--是否允许查阅试卷
					WebExam.StartTime,															--开考时间
					WebExamineePaperView.CloseTime,												--闭考时间
					ABS(DATEDIFF(Day,GetDate(),WebExam.StartTime)) AS RecIndex,					--排序索引
					WebExam.ExamTimeSpan,														--时长
					WebExam.ExamMode,															--考试形式
					WebExam.PaperMode,															--用卷方式
					WebExam.TotalScore,															--试卷总分
					WebExam.PassScore,															--合格分
					WebExaminee.Id AS WebExamineeId,											--考生Id
					WebExaminee.EmployeeId,														--人员Id
					WebExaminee.EmployeeNO,														--考生考试号
					--考生人数
					(SELECT COUNT(*) FROM WebExaminee WHERE WebExamId = WebExam.Id) AS WebExamineeCount,
					--考生状态显示
					(SELECT CASE WebExamineePaperView.PaperReplyState WHEN 20 THEN '阅卷中' WHEN 40 THEN '缺考' WHEN 50 THEN '作弊' WHEN 60 THEN '代考'
					ELSE Convert(NVARCHAR(20),WebExamineePaperView.EmployeeTotalScore) END) AS StateShow,
					--平均分
					(SELECT AVG(EmployeeTotalScore) FROM WebExamineePaperView WHERE WebExamId = WebExam.Id) AS AvgScore,
					--合格率
					(SELECT (SELECT CONVERT(DECIMAL,COUNT(*)) FROM WebExamineePaperView WHERE WebExamId = WebExam.Id AND EmployeeTotalScore > WebExam.PassScore) / (SELECT COUNT(*) FROM WebExaminee WHERE WebExamId = WebExam.Id)) AS PassRate,
					--名次(名次生成方式:成绩重复时保留名次空缺)
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

print '--------------------查询参与管理的考试视图------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SQ_ManageExamView]'))
DROP VIEW [SQ_ManageExamView]
GO
CREATE VIEW [SQ_ManageExamView]
AS
SELECT				WebExam.Id AS WebExamId,													--考试Id
					WebExam.ObjectName,															--考试名称
					WebExam.ExamState,															--考试状态
					WebExam.DeptFullPath,														--部门
					WebExam.StartTime,															--开考时间
					WebExam.CloseTime,															--闭考时间
					ABS(DATEDIFF(Day,GetDate(),WebExam.StartTime)) AS RecIndex,					--排序索引
					WebExam.ExamTimeSpan,														--时长
					WebExam.ExamMode,															--考试形式
					WebExam.PaperMode,															--用卷方式
					WebExam.TotalScore,															--试卷总分
					WebExam.PassScore,															--合格分
					WebExamStaff.EmployeeId,													--工作人员的人员Id
					--考生人数
					(SELECT COUNT(*) FROM WebExaminee WHERE WebExamId = WebExam.Id) AS WebExamineeCount,
					--平均分
					(SELECT AVG(EmployeeTotalScore) FROM WebExamineePaperView WHERE WebExamId = WebExam.Id) AS AvgScore,
					--合格率
					(SELECT (SELECT CONVERT(DECIMAL,COUNT(*)) FROM WebExamineePaperView WHERE WebExamId = WebExam.Id AND EmployeeTotalScore > WebExam.PassScore) / (CASE WHEN EXISTS(SELECT 1 FROM WebExaminee WHERE WebExamId = WebExam.Id) THEN (SELECT COUNT(*) FROM WebExaminee WHERE WebExamId = WebExam.Id) ELSE 1 END)) PassRate
FROM			WebExam INNER JOIN 
				WebExamStaff ON WebExam.Id = WebExamStaff.WebExamId
GO


print '--------------------考生参加考试的详细信息视图，提供给其他系统从本系统获取考试信息(不要做修改)------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[ExamineeInfoView]'))
DROP VIEW [ExamineeInfoView]
GO
CREATE VIEW [ExamineeInfoView]
AS
	SELECT
	E.ObjectName AS '考试名称'
	,(CASE WHEN E.PaperMode = 0 THEN '统一开考' ELSE '随到随考' END) AS '开考方式'
	,(CASE WHEN E.ExamMode = 0 THEN '单份试卷' WHEN E.ExamMode = 1 THEN 'AB卷' ELSE '多人多卷' END) AS '试卷类型'
	,EX.EmployeeNO AS '考号'
	,EX.EmployeeNO AS '人员编号'
	,EX.EmployeeName AS '姓名'
	,EX.DeptFullPath AS '部门'
	,EX.PostName AS '岗位'
	,EP.JoinTime AS '答题开始时间'
	,EP.SubmitTime AS '答题结束时间'
	,EP.CloseTime AS '延长交卷时间'
	,(CASE PaperReplyState 
		WHEN 0 THEN '已报名'
		WHEN 10 THEN '正在答题'
		WHEN 20 THEN '已交卷'
		WHEN 30 THEN '已评分'
		WHEN 40 THEN '缺考'
		WHEN 50 THEN '作弊'
	  END
	 )AS '考生状态'
	,Score+AddedScore AS '考分'
	,E.PassScore AS '合格分'
	FROM WebExaminee EX
	JOIN WebExamineePaper EP ON EX.Id = EP.WebExamineeId
	JOIN WebExam E ON EX.WebExamId = E.Id
GO
print '--------------------知识点得分率视图------------------------------------'
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