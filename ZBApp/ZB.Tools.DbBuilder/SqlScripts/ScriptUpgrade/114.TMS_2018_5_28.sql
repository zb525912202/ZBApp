IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TrainingAttribute]') AND type in (N'U'))
BEGIN
PRINT '------ 培训事务属性 ------'
CREATE TABLE [dbo].[TrainingAttribute](
	[Id]			INT PRIMARY KEY,
	[ParentId]		INT NOT NULL,
	[ObjectName]	NVARCHAR(50) NOT NULL,
	[FullPath]		NVARCHAR(260) NOT NULL UNIQUE,									-- 全路径，不能有两个相同的路径
	[LockStatus]	INT NOT NULL DEFAULT 0,									-- 如果是系统内置，不许改动或删除(值为对应枚举EDictionaryRecordLockStatus的3);新添加项默认为零
	[SortIndex]		INT NOT NULL DEFAULT 0,
)


PRINT'--约束，确保一个标题下的子节点名称不重复--'
CREATE UNIQUE NONCLUSTERED INDEX [IDX_TrainingAttribute_ParentId_ObjectName] ON [dbo].[TrainingAttribute] 
(
	[ParentId] ASC,
	[ObjectName] ASC
)

END

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TrainingAttributeValue]') AND type in (N'U'))
BEGIN
PRINT '------ 培训事务属性值 ------'
CREATE TABLE [dbo].[TrainingAttributeValue](
	[Id]					INT PRIMARY KEY,
	[AttrId]				INT NOT NULL,
	[ObjectName]			NVARCHAR(50) NOT NULL,									-- 培训项目分类名称	
	[ParentId]				INT NOT NULL,
	[FullPath]				NVARCHAR(260) NOT NULL,									-- 全路径，不能有两个相同的路径
	[LockStatus]			INT NOT NULL DEFAULT 0,									-- 如果是系统内置，不许改动或删除(值为对应枚举EDictionaryRecordLockStatus的3);新添加项默认为零
	[SortIndex]				INT NOT NULL DEFAULT 0,
)

ALTER TABLE [TrainingAttributeValue] WITH CHECK ADD
	CONSTRAINT [FK_TrainingAttributeValue_AttrId] FOREIGN KEY ([AttrId]) REFERENCES [TrainingAttribute]([Id])

PRINT'--约束，确保一个节点的子节点名称不重复--'
CREATE UNIQUE NONCLUSTERED INDEX [IDX_TrainingAttributeValue_ParentId_ObjectName_AttrId] ON [dbo].[TrainingAttributeValue] 
(
	[ParentId] ASC,
	[ObjectName] ASC,
	[AttrId] ASC
)
CREATE UNIQUE NONCLUSTERED INDEX [IDX_TrainingOnWorkItemValue_FullPath_AttrId] ON [dbo].[TrainingAttributeValue] 
(
	[FullPath] ASC,
	[AttrId] ASC
)
END

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TrainingAttributeInType]') AND type in (N'U'))
BEGIN

PRINT '------ 培训事务类型对应的属性 ------'
CREATE TABLE [dbo].[TrainingAttributeInType](
	[Id]					INT PRIMARY KEY,
	[WorkTypeId]			INT NOT NULL,											--培训分类ID
	[AttrId]				INT NOT NULL,											--培训属性ID					
	[LockStatus]			INT NOT NULL DEFAULT 0,									--如果是系统内置，不许改动或删除(值为对应枚举EDictionaryRecordLockStatus的3);新添加项默认为零
	[SortIndex]				INT NOT NULL DEFAULT 0,
)


ALTER TABLE [TrainingAttributeInType] WITH CHECK ADD
	CONSTRAINT [FK_TrainingAttributeInType_WorkTypeId] FOREIGN KEY ([WorkTypeId]) REFERENCES [TrainingOnWorkType]([Id])


ALTER TABLE [TrainingAttributeInType] WITH CHECK ADD
	CONSTRAINT [FK_TrainingAttributeInType_AttrId] FOREIGN KEY ([AttrId]) REFERENCES [TrainingAttribute]([Id])


PRINT'--约束，确保属性不重复--'
CREATE UNIQUE NONCLUSTERED INDEX [IDX_TrainingAttributeInType_WorkTypeId_AttrId] ON [dbo].[TrainingAttributeInType] 
(
	[WorkTypeId] ASC,
	[AttrId] ASC
)
END

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TrainingRoleInType]') AND type in (N'U'))
BEGIN
PRINT '------ 培训事务类型对应的角色(已废弃，合并至培训事务结果) ------'
CREATE TABLE [dbo].[TrainingRoleInType](
	[Id]					INT PRIMARY KEY,
	[WorkTypeId]			INT NOT NULL,											--培训分类ID
	[ObjectName]			NVARCHAR(50) NOT NULL,									--角色名称					
	[LockStatus]			INT NOT NULL DEFAULT 0,									--如果是系统内置，不许改动或删除(值为对应枚举EDictionaryRecordLockStatus的3);新添加项默认为零
	[SortIndex]				INT NOT NULL DEFAULT 0,
)

ALTER TABLE [TrainingRoleInType] WITH CHECK ADD
	CONSTRAINT [FK_TrainingRoleInType_WorkTypeId] FOREIGN KEY ([WorkTypeId]) REFERENCES [TrainingOnWorkType]([Id])

PRINT'--约束，确保名称不重复--'
CREATE UNIQUE NONCLUSTERED INDEX [IDX_TrainingRoleInType_WorkTypeId_ObjectName] ON [dbo].[TrainingRoleInType] 
(
	[WorkTypeId] ASC,
	[ObjectName] ASC
)
END

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TrainingResultInType]') AND type in (N'U'))
BEGIN
PRINT '------ 培训事务类型对应的结果 ------'
CREATE TABLE [dbo].[TrainingResultInType](
	[Id]					INT PRIMARY KEY,
	[WorkTypeId]			INT NOT NULL,											--培训分类ID
	[ParentId]				INT NOT NULL,											--父节点ID
	[ObjectName]			NVARCHAR(50) NOT NULL,									--角色名称			
	[FullPath]				NVARCHAR(260) NOT NULL,									-- 全路径，不能有两个相同的路径		
	[LockStatus]			INT NOT NULL DEFAULT 0,									--如果是系统内置，不许改动或删除(值为对应枚举EDictionaryRecordLockStatus的3);新添加项默认为零
	[SortIndex]				INT NOT NULL DEFAULT 0,
)


ALTER TABLE [TrainingResultInType] WITH CHECK ADD
	CONSTRAINT [FK_TrainingResultInType_WorkTypeId] FOREIGN KEY ([WorkTypeId]) REFERENCES [TrainingOnWorkType]([Id])



PRINT'--约束，确保名称不重复--'
CREATE UNIQUE NONCLUSTERED INDEX [IDX_TrainingResultInType_WorkTypeId_ParentId_ObjectName] ON [dbo].[TrainingResultInType] 
(
	[WorkTypeId] ASC,
	[ParentId] ASC,
	[ObjectName] ASC
)


CREATE UNIQUE NONCLUSTERED INDEX [IDX_TrainingResultInType_FullPath_WorkTypeId] ON [dbo].[TrainingResultInType] 
(
	[FullPath] ASC,
	[WorkTypeId] ASC
)
END

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TrainingUnitInType]') AND type in (N'U'))
BEGIN
PRINT '------ 培训事务类型对应的单位 ------'
CREATE TABLE [dbo].[TrainingUnitInType](
	[Id]				INT PRIMARY KEY,
	[WorkTypeId]		INT NOT NULL,
	[ObjectName]		NVARCHAR(50) NOT NULL,
	[LockStatus]		INT NOT NULL DEFAULT 0,					--如果是系统内置，不许改动或删除(值为对应枚举EDictionaryRecordLockStatus的3);新添加项默认为零
	[SortIndex]			INT NOT NULL DEFAULT 0,
)

ALTER TABLE [TrainingUnitInType] WITH CHECK ADD
	CONSTRAINT [FK_TrainingUnitInType_WorkTypeId] FOREIGN KEY ([WorkTypeId]) REFERENCES [TrainingOnWorkType]([Id])

PRINT'--约束，确保名称不重复--'
CREATE UNIQUE NONCLUSTERED INDEX [IDX_TrainingUnitInType_WorkTypeId_ObjectName] ON [dbo].[TrainingUnitInType] 
(
	[WorkTypeId] ASC,
	[ObjectName] ASC
)
END

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TrainingCreditsRule]') AND type in (N'U'))
BEGIN
PRINT  '------ 培训事务类型对应的学分规则 ------'
CREATE TABLE [dbo].[TrainingCreditsRule](
	[Id]				INT PRIMARY KEY,
	[WorkTypeId]		INT NOT NULL,						--事务类型
	[CreditsRule]		VARBINARY(MAX) NOT NULL,			--学分规则，序列化存储
)

ALTER TABLE [TrainingCreditsRule] WITH CHECK ADD
	CONSTRAINT [FK_TrainingCreditsRule_WorkTypeId] FOREIGN KEY ([WorkTypeId]) REFERENCES [TrainingOnWorkType]([Id])
END

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TrainingContentType]') AND type in (N'U'))
BEGIN
PRINT '------ 培训内容分类 ------'
CREATE TABLE  [dbo].[TrainingContentType](
	[Id]					INT PRIMARY KEY,
	[ObjectName]			NVARCHAR(50) NOT NULL,									-- 培训项目内容	
	[ParentId]				INT NOT NULL,
	[FullPath]				NVARCHAR(260) NOT NULL UNIQUE,							-- 全路径，不能有两个相同的路径
	[LockStatus]			INT NOT NULL,							
	[SortIndex]				INT NOT NULL DEFAULT 0,
)
PRINT'--确保一个培训内容分类下的子节点名称不重复--'
CREATE UNIQUE NONCLUSTERED INDEX [IDX_TrainingContentType_ParentId_ObjectName] ON [dbo].[TrainingContentType] 
(
	[ParentId] ASC,
	[ObjectName] ASC
)
END