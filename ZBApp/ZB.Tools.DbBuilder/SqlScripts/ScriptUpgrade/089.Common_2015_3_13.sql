--089.Common_2015_3_13
IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('Employee') AND name='SortIndex')
BEGIN
	ALTER TABLE [Employee] ADD SortIndex INT NOT NULL DEFAULT 0;
	PRINT '添加人员表排序字段';
END
GO
