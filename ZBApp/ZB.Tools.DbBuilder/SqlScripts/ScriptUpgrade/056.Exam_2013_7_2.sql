

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('WebExam') AND name='WebExamType')
BEGIN
	ALTER TABLE WebExam ADD WebExamType INT NOT NULL DEFAULT 0;		--网络考试类型(0、网络考试，1、TM网络考试)	
	PRINT '添加WebExam表内的WebExamType成功';
END
