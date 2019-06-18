IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('WebExamineePaperDetail') AND name='IsLook')
BEGIN
	ALTER TABLE WebExamineePaperDetail ADD IsLook	BIT NOT NULL DEFAULT 0;
	PRINT '添加WebExamineePaperDetail内的IsLook成功';
END

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('WebExamineePaperDetail') AND name='IsLook')
BEGIN
	ALTER TABLE WebExam ADD IsLook	BIT NOT NULL DEFAULT 0;
	PRINT '添加WebExamineePaperDetail内的IsLook成功';
END

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('WebExam') AND name='WebExamDoPaperMode')
BEGIN
	ALTER TABLE WebExam ADD WebExamDoPaperMode	INT NOT NULL DEFAULT 0;
	PRINT '添加WebExam内的WebExamDoPaperMode成功';
END

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('WebExam') AND name='CanEditLookQues')
BEGIN
	ALTER TABLE WebExam ADD CanEditLookQues	BIT NOT NULL DEFAULT 0;
	PRINT '添加WebExam内的CanEditLookQues成功';
END

IF EXISTS(SELECT * FROM syscolumns WHERE id = object_id('WebPaperPackage') AND name='ObjectName')
BEGIN
	ALTER TABLE WebPaperPackage ALTER COLUMN ObjectName NVARCHAR(255) NOT NULL;
	PRINT '修改‘WebPaperPackage’内的‘ObjectName’成功';
END