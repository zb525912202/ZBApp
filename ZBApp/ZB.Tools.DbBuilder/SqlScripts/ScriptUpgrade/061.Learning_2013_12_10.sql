IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('PQRequiredPaperPackage') AND name='IsRandomPaper')
BEGIN
	ALTER TABLE PQRequiredPaperPackage ADD IsRandomPaper BIT NOT NULL DEFAULT 0;
	PRINT '添加PQRequiredPaperPackage表内的是否随机卷成功';
END