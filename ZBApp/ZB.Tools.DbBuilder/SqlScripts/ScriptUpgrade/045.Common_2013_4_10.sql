

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('Teacher') AND name='IsOutSideTeacher')
BEGIN	
	ALTER TABLE Teacher ADD IsOutSideTeacher Bit NOT NULL DEFAULT 0;
	PRINT '��ӡ�Teacher���ڵġ�IsOutSideTeacher���ɹ�';
END
GO

