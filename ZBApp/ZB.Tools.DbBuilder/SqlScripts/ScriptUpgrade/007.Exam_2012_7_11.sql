


--为试卷表添加试卷导出配置字段，保存试卷每次导出的设置
IF EXISTS(SELECT * FROM syscolumns WHERE id = object_id('WebPaperPackage') AND name='ExportConfig')
BEGIN
	ALTER TABLE WebPaperPackage ALTER COLUMN ExportConfig VARBINARY(MAX);
	PRINT '修改试卷表内的试卷导出设置成功';
END
ELSE
BEGIN
	ALTER TABLE WebPaperPackage ADD ExportConfig VARBINARY(MAX);
	PRINT '添加试卷表内的试卷导出设置成功';
END

GO

--为网络考试试卷表添加试卷总分列
IF EXISTS(SELECT * FROM syscolumns WHERE id = object_id('WebPaperPackage') AND name='PaperScore')
BEGIN
	ALTER TABLE WebPaperPackage ALTER COLUMN PaperScore DECIMAL(18,1) NOT NULL;
	PRINT '修改试卷表内的试卷总分成功';
END
ELSE
BEGIN
	ALTER TABLE WebPaperPackage ADD PaperScore DECIMAL(18,1) NOT NULL DEFAULT 0;
	PRINT '添加试卷表内的试卷总分成功';
END

GO

--为网络考试试卷表添加试卷题量
IF EXISTS(SELECT * FROM syscolumns WHERE id = object_id('WebPaperPackage') AND name='PaperQuesCount')
BEGIN
	ALTER TABLE WebPaperPackage ALTER COLUMN PaperQuesCount INT NOT NULL;
	PRINT '修改试卷表内的试卷题量成功';
END
ELSE
BEGIN
	ALTER TABLE WebPaperPackage ADD PaperQuesCount INT NOT NULL DEFAULT 0;
	PRINT '添加试卷表内的试卷题量成功';
END

GO

--为网络考试考生试卷表添加试卷总分列
IF EXISTS(SELECT * FROM syscolumns WHERE id = object_id('WebExamineePaper') AND name='PaperScore')
BEGIN
	ALTER TABLE WebExamineePaper ALTER COLUMN PaperScore DECIMAL(18,1) NOT NULL;
	PRINT '修改试卷表内的试卷总分成功';
END
ELSE
BEGIN
	ALTER TABLE WebExamineePaper ADD PaperScore DECIMAL(18,1) NOT NULL DEFAULT 0;
	PRINT '添加试卷表内的试卷总分成功';
END

GO

--为网络考试考生试卷表添加试卷题量
IF EXISTS(SELECT * FROM syscolumns WHERE id = object_id('WebExamineePaper') AND name='PaperQuesCount')
BEGIN
	ALTER TABLE WebExamineePaper ALTER COLUMN PaperQuesCount INT NOT NULL;
	PRINT '修改试卷表内的试卷题量成功';
END
ELSE
BEGIN
	ALTER TABLE WebExamineePaper ADD PaperQuesCount INT NOT NULL DEFAULT 0;
	PRINT '添加试卷表内的试卷题量成功';
END
