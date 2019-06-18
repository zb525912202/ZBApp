IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MFolder]') AND type in (N'U'))
BEGIN
	PRINT '------ 知识结构文件夹 ------'
	CREATE TABLE [dbo].[MFolder](
		[Id]				INT PRIMARY KEY NOT NULL,							-- 唯一标识
		[ParentId]			INT NOT NULL,										-- 父文件夹Id（根文件夹的话，要更新）
		[ProCategoryId]		INT NOT NULL,										--职岗类型Id
		[ObjectName]		NVARCHAR(50) NOT NULL,								-- 文件名称（也包括文件夹名称）
		[FullPath]			NVARCHAR(255) NOT NULL,								-- 全路径（文件夹/……/文件）
		[DeptId]			INT NOT NULL,										-- 部门Id
		[Comment]			NVARCHAR(400) NULL,									-- 批注
		[CreateTime]		DATETIME NULL,									-- 创建时间
		[CreatorId]			INT NULL,										-- 创建用户ID
		[CreatorName]		NVARCHAR(50) NULL,								-- 创建用户姓名
		[SortIndex]			INT NOT NULL DEFAULT ((0)),							-- 排序索引
	)
	ALTER TABLE [MFolder] WITH CHECK ADD
		CONSTRAINT [FK_MFolder_ProfessionCategory] FOREIGN KEY([ProCategoryId]) REFERENCES [ProfessionCategory]([Id])

		CREATE UNIQUE NONCLUSTERED INDEX [IDX_MFolder_ProCategoryIdFullPath] ON [dbo].[MFolder] 
		(
			[ProCategoryId] ASC,
			[FullPath] ASC
		)

		CREATE NONCLUSTERED INDEX [IDX_MFolder_ProCategoryId] ON [dbo].[MFolder]
		(
			[ProCategoryId] ASC,
			[Id] ASC	
		)

		CREATE UNIQUE NONCLUSTERED INDEX [IDX_MFolder_ProCategoryId_ParentId_ObjectName] ON [dbo].[MFolder] 
		(
			[ProCategoryId] ASC,
			[ParentId] ASC,
			[ObjectName] ASC
		)

END
GO



IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Module]') AND type in (N'U'))
BEGIN
	PRINT '--------模块-------------'
	CREATE TABLE [dbo].[Module](
	[Id]				INT PRIMARY KEY NOT NULL,									--ID								
	[ObjectName]		NVARCHAR(50) NOT NULL,										--模块名称
	[Code]				NVARCHAR(50) NOT NULL,										--编码
	[MFolderId]			INT NOT NULL,												--知识结构文件夹Id
	[ProCategoryId]		INT NOT NULL,												--职岗类型
	)
	CREATE UNIQUE NONCLUSTERED INDEX [IDX_MFolderId_ObjectName] ON [dbo].[Module]
	(
		[MFolderId] ASC,
		[ObjectName] ASC
	)
	CREATE UNIQUE NONCLUSTERED INDEX [IDX_Module_Code] ON [dbo].[Module] 
	(
		[Code] ASC
	)

	ALTER TABLE [Module] WITH CHECK ADD
		CONSTRAINT [FK_Module_MFolderId] FOREIGN KEY([MFolderId]) REFERENCES [MFolder]([Id])

	ALTER TABLE [Module] WITH CHECK ADD
	CONSTRAINT [FK_Module_ProCategoryId] FOREIGN KEY([ProCategoryId]) REFERENCES [ProfessionCategory]([Id])
END
GO

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ModuleLevel]') AND type in (N'U'))
BEGIN
	PRINT '---------模块级别与掌握程度------------'
	CREATE TABLE [dbo].[ModuleLevel](
		[Id]				INT IDENTITY(1,1) PRIMARY KEY,
		[ModuleId]			INT NOT NULL,								--模块ID
		[MasteryLevel]	INT NOT NULL,									--掌握程度
		[Level]				INT	NULL,									--级别
	)
	ALTER TABLE [ModuleLevel] WITH CHECK ADD
		CONSTRAINT [FK_ModuleLevel_ModuleId] FOREIGN KEY([ModuleId]) REFERENCES [Module]([Id])
	
END
GO


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ModuleInProfession]') AND type in (N'U'))
BEGIN
	PRINT '--------模块与职业的对应关系-------------'
CREATE TABLE [dbo].[ModuleInProfession](
	[ModuleId]			INT NOT NULL PRIMARY KEY,					--模块ID
	[ProfessionId]		INT NOT NULL,								--标准ID
)

ALTER TABLE [ModuleInProfession] WITH CHECK ADD
	CONSTRAINT [FK_ModuleInProfession_ModuleId] FOREIGN KEY([ModuleId]) REFERENCES [Module]([Id])

ALTER TABLE [ModuleInProfession] WITH CHECK ADD
	CONSTRAINT [FK_ModuleInProfession_ProfessionId] FOREIGN KEY([ProfessionId]) REFERENCES [Profession]([Id])
END
GO

--删除约束
IF EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_PostInProfession_Level]') AND parent_object_id = OBJECT_ID(N'[dbo].[PostInProfession]'))
BEGIN
	PRINT '修改PostInProfession默认约束DF_PostInProfession_Level成功';
	ALTER TABLE PostInProfession DROP CONSTRAINT DF_PostInProfession_Level
END
GO

IF EXISTS(SELECT * FROM syscolumns WHERE id = object_id('PostInProfession') AND name='Level')
BEGIN
	UPDATE PostInProfession SET [Level]=0 WHERE [Level] IS NULL;
	ALTER TABLE PostInProfession ALTER COLUMN [Level] INT NOT NULL;	
	ALTER TABLE PostInProfession ADD CONSTRAINT DF_PostInProfession_Level DEFAULT 0 FOR [Level]; -------说明：添加一个表的字段的约束并指定默认值

	PRINT '修改PostInProfession列Level成功';
END
GO





