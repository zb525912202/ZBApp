
PRINT'--�޸�ǰ̨ѧϰ��������ɾ����������ʾ'
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


