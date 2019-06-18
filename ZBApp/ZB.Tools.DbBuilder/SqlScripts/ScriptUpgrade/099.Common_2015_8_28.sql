IF EXISTS(SELECT * FROM syscolumns WHERE id = object_id('PostStandard') AND name='ObjectName')
BEGIN
	ALTER TABLE PostStandard ALTER COLUMN ObjectName NVARCHAR(500);
	PRINT '修改‘PostStandard’内的‘ObjectName’长度为NVARCHAR(500)成功';
END


IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('FriendLink') AND name='IsLoginShow')
BEGIN
	ALTER TABLE FriendLink ADD IsLoginShow BIT NOT NULL DEFAULT 0;
	PRINT '添加FriendLink内的IsLoginShow成功';
END
GO