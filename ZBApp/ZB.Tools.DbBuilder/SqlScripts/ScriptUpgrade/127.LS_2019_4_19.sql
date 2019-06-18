IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('LessonExamineePaperDetail') AND name='GraderId')
BEGIN
	ALTER TABLE LessonExamineePaperDetail ADD GraderId INT NOT NULL DEFAULT 0;
	PRINT '添加LessonExamineePaperDetail内的GraderId成功';
END

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('LessonExamineePaperDetail') AND name='GraderName')
BEGIN
	ALTER TABLE LessonExamineePaperDetail ADD GraderName NVARCHAR(50) NOT NULL DEFAULT '';
	PRINT '添加LessonExamineePaperDetail内的GraderName成功';
END
GO