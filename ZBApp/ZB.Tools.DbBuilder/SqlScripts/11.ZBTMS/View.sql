print '--------------------项目库列表视图------------------------------------'
GO
IF EXISTS (SELECT * FROM sys.views WHERE object_id=OBJECT_ID(N'[SQ_ProjectLibrary]'))
DROP VIEW [SQ_ProjectLibrary]
GO
CREATE VIEW [SQ_ProjectLibrary]
AS
	SELECT ProjectLibrary.* ,
	(SELECT COUNT(*) FROM ProjectPeriod WHERE ProjectPeriod.ProjectId = ProjectLibrary.Id) AS Period,
	PlanProject.ProjectStatus,
	PlanProject.TrainingPlanId AS PlanId,
	PlanProject.TemporaryPlan,
	TrainingYearPlan.OpenBudget,
	TrainingYearPlan.DeptFullPath,
	TrainingYearPlan.PlanYear,
	TrainingYearPlan.PlanStage
	FROM ProjectLibrary
	LEFT JOIN PlanProject ON ProjectLibrary.Id = PlanProject.ProjectId
	LEFT JOIN TrainingYearPlan ON PlanProject.TrainingPlanId = TrainingYearPlan.Id
GO

PRINT '--------------------项目培训分类视图------------------------------------'
IF EXISTS (SELECT * FROM sys.views WHERE object_id=OBJECT_ID(N'[SQ_ProjectTrainingCategory]'))
DROP VIEW [SQ_ProjectTrainingCategory]
GO
CREATE VIEW [SQ_ProjectTrainingCategory]
AS
	SELECT PTC.*, TC.ObjectName AS CategoryName, TC.Dimension, TC.FullPath 
	FROM ProjectTrainingCategory AS PTC LEFT JOIN TrainingCategory AS TC 
	ON PTC.CategoryId = TC.Id
GO



PRINT '--------------------培训事务列表视图------------------------------------'
IF EXISTS (SELECT * FROM sys.views WHERE object_id=OBJECT_ID(N'[SQ_TrainingOnWork]'))
DROP VIEW [SQ_TrainingOnWork]
GO
CREATE VIEW [dbo].[SQ_TrainingOnWork]
AS
	SELECT TrainingOnWork.*,'' AS LevelName,TrainingOnWorkType.ObjectName AS ProjectTypeName
	FROM TrainingOnWork LEFT JOIN TrainingOnWorkType 
	ON TrainingOnWork.ProjectType1 = TrainingOnWorkType.Id
GO


PRINT '--------------------培训事务培训分类视图------------------------------------'
IF EXISTS (SELECT * FROM sys.views WHERE object_id=OBJECT_ID(N'[SQ_TrainingOnWorkCategory]'))
DROP VIEW [SQ_TrainingOnWorkCategory]
GO
CREATE VIEW [dbo].[SQ_TrainingOnWorkCategory]
AS
	SELECT TWC.*, TC.ObjectName AS CategoryName, TC.Dimension, TC.FullPath 
	FROM TrainingOnWorkCategory AS TWC 
	LEFT JOIN TrainingCategory AS TC ON TWC.CategoryId = TC.Id
GO

PRINT '--------------------考试违规列表视图------------------------------------'
IF EXISTS (SELECT * FROM sys.views WHERE object_id=OBJECT_ID(N'[SQ_ExamViolation]'))
DROP VIEW [SQ_ExamViolation]
GO

CREATE VIEW [dbo].[SQ_ExamViolation]
AS
	SELECT CV.*, TE.EmployeeId, TE.EmployeeNO, TE.EmployeeName, TE.DeptId, TE.DeptName
	FROM ExamViolation AS CV
	INNER JOIN TrainingOnWorkEmployee AS TE ON CV.TWEmployeeId=TE.Id
GO




PRINT '--------------------项目人员费用报表------------------------------------'
IF EXISTS (SELECT * FROM sys.views WHERE object_id=OBJECT_ID(N'[SQ_ProjectBillByEmployeeReportView]'))
DROP VIEW [SQ_ProjectBillByEmployeeReportView]
GO
CREATE view [dbo].[SQ_ProjectBillByEmployeeReportView]
as
SELECT  TW.TrainingProjectId, TBD.*,TWB.BillType,TWB.BillCategory2
		FROM EmployeeTrainingBillDetail TBD
		INNER JOIN TrainingWorkBill TWB ON TBD.BillId = TWB.Id
		INNER JOIN TrainingOnWork TW ON TBD.WorkId=TW.Id
GO


PRINT '--------------------培训学员------------------------------------'
IF EXISTS (SELECT * FROM sys.views WHERE object_id=OBJECT_ID(N'[SQL_TrainingOnWorkEmployee]'))
DROP VIEW [SQL_TrainingOnWorkEmployee]
GO
CREATE View [dbo].[SQL_TrainingOnWorkEmployee]
AS
	SELECT TOE.*, TW.TrainingProjectId, TOE.DeptName+'/' AS DeptFullPath_Search
	FROM TrainingOnWorkEmployee TOE 
	INNER JOIN TrainingOnWork TW ON TOE.WorkId = TW.id
GO


PRINT '--------------------培训学员违规------------------------------------'
IF EXISTS (SELECT * FROM sys.views WHERE object_id=OBJECT_ID(N'[SQ_ClassEmployeeViolation]'))
DROP VIEW [SQ_ClassEmployeeViolation]
GO
CREATE VIEW [dbo].[SQ_ClassEmployeeViolation]
AS	
	--培训师	
	SELECT CV.*, TE.EmployeeId, TE.EmployeeNO, TE.EmployeeName, TE.DeptId, TE.DeptName
	FROM ClassEmployeeViolation AS CV
	INNER JOIN TrainingOnWorkEmployee AS TE ON CV.TWEmployeeId=TE.Id 
GO


PRINT '--------------------培训师------------------------------------'
IF EXISTS (SELECT * FROM sys.views WHERE object_id=OBJECT_ID(N'[SQ_ClassTeacher]'))
DROP VIEW [SQ_ClassTeacher]
GO
CREATE View [dbo].[SQ_ClassTeacher]
AS
	SELECT CT.*,T.IsOutSideTeacher
	FROM TrainingWorkClassTeacher CT
	JOIN TeacherView T ON T.EmployeeId = CT.EmployeeId
GO

PRINT '--------------------培训师违规------------------------------------'
IF EXISTS (SELECT * FROM sys.views WHERE object_id=OBJECT_ID(N'[SQ_ClassTeacherViolation]'))
DROP VIEW [SQ_ClassTeacherViolation]
GO
CREATE VIEW [dbo].[SQ_ClassTeacherViolation]
AS	
	--培训师	
	SELECT CTV.*, TC.EmployeeId, TC.EmployeeNO, TC.EmployeeName, TC.DeptId, TC.DeptName
	FROM ClassTeacherViolation AS CTV
	INNER JOIN TrainingWorkClassTeacher AS TC ON TC.Id=CTV.teacherId
GO



PRINT '--------------------培训事务结果视图------------------------------------'
IF EXISTS (SELECT * FROM sys.views WHERE object_id=OBJECT_ID(N'[SQ_TrainingOnWorkResult]'))
DROP VIEW [SQ_TrainingOnWorkResult]
GO
CREATE VIEW [dbo].[SQ_TrainingOnWorkResult]
AS
	SELECT TWR.*,EV.EmployeeNO,EV.ObjectName AS EmployeeName,DV.ObjectName  AS DeptName,PV.ObjectName AS PostName,DV.Depth,DV.DeptFullPath_Search
	FROM TrainingOnWorkResult TWR
	LEFT JOIN EmployeeView EV ON TWR.EmployeeId = EV.Id
	LEFT JOIN PostView PV ON EV.PostId = PV.Id
	LEFT JOIN DeptView DV ON EV.DeptId = DV.Id
GO


PRINT '--------------------培训期次结果视图------------------------------------'
IF EXISTS (SELECT * FROM sys.views WHERE object_id=OBJECT_ID(N'[SQ_TrainingOnWorkPeriodResult]'))
DROP VIEW [SQ_TrainingOnWorkPeriodResult]
GO
CREATE VIEW [dbo].[SQ_TrainingOnWorkPeriodResult]
AS
	SELECT TOR.*, EV.EmployeeNO,EV.ObjectName AS EmployeeName,EV.DeptId
	,DV.FullPath AS DeptName,EV.PostId,PV.ObjectName AS PostName,DV.Depth,DV.FullPath+'/' AS DeptFullPath_Search
	FROM TrainingOnWorkPeriodResult AS TOR
	JOIN EmployeeView EV ON TOR.EmployeeId = EV.Id
	JOIN DeptView DV ON DV.Id = EV.DeptId
	JOIN PostView PV ON EV.PostId = PV.Id
GO



PRINT '--------------------培训期次学员视图------------------------------------'
IF EXISTS (SELECT * FROM sys.views WHERE object_id=OBJECT_ID(N'[SQ_TrainingOnWorkPeriodEmployee]'))
DROP VIEW [SQ_TrainingOnWorkPeriodEmployee]
GO
CREATE VIEW [SQ_TrainingOnWorkPeriodEmployee]
AS
	SELECT *, DeptName+'/' AS DeptFullPath_Search FROM dbo.TrainingOnWorkPeriodEmployee
GO



PRINT '--------------------培训结果详情视图------------------------------------'
IF EXISTS (SELECT * FROM sys.views WHERE object_id=OBJECT_ID(N'[SQ_TrainingOnWorkResultEmployeeReportView]'))
DROP VIEW [SQ_TrainingOnWorkResultEmployeeReportView]
GO
CREATE View SQ_TrainingOnWorkResultEmployeeReportView
AS
	SELECT TOR.WorkId, TOR.EmployeeId, EV.EmployeeNO,EV.ObjectName AS EmployeeName,EV.DeptId
	,DV.FullPath AS DeptName,EV.PostId,PV.ObjectName AS PostName,DV.Depth,DV.FullPath+'/' AS DeptFullPath_Search
	FROM TrainingOnWorkResult AS TOR
	JOIN EmployeeView EV ON TOR.EmployeeId = EV.Id
	JOIN DeptView DV ON DV.Id = EV.DeptId
	JOIN PostView PV ON EV.PostId = PV.Id
GO


PRINT '--------------------项目结果详情视图------------------------------------'
IF EXISTS (SELECT * FROM sys.views WHERE object_id=OBJECT_ID(N'[SQ_TrainingProjectResultView]'))
DROP VIEW [SQ_TrainingProjectResultView]
GO
CREATE View [dbo].[SQ_TrainingProjectResultView]
AS
	SELECT TPR.*, EV.EmployeeNO,EV.ObjectName AS EmployeeName
	,EV.DeptId,DV.FullPath AS DeptName,EV.PostId,PV.ObjectName AS PostName
	,DV.Depth, DV.FullPath+'/' AS DeptFullPath_Search
	FROM TrainingProjectResult AS TPR
	JOIN EmployeeView EV ON TPR.EmployeeId = EV.Id
	JOIN DeptView DV ON DV.Id = EV.DeptId
	JOIN PostView PV ON EV.PostId = PV.Id
GO

PRINT '--------------------培训分类的属性视图------------------------------------'
IF EXISTS (SELECT * FROM sys.views WHERE object_id=OBJECT_ID(N'[SQ_TrainingAttributeInType]'))
DROP VIEW [SQ_TrainingAttributeInType]
GO
CREATE VIEW [dbo].[SQ_TrainingAttributeInType]
AS
	SELECT TrainingAttributeInType.*,TrainingAttribute.ObjectName FROM  TrainingAttributeInType
	JOIN TrainingAttribute ON TrainingAttributeInType.AttrId = TrainingAttribute.Id
GO


PRINT '--------------------培训结果视图------------------------------------'
IF EXISTS (SELECT * FROM sys.views WHERE object_id=OBJECT_ID(N'[SQ_TrainingOnWorkEmployeeResult]'))
DROP VIEW [SQ_TrainingOnWorkEmployeeResult]
GO
CREATE VIEW [dbo].[SQ_TrainingOnWorkEmployeeResult]
AS 
	SELECT TR.*, TE.EmployeeNO,TE.EmployeeName,TE.Sex,TE.Age,TE.DeptName AS DeptFullPath,TE.PostName 
	FROM TrainingOnWork TW
	JOIN TrainingOnWorkEmployee TE ON TE.WorkId = ( CASE WHEN TW.GroupId > 0 THEN TW.GroupId ELSE TW.Id END)
	LEFT JOIN TrainingOnWorkEmployeeResult TR ON TR.WorkId = TW.Id AND TR.EmployeeId = TE.EmployeeId
GO


PRINT '--------------------巢湖培训结果视图------------------------------------'
IF EXISTS (SELECT * FROM sys.views WHERE object_id=OBJECT_ID(N'[SQ_ChaoHuTrainingOnWorkResultByDept]'))
DROP VIEW [SQ_ChaoHuTrainingOnWorkResultByDept]
GO
CREATE VIEW [SQ_ChaoHuTrainingOnWorkResultByDept]
AS
SELECT TW.ObjectName AS WorkName,
TW.StartTime,
TW.EndTime,
TR.TrainingResult,
TR.EmployeeId,
TR.IsPass,
TT.ObjectName AS WorkType,
TT.Id AS WorkTypeId,
TW.WorkState,
DV.SortIndex AS DeptSortIndex,
EV.EmployeeNO,EV.ObjectName AS EmployeeName,DV.FullPath  AS DeptName,PV.ObjectName AS PostName,DV.Depth,DV.DeptFullPath_Search
FROM TrainingOnWorkResult TR
JOIN TrainingOnWork TW ON TR.WorkId = TW.Id
JOIN TrainingOnWorkType TT ON TW.ProjectType1 = TT.Id
INNER JOIN EmployeeView EV ON TR.EmployeeId = EV.Id
LEFT JOIN PostView PV ON EV.PostId = PV.Id
LEFT JOIN DeptView DV ON EV.DeptId = DV.Id
GO


