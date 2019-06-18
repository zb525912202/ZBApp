
PRINT'--修复前台学习任务中已删除的任务显示'
Delete FROM [$(ZBCommonDatabaseName)].dbo.BuzEmployeeMessage 
WHERE BuzMessageId IN
	(SELECT Id FROM [$(ZBCommonDatabaseName)].dbo.BuzMessage 
	WHERE TypeId=200 
	AND ObjectId 
	NOT IN
		(SELECT Id FROM LearningTask))
		
Delete FROM [$(ZBCommonDatabaseName)].dbo.BuzEmployeeMessage 
WHERE BuzMessageId IN
	(SELECT Id FROM [$(ZBCommonDatabaseName)].dbo.BuzMessage 
	WHERE TypeId=300 
	AND ObjectId 
	NOT IN
		(SELECT Id FROM EGLearningTask))
		
DELETE FROM [$(ZBCommonDatabaseName)].dbo.BuzMessage WHERE TypeId = 200 AND ObjectId NOT IN (SELECT Id FROM LearningTask)

DELETE FROM [$(ZBCommonDatabaseName)].dbo.BuzMessage WHERE TypeId = 300 AND ObjectId NOT IN (SELECT Id FROM EGLearningTask)


