
IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('WebExam') AND name='IsNeedFaceMatch')
BEGIN
	ALTER TABLE WebExam ADD IsNeedFaceMatch BIT NOT NULL DEFAULT 0;
	PRINT '添加‘WebExam’的‘是否需要进行人脸比对字段(IsNeedFaceMatch)’成功';
END
GO