print '--------------------学习任务列表视图------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SQ_LearningTaskView]'))
DROP VIEW [SQ_LearningTaskView]
GO
CREATE VIEW [SQ_LearningTaskView]
AS
SELECT				LearningTask.Id,																--任务Id
					LearningTask.ObjectName,														--任务名称
					LearningTask.DeptId,															--部门Id
					CASE 
					WHEN DATEDIFF(MINUTE,GetDate(),LearningTask.StartTime)>0 Then 10 
					WHEN DATEDIFF(MINUTE,LearningTask.EndTime,GetDate())>0 THEN 30 
					ELSE 20 
					END AS TaskState,																--任务状态
					LearningTask.CreatorId,															--创建人Id
					LearningTask.CreatorName,														--创建人
					LearningTask.StartTime,															--开始时间
					LearningTask.EndTime,															--结束时间
					YEAR(LearningTask.StartTime) AS TaskYear,										--任务年度																			
					ABS(DATEDIFF(Day,GetDate(),LearningTask.CreateTime)) AS RecIndex				--排序索引
FROM			LearningTask

GO

print '--------------------人员组学习任务列表视图------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SQ_EGLearningTaskView]'))
DROP VIEW [SQ_EGLearningTaskView]
GO
CREATE VIEW [SQ_EGLearningTaskView]
AS
SELECT				EGLearningTask.Id,																--任务Id
					EGLearningTask.ObjectName,														--任务名称
					EGLearningTask.EmployeeGroupId,													--人员组Id
					CASE 
					WHEN DATEDIFF(MINUTE,GetDate(),EGLearningTask.StartTime)>0 Then 10 
					WHEN DATEDIFF(MINUTE,EGLearningTask.EndTime,GetDate())>0 THEN 30 
					ELSE 20 
					END AS TaskState,																			--任务状态
					EGLearningTask.CreatorId,														--创建人Id
					EGLearningTask.CreatorName,														--创建人
					EGLearningTask.StartTime,														--开始时间
					EGLearningTask.EndTime,															--结束时间
					YEAR(EGLearningTask.StartTime) AS TaskYear,										--任务年度																			
					ABS(DATEDIFF(Day,GetDate(),EGLearningTask.CreateTime)) AS RecIndex				--排序索引
FROM				EGLearningTask

GO

print '--------------------网络培训班列表视图------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SQ_RequiredTaskView]'))
DROP VIEW [SQ_RequiredTaskView]
GO
CREATE VIEW [SQ_RequiredTaskView]
AS
SELECT				RequiredTask.Id,																--任务Id
					RequiredTask.ObjectName,														--任务名称
					RequiredTask.DeptId,
					DeptView.FullPath AS DeptFullPath,															--部门Id
					RequiredTask.RequiredTaskState,													--网络培训班发布状态(发布、暂停)
					CASE 					
					WHEN DATEDIFF(DAY,RequiredTask.EndTime,GetDate())>0 THEN 30 
					ELSE 20																			--这里的判断逻辑与学习任务里的不同,用的是DAY
					END AS TaskState,																--任务状态
					RequiredTask.CreatorId,															--创建人Id
					RequiredTask.CreatorName,														--创建人					
					RequiredTask.EndTime,															--结束时间																		
					ABS(DATEDIFF(Day,GetDate(),RequiredTask.CreateTime)) AS RecIndex,				--排序索引
					ISNULL(EmployeeView.Id,0) AS EmployeeId
FROM			RequiredTask
LEFT JOIN DeptView ON RequiredTask.DeptId = DeptView.Id
LEFT JOIN EmployeeView ON RequiredTask.CreatorId =EmployeeView.Id
GO

print '--------------------查询每天积分超过指定上限值的学习记录------------------------------------'
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeLearningUpper_View]'))
DROP VIEW [dbo].[EmployeeLearningUpper_View]
GO

CREATE View [dbo].[EmployeeLearningUpper_View]
AS

	SELECT B.*
	,E.EmployeeNO
	,E.ObjectName,D.FullPath AS DeptFullPath,P.ObjectName AS PostName 
	FROM(
		SELECT EmployeeId
		
		,StudyType
		,StudyDate
		,SUM(StudyTimeSpan) AS StudyTimeSpan
		,SUM(LearningPoint) AS LearningPoint
		FROM(
		SELECT EmployeeId,
		StudyType,
		StudyTimeSpan,
		LearningPoint,
		StudyDate
		FROM [EmployeeQuesStudyDetail]
		UNION ALL
		SELECT EmployeeId,
		StudyType,
		StudyTimeSpan,
		LearningPoint,
		StudyDate
		FROM [EmployeePaperStudyDetail]
		UNION ALL
		SELECT EmployeeId,
		StudyType,
		StudyTimeSpan,
		LearningPoint,
		StudyDate
		FROM [EmployeeResourceStudyDetail]
		) AS A
		GROUP BY EmployeeId,StudyDate,StudyType
	) AS B
	JOIN [$(ZBCommonDatabaseName)].[dbo].[Employee] E ON B.EmployeeId = E.Id
	JOIN [$(ZBCommonDatabaseName)].[dbo].[Dept] D ON E.DeptId = D.Id
	LEFT JOIN [$(ZBCommonDatabaseName)].[dbo].[Post] P ON E.PostId = P.Id
GO