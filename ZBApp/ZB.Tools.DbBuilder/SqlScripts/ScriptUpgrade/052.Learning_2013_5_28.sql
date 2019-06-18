
IF EXISTS(SELECT * FROM syscolumns WHERE id = object_id('RequiredTrainee') AND name='TraineeName')
BEGIN
	PRINT'--重命名列RequiredTrainee.TraineeName，改为EmployeeName'
	EXEC sp_rename 'dbo.RequiredTrainee.TraineeName', 'EmployeeName'
END

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('RequiredTrainee') AND name='DeptId')
BEGIN
	ALTER TABLE RequiredTrainee ADD DeptId INT NOT NULL DEFAULT 0;
	PRINT '添加RequiredTrainee表内的DeptId成功';
END

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('RequiredTrainee') AND name='PostId')
BEGIN
	ALTER TABLE RequiredTrainee ADD PostId INT NOT NULL DEFAULT 0;
	PRINT '添加RequiredTrainee表内的PostId成功';
END




IF EXISTS(SELECT * FROM syscolumns WHERE id = object_id('RequiredTaskPassInfo') AND name='TraineeName')
BEGIN	
	EXEC sp_rename 'dbo.RequiredTaskPassInfo.TraineeName', 'EmployeeName'
	PRINT'--重命名列RequiredTaskPassInfo.TraineeName，改为EmployeeName'
END

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('RequiredTaskPassInfo') AND name='DeptId')
BEGIN
	ALTER TABLE RequiredTaskPassInfo ADD DeptId INT NOT NULL DEFAULT 0;
	PRINT '添加RequiredTaskPassInfo表内的DeptId成功';
END

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('RequiredTaskPassInfo') AND name='PostId')
BEGIN
	ALTER TABLE RequiredTaskPassInfo ADD PostId INT NOT NULL DEFAULT 0;
	PRINT '添加RequiredTaskPassInfo表内的PostId成功';
END
