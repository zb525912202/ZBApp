
USE [$(DatabaseName)]
GO
BEGIN TRANSACTION

PRINT '------ 岗位标准 ------'
CREATE TABLE [dbo].[PostCategory](
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,
	[ObjectName]			NVARCHAR(50) NOT NULL,	
	[SortIndex]				INT NOT NULL DEFAULT 0,
	[LockStatus]			INT NOT NULL,				--如果是系统内置默认的岗位标准，不许改动或删除(值为对应枚举EDictionaryRecordLockStatus的3);新添加项默认为零
)
GO

PRINT '------ 人员状态表 ------'
CREATE TABLE [dbo].[EmployeeStatus](
	[Id]			INT IDENTITY(1,1) PRIMARY KEY,
	[ObjectName]	NVARCHAR(50) NOT NULL,			
	[IsDefault]		BIT NOT NULL,				--是否是系统内置默认人员状态，只会有一个系统内置的'在岗'
	[LockStatus]	INT NOT NULL,				--如果是系统内置默认的人员状态，不许改动或删除(值为对应枚举EDictionaryRecordLockStatus的3);新添加项默认为零
	[SortIndex]		INT NOT NULL DEFAULT 0,
)
GO

PRINT '------ 培训师级别表 ------'
CREATE TABLE  [dbo].[TeacherLevel](
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,
	[ObjectName]			NVARCHAR(50) NOT NULL,									-- 培训师级别表
	[SortIndex]				INT NOT NULL DEFAULT 0,	
)
GO

PRINT '------ 证书驳回提示表 ------'
CREATE TABLE  [dbo].[CertRejectInfo](
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,
	[ObjectName]			NVARCHAR(50) NOT NULL,									-- 培训师级别表
	[SortIndex]				INT NOT NULL DEFAULT 0,	
)
GO

PRINT '------ 专属类型表 ------'
CREATE TABLE  [dbo].[ManageType](
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,
	[ObjectName]			NVARCHAR(50) NOT NULL,									-- 专属类型表
	[IsDefault]				BIT NOT NULL,				--是否是系统内置默认人员状态，只会有一个系统内置的'在岗'
	[LockStatus]			INT NOT NULL,				--如果是系统内置默认的人员状态，不许改动或删除(值为对应枚举EDictionaryRecordLockStatus的3);新添加项默认为零
	[SortIndex]				INT NOT NULL DEFAULT 0,	
)
GO


PRINT '------ 职岗类型体系表 ------'
CREATE TABLE [dbo].[ProfessionCategorySystem](
	[Id]					INT PRIMARY KEY,						--分类ID
	[ObjectName]			NVARCHAR(50) NOT NULL,					--分类名称
	[IsCurrent]				BIT NOT NULL							--是否是当前体系
)
GO

PRINT '------ 职岗类型 ------'
CREATE TABLE [dbo].[ProfessionCategory](
	[Id]					INT PRIMARY KEY,						--类型ID
	[ObjectName]			NVARCHAR(50) NOT NULL,					--类型名称
	[Level]					INT NOT NULL DEFAULT 0,					--层级(二层，三层，四层，五层，空层,对应枚举ProfessionCategoryLevelEnum)
	[Code]					NVARCHAR(50) NULL,						--类型编码
	[SystemId]				INT NOT NULL DEFAULT 1,					--体系Id
	[SortIndex]				INT NOT NULL DEFAULT 0,					--排序序号
	[LockStatus]			INT NOT NULL DEFAULT 0,					--内置的职岗类型，不许改动或删除(值为对应枚举EDictionaryRecordLockStatus的3);新添加项默认为零
	[ProCategoryType]		INT NOT NULL DEFAULT 0,					--文件夹类型(0:普通职岗类型 1：职岗类型分组)
)
GO
ALTER TABLE [ProfessionCategory] WITH CHECK ADD
	CONSTRAINT [FK_ProfessionCategory_SystemId] FOREIGN KEY([SystemId]) REFERENCES [ProfessionCategorySystem]([Id])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_ProfessionCategory_ObjectName] ON [dbo].[ProfessionCategory] 
(
	[SystemId] ASC,
	[ObjectName] ASC
)
GO

CREATE UNIQUE NONCLUSTERED INDEX [IDX_ProfessionCategory_Code] ON [dbo].[ProfessionCategory] 
(
	[SystemId] ASC,
	[Code] ASC
)
WHERE Code IS NOT NULL AND Code !=''
GO

PRINT '------------掌握程度-------------------'
CREATE TABLE [dbo].[MasteryLevel](
	[Id]				INT PRIMARY KEY NOT NULL,
	[ObjectName]		NVARCHAR(10) NOT NULL,			--默认，拔高，应知，应会
	[SortIndex]			INT NOT NULL DEFAULT 0,
	[LockStatus]		INT NOT NULL DEFAULT 0,	
)
GO

PRINT '------ 职业 ------'
CREATE TABLE [dbo].[Profession](
	[Id]					INT PRIMARY KEY,						--职业ID
	[PCategoryId]			INT NOT NULL,							--职网类型ID
	[ObjectName]			NVARCHAR(500) NOT NULL,					--职业名称
	[Code]					NVARCHAR(50) NULL,						--职业编码
	[Describe]				VARBINARY(MAX),							--描述
	[SortIndex]				INT NOT NULL DEFAULT 0,					--排序序号
)
ALTER TABLE [Profession] WITH CHECK ADD
	CONSTRAINT [FK_Profession_PCategoryId] FOREIGN KEY([PCategoryId]) REFERENCES [ProfessionCategory]([Id])
GO

CREATE UNIQUE NONCLUSTERED INDEX [IDX_PCategoryId_ObjectName] ON [dbo].[Profession] 
(
	[PCategoryId] ASC,
	[ObjectName] ASC
)
GO

CREATE UNIQUE NONCLUSTERED INDEX [IDX_Code] ON [dbo].[Profession]
(
	[Code]
)
WHERE Code IS NOT NULL AND Code !=''
GO

PRINT '--------岗位与职业的对应关系-------------'
/*现在的规则是一个岗位仅能对应一个职业，建立此表的原因是考虑后期一个岗位可对应多个标准的情况*/
CREATE TABLE [dbo].[PostInProfession](
	[PostId]			INT NOT NULL PRIMARY KEY,					--岗位ID
	[ProfessionId]		INT NOT NULL,								--标准ID
	[Level]				INT	NOT NULL DEFAULT 0,						--级别
)
GO
ALTER TABLE [PostInProfession] WITH CHECK ADD
	CONSTRAINT [FK_PostInProfession_PostId] FOREIGN KEY([PostId]) REFERENCES [Post]([Id])
GO
ALTER TABLE [PostInProfession] WITH CHECK ADD
	CONSTRAINT [FK_PostInProfession_ProfessionId] FOREIGN KEY([ProfessionId]) REFERENCES [Profession]([Id])
GO

PRINT '--------模块与职业的对应关系-------------'
CREATE TABLE [dbo].[ModuleInProfession](
	[ModuleId]			INT NOT NULL PRIMARY KEY,					--模块ID
	[ProfessionId]		INT NOT NULL,								--标准ID
)
GO
ALTER TABLE [ModuleInProfession] WITH CHECK ADD
	CONSTRAINT [FK_ModuleInProfession_ModuleId] FOREIGN KEY([ModuleId]) REFERENCES [Module]([Id])
GO
ALTER TABLE [ModuleInProfession] WITH CHECK ADD
	CONSTRAINT [FK_ModuleInProfession_ProfessionId] FOREIGN KEY([ProfessionId]) REFERENCES [Profession]([Id])
GO

COMMIT TRANSACTION