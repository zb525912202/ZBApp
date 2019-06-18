

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('WebExam') AND name='ExamGroupName')
BEGIN
	--不存在该字段，测添加，使用 ADD 语句
	ALTER TABLE WebExam ADD ExamGroupName NVARCHAR(50);
	PRINT '添加‘WebExam’内的‘ExamGroupName’成功';
END
