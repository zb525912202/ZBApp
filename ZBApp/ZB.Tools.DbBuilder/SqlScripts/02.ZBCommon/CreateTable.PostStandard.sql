
USE [$(DatabaseName)]
GO
BEGIN TRANSACTION

PRINT '------ 标准分类 ------'
CREATE TABLE [dbo].[StandardCategory](
	[Id]					INT PRIMARY KEY,			--分类ID
	[ObjectName]			NVARCHAR(50) NOT NULL,					--分类名称
	[SortIndex]				INT NOT NULL DEFAULT 0,					--排序序号
	[LockStatus]			INT NOT NULL DEFAULT 0,					--内置的岗位标准，不许改动或删除(值为对应枚举EDictionaryRecordLockStatus的3);新添加项默认为零
)
GO

PRINT '--------专业---------------'
CREATE TABLE [dbo].[PostSubject](
	[Id]					INT PRIMARY KEY,			--专业ID
	[CategoryId]			INT NOT NULL,							--标准分类ID
	[ObjectName]			NVARCHAR(50) NOT NULL,					--专业名称
	[SortIndex]				INT NOT NULL DEFAULT 0,					--排序序号	
)
GO
ALTER TABLE [PostSubject] WITH CHECK ADD
	CONSTRAINT [FK_PostSubject_CategoryId] FOREIGN KEY([CategoryId]) REFERENCES [StandardCategory]([Id])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_PostSubject_ObjectName] ON [dbo].[PostSubject] 
(
	[CategoryId] ASC,
	[ObjectName] ASC
)
GO

PRINT '--------岗位标准---------------'
CREATE TABLE [dbo].[PostStandard](
	[Id]					INT PRIMARY KEY,						--岗位标准ID
	[CategoryId]			INT NOT NULL,							--标准分类ID
	[SubjectId]				INT,									--专业ID（可为空）
	[ObjectName]			NVARCHAR(500) NOT NULL,					--岗位标准名称
	[Describe]				VARBINARY(MAX),							--描叙
	[SortIndex]				INT NOT NULL DEFAULT 0,					--排序序号
)
GO
ALTER TABLE [PostStandard] WITH CHECK ADD
	CONSTRAINT [FK_PostStandard_CategoryId] FOREIGN KEY([CategoryId]) REFERENCES [StandardCategory]([Id])
GO
ALTER TABLE [PostStandard] WITH CHECK ADD
	CONSTRAINT [FK_PostStandard_SubjectId] FOREIGN KEY([SubjectId]) REFERENCES [PostSubject]([Id])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_PostStandard_ObjectName] ON [dbo].[PostStandard] 
(
	[CategoryId] ASC,
	[ObjectName] ASC
)
GO


PRINT '--------岗位与岗位标准的对应关系-------------'
/*现在的规则是一个岗位仅能对应一个岗位标准，建立此表的原因是考虑后期一个岗位可对应多个标准的情况*/
CREATE TABLE [dbo].[PostInStandard](
	[PostId]			INT NOT NULL PRIMARY KEY,					--岗位ID
	[StandardId]		INT NOT NULL,								--标准ID
)
GO
ALTER TABLE [PostInStandard] WITH CHECK ADD
	CONSTRAINT [FK_PostInStandard_PostId] FOREIGN KEY([PostId]) REFERENCES [Post]([Id])
GO
ALTER TABLE [PostInStandard] WITH CHECK ADD
	CONSTRAINT [FK_PostInStandard_StandardId] FOREIGN KEY([StandardId]) REFERENCES [PostStandard]([Id])
GO




COMMIT TRANSACTION
