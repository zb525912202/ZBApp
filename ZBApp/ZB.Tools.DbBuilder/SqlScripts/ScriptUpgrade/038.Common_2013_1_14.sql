

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('Employee') AND name='OutsideDeptFullPath')
BEGIN	
	ALTER TABLE Employee ADD OutsideDeptFullPath NVARCHAR(260);
	PRINT '添加‘Employee’内的‘OutsideDeptFullPath’成功';
END
GO
