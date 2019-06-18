IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('PaperPackage') AND name='IsRandomPaper')
BEGIN
	ALTER TABLE PaperPackage ADD IsRandomPaper BIT NOT NULL DEFAULT 0;
	PRINT '添加PaperPackage内的IsRandomPaper成功';
END