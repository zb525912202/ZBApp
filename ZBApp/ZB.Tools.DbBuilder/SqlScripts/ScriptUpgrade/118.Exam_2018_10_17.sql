IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('WebExam') AND name='IsShowGrader')
BEGIN
	ALTER TABLE WebExam ADD IsShowGrader BIT NOT NULL DEFAULT 0;
	PRINT '添加WebExam的IsShowGrader成功';
END


IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('WebExam') AND name='AfterExamTimeSpan')
BEGIN
	ALTER TABLE WebExam ADD AfterExamTimeSpan INT NOT NULL DEFAULT 0;
	PRINT '添加WebExam内的AfterExamTimeSpan成功';
END

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('WebExam') AND name='BeforeExamTimeSpan')
BEGIN
	ALTER TABLE WebExam ADD BeforeExamTimeSpan INT NOT NULL DEFAULT 0;
	PRINT '添加WebExam内的BeforeExamTimeSpan成功';
END
GO