IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('WebExamineePaper') AND name='ReplyTimeSpan')
BEGIN
	ALTER TABLE WebExamineePaper ADD ReplyTimeSpan INT NOT NULL DEFAULT 0;
	PRINT '添加WebExamineePaper内的答卷时长成功';
END
