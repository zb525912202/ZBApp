

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('Question') AND name='QuestionCreateType')
BEGIN
	--�����ڸ��ֶΣ�����ӣ�ʹ�� ADD ���
	ALTER TABLE Question ADD QuestionCreateType INT NOT NULL DEFAULT 0;

	CREATE NONCLUSTERED INDEX [IDX_Question_QuestionCreateType] ON [dbo].[Question]
	(
		[QuestionCreateType] ASC	
	);
	PRINT '��ӡ�Question���ڵġ�QuestionCreateType���ɹ�';
END
GO