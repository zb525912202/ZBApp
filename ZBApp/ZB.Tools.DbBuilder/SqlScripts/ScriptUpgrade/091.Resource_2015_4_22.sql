IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('QFolderShare') AND name='AllowStudy')
BEGIN
	ALTER TABLE QFolderShare ADD AllowStudy	BIT NOT NULL DEFAULT 0;
	PRINT '添加QFolderShare内的AllowStudy成功';
END

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('QFolderShare') AND name='IsIncludeSubDept')
BEGIN
	ALTER TABLE QFolderShare ADD IsIncludeSubDept	BIT NOT NULL DEFAULT 0;
	PRINT '添加QFolderShare内的IsIncludeSubDept成功';
END

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('PFolderShare') AND name='AllowStudy')
BEGIN
	ALTER TABLE PFolderShare ADD AllowStudy	BIT NOT NULL DEFAULT 0;
	PRINT '添加PFolderShare内的AllowStudy成功';
END

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('PFolderShare') AND name='IsIncludeSubDept')
BEGIN
	ALTER TABLE PFolderShare ADD IsIncludeSubDept	BIT NOT NULL DEFAULT 0;
	PRINT '添加PFolderShare内的IsIncludeSubDept成功';
END

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('RFolderShare') AND name='AllowStudy')
BEGIN
	ALTER TABLE RFolderShare ADD AllowStudy	BIT NOT NULL DEFAULT 0;
	PRINT '添加RFolderShare内的AllowStudy成功';
END

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('RFolderShare') AND name='IsIncludeSubDept')
BEGIN
	ALTER TABLE RFolderShare ADD IsIncludeSubDept	BIT NOT NULL DEFAULT 0;
	PRINT '添加RFolderShare内的IsIncludeSubDept成功';
END