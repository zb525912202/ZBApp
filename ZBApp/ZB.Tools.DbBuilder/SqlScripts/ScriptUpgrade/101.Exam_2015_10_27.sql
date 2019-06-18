
IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('WebExam') AND name='WorkId')
BEGIN
	ALTER TABLE WebExam ADD WorkId INT NOT NULL DEFAULT 0;
	PRINT '添加‘WebExam’的‘WorkId’成功';
END
GO