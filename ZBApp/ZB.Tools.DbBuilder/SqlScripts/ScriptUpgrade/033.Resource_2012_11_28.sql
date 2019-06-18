

PRINT '------ 试题文件夹共享 ------'
IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('QFolderShare') AND name='SharedId')
BEGIN
	DROP TABLE [dbo].[QFolderShare];

	PRINT '删除试题文件夹共享成功';

	PRINT '------创建试题文件夹共享表------';
	
	CREATE TABLE [dbo].[QFolderShare](
		[Id]				INT PRIMARY KEY NOT NULL,							-- 唯一标识
		[FolderId]			INT NOT NULL,										-- 文件夹Id
		[SharedType]		INT NOT NULL,										-- 共享类型(0:所有人, 1:所有部门, 2:人员, 3:部门， 4:岗位)
		[SharedId]			INT NOT NULL,										-- 共享ID(人员ID,部门ID,岗位ID)
		[SharedName]		NVARCHAR(320) NOT NULL,								-- 共享名称(冗余)
		[SharedMode]		INT NOT NULL DEFAULT(0)								-- 共享模式(0:只读，1:读写)
	)

	ALTER TABLE [QFolderShare]  WITH CHECK ADD  
		CONSTRAINT [FK_QFolderShare_QFolder] FOREIGN KEY([FolderId]) REFERENCES [QFolder] ([Id])

	PRINT '------创建试题文件夹共享表成功------'
END





PRINT '------ 试卷文件夹共享 ------'
IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('PFolderShare') AND name='SharedId')
BEGIN
	DROP TABLE [dbo].[PFolderShare];

	PRINT '删除试卷文件夹共享成功';

	PRINT '------创建试卷文件夹共享表------';
	
	CREATE TABLE [dbo].[PFolderShare](
		[Id]				INT PRIMARY KEY NOT NULL,							-- 唯一标识
		[FolderId]			INT NOT NULL,										-- 文件夹Id
		[SharedType]		INT NOT NULL,										-- 共享类型(0:所有人, 1:所有部门, 2:人员, 3:部门， 4:岗位)
		[SharedId]			INT NOT NULL,										-- 共享ID(人员ID,部门ID,岗位ID)
		[SharedName]		NVARCHAR(320) NOT NULL,								-- 共享名称(冗余)
		[SharedMode]		INT NOT NULL DEFAULT(0)								-- 共享模式(0:只读，1:读写)
	)

	ALTER TABLE [PFolderShare]  WITH CHECK ADD  
		CONSTRAINT [FK_PFolderShare_PFolder] FOREIGN KEY([FolderId]) REFERENCES [PFolder] ([Id])

	PRINT '------创建试卷文件夹共享表成功------'
END



PRINT '------ 资源文件夹共享 ------'
IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('RFolderShare') AND name='SharedId')
BEGIN
	DROP TABLE [dbo].[RFolderShare];

	PRINT '删除资源文件夹共享成功';

	PRINT '------创建资源文件夹共享表------';
	
	CREATE TABLE [dbo].[RFolderShare](
		[Id]				INT PRIMARY KEY NOT NULL,							-- 唯一标识
		[FolderId]			INT NOT NULL,										-- 文件夹Id
		[SharedType]		INT NOT NULL,										-- 共享类型(0:所有人, 1:所有部门, 2:人员, 3:部门， 4:岗位)
		[SharedId]			INT NOT NULL,										-- 共享ID(人员ID,部门ID,岗位ID)
		[SharedName]		NVARCHAR(320) NOT NULL,								-- 共享名称(冗余)
		[SharedMode]		INT NOT NULL DEFAULT(0)								-- 共享模式(0:只读，1:读写)
	)

	ALTER TABLE [RFolderShare]  WITH CHECK ADD  
		CONSTRAINT [FK_RFolderShare_RFolder] FOREIGN KEY([FolderId]) REFERENCES [RFolder] ([Id])

	PRINT '------创建资源文件夹共享表成功------'
END


PRINT '------ 重建试题文件夹共享索引 ------'
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[QFolder]') AND name = N'Index_QFolder_Shared')
DROP INDEX [Index_QFolder_Shared] ON [dbo].[QFolder] WITH ( ONLINE = OFF )
GO

CREATE NONCLUSTERED INDEX [Index_QFolder_Shared] ON [dbo].[QFolder] 
(
	[DeptId] ASC,
	[FullPath] ASC,
	[Id] ASC
)
INCLUDE (
	[ParentId],
	[ObjectName],
	[Comment],
	[SortIndex]
)
GO
