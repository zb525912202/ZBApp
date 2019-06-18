IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProfessionCategorySystem]') AND type in (N'U'))
BEGIN
	PRINT '------ 职岗类型体系表 ------'
	CREATE TABLE [dbo].[ProfessionCategorySystem](
		[Id]					INT PRIMARY KEY,						--体系ID
		[ObjectName]			NVARCHAR(50) NOT NULL,					--体系名称
		[IsCurrent]				BIT NOT NULL							--体系是否是当前
	)
END
GO

IF NOT EXISTS (SELECT * FROM [ProfessionCategorySystem] WHERE ObjectName = '大唐托克托发电有限公司')
BEGIN
	INSERT INTO [ProfessionCategorySystem] ([Id],[ObjectName],IsCurrent) VALUES(1,'大唐托克托发电有限公司',1)
END

IF NOT EXISTS (SELECT * FROM [ProfessionCategorySystem] WHERE ObjectName = '华能体系')
BEGIN
	INSERT INTO [ProfessionCategorySystem] ([Id],[ObjectName],IsCurrent) VALUES(2,'华能体系',0)
END

IF NOT EXISTS (SELECT * FROM [ProfessionCategorySystem] WHERE ObjectName = '华电体系')
BEGIN
	INSERT INTO [ProfessionCategorySystem] ([Id],[ObjectName],IsCurrent) VALUES(3,'华电体系',0)
END
GO

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProfessionCategory]') AND type IN (N'U'))
BEGIN
	PRINT '------ 职岗类型 ------'
	CREATE TABLE [dbo].[ProfessionCategory](
		[Id]					INT PRIMARY KEY,						--类型ID
		[ObjectName]			NVARCHAR(50) NOT NULL,					--类型名称
		[Level]					INT NOT NULL DEFAULT 0,					--层级(二层，三层，四层，五层，空层)
		[Code]					NVARCHAR(50) NULL,						--类型编码
		[SystemId]				INT NOT NULL DEFAULT 1,					--体系Id
		[SortIndex]				INT NOT NULL DEFAULT 0,					--排序序号
		[LockStatus]			INT NOT NULL DEFAULT 0,					--内置的职岗类型，不许改动或删除(值为对应枚举EDictionaryRecordLockStatus的3);新添加项默认为零
		[ProCategoryType]	INT NOT NULL DEFAULT 0,						-- 文件夹类型(0:普通职岗类型 1：职岗类型分组)
	)
	ALTER TABLE [ProfessionCategory] WITH CHECK ADD
		CONSTRAINT [FK_ProfessionCategory_SystemId] FOREIGN KEY([SystemId]) REFERENCES [ProfessionCategorySystem]([Id])

	CREATE UNIQUE NONCLUSTERED INDEX [IDX_ProfessionCategory_ObjectName] ON [dbo].[ProfessionCategory] 
	(
		[SystemId] ASC,
		[ObjectName] ASC
	)
	CREATE UNIQUE NONCLUSTERED INDEX [IDX_ProfessionCategory_Code] ON [dbo].[ProfessionCategory] 
	(
		[SystemId] ASC,
		[Code] ASC
	)
	WHERE Code IS NOT NULL AND Code !=''

END
GO

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MasteryLevel]') AND type in (N'U'))
BEGIN
	PRINT '------------掌握程度-------------------'
	CREATE TABLE [dbo].[MasteryLevel](
		[Id]				INT PRIMARY KEY NOT NULL,
		[ObjectName]		NVARCHAR(10) NOT NULL,			--默认，拔高，应知，应会
		[SortIndex]			INT NOT NULL DEFAULT 0,
		[LockStatus]		INT NOT NULL DEFAULT 0,	
	)
END
GO

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Profession]') AND type in (N'U'))
BEGIN
	PRINT '------ 职业 ------'
	CREATE TABLE [dbo].[Profession](
		[Id]					INT PRIMARY KEY,						--职业ID
		[PCategoryId]			INT NOT NULL,							--职网类型ID
		[ObjectName]			NVARCHAR(500) NOT NULL,					--职业名称
		[Describe]				VARBINARY(MAX),							--描述
		[Code]					NVARCHAR(50) NULL,						--职业编码
		[SortIndex]				INT NOT NULL DEFAULT 0,					--排序序号
	)
	ALTER TABLE [Profession] WITH CHECK ADD
		CONSTRAINT [FK_Profession_PCategoryId] FOREIGN KEY([PCategoryId]) REFERENCES [ProfessionCategory]([Id])


	CREATE UNIQUE NONCLUSTERED INDEX [IDX_PCategoryId_ObjectName] ON [dbo].[Profession] 
	(
		[PCategoryId] ASC,
		[ObjectName] ASC
	)
	CREATE UNIQUE NONCLUSTERED INDEX [IDX_Code] ON [dbo].[Profession]
	(
		[Code]
	)
	WHERE Code IS NOT NULL AND Code !=''
END
GO

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PostInProfession]') AND type in (N'U'))
BEGIN
	PRINT '--------岗位与职业的对应关系-------------'
	/*现在的规则是一个岗位仅能对应一个职业，建立此表的原因是考虑后期一个岗位可对应多个标准的情况*/
	CREATE TABLE [dbo].[PostInProfession](
		[PostId]			INT NOT NULL PRIMARY KEY,					--岗位ID
		[ProfessionId]		INT NOT NULL,								--标准ID
		[Level]				INT	NOT NULL DEFAULT 0,						--级别
	)
	ALTER TABLE [PostInProfession] WITH CHECK ADD
		CONSTRAINT [FK_PostInProfession_PostId] FOREIGN KEY([PostId]) REFERENCES [Post]([Id])
	ALTER TABLE [PostInProfession] WITH CHECK ADD
		CONSTRAINT [FK_PostInProfession_ProfessionId] FOREIGN KEY([ProfessionId]) REFERENCES [Profession]([Id])
END
GO


IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('Post') AND NAME='PCategoryId')
BEGIN
	ALTER TABLE Post ADD PCategoryId INT NOT NULL DEFAULT 1;
	ALTER TABLE [Post] WITH CHECK ADD
	CONSTRAINT [FK_Post_ProfessionCategory] FOREIGN KEY([PCategoryId]) REFERENCES [ProfessionCategory]([Id])
	PRINT '添加Post的PCategoryId成功';
END
GO

PRINT '----------向岗位标准类型表插入默认数据（其他）---------------------'
IF((SELECT COUNT(*) FROM ProfessionCategory WHERE ObjectName = '默认')=0)
BEGIN
	INSERT INTO ProfessionCategory(Id, ObjectName, SortIndex, LockStatus)
	SELECT ISNULL(MAX(Id)+1,1), '默认', 0, 3 FROM ProfessionCategory
END

IF((SELECT COUNT(*) FROM ProfessionCategory WHERE ObjectName = '管理')=0)
BEGIN
	INSERT INTO ProfessionCategory(Id, ObjectName, SortIndex, LockStatus)
	SELECT ISNULL(MAX(Id)+1,1), '管理', 1, 1 FROM ProfessionCategory
END

IF((SELECT COUNT(*) FROM ProfessionCategory WHERE ObjectName = '技术')=0)
BEGIN
	INSERT INTO ProfessionCategory(Id, ObjectName, SortIndex, LockStatus)
	SELECT ISNULL(MAX(Id)+1,1), '技术', 2, 1 FROM ProfessionCategory
END

IF((SELECT COUNT(*) FROM ProfessionCategory WHERE ObjectName = '技能')=0)
BEGIN
	INSERT INTO ProfessionCategory(Id, ObjectName, SortIndex, LockStatus)
	SELECT ISNULL(MAX(Id)+1,1), '技能', 3, 1 FROM ProfessionCategory
END
GO

PRINT '----------向掌握程度表插入默认数据（默认）---------------------'
IF((SELECT COUNT(*) FROM MasteryLevel WHERE ObjectName = '默认')=0)
BEGIN
	INSERT INTO MasteryLevel(Id, ObjectName, SortIndex, LockStatus)
	SELECT ISNULL(MAX(Id)+1,1), '默认', 0, 3 FROM MasteryLevel
END

