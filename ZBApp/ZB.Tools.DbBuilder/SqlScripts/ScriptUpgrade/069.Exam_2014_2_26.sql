IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('WebExam') AND name='IsAllowOthersPapers')
BEGIN
	ALTER TABLE WebExam ADD IsAllowOthersPapers	BIT NOT NULL DEFAULT 0;
	PRINT '添加WebExam内的IsAllowOthersPapers成功';
END