
USE [$(DatabaseName)]
GO
BEGIN TRANSACTION

PRINT '------ 知识结构文件夹 ------'
CREATE TABLE [dbo].[MFolder](
	[Id]				INT PRIMARY KEY NOT NULL,							-- 唯一标识
	[ProCategoryId]		INT NOT NULL,										--职岗类型Id
	[ParentId]			INT NOT NULL,										-- 父文件夹Id（根文件夹的话，要更新）
	[ObjectName]		NVARCHAR(50) NOT NULL,								-- 文件名称（也包括文件夹名称）
	[FullPath]			NVARCHAR(255) NOT NULL,								-- 全路径（文件夹/……/文件）
	[DeptId]			INT NOT NULL,										-- 部门Id
	[Comment]			NVARCHAR(400) NULL,									-- 批注
	[CreateTime]		DATETIME NULL,										-- 创建时间
	[CreatorId]			INT NULL,											-- 创建用户ID
	[CreatorName]		NVARCHAR(50) NULL,									-- 创建用户姓名
	[SortIndex]			INT NOT NULL DEFAULT ((0)),							-- 排序索引
)
GO
ALTER TABLE [MFolder] WITH CHECK ADD
	CONSTRAINT [FK_MFolder_ProfessionCategory] FOREIGN KEY([ProCategoryId]) REFERENCES [ProfessionCategory]([Id])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_MFolder_ProCategoryIdFullPath] ON [dbo].[MFolder] 
(
	[ProCategoryId] ASC,
	[FullPath] ASC
)
GO
CREATE NONCLUSTERED INDEX [IDX_MFolder_ProCategoryId] ON [dbo].[MFolder]
(
	[ProCategoryId] ASC,
	[Id] ASC	
)
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_MFolder_ProCategoryId_ParentId_ObjectName] ON [dbo].[MFolder] 
(
	[ProCategoryId] ASC,
	[ParentId] ASC,
	[ObjectName] ASC
)
GO


PRINT '---------模块------------'

CREATE TABLE [dbo].[Module](
	[Id]				INT  PRIMARY KEY NOT NULL,									--ID								
	[ObjectName]		NVARCHAR(50) NOT NULL,										--模块名称
	[Code]				NVARCHAR(50) NOT NULL,										--编码
	[MFolderId]			INT NOT NULL,												--知识结构文件夹Id
	[ProCategoryId]		INT NOT NULL,												--职岗类型
)

CREATE UNIQUE NONCLUSTERED INDEX [IDX_[MFolderId_ObjectName] ON [dbo].[Module]
(
	[MFolderId] ASC,
	[ObjectName] ASC
)
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_Module_Code] ON [dbo].[Module] 
(
	[Code] ASC
)
GO

ALTER TABLE [Module] WITH CHECK ADD
	CONSTRAINT [FK_Module_MFolderId] FOREIGN KEY([MFolderId]) REFERENCES [MFolder]([Id])
GO

ALTER TABLE [Module] WITH CHECK ADD
	CONSTRAINT [FK_Module_ProCategoryId] FOREIGN KEY([ProCategoryId]) REFERENCES [ProfessionCategory]([Id])
GO


PRINT '---------模块级别与掌握程度------------'
CREATE TABLE [dbo].[ModuleLevel](
	[Id]				INT IDENTITY(1,1) PRIMARY KEY,
	[ModuleId]			INT NOT NULL,								--模块ID
	[MasteryLevel]		INT NOT NULL,								--掌握程度
	[Level]				INT	NULL,									--级别
)
GO
ALTER TABLE [ModuleLevel] WITH CHECK ADD
	CONSTRAINT [FK_ModuleLevel_ModuleId] FOREIGN KEY([ModuleId]) REFERENCES [Module]([Id])
GO



COMMIT TRANSACTION