IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('WebExamineePaperDetail') AND name='IsMark')
BEGIN
	ALTER TABLE WebExamineePaperDetail ADD IsMark	BIT NOT NULL DEFAULT 0;
	PRINT '添加WebExamineePaperDetail内的IsMark成功';
END

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('WebExamineePaperDetail') AND name='MarkContent')
BEGIN
	ALTER TABLE WebExamineePaperDetail ADD MarkContent	NVARCHAR(200) NULL;
	PRINT '添加WebExamineePaperDetail内的MarkContent成功';
END

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('WebExamineePaperDetail') AND name='GradeContent')
BEGIN
	ALTER TABLE WebExamineePaperDetail ADD GradeContent	NVARCHAR(200) NULL;
	PRINT '添加WebExamineePaperDetail内的GradeContent成功';
END