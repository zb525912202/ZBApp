IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('LFolderShare') AND name='AllowStudy')
BEGIN
	ALTER TABLE LFolderShare ADD AllowStudy	BIT NOT NULL DEFAULT 0;
	PRINT '���LFolderShare�ڵ�AllowStudy�ɹ�';
END

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('LFolderShare') AND name='IsIncludeSubDept')
BEGIN
	ALTER TABLE LFolderShare ADD IsIncludeSubDept	BIT NOT NULL DEFAULT 0;
	PRINT '���LFolderShare�ڵ�IsIncludeSubDept�ɹ�';
END