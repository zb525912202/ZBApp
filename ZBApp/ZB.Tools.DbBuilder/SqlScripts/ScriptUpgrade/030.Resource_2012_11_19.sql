

PRINT '添加字段到[Comment]表'

IF EXISTS(SELECT * FROM syscolumns WHERE id = object_id('Comment') AND name='SourceName')
BEGIN
	ALTER TABLE [Comment] ALTER COLUMN [SourceName] NVARCHAR(255);
	PRINT '修改‘[Comment]’内的‘SourceName’成功';
END
ELSE
BEGIN
	--不存在该字段，测添加，使用 ADD 语句
	ALTER TABLE [Comment] ADD [SourceName] NVARCHAR(255);
	PRINT '添加‘[Comment]’内的‘[SourceName]’成功';
END
GO

IF EXISTS(SELECT * FROM syscolumns WHERE id = object_id('Comment') AND name='EmployeeNO')
BEGIN
	ALTER TABLE [Comment] ALTER COLUMN [EmployeeNO] NVARCHAR(50);
	PRINT '修改‘[Comment]’内的‘EmployeeNO’成功';
END
ELSE
BEGIN
	--不存在该字段，测添加，使用 ADD 语句
	ALTER TABLE [Comment] ADD [EmployeeNO] NVARCHAR(50);
	PRINT '添加‘[Comment]’内的‘[EmployeeNO]’成功';
END
GO

IF EXISTS(SELECT * FROM syscolumns WHERE id = object_id('Comment') AND name='DeptFullPath')
BEGIN
	ALTER TABLE [Comment] ALTER COLUMN [DeptFullPath] NVARCHAR(260);
	PRINT '修改‘[Comment]’内的‘DeptFullPath’成功';
END
ELSE
BEGIN
	--不存在该字段，测添加，使用 ADD 语句
	ALTER TABLE [Comment] ADD [DeptFullPath] NVARCHAR(260);
	PRINT '添加‘[Comment]’内的‘[DeptFullPath]’成功';
END
GO

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('Comment') AND name='IsIgnore')
BEGIN
	--不存在该字段，测添加，使用 ADD 语句
	ALTER TABLE [Comment] ADD [IsIgnore] BIT NOT NULL DEFAULT(0);
	PRINT '添加‘[Comment]’内的‘IsIgnore’成功';
END
GO
