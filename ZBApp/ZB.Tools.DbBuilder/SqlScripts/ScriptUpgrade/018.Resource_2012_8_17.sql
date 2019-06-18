

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('Question') AND name='QuestionCreateType')
BEGIN
	--不存在该字段，测添加，使用 ADD 语句
	ALTER TABLE Question ADD QuestionCreateType INT NOT NULL DEFAULT 0;

	CREATE NONCLUSTERED INDEX [IDX_Question_QuestionCreateType] ON [dbo].[Question]
	(
		[QuestionCreateType] ASC	
	);
	PRINT '添加‘Question’内的‘QuestionCreateType’成功';
END
GO