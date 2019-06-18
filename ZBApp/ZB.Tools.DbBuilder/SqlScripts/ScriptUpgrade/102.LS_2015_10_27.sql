IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('NetClass') AND name='WorkId')
BEGIN
	ALTER TABLE NetClass ADD WorkId INT NOT NULL DEFAULT 0;
	PRINT '添加‘NetClass’的‘WorkId’成功';
END
GO


IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('NetClass') AND name='ClassState')
BEGIN
	ALTER TABLE NetClass ADD ClassState INT NOT NULL DEFAULT 0;
	PRINT '添加‘NetClass’的‘ClassState’成功';
END
GO