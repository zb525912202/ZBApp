

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('WebExam') AND name='ExamGroupName')
BEGIN
	--�����ڸ��ֶΣ�����ӣ�ʹ�� ADD ���
	ALTER TABLE WebExam ADD ExamGroupName NVARCHAR(50);
	PRINT '��ӡ�WebExam���ڵġ�ExamGroupName���ɹ�';
END
