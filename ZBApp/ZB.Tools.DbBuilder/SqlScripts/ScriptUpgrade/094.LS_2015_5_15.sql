IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('NetClassSectionQues') AND name='QuestionId')
BEGIN
	ALTER TABLE NetClassSectionQues ADD QuestionId	INT NOT NULL DEFAULT 0;
	PRINT '���NetClassSectionQues�ڵ�QuestionId�ɹ�';
END

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('SectionQues') AND name='QuestionId')
BEGIN
	ALTER TABLE SectionQues ADD QuestionId	INT NOT NULL DEFAULT 0;
	PRINT '���SectionQues�ڵ�QuestionId�ɹ�';
END
