IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('Notice') AND name='CreatorId')
BEGIN
	ALTER TABLE Notice ADD CreatorId INT NOT NULL DEFAULT 0;
	PRINT '添加公告表内的创建人Id字段';
END
GO

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('Notice') AND name='CreatorName')
BEGIN
	ALTER TABLE Notice ADD CreatorName NVARCHAR(50) NULL;
	PRINT '添加公告表内的创建人姓名字段';
END
GO

