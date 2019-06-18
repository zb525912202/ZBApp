IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('WebExam') AND name='IsAutoGrade')
BEGIN
	ALTER TABLE WebExam ADD IsAutoGrade BIT NOT NULL DEFAULT 0;
	PRINT '添加WebExamIsAutoGrade成功';
END


IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('WebExam') AND name='RightPercentMode')
BEGIN
	ALTER TABLE WebExam ADD RightPercentMode INT NOT NULL DEFAULT 0;
	PRINT '添加WebExam内的RightPercentMode成功';
END
GO