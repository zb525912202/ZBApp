IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('WebExam') AND name='IsReplaceScoring')
BEGIN
	ALTER TABLE WebExam ADD IsReplaceScoring BIT NOT NULL DEFAULT 0;
	PRINT '添加WebExam内的是否可由他人阅卷成功';
END

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('WebExam') AND name='PaperGradePolicyByte')
BEGIN
	ALTER TABLE WebExam ADD PaperGradePolicyByte VARBINARY(MAX) NULL;
	PRINT '添加WebExam阅卷任务设置成功';
END
