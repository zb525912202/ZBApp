

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('Employee') AND name='OutsideDeptFullPath')
BEGIN	
	ALTER TABLE Employee ADD OutsideDeptFullPath NVARCHAR(260);
	PRINT '��ӡ�Employee���ڵġ�OutsideDeptFullPath���ɹ�';
END
GO
