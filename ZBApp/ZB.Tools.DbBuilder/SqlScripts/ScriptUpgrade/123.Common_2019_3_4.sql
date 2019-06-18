
IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('EmployeeChangeInfo') AND name='CreatorId')
BEGIN
	ALTER TABLE EmployeeChangeInfo ADD CreatorId INT;
	PRINT '添加EmployeeChangeInfo内的CreatorId成功';
END



IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('EmployeeChangeInfo') AND name='CreatorName')
BEGIN
	ALTER TABLE EmployeeChangeInfo ADD CreatorName NVARCHAR(50) NULL;
	PRINT '添加EmployeeChangeInfo内的CreatorName成功';
END
