print '--------------------培训计划列表视图------------------------------------'
GO
IF EXISTS (SELECT * FROM sys.views WHERE object_id=OBJECT_ID(N'[SQ_TRAININGPLANVIEW]'))
DROP VIEW [SQ_TRAININGPLANVIEW]
GO
CREATE VIEW [SQ_TRAININGPLANVIEW]
AS
SELECT				TrainingPlan.*,										--
					b.ReporterId,										--
					b.ReporterName,		
					b.AuditorName,										--
					b.ReportTime,										--
					b.AuditorId,										--
					ISNULL(b.AuditResult,0) AS AuditResult,				--
					ISNULL(a.PlanBudget,0) AS PlanBudget,        		--
					ISNULL(a.ProjectCount,0) AS ProjectCount,
					CASE WHEN GetDate()>StartTime AND GetDate()<EndTime THEN 0 WHEN StartTime>GetDate() THEN 1 ELSE 2 END AS CompleteState,
					ABS(DATEDIFF(Day,GetDate(),StartTime)) AS RecIndex					
FROM				TrainingPlan LEFT JOIN (SELECT PlanId,SUM(Budget) AS PlanBudget,COUNT(*) AS ProjectCount FROM TrainingProject GROUP BY PlanId) AS a 
					ON TrainingPlan.Id=a.PlanId
					 LEFT JOIN (SELECT * FROM PlanFlow WHERE Id IN (SELECT Max(Id) FROM PlanFlow GROUP BY PlanId)) AS b
					ON TrainingPlan.Id = b.PlanId
GO

print '--------------------培训班列表视图------------------------------------'
GO
IF EXISTS (SELECT * FROM sys.views WHERE object_id=OBJECT_ID(N'[SQ_TRAININGCLASSVIEW]'))
DROP VIEW [SQ_TRAININGCLASSVIEW]
GO
CREATE VIEW [SQ_TRAININGCLASSVIEW]
AS
SELECT				MDV_TrainingWork_TrainingClass.*,
					TcType.ObjectName AS TcTypeName,
					TrainingLevel.ObjectName AS TrainingLevelName,
					TrainingMode.Id AS TcModelId,
					TrainingMode.ObjectName AS TcModelName,
					TrainingKind.ObjectName AS TrainingKindName,
					TrainingContentType.ObjectName AS TcContentTypeName,
					TrainingProject.ObjectName AS TrainingProjectName,
					CASE WHEN GetDate()>MDV_TrainingWork_TrainingClass.StartTime AND GetDate()<MDV_TrainingWork_TrainingClass.EndTime THEN 0 WHEN MDV_TrainingWork_TrainingClass.StartTime>GetDate() THEN 1 ELSE 2 END AS CompleteState,
					ABS(DATEDIFF(Day,GetDate(),MDV_TrainingWork_TrainingClass.StartTime)) AS RecIndex
FROM				MDV_TrainingWork_TrainingClass 
					LEFT JOIN TrainingLevel ON MDV_TrainingWork_TrainingClass.TrainingLevelId=TrainingLevel.id
					LEFT JOIN TcType ON MDV_TrainingWork_TrainingClass.TcTypeId= TcType.Id
					LEFT JOIN TrainingMode ON MDV_TrainingWork_TrainingClass.TrainingModeId=TrainingMode.Id
					LEFT JOIN TrainingKind ON MDV_TrainingWork_TrainingClass.TrainingKindId=TrainingKind.Id
					LEFT JOIN TrainingContentType ON MDV_TrainingWork_TrainingClass.TrainingContentTypeId =TrainingContentType.Id
					LEFT JOIN TrainingProject ON MDV_TrainingWork_TrainingClass.TrainingProjectId =TrainingProject.Id
GO

print '--------------------课程设置表视图------------------------------------'
GO
IF EXISTS (SELECT * FROM sys.views WHERE object_id=OBJECT_ID(N'[SQ_TCCOURSEVIEW]'))
DROP VIEW SQ_TCCOURSEVIEW
GO
CREATE VIEW SQ_TCCOURSEVIEW
AS
SELECT	TcCourse.*,
		TcCourseType.ObjectName AS CtName 
		FROM TcCourse LEFT JOIN TcCourseType 
		ON TcCourse.TcCourseTypeId=TcCourseType.Id 
GO

print '--------------------学员违规情况表视图------------------------------------'
GO
IF EXISTS (SELECT * FROM sys.views WHERE object_id=OBJECT_ID(N'[SQ_TCTRAINEEMISTAKE]'))
DROP VIEW SQ_TCTRAINEEMISTAKE
GO
CREATE VIEW SQ_TCTRAINEEMISTAKE
AS
SELECT 		TrainingEmployee.EmployeeNO,
			TrainingEmployee.EmployeeName,
			TrainingEmployee.DeptFullPath,
			TcTraineeMistake.*,
			TcCourse.ObjectName
FROM		TcTraineeMistake LEFT JOIN TrainingEmployee 
			ON TcTraineeMistake.TcTraineeId=TrainingEmployee.Id LEFT JOIN TcCourse 
			ON TcTraineeMistake.TcCourseId=TcCourse.Id
GO


print '--------------------培训师违规表视图------------------------------------'
GO
IF EXISTS (SELECT * FROM sys.views WHERE object_id=OBJECT_ID(N'[SQ_TCTEACHERMISTAKE]'))
DROP VIEW [SQ_TCTEACHERMISTAKE]
GO
CREATE VIEW [SQ_TCTEACHERMISTAKE]
AS
SELECT		TrainingEmployee.EmployeeName,
			TrainingEmployee.EmployeeNO,
			TrainingEmployee.DeptId,
			TrainingEmployee.DeptFullPath,
			TcTeacherMistake.*,
			TcCourse.ObjectName as TcCourseName
FROM		TcTeacherMistake LEFT JOIN 	TrainingEmployee ON TcTeacherMistake.TcTeacherId=TrainingEmployee.Id
			LEFT JOIN TcCourse ON TcTeacherMistake.TcCourseId=TcCourse.Id
GO

print '--------------------查询培训班培训师的视图-----------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SQ_TCTEACHERVIEW]'))
DROP VIEW [SQ_TCTEACHERVIEW]
GO
CREATE VIEW [SQ_TCTEACHERVIEW]
AS
select *,ISNULL((CASE WHEN DeptId<0 THEN 'TRUE' ELSE 'FALSE' END), '') AS IsOutside from MDV_TrainingEmployee_TcTeacher		                                         

GO

print '--------------------培训事务表视图------------------------------------'
GO
IF EXISTS (SELECT * FROM sys.views WHERE object_id=OBJECT_ID(N'[SQ_TrainingWork]'))
DROP VIEW SQ_TrainingWork
GO
CREATE VIEW SQ_TrainingWork
AS
SELECT			TrainingWork.*,
				TrainingLevel.ObjectName AS TrainingLevelName ,
				TrainingMode.ObjectName AS TrainingModeName,
				TrainingWorkType.ObjectName AS TrainingWorkTypeName, 
				TrainingKind.ObjectName AS TrainingKindName,
				a.TrainingWorkAmount,
				CASE WHEN GetDate()>StartTime AND GetDate()<EndTime THEN 0 WHEN StartTime>GetDate() THEN 1 ELSE 2 END AS CompleteState,
				ABS(DATEDIFF(Day,GetDate(),StartTime)) AS RecIndex
FROM			TrainingWork 
				LEFT JOIN TrainingLevel ON TrainingWork.TrainingLevelId=TrainingLevel.Id
				LEFT JOIN TrainingMode ON TrainingWork.TrainingModeId = TrainingMode.Id
				LEFT JOIN TrainingWorkType ON TrainingWork.TrainingWorkTypeId=TrainingWorkType.Id
				LEFT JOIN TrainingKind ON TrainingWork.TrainingKindId=TrainingKind.Id
				LEFT JOIN (SELECT TrainingWorkId,SUM(Amount) AS TrainingWorkAmount FROM TrainingBill GROUP BY TrainingWorkId) AS a ON TrainingWork.Id = a.TrainingWorkId
GO

print '--------------------培训项目列表视图------------------------------------'
GO
IF EXISTS (SELECT * FROM sys.views WHERE object_id=OBJECT_ID(N'[SQ_TrainingProjectView]'))
DROP VIEW SQ_TrainingProjectView
GO
CREATE VIEW SQ_TrainingProjectView
AS
SELECT			TrainingProject.DeptId,
				TrainingProject.Id,
				TrainingProject.ObjectName,
				TrainingProject.StartTimeSpan,
				TrainingProject.TrainingContent,
				TrainingMode.Id AS ProjectModeId,
				TrainingMode.ObjectName AS ProjectModeName,
				TrainingProject.Budget,
				TrainingProject.ProjectState,
				TrainingProject.DirectorName,
				TrainingProject.CreatorId,
				TrainingProject.StartTime,
				TrainingProject.EndTime,
				TrainingPlan.StartTime AS PlanStartTime,
				TrainingPlan.EndTime AS PlanEndTime,
				TrainingProject.CreatorName,
				TrainingPlan.ObjectName AS PlanName,
				TrainingProject.TrainingContentTypeId,
				TrainingContentType.FullPath AS TrainingContentTypeFullPath,
				ISNULL(a.TrainingWorkCount,0) AS TrainingWorkCount,
				ISNULL(b.TrainingProjectAmount,0) AS TrainingProjectAmount
FROM			TrainingProject 
				LEFT JOIN TrainingPlan ON TrainingProject.PlanId=TrainingPlan.Id 
				LEFT JOIN (SELECT TrainingProjectId,COUNT(*) AS TrainingWorkCount FROM TrainingWork GROUP BY TrainingProjectId) AS a ON TrainingProject.Id =a.TrainingProjectId
				LEFT JOIN TrainingMode ON TrainingMode.Id=TrainingProject.TrainingModeId
				LEFT JOIN (SELECT TrainingProjectId,SUM(Amount) AS TrainingProjectAmount FROM TrainingWork LEFT JOIN TrainingBill ON TrainingWork.Id = TrainingBill.TrainingWorkId GROUP BY TrainingProjectId) AS b ON TrainingProject.Id =b.TrainingProjectId
				LEFT JOIN TrainingContentType ON TrainingContentType.Id=TrainingProject.TrainingContentTypeId
				WHERE PlanId IN(SELECT PlanId FROM PlanFlow WHERE AuditResult=4)
GO

print '--------------------工作人员相关培训项目列表视图------------------------------------'
GO
IF EXISTS (SELECT * FROM sys.views WHERE object_id=OBJECT_ID(N'[SQ_TrainingRelatedProjectView]'))
DROP VIEW SQ_TrainingRelatedProjectView
GO
CREATE VIEW SQ_TrainingRelatedProjectView
AS
SELECT			TrainingProject.DeptId,
				TrainingProject.Id,
				TrainingProject.ObjectName,
				TrainingProject.StartTimeSpan,
				TrainingProject.TrainingContent,
				TrainingMode.Id AS ProjectModeId,
				TrainingMode.ObjectName AS ProjectModeName,
				TrainingProject.Budget,
				TrainingProject.ProjectState,
				TrainingProject.CreatorId,
				TS.EmployeeId,
				TS.TrainingStaffWorkType,
				TrainingPlan.ObjectName AS PlanName,
				TrainingProject.TrainingContentTypeId,
				TrainingContentType.ObjectName AS TrainingContentTypeName,
				ISNULL(a.TrainingWorkCount,0) AS TrainingWorkCount,
				ISNULL(b.TrainingProjectAmount,0) AS TrainingProjectAmount
FROM			TrainingProject 
				LEFT JOIN TrainingPlan ON TrainingProject.PlanId=TrainingPlan.Id 
				LEFT JOIN (SELECT TrainingProjectId,COUNT(*) AS TrainingWorkCount FROM TrainingWork GROUP BY TrainingProjectId) AS a ON TrainingProject.Id =a.TrainingProjectId
				LEFT JOIN TrainingMode ON TrainingMode.Id=TrainingProject.TrainingModeId
				LEFT JOIN (SELECT TrainingProjectId,SUM(Amount) AS TrainingProjectAmount FROM TrainingWork LEFT JOIN TrainingBill ON TrainingWork.Id = TrainingBill.TrainingWorkId GROUP BY TrainingProjectId) AS b ON TrainingProject.Id =b.TrainingProjectId
				LEFT JOIN TrainingStaff TS ON TrainingProject.Id = TS.WorkId
				LEFT JOIN TrainingContentType ON TrainingContentType.Id=TrainingProject.TrainingContentTypeId
				WHERE PlanId IN(SELECT PlanId FROM PlanFlow WHERE AuditResult=4)
GO


print '--------------------事务列表视图------------------------------------'
GO
IF EXISTS (SELECT * FROM sys.views WHERE object_id=OBJECT_ID(N'[SQ_TrainingWorkView]'))
DROP VIEW SQ_TrainingWorkView
GO
CREATE VIEW SQ_TrainingWorkView
AS
SELECT			TrainingWork.*,
				TrainingLevel.ObjectName AS TrainingLevelName,
				TrainingMode.ObjectName AS TrainingModeName,
				TrainingWorkType.ObjectName AS TrainingWorkTypeName, 
				a.TrainingWorkAmount,
				CASE WHEN GetDate()>StartTime AND GetDate()<EndTime THEN 0 WHEN StartTime>GetDate() THEN 1 ELSE 2 END AS CompleteState,
				ABS(DATEDIFF(Day,GetDate(),StartTime)) AS RecIndex
FROM 			TrainingWork
				LEFT JOIN (SELECT TrainingWorkId,SUM(Amount) AS TrainingWorkAmount FROM TrainingBill GROUP BY TrainingWorkId) AS a ON TrainingWork.Id = a.TrainingWorkId
				LEFT JOIN TrainingLevel ON TrainingWork.TrainingLevelId=TrainingLevel.Id
				LEFT JOIN TrainingMode ON TrainingWork.TrainingModeId=TrainingMode.Id
				LEFT JOIN TrainingWorkType ON TrainingWork.TrainingWorkTypeId=TrainingWorkType.Id
GO


print '--------------------工作人员相关培训事务视图------------------------------------'
GO
IF EXISTS (SELECT * FROM sys.views WHERE object_id=OBJECT_ID(N'[SQ_TrainingRelatedWorkView]'))
DROP VIEW [SQ_TrainingRelatedWorkView]
GO
CREATE VIEW [SQ_TrainingRelatedWorkView]
AS
SELECT 		TW.*,
			TWT.ObjectName AS TrainingWorkTypeName,
			TP.ObjectName AS TrainingPlanName,
			TPJ.ObjectName AS TrainingProjectName,
			TCT.FullPath AS TrainingContentName,
			TL.ObjectName AS TrainingLevelName,
			TM.ObjectName AS TrainingModeName,
			TS.EmployeeId,
			TS.TrainingStaffWorkType,
			TS.TrainingStaffRole,
			CASE WHEN GetDate()>TW.StartTime AND GetDate()<TW.EndTime THEN 0 WHEN TW.StartTime>GetDate() THEN 1 ELSE 2 END AS CompleteState,
			ABS(DATEDIFF(Day,GetDate(),TW.StartTime)) AS RecIndex
FROM		TrainingWork TW
			LEFT JOIN TrainingWorkType TWT ON TW.TrainingWorkTypeId = TWT.Id
			LEFT JOIN TrainingContentType TCT ON TW.TrainingContentTypeId = TCT.Id
			LEFT JOIN TrainingPlan TP ON TW.TrainingPlanId = TP.Id
			LEFT JOIN TrainingProject TPJ ON TW.TrainingProjectId = TPJ.Id 
			LEFT JOIN TrainingLevel TL ON TW.TrainingLevelId = TL.Id
			LEFT JOIN TrainingMode TM ON TW.TrainingModeId = TM.Id
			LEFT JOIN TrainingStaff TS ON TW.Id = TS.WorkId
GO

print '--------------------考试列表视图------------------------------------'
GO
IF EXISTS (SELECT * FROM sys.views WHERE object_id=OBJECT_ID(N'[SQ_TRAININGEXAMVIEW]'))
DROP VIEW [SQ_TRAININGEXAMVIEW]
GO
CREATE VIEW [SQ_TRAININGEXAMVIEW]
AS
SELECT				MDV_TrainingWork_TrainingExam.*,
					TeType.ObjectName AS TeTypeName,
					TrainingLevel.ObjectName AS TrainingLevelName,
					TrainingMode.ObjectName AS TeModelName,
					TrainingKind.ObjectName AS TrainingKindName,
					TrainingContentType.ObjectName AS TeContentTypeName,
					TrainingProject.ObjectName AS TrainingProjectName,
					CASE WHEN GetDate()>MDV_TrainingWork_TrainingExam.StartTime AND GetDate()<MDV_TrainingWork_TrainingExam.EndTime THEN 0 WHEN MDV_TrainingWork_TrainingExam.StartTime>GetDate() THEN 1 ELSE 2 END AS CompleteState,
					ABS(DATEDIFF(Day,GetDate(),MDV_TrainingWork_TrainingExam.StartTime)) AS RecIndex
FROM				MDV_TrainingWork_TrainingExam 
					LEFT JOIN TrainingLevel ON MDV_TrainingWork_TrainingExam.TrainingLevelId=TrainingLevel.id
					LEFT JOIN TeType ON MDV_TrainingWork_TrainingExam.TeTypeId= TeType.Id
					LEFT JOIN TrainingMode ON MDV_TrainingWork_TrainingExam.TrainingModeId=TrainingMode.Id
					LEFT JOIN TrainingKind ON MDV_TrainingWork_TrainingExam.TrainingKindId=TrainingKind.Id
					LEFT JOIN TrainingContentType ON MDV_TrainingWork_TrainingExam.TrainingContentTypeId =TrainingContentType.Id
					LEFT JOIN TrainingProject ON MDV_TrainingWork_TrainingExam.TrainingProjectId =TrainingProject.Id
GO

print '--------------------学历学位管理列表------------------------------------'
GO
--IF EXISTS (SELECT * FROM sys.views WHERE object_id=OBJECT_ID(N'[SQ_EDUTRAINEELISTVIEW]'))
--DROP VIEW [SQ_EDUTRAINEELISTVIEW]
--GO
--CREATE VIEW [SQ_EDUTRAINEELISTVIEW]
--AS
--SELECT		TrainingEmployee.Id,
--			EmployeeBaseInfoView.*,
--			EduLevel.ObjectName AS EduLevelName,			
--			TrainingKind.Id AS TrainingKindId,
--			TrainingKind.ObjectName AS TrainingKindName,
--			EduResultType.ObjectName as EduResultTypeName,
--			ExpendEmployeeTrainingBill.ExpendAmount,
--			RevenueEmployeeTrainingBill.RevenueAmount
--FROM		EduTrainee
--			LEFT JOIN TrainingEmployee ON EduTrainee.TrainingEmployeeId=TrainingEmployee.Id
--			LEFT JOIN EmployeeBaseInfoView ON TrainingEmployee.EmployeeId=EmployeeBaseInfoView.EmployeeId
--			INNER JOIN ZBCommon_9900.dbo.EduLevel ON EduTrainee.EduLevelId = EduLevel.Id
--			LEFT JOIN TrainingWork ON TrainingEmployee.TrainingWorkId=TrainingWork.Id
--			LEFT JOIN TrainingKind ON TrainingWork.TrainingKindId=TrainingKind.Id
--			LEFT JOIN EduResultType ON EduTrainee.EduResultTypeId = EduResultType.Id
--			LEFT JOIN (SELECT TrainingWorkId,SUM(Amount) AS ExpendAmount FROM EmployeeTrainingBill WHERE BillType = 1 GROUP BY TrainingWorkId) AS ExpendEmployeeTrainingBill ON TrainingEmployee.TrainingWorkId =ExpendEmployeeTrainingBill.TrainingWorkId
--			LEFT JOIN (SELECT TrainingWorkId,SUM(Amount*-1) AS RevenueAmount FROM EmployeeTrainingBill WHERE BillType = 2 GROUP BY TrainingWorkId) AS RevenueEmployeeTrainingBill ON TrainingEmployee.TrainingWorkId =RevenueEmployeeTrainingBill.TrainingWorkId
--GO

--IF EXISTS (SELECT * FROM sys.views WHERE object_id=OBJECT_ID(N'[SQ_EDUTRAINEELISTVIEW]'))
--DROP VIEW [SQ_EDUTRAINEELISTVIEW]
--GO
--CREATE VIEW [SQ_EDUTRAINEELISTVIEW]
--AS
--SELECT		TrainingEmployee.Id,
--			TrainingEmployee.DeptFullPath,			
--			TrainingEmployee.Credit,
--			EduTrainee.*,
--			EmployeeBaseInfoView.*,
--			TrainingEmployee.TrainingWorkId,
--			EduLevel.ObjectName AS EduLevelName,			
--			TrainingKind.Id AS TrainingKindId,
--			TrainingKind.ObjectName AS TrainingKindName,
--			EduResultType.ObjectName as EduResultTypeName,
--			ExpendEmployeeTrainingBill.ExpendAmount,
--			RevenueEmployeeTrainingBill.RevenueAmount
--FROM		EduTrainee
--			LEFT JOIN TrainingEmployee ON EduTrainee.TrainingEmployeeId=TrainingEmployee.Id
--			LEFT JOIN EmployeeBaseInfoView ON TrainingEmployee.EmployeeId=EmployeeBaseInfoView.EmployeeId
--			INNER JOIN [$(ZBCommonDatabaseName)].dbo.EduLevel ON EduTrainee.EduLevelId = EduLevel.Id
--			LEFT JOIN TrainingWork ON TrainingEmployee.TrainingWorkId=TrainingWork.Id
--			LEFT JOIN TrainingKind ON TrainingWork.TrainingKindId=TrainingKind.Id
--			LEFT JOIN EduResultType ON EduTrainee.EduResultTypeId = EduResultType.Id
--			LEFT JOIN (SELECT TrainingWorkId,SUM(Amount) AS ExpendAmount FROM EmployeeTrainingBill WHERE BillType = 1 GROUP BY TrainingWorkId) AS ExpendEmployeeTrainingBill ON TrainingEmployee.TrainingWorkId =ExpendEmployeeTrainingBill.TrainingWorkId
--			LEFT JOIN (SELECT TrainingWorkId,SUM(Amount*-1) AS RevenueAmount FROM EmployeeTrainingBill WHERE BillType = 2 GROUP BY TrainingWorkId) AS RevenueEmployeeTrainingBill ON TrainingEmployee.TrainingWorkId =RevenueEmployeeTrainingBill.TrainingWorkId
--GO

print '--------------------评定项视图------------------------------------'
GO
IF EXISTS (SELECT * FROM sys.views WHERE object_id=OBJECT_ID(N'[SQ_JUDGEVIEW]'))
DROP VIEW [SQ_JUDGEVIEW]
GO
CREATE VIEW [SQ_JUDGEVIEW]
AS
SELECT 
			Judge.Id,
			Judge.ObjectName,
			Judge.TrainingKindId,
			Judge.Remark,
			TrainingKind.ObjectName AS TrainingKindName 
FROM		Judge 
			LEFT JOIN TrainingKind ON Judge.TrainingKindId=TrainingKind.Id
GO

print '--------------------培训班学员选择视图------------------------------------'
GO																
IF EXISTS (SELECT * FROM sys.views WHERE object_id=OBJECT_ID(N'[SQ_TCTRAINEESELECTVIEW]'))
DROP VIEW [SQ_TCTRAINEESELECTVIEW]
GO
CREATE VIEW [SQ_TCTRAINEESELECTVIEW]
AS				

SELECT TrainingEmployee.*,
	   TcTrainee.TcResultTypeId,
	   TcTeacher.TeacherLevelId,
	   ISNULL(TcTeacher.TeacherLevelId,0) AS EmployeeType 
	   From TrainingEmployee 
LEFT JOIN TcTrainee ON TcTrainee.TrainingEmployeeId = TrainingEmployee.Id
LEFT JOIN TcTeacher ON TcTeacher.TrainingEmployeeId = TrainingEmployee.Id

--EmployeeType标识TrainingEmployee的类型，本视图中用来判断是学员还是培训师，
--因为现在培训班中，只有培训师和学员，所以暂使用TeacherLevelId来判断是学员还是讲师。
GO

print '--------------------考试学员选择视图------------------------------------'
GO																
IF EXISTS (SELECT * FROM sys.views WHERE object_id=OBJECT_ID(N'[SQ_TETRAINEESELECTVIEW]'))
DROP VIEW [SQ_TETRAINEESELECTVIEW]
GO
CREATE VIEW [SQ_TETRAINEESELECTVIEW]
AS				
SELECT				TrainingEmployee.*,
					TeTrainee.*
FROM				TrainingEmployee INNER JOIN TeTrainee 
					ON TrainingEmployee.Id=TeTrainee.TrainingEmployeeId
GO

print '--------------------学分录入视图------------------------------------'
GO																
IF EXISTS (SELECT * FROM sys.views WHERE object_id=OBJECT_ID(N'[SQ_TEJUDGETRAINEEVIEW]'))
DROP VIEW [SQ_TEJUDGETRAINEEVIEW]
GO
CREATE VIEW [SQ_TEJUDGETRAINEEVIEW]
AS				
SELECT				TrainingEmployee.*,
					JudgeTrainee.*,
					TrainingWork.DeptId AS JudgeDeptId,
					TrainingWork.DeptFullPath AS JudgeDeptFullPath,
					TrainingBill.Amount,
					ABS(DATEDIFF(Day,GetDate(),[GetDate])) AS RecIndex
FROM				TrainingEmployee INNER JOIN JudgeTrainee 
					ON TrainingEmployee.Id=JudgeTrainee.TrainingEmployeeId
					LEFT JOIN TrainingWork ON TrainingEmployee.TrainingWorkId=TrainingWork.Id
					LEFT JOIN TrainingBill on TrainingWork.Id =TrainingBill.TrainingWorkId
GO

print '--------------------学分任务视图------------------------------------'
GO																
IF EXISTS (SELECT * FROM sys.views WHERE object_id=OBJECT_ID(N'[SQ_TRAININGCREDITTASKVIEW]'))
DROP VIEW [SQ_TRAININGCREDITTASKVIEW]
GO
CREATE VIEW [SQ_TRAININGCREDITTASKVIEW]
AS				
SELECT				Id,																--任务Id
					ObjectName,														--任务名称														--部门Id
					CASE 
					WHEN DATEDIFF(MINUTE,GetDate(),StartTime)>0 Then 10 
					WHEN DATEDIFF(MINUTE,EndTime,GetDate())>0 THEN 30 
					ELSE 20 
					END AS TaskState,												--任务状态
					CreatorId,														--创建人Id
					CreatorName,													--创建人
					StartTime,														--开始时间
					EndTime,														--结束时间
					CASE WHEN GetDate()>StartTime AND GetDate()<EndTime THEN 0 WHEN StartTime>GetDate() THEN 1 ELSE 2 END AS CompleteState,
					ABS(DATEDIFF(Day,GetDate(),StartTime)) AS RecIndex,
					YEAR(StartTime) AS TaskYear										--任务年度	
FROM				TrainingTask
GO

print '--------------------培训班全部信息视图------------------------------------'
GO																
IF EXISTS (SELECT * FROM sys.views WHERE object_id=OBJECT_ID(N'[SQ_TrainingClassInfoView]'))
DROP VIEW [SQ_TrainingClassInfoView]
GO
CREATE VIEW [SQ_TrainingClassInfoView]
AS				
SELECT				TrainingWork.*,
					TrainingClass.*
FROM				TrainingWork INNER JOIN TrainingClass 
					ON TrainingWork.Id=TrainingClass.TrainingWorkId
GO

print '--------------------考试全部信息视图------------------------------------'
GO																
IF EXISTS (SELECT * FROM sys.views WHERE object_id=OBJECT_ID(N'[SQ_TrainingExamInfoView]'))
DROP VIEW [SQ_TrainingExamInfoView]
GO
CREATE VIEW [SQ_TrainingExamInfoView]
AS				
SELECT				TrainingWork.*,
					TrainingExam.*
FROM				TrainingWork INNER JOIN TrainingExam 
					ON TrainingWork.Id=TrainingExam.TrainingWorkId
GO

--print '--------------------学历全部信息视图------------------------------------'
--GO																
--IF EXISTS (SELECT * FROM sys.views WHERE object_id=OBJECT_ID(N'[SQ_TrainingEduInfoView]'))
--DROP VIEW [SQ_TrainingEduInfoView]
--GO
--CREATE VIEW [SQ_TrainingEduInfoView]
--AS				
--SELECT				TrainingEmployee.*,
--					EduTrainee.*
--FROM				TrainingEmployee INNER JOIN EduTrainee 
--					ON TrainingEmployee.Id=EduTrainee.TrainingEmployeeId
--GO

print '--------------------评定项全部信息视图------------------------------------'
GO																
IF EXISTS (SELECT * FROM sys.views WHERE object_id=OBJECT_ID(N'[SQ_TrainingJudgeInfoView]'))
DROP VIEW [SQ_TrainingJudgeInfoView]
GO
CREATE VIEW [SQ_TrainingJudgeInfoView]
AS				
SELECT				TrainingEmployee.*,
					JudgeTrainee.*,
					TrainingWork.DeptId AS JudgeDeptId,
					TrainingWork.DeptFullPath AS JudgeDeptFullPath,
					TrainingBill.Amount
FROM				TrainingEmployee INNER JOIN JudgeTrainee 
					ON TrainingEmployee.Id=JudgeTrainee.TrainingEmployeeId
					LEFT JOIN TrainingWork ON TrainingEmployee.TrainingWorkId=TrainingWork.Id
					LEFT JOIN TrainingBill on TrainingWork.Id =TrainingBill.TrainingWorkId
GO

print '--------------------网络自主学习全部信息视图------------------------------------'
GO																
IF EXISTS (SELECT * FROM sys.views WHERE object_id=OBJECT_ID(N'[SQ_LearningOnlineTraineeDetailInfoView]'))
DROP VIEW [SQ_LearningOnlineTraineeDetailInfoView]
GO
CREATE VIEW [SQ_LearningOnlineTraineeDetailInfoView]
AS				
SELECT				TrainingEmployee.*,
					LearningOnlineTraineeDetail.TrainingEmployeeId,
					LearningOnlineTraineeDetail.LearningOnlineStudyType,
					LearningOnlineTraineeDetail.StudyTimeSpan,
					LearningOnlineTraineeDetail.LearningPoint
FROM				TrainingEmployee INNER JOIN LearningOnlineTraineeDetail 
					ON TrainingEmployee.Id=LearningOnlineTraineeDetail.TrainingEmployeeId
GO

print '--------------------跨库人员档案视图------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeHistoryInfoView]'))
DROP VIEW [dbo].[EmployeeHistoryInfoView]
GO
CREATE VIEW [dbo].[EmployeeHistoryInfoView]
AS
SELECT				Employee.Id AS EmployeeId,													
					Employee.EmployeeNO,														
					Employee.ObjectName AS EmployeeName,										
					Employee.Sex,	
					Dept.Id AS DeptId,													
					Dept.ObjectName AS DeptName,
					Post.ObjectName AS PostName,																												
					FullPath AS DeptFullPath,																	
					FullPath + '/' AS DeptFullPath_Search,
					EmployeeYearExpendAmount.ThisYearExpendAmount,
					EmployeeYearRevenueAmount.ThisYearRevenueAmount,
					EmployeeExpendAmount.TotalExpendAmount,
					EmployeeRevenueAmount.TotalRevenueAmount,
					EmployeeCredit.TotalCredit,
					EmployeeYearCredit.ThisYearCredit														
FROM				EmployeeView AS Employee 
					LEFT JOIN DeptView AS Dept ON Employee.DeptId=Dept.Id
					LEFT JOIN PostView AS Post ON Employee.PostId=Post.Id
					
					LEFT JOIN (SELECT EmployeeTrainingBill.EmployeeId,SUM(Amount) AS ThisYearExpendAmount 
					           FROM EmployeeTrainingBill LEFT JOIN TrainingWork  ON EmployeeTrainingBill.TrainingWorkId=TrainingWork.Id WHERE TrainingWork.EndYear = convert(varchar(4),GetDate(),120) AND EmployeeTrainingBill.BillType=1 GROUP BY EmployeeTrainingBill.EmployeeId) 
					           AS EmployeeYearExpendAmount 
							   ON Employee.Id = EmployeeYearExpendAmount.EmployeeId 
					LEFT JOIN (SELECT EmployeeTrainingBill.EmployeeId,SUM(Amount*-1) AS ThisYearRevenueAmount 
								FROM EmployeeTrainingBill LEFT JOIN TrainingWork  ON EmployeeTrainingBill.TrainingWorkId=TrainingWork.Id WHERE TrainingWork.EndYear = convert(varchar(4),GetDate(),120) AND EmployeeTrainingBill.BillType=2 GROUP BY EmployeeTrainingBill.EmployeeId) 
								AS EmployeeYearRevenueAmount 
								ON Employee.Id = EmployeeYearRevenueAmount.EmployeeId 
								
					Left JOIN (SELECT EmployeeTrainingBill.EmployeeId,SUM(Amount) AS TotalExpendAmount 
					           FROM EmployeeTrainingBill LEFT JOIN TrainingWork  ON EmployeeTrainingBill.TrainingWorkId=TrainingWork.Id WHERE EmployeeTrainingBill.BillType=1 GROUP BY EmployeeTrainingBill.EmployeeId) 
					           AS EmployeeExpendAmount
							   ON Employee.Id =EmployeeExpendAmount.EmployeeId
					Left JOIN (SELECT EmployeeTrainingBill.EmployeeId,SUM(Amount*-1) AS TotalRevenueAmount 
					           FROM EmployeeTrainingBill LEFT JOIN TrainingWork  ON EmployeeTrainingBill.TrainingWorkId=TrainingWork.Id WHERE EmployeeTrainingBill.BillType=2 GROUP BY EmployeeTrainingBill.EmployeeId) 
					           AS EmployeeRevenueAmount
							   ON Employee.Id =EmployeeRevenueAmount.EmployeeId
					
					LEFT JOIN (SELECT TrainingEmployee.EmployeeId,SUM(TrainingEmployee.Credit) AS ThisYearCredit FROM TrainingEmployee LEFT JOIN TrainingWork ON TrainingEmployee.TrainingWorkId=TrainingWork.Id  WHERE TrainingWork.EndYear = convert(varchar(4),GetDate(),120) AND TrainingWork.TrainingWorkState=3 GROUP BY TrainingEmployee.EmployeeId) 
								AS EmployeeYearCredit
							   ON Employee.Id= EmployeeYearCredit.EmployeeId		   
				    LEFT JOIN (SELECT TrainingEmployee.EmployeeId,SUM(TrainingEmployee.Credit) AS TotalCredit FROM	TrainingEmployee LEFT JOIN TrainingWork ON TrainingEmployee.TrainingWorkId=TrainingWork.Id WHERE TrainingWork.TrainingWorkState=3 GROUP BY TrainingEmployee.EmployeeId) 
								AS EmployeeCredit
				               ON Employee.Id=EmployeeCredit.EmployeeId
				               
GO
 
print '--------------------培训班培训师跨库列表视图------------------------------------'
GO																
IF EXISTS (SELECT * FROM sys.views WHERE object_id=OBJECT_ID(N'[SQ_TcTeacherInfoView]'))
DROP VIEW [SQ_TcTeacherInfoView]
GO
CREATE VIEW [SQ_TcTeacherInfoView]
AS				
SELECT				TrainingEmployee.*,
					TcTeacher.*,
					TeacherView.IsOutSideTeacher
FROM				TrainingEmployee INNER JOIN TcTeacher 
					ON TrainingEmployee.Id=TcTeacher.TrainingEmployeeId
					LEFT JOIN TeacherView ON TrainingEmployee.EmployeeId = TeacherView.EmployeeId
GO

print '--------------------在线学分管理列表视图------------------------------------'
GO																
IF EXISTS (SELECT * FROM sys.views WHERE object_id=OBJECT_ID(N'[SQ_NetWorkLearingCreditView]'))
DROP VIEW [SQ_NetWorkLearingCreditView]
GO
CREATE VIEW [SQ_NetWorkLearingCreditView]
AS				
SELECT 
			TrainingWork.*,
			A.TotalLearningPoint,
			A.TotalCredit,
			A.TotleStudyTimeSpan,
			B.EmployeeCount,
			A.TotleStudyTimeSpan/B.EmployeeCount as PerStudyTimeSpan,
			A.TotalLearningPoint/B.EmployeeCount AS PerLearningPoint,
			A.TotalCredit/B.EmployeeCount AS PerCredit					 
FROM		TrainingWork 
			LEFT JOIN(SELECT	TrainingWork.Id,
								SUM(LearningOnlineTraineeDetail.LearningPoint) AS TotalLearningPoint,
								SUM(LearningOnlineTraineeDetail.Credit) AS TotalCredit,
								SUM(LearningOnlineTraineeDetail.StudyTimeSpan) AS TotleStudyTimeSpan 
					  FROM		TrainingWork 
								LEFT JOIN TrainingEmployee ON TrainingWork.Id=TrainingEmployee.TrainingWorkId
								LEFT JOIN LearningOnlineTraineeDetail ON TrainingEmployee.Id=TrainingEmployeeId				
								GROUP BY TrainingWork.Id) AS A ON TrainingWork.Id=A.Id							
			LEFT JOIN (SELECT COUNT(*) AS EmployeeCount,TrainingWorkId FROM TrainingEmployee GROUP BY TrainingWorkId)AS B ON TrainingWork.Id =B.TrainingWorkId
GO

print '--------------------培训事务查询列表视图------------------------------------'
GO					
IF EXISTS (SELECT * FROM sys.views WHERE object_id=OBJECT_ID(N'[SQ_TrainingWorkQueryView]'))
DROP VIEW [SQ_TrainingWorkQueryView]
GO
CREATE VIEW [SQ_TrainingWorkQueryView]
AS		
SELECT TrainingWork.Id AS TrainingWorkId,
		TrainingWork.ObjectName AS ObjectName,
		ISNULL(TrainingWorkType.ObjectName,'') AS TrainingWorkTypeName,
		ISNULL(TrainingContentType.FullPath,'') AS TrainingContentTypeFullPath,
		TrainingWork.StartTime,
		TrainingWork.EndTime,
		ISNULL(TrainingWorkEmployeeGroup.TrainingWorkCredit,0) AS TotalEmployeeCount,
		ISNULL(TrainingWorkCreditGroup.TrainingWorkCredit,0) AS TotalCredit,
		ISNULL(TrainingWorkBillGroup.EmployeeTrainingBillAmount,0) AS TotalExpendBill,
		TrainingWork.DeptFullPath,
		TrainingWork.CreatorId,
		TrainingWork.CreateTime,
		TrainingWork.TrainingWorkState,
		TrainingWork.TrainingContentTypeId,
		TrainingWork.TrainingWorkTypeId,
		TrainingWork.TrainingLevelId,
		TrainingWork.TrainingModeId,
		TrainingLevel.ObjectName AS TrainingLevelName,
		TrainingMode.ObjectName AS TrainingModeName,
		ISNULL(TrainingClassTable.FullPath,TrainingExamTable.FullPath) AS TrainingWorkSort

FROM TrainingWork
	LEFT JOIN TrainingWorkType ON TrainingWorkType.Id=TrainingWork.TrainingWorkTypeId
	LEFT JOIN TrainingContentType ON TrainingContentType.Id=TrainingWork.TrainingContentTypeId
	LEFT JOIN TrainingLevel ON TrainingLevel.Id = TrainingWork.TrainingLevelId
	LEFT JOIN TrainingMode ON TrainingMode.Id = TrainingWork.TrainingModeId
	LEFT JOIN
		(
			SELECT TrainingClass.TrainingWorkId, TcType.Id,TcType.FullPath 
			FROM TrainingClass 
			INNER JOIN TcType ON TcType.Id = TrainingClass.TcTypeId
		) AS TrainingClassTable
		ON TrainingClassTable.TrainingWorkId = TrainingWork.Id
	LEFT JOIN
		(
			SELECT TrainingExam.TrainingWorkId, TeType.Id,TeType.FullPath 
			FROM TrainingExam
			INNER JOIN TeType ON TeType.Id = TrainingExam.TeTypeId
		) AS TrainingExamTable
		ON TrainingExamTable.TrainingWorkId = TrainingWork.Id		
	LEFT JOIN 
		(
			SELECT TrainingEmployee.TrainingWorkId AS TrainingWorkId,
					COUNT(TrainingEmployee.Credit) AS TrainingWorkCredit
			FROM TrainingEmployee
			GROUP BY TrainingEmployee.TrainingWorkId
		) AS TrainingWorkEmployeeGroup
		 ON TrainingWorkEmployeeGroup.TrainingWorkId=TrainingWork.Id
	LEFT JOIN 
		(
			SELECT TrainingWork.Id AS TrainingWorkId,
					SUM(TrainingEmployee.Credit) AS TrainingWorkCredit
			FROM TrainingWork
			LEFT JOIN TrainingEmployee ON TrainingEmployee.TrainingWorkId=TrainingWork.Id
			WHERE TrainingWork.TrainingWorkState=3 
			GROUP BY TrainingWork.Id
		) AS TrainingWorkCreditGroup
		 ON TrainingWorkCreditGroup.TrainingWorkId=TrainingWork.Id
	LEFT JOIN 
		(
			SELECT TrainingWork.Id AS TrainingWorkId,
					SUM(EmployeeTrainingBill.Amount) AS EmployeeTrainingBillAmount
			FROM TrainingWork
			LEFT JOIN EmployeeTrainingBill ON EmployeeTrainingBill.TrainingWorkId=TrainingWork.Id
			WHERE EmployeeTrainingBill.BillType=1 
			AND TrainingWork.TrainingWorkState=3 
			GROUP BY TrainingWork.Id
		) AS TrainingWorkBillGroup
		 ON TrainingWorkBillGroup.TrainingWorkId=TrainingWork.Id

GO