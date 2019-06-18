IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('LFolderShare') AND name='IncludeSubDeptMode')
BEGIN
	ALTER TABLE LFolderShare ADD IncludeSubDeptMode INT NOT NULL DEFAULT 0;
	PRINT '添加LFolderShare的IncludeSubDeptMode成功';
END
GO