IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('QFolderShare') AND name='AllowStudy')
BEGIN
	ALTER TABLE QFolderShare ADD AllowStudy	BIT NOT NULL DEFAULT 0;
	PRINT '���QFolderShare�ڵ�AllowStudy�ɹ�';
END

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('QFolderShare') AND name='IsIncludeSubDept')
BEGIN
	ALTER TABLE QFolderShare ADD IsIncludeSubDept	BIT NOT NULL DEFAULT 0;
	PRINT '���QFolderShare�ڵ�IsIncludeSubDept�ɹ�';
END

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('PFolderShare') AND name='AllowStudy')
BEGIN
	ALTER TABLE PFolderShare ADD AllowStudy	BIT NOT NULL DEFAULT 0;
	PRINT '���PFolderShare�ڵ�AllowStudy�ɹ�';
END

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('PFolderShare') AND name='IsIncludeSubDept')
BEGIN
	ALTER TABLE PFolderShare ADD IsIncludeSubDept	BIT NOT NULL DEFAULT 0;
	PRINT '���PFolderShare�ڵ�IsIncludeSubDept�ɹ�';
END

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('RFolderShare') AND name='AllowStudy')
BEGIN
	ALTER TABLE RFolderShare ADD AllowStudy	BIT NOT NULL DEFAULT 0;
	PRINT '���RFolderShare�ڵ�AllowStudy�ɹ�';
END

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('RFolderShare') AND name='IsIncludeSubDept')
BEGIN
	ALTER TABLE RFolderShare ADD IsIncludeSubDept	BIT NOT NULL DEFAULT 0;
	PRINT '���RFolderShare�ڵ�IsIncludeSubDept�ɹ�';
END