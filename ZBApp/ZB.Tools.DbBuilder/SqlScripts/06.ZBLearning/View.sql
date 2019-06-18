print '--------------------ѧϰ�����б���ͼ------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SQ_LearningTaskView]'))
DROP VIEW [SQ_LearningTaskView]
GO
CREATE VIEW [SQ_LearningTaskView]
AS
SELECT				LearningTask.Id,																--����Id
					LearningTask.ObjectName,														--��������
					LearningTask.DeptId,															--����Id
					CASE 
					WHEN DATEDIFF(MINUTE,GetDate(),LearningTask.StartTime)>0 Then 10 
					WHEN DATEDIFF(MINUTE,LearningTask.EndTime,GetDate())>0 THEN 30 
					ELSE 20 
					END AS TaskState,																--����״̬
					LearningTask.CreatorId,															--������Id
					LearningTask.CreatorName,														--������
					LearningTask.StartTime,															--��ʼʱ��
					LearningTask.EndTime,															--����ʱ��
					YEAR(LearningTask.StartTime) AS TaskYear,										--�������																			
					ABS(DATEDIFF(Day,GetDate(),LearningTask.CreateTime)) AS RecIndex				--��������
FROM			LearningTask

GO

print '--------------------��Ա��ѧϰ�����б���ͼ------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SQ_EGLearningTaskView]'))
DROP VIEW [SQ_EGLearningTaskView]
GO
CREATE VIEW [SQ_EGLearningTaskView]
AS
SELECT				EGLearningTask.Id,																--����Id
					EGLearningTask.ObjectName,														--��������
					EGLearningTask.EmployeeGroupId,													--��Ա��Id
					CASE 
					WHEN DATEDIFF(MINUTE,GetDate(),EGLearningTask.StartTime)>0 Then 10 
					WHEN DATEDIFF(MINUTE,EGLearningTask.EndTime,GetDate())>0 THEN 30 
					ELSE 20 
					END AS TaskState,																			--����״̬
					EGLearningTask.CreatorId,														--������Id
					EGLearningTask.CreatorName,														--������
					EGLearningTask.StartTime,														--��ʼʱ��
					EGLearningTask.EndTime,															--����ʱ��
					YEAR(EGLearningTask.StartTime) AS TaskYear,										--�������																			
					ABS(DATEDIFF(Day,GetDate(),EGLearningTask.CreateTime)) AS RecIndex				--��������
FROM				EGLearningTask

GO

print '--------------------������ѵ���б���ͼ------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SQ_RequiredTaskView]'))
DROP VIEW [SQ_RequiredTaskView]
GO
CREATE VIEW [SQ_RequiredTaskView]
AS
SELECT				RequiredTask.Id,																--����Id
					RequiredTask.ObjectName,														--��������
					RequiredTask.DeptId,
					DeptView.FullPath AS DeptFullPath,															--����Id
					RequiredTask.RequiredTaskState,													--������ѵ�෢��״̬(��������ͣ)
					CASE 					
					WHEN DATEDIFF(DAY,RequiredTask.EndTime,GetDate())>0 THEN 30 
					ELSE 20																			--������ж��߼���ѧϰ������Ĳ�ͬ,�õ���DAY
					END AS TaskState,																--����״̬
					RequiredTask.CreatorId,															--������Id
					RequiredTask.CreatorName,														--������					
					RequiredTask.EndTime,															--����ʱ��																		
					ABS(DATEDIFF(Day,GetDate(),RequiredTask.CreateTime)) AS RecIndex,				--��������
					ISNULL(EmployeeView.Id,0) AS EmployeeId
FROM			RequiredTask
LEFT JOIN DeptView ON RequiredTask.DeptId = DeptView.Id
LEFT JOIN EmployeeView ON RequiredTask.CreatorId =EmployeeView.Id
GO

print '--------------------��ѯÿ����ֳ���ָ������ֵ��ѧϰ��¼------------------------------------'
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