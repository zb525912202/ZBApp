

PRINT '------ ѧԱ����ѧϰλ�ñ� ------'
IF EXISTS(SELECT * FROM syscolumns WHERE id = object_id('QuesStudyPosition') AND name='QtIds')
BEGIN
	ALTER TABLE QuesStudyPosition DROP COLUMN QtIds;
	ALTER TABLE QuesStudyPosition ADD QtId INT NOT NULL DEFAULT 0;	
	PRINT '�޸ġ�QuesStudyPosition���ڵġ�QtIds��Ϊ��QtId���ɹ�';
END
GO

