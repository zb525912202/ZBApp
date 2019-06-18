

IF EXISTS(SELECT * FROM syscolumns WHERE id = object_id('WebExaminee') AND name='ExamineeNo')
BEGIN	
	EXEC sp_rename 'WebExaminee.ExamineeNo', 'EmployeeNO', 'column'
	PRINT '重命名‘WebExaminee’内的‘ExamineeNo’为‘EmployeeNO’成功';
END
GO

IF EXISTS(SELECT * FROM syscolumns WHERE id = object_id('WebExaminee') AND name='ExamineeName')
BEGIN	
	EXEC sp_rename 'WebExaminee.ExamineeName', 'EmployeeName', 'column' 
	PRINT '重命名‘WebExaminee’内的‘ExamineeName’为‘EmployeeName’成功';
END
GO

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('WebExaminee') AND name='DeptId')
BEGIN	
	ALTER TABLE WebExaminee ADD DeptId INT NOT NULL DEFAULT 0;
	PRINT '添加‘WebExaminee’内的‘DeptId’成功';
END
GO

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('WebExaminee') AND name='PostId')
BEGIN	
	ALTER TABLE WebExaminee ADD PostId INT NOT NULL DEFAULT 0;
	PRINT '添加‘WebExaminee’内的‘PostId’成功';
END
GO

