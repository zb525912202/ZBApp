

PRINT '------ 学员试题学习位置表 ------'
IF EXISTS(SELECT * FROM syscolumns WHERE id = object_id('QuesStudyPosition') AND name='QtIds')
BEGIN
	ALTER TABLE QuesStudyPosition DROP COLUMN QtIds;
	ALTER TABLE QuesStudyPosition ADD QtId INT NOT NULL DEFAULT 0;	
	PRINT '修改‘QuesStudyPosition’内的‘QtIds’为‘QtId’成功';
END
GO

