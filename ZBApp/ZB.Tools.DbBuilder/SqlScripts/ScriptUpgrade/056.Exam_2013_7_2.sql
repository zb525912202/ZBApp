

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('WebExam') AND name='WebExamType')
BEGIN
	ALTER TABLE WebExam ADD WebExamType INT NOT NULL DEFAULT 0;		--���翼������(0�����翼�ԣ�1��TM���翼��)	
	PRINT '���WebExam���ڵ�WebExamType�ɹ�';
END
