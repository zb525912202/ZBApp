IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('LFolderShare') AND name='AllowStudy')
BEGIN
	ALTER TABLE LFolderShare ADD AllowStudy	BIT NOT NULL DEFAULT 0;
	PRINT '添加LFolderShare内的AllowStudy成功';
END

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('LFolderShare') AND name='IsIncludeSubDept')
BEGIN
	ALTER TABLE LFolderShare ADD IsIncludeSubDept	BIT NOT NULL DEFAULT 0;
	PRINT '添加LFolderShare内的IsIncludeSubDept成功';
END