IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('WebPaperPackage') AND name='IsRandomPaper')
BEGIN
	ALTER TABLE WebPaperPackage ADD IsRandomPaper BIT NOT NULL DEFAULT 0;
	PRINT '添加WebPaperPackage内的是否随机卷成功';
END

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('WebExamineePaper') AND name='IsRandomPaper')
BEGIN
	ALTER TABLE WebExamineePaper ADD IsRandomPaper BIT NOT NULL DEFAULT 0;
	PRINT '添加WebExamineePaper内的是否随机卷成功';
END
