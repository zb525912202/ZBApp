
--为试卷表添加试卷导出配置字段，保存试卷每次导出的设置
IF EXISTS(SELECT * FROM syscolumns WHERE id = object_id('PaperPackage') AND name='ExportConfig')
BEGIN
	ALTER TABLE PaperPackage ALTER COLUMN ExportConfig VARBINARY(MAX);
	PRINT '修改试卷表内的试卷导出设置成功';
END
ELSE
BEGIN
	ALTER TABLE PaperPackage ADD ExportConfig VARBINARY(MAX);
	PRINT '添加试卷表内的试卷导出设置成功';
END

GO

--为试卷表添加试卷总分列
IF EXISTS(SELECT * FROM syscolumns WHERE id = object_id('PaperPackage') AND name='PaperScore')
BEGIN
	ALTER TABLE PaperPackage ALTER COLUMN PaperScore DECIMAL(18,1) NOT NULL;
	PRINT '修改试卷表内的试卷总分成功';
END
ELSE
BEGIN
	ALTER TABLE PaperPackage ADD PaperScore DECIMAL(18,1) NOT NULL DEFAULT 0;
	PRINT '添加试卷表内的试卷总分成功';
END

GO

--为试卷表添加试卷题量
IF EXISTS(SELECT * FROM syscolumns WHERE id = object_id('PaperPackage') AND name='PaperQuesCount')
BEGIN
	ALTER TABLE PaperPackage ALTER COLUMN PaperQuesCount INT NOT NULL;
	PRINT '修改试卷表内的试卷题量成功';
END
ELSE
BEGIN
	ALTER TABLE PaperPackage ADD PaperQuesCount INT NOT NULL DEFAULT 0;
	PRINT '添加试卷表内的试卷题量成功';
END

