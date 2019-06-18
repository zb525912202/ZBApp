
IF EXISTS(SELECT * FROM syscolumns WHERE id = object_id('RequiredTrainee') AND name='TraineeName')
BEGIN
	PRINT'--��������RequiredTrainee.TraineeName����ΪEmployeeName'
	EXEC sp_rename 'dbo.RequiredTrainee.TraineeName', 'EmployeeName'
END

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('RequiredTrainee') AND name='DeptId')
BEGIN
	ALTER TABLE RequiredTrainee ADD DeptId INT NOT NULL DEFAULT 0;
	PRINT '���RequiredTrainee���ڵ�DeptId�ɹ�';
END

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('RequiredTrainee') AND name='PostId')
BEGIN
	ALTER TABLE RequiredTrainee ADD PostId INT NOT NULL DEFAULT 0;
	PRINT '���RequiredTrainee���ڵ�PostId�ɹ�';
END




IF EXISTS(SELECT * FROM syscolumns WHERE id = object_id('RequiredTaskPassInfo') AND name='TraineeName')
BEGIN	
	EXEC sp_rename 'dbo.RequiredTaskPassInfo.TraineeName', 'EmployeeName'
	PRINT'--��������RequiredTaskPassInfo.TraineeName����ΪEmployeeName'
END

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('RequiredTaskPassInfo') AND name='DeptId')
BEGIN
	ALTER TABLE RequiredTaskPassInfo ADD DeptId INT NOT NULL DEFAULT 0;
	PRINT '���RequiredTaskPassInfo���ڵ�DeptId�ɹ�';
END

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('RequiredTaskPassInfo') AND name='PostId')
BEGIN
	ALTER TABLE RequiredTaskPassInfo ADD PostId INT NOT NULL DEFAULT 0;
	PRINT '���RequiredTaskPassInfo���ڵ�PostId�ɹ�';
END
