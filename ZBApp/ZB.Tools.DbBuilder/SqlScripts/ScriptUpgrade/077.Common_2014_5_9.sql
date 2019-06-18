IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('Employee') AND name='Mobile')
BEGIN
	ALTER TABLE Employee ADD Mobile	NVARCHAR(50) NULL;
	PRINT '添加Employee内的Mobile成功';
END

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('Employee') AND name='Email')
BEGIN
	ALTER TABLE Employee ADD Email NVARCHAR(200) NULL;
	PRINT '添加Employee内的Email成功';
END