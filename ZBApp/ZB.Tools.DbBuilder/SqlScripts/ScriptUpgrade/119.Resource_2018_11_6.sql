IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('QFolderShare') AND name='IncludeSubDeptMode')
BEGIN
	ALTER TABLE QFolderShare ADD IncludeSubDeptMode INT NOT NULL DEFAULT 0;
	PRINT '添加QFolderShare的IncludeSubDeptMode成功';
END

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('RFolderShare') AND name='IncludeSubDeptMode')
BEGIN
	ALTER TABLE RFolderShare ADD IncludeSubDeptMode INT NOT NULL DEFAULT 0;
	PRINT '添加RFolderShare的IncludeSubDeptMode成功';
END

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('PFolderShare') AND name='IncludeSubDeptMode')
BEGIN
	ALTER TABLE PFolderShare ADD IncludeSubDeptMode INT NOT NULL DEFAULT 0;
	PRINT '添加PFolderShare的IncludeSubDeptMode成功';
END


GO