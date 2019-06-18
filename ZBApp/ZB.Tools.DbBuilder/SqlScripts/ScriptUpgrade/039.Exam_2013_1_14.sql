

IF EXISTS(SELECT * FROM syscolumns WHERE id = object_id('WebExaminee') AND name='ExamineeNo')
BEGIN	
	EXEC sp_rename 'WebExaminee.ExamineeNo', 'EmployeeNO', 'column'
	PRINT '��������WebExaminee���ڵġ�ExamineeNo��Ϊ��EmployeeNO���ɹ�';
END
GO

IF EXISTS(SELECT * FROM syscolumns WHERE id = object_id('WebExaminee') AND name='ExamineeName')
BEGIN	
	EXEC sp_rename 'WebExaminee.ExamineeName', 'EmployeeName', 'column' 
	PRINT '��������WebExaminee���ڵġ�ExamineeName��Ϊ��EmployeeName���ɹ�';
END
GO

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('WebExaminee') AND name='DeptId')
BEGIN	
	ALTER TABLE WebExaminee ADD DeptId INT NOT NULL DEFAULT 0;
	PRINT '��ӡ�WebExaminee���ڵġ�DeptId���ɹ�';
END
GO

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('WebExaminee') AND name='PostId')
BEGIN	
	ALTER TABLE WebExaminee ADD PostId INT NOT NULL DEFAULT 0;
	PRINT '��ӡ�WebExaminee���ڵġ�PostId���ɹ�';
END
GO

