IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('WebExam') AND name='CanAppJoin')
BEGIN
	ALTER TABLE WebExam ADD CanAppJoin BIT NOT NULL DEFAULT 1;
	PRINT '添加WebExam的CanAppJoin成功';
END

