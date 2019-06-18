

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('Teacher') AND name='IsOutSideTeacher')
BEGIN	
	ALTER TABLE Teacher ADD IsOutSideTeacher Bit NOT NULL DEFAULT 0;
	PRINT '添加‘Teacher’内的‘IsOutSideTeacher’成功';
END
GO

