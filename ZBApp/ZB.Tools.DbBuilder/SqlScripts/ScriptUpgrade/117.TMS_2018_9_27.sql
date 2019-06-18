IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('TrainingWorkExam') AND name='IsAutoGrade')
BEGIN
	ALTER TABLE TrainingWorkExam ADD IsAutoGrade BIT NOT NULL DEFAULT 0;
	PRINT '添加TrainingWorkExam内的IsAutoGrade成功';
END


IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('TrainingWorkExam') AND name='RightPercentMode')
BEGIN
	ALTER TABLE TrainingWorkExam ADD RightPercentMode INT NOT NULL DEFAULT 0;
	PRINT '添加TrainingWorkExam内的RightPercentMode成功';
END
GO