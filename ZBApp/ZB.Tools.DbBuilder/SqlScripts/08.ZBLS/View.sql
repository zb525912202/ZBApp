USE [$(DatabaseName)]
GO
print '--------------------2014/5/16��ѯ�γ��б����ͼ �Ȼ���--------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SQ_LessonManagerView]'))
DROP VIEW [SQ_LessonManagerView]
GO
	CREATE VIEW [dbo].[SQ_LessonManagerView]
	AS
	SELECT 	Lesson.*,
			LFolder.FullPath AS LFolderFullPath,
			DeptView.FullPath AS DeptFullPath,
			DeptView.Id AS DeptId,
			ISNULL(EmployeeView.Id,0) AS EmployeeId,
			PostStandardView.ObjectName AS PostStandardName,
			PostStandardLevelView.ObjectName AS StandardLevelName				
	FROM Lesson
	INNER JOIN LFolder ON Lesson.FolderId=LFolder.Id
	INNER JOIN DeptView ON LFolder.DeptId=DeptView.Id
	LEFT JOIN EmployeeView ON Lesson.CreatorId =EmployeeView.Id
	LEFT JOIN PostStandardView ON Lesson.StandardId = PostStandardView.Id
	LEFT JOIN PostStandardLevelView ON Lesson.LevelId = PostStandardLevelView.Id
GO

print '--------------------2015/2/4��ѯ��������ѵ���б����ͼ �￭--------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SQ_NetClassManagerView]'))
DROP VIEW [SQ_NetClassManagerView]
GO
CREATE VIEW [SQ_NetClassManagerView]
AS
	SELECT NetClass.*,
		DeptView.FullPath AS DeptFullPath,
		CASE 					
		WHEN DATEDIFF(DAY,NetClass.EndDate,GetDate())>0 THEN 30
		WHEN DATEDIFF(DAY,NetClass.StartDate,GetDate())<0 THEN 10 
		ELSE 20																			--������ж��߼���ѧϰ������Ĳ�ͬ,�õ���DAY
		END AS NetClassEndState,
		ISNULL(EmployeeView.Id,0) AS EmployeeId,
		(SELECT COUNT(1) FROM NetClassTrainee WHERE NetClassId=NetClass.Id) AS EmployeeCount,
		(SELECT COUNT(1) FROM NetClassPassInfo NCP
		JOIN  NetClassTrainee NCT ON NCP.EmployeeId=NCT.EmployeeId AND NCT.NetClassId=NCP.NetClassId
		WHERE NCT.NetClassId=NetClass.Id AND NetClassPassTime IS NOT NULL) AS PassCount
	FROM      NetClass
	LEFT JOIN DeptView ON NetClass.DeptId = DeptView.Id
	LEFT JOIN EmployeeView ON NetClass.CreatorId =EmployeeView.Id
GO

print '--------------------��ⲿ����ͼ------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[DeptBaseInfoView]'))
DROP VIEW [dbo].[DeptBaseInfoView]
GO
CREATE VIEW [dbo].[DeptBaseInfoView]
AS
SELECT				Id,																			--Id
					ObjectName,																	--����
					ParentId,																	--������Id
					FullPath,																	--����ȫ·��
					FullPath + '/' AS DeptFullPath_Search,										--��ѯ�Ӳ�����
					SortIndex,																	--����
					Depth,																		--�������ڵ����
					DeptType																	--��������
					FROM [$(ZBCommonDatabaseName)].[dbo].[Dept]
GO


print '--------------------�γ���Ա��ͼ------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[LessonTraineeView]'))
DROP VIEW [dbo].[LessonTraineeView]
GO
CREATE VIEW [dbo].[LessonTraineeView]
AS
SELECT LT.*,LP.LessonStartTime FROM LessionTrainee LT 
LEFT JOIN LessonPassInfo LP ON LT.LessionId = LP.LessonId AND LT.EmployeeId=LP.EmployeeId
GO



print '--------------------�γ̿��Կ�����ͼ------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[LessonExamineeInfoView]'))
DROP VIEW [dbo].[LessonExamineeInfoView]
GO
CREATE VIEW [dbo].[LessonExamineeInfoView]
AS
	SELECT LE.*, LEP.JoinTime, LEP.SubmitTime, LEP.ReplyTimeSpan, LEP.Score, LEP.CloseTime,LEP.OfflineScore,
	EV.EmployeeNO, EV.ObjectName AS EmployeeName, ISNULL(EV.Sex,0) AS Sex, DV.FullPath AS DeptFullPath, PV.ObjectName AS PostName
	FROM (
		SELECT MAX(Id) AS Id FROM LessonExaminee 
		GROUP BY EmployeeId,LessonId
	) A
	JOIN LessonExaminee LE ON LE.Id = A.Id
	LEFT JOIN LessonWebExamineePaper LEP ON LEP.LessonId = LE.LessonId AND LEP.LessonExamineeId = LE.Id
	LEFT JOIN EmployeeView EV ON EV.Id = LE.EmployeeId
	LEFT JOIN DeptView DV ON DV.Id = EV.DeptId
	LEFT JOIN PostView PV ON PV.Id = EV.PostId
GO



PRINT '--------------------������ѵ�����ͼ------------------------------------'
IF EXISTS (SELECT * FROM sys.views WHERE object_id=OBJECT_ID(N'[SQ_ChaoHuTrainingOnWorkResultByDept]'))
DROP VIEW [SQ_ChaoHuTrainingOnWorkResultByDept]
GO
CREATE VIEW [SQ_ChaoHuTrainingOnWorkResultByDept]
AS
SELECT L.ObjectName AS WorkName,
'�γ�' AS WorkType,
LP.LessonStartTime AS StartTime,
LP.LessonPassTime AS EndTime,
LE.IsPass,
DV.SortIndex AS DeptSortIndex,
('���Ͽ���'+CONVERT(varchar(10), LEP.Score)+'��'+(CASE LEPP.IncludeOffline WHEN 1 THEN (',���¿���'+CONVERT(VARCHAR(10),LEP.OfflineScore)+'��') ELSE '' END)+ISNULL(',ȡ��'+ECV.CertTypeName+'֤��','')) AS TrainingResult,
EV.EmployeeNO,EV.ObjectName AS EmployeeName,DV.FullPath  AS DeptName,PV.ObjectName AS PostName,DV.Depth,DV.DeptFullPath_Search
FROM LessonPassInfo LP
JOIN LessonExaminee LE ON LP.EmployeeId = LE.EmployeeId AND LP.LessonId = LE.LessonId
JOIN Lesson L ON LP.LessonId = L.Id
JOIN LessonExamPaperPackage LEPP ON LEPP.LessonId=L.Id
JOIN LessonWebExamineePaper LEP ON LEP.LessonId = LE.LessonId AND LEP.LessonExamineeId = LE.Id
LEFT JOIN EmmployeeCertInfoView ECV ON ECV.EmployeeId = LP.EmployeeId
INNER JOIN EmployeeView EV ON LP.EmployeeId = EV.Id
LEFT JOIN PostView PV ON EV.PostId = PV.Id
LEFT JOIN DeptView DV ON EV.DeptId = DV.Id
GO