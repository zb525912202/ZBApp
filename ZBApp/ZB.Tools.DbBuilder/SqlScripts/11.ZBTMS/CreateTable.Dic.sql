
PRINT '重建TMS库时，要将Exam库内的WebExam表的WorkId, LS库的NetClass表的WorkId,重置为0'

UPDATE [$(ZBExamDatabaseName)].[dbo].[WebExam] SET WorkId = 0;
UPDATE [$(ZBLSDatabaseName)].[dbo].[NetClass] SET WorkId = 0;

PRINT '这种方式存在问题，但也是没有办法的办法，目前只能使用该方式处理'


PRINT '------ 培训事务类型 ------'
CREATE TABLE [dbo].[TrainingOnWorkType](
	[Id]				INT PRIMARY KEY,				
	[ObjectName]		NVARCHAR(50) NOT NULL,					--培训事务名称	
	[LockStatus]		INT NOT NULL DEFAULT 0,					--是否系统内置培训事务，不许改动或删除(值为对应枚举EDictionaryRecordLockStatus的3);新添加项默认为零			
	[SortIndex]			INT NOT NULL DEFAULT 0,			
)
GO

PRINT '------ 培训事务属性 ------'
CREATE TABLE [dbo].[TrainingAttribute](
	[Id]			INT PRIMARY KEY,
	[ParentId]		INT NOT NULL,
	[ObjectName]	NVARCHAR(50) NOT NULL,
	[FullPath]		NVARCHAR(260) NOT NULL UNIQUE,									-- 全路径，不能有两个相同的路径
	[LockStatus]	INT NOT NULL DEFAULT 0,									-- 如果是系统内置，不许改动或删除(值为对应枚举EDictionaryRecordLockStatus的3);新添加项默认为零
	[SortIndex]		INT NOT NULL DEFAULT 0,
)
GO

PRINT'--约束，确保一个标题下的子节点名称不重复--'
CREATE UNIQUE NONCLUSTERED INDEX [IDX_TrainingAttribute_ParentId_ObjectName] ON [dbo].[TrainingAttribute] 
(
	[ParentId] ASC,
	[ObjectName] ASC
)
GO

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
GO

ALTER TABLE [TrainingAttributeValue] WITH CHECK ADD
	CONSTRAINT [FK_TrainingAttributeValue_AttrId] FOREIGN KEY ([AttrId]) REFERENCES [TrainingAttribute]([Id])
GO

PRINT'--约束，确保一个节点的子节点名称不重复--'
CREATE UNIQUE NONCLUSTERED INDEX [IDX_TrainingAttributeValue_ParentId_ObjectName_AttrId] ON [dbo].[TrainingAttributeValue] 
(
	[ParentId] ASC,
	[ObjectName] ASC,
	[AttrId] ASC
)
GO

CREATE UNIQUE NONCLUSTERED INDEX [IDX_TrainingOnWorkItemValue_FullPath_AttrId] ON [dbo].[TrainingAttributeValue] 
(
	[FullPath] ASC,
	[AttrId] ASC
)
GO

PRINT '------ 培训事务类型对应的属性 ------'
CREATE TABLE [dbo].[TrainingAttributeInType](
	[Id]					INT PRIMARY KEY,
	[WorkTypeId]			INT NOT NULL,											--培训分类ID
	[AttrId]				INT NOT NULL,											--培训属性ID					
	[LockStatus]			INT NOT NULL DEFAULT 0,									--如果是系统内置，不许改动或删除(值为对应枚举EDictionaryRecordLockStatus的3);新添加项默认为零
	[SortIndex]				INT NOT NULL DEFAULT 0,
)
GO

ALTER TABLE [TrainingAttributeInType] WITH CHECK ADD
	CONSTRAINT [FK_TrainingAttributeInType_WorkTypeId] FOREIGN KEY ([WorkTypeId]) REFERENCES [TrainingOnWorkType]([Id])
GO

ALTER TABLE [TrainingAttributeInType] WITH CHECK ADD
	CONSTRAINT [FK_TrainingAttributeInType_AttrId] FOREIGN KEY ([AttrId]) REFERENCES [TrainingAttribute]([Id])
GO

PRINT'--约束，确保属性不重复--'
CREATE UNIQUE NONCLUSTERED INDEX [IDX_TrainingAttributeInType_WorkTypeId_AttrId] ON [dbo].[TrainingAttributeInType] 
(
	[WorkTypeId] ASC,
	[AttrId] ASC
)
GO


PRINT '------ 培训事务类型对应的角色(已废弃，合并至培训事务结果) ------'
CREATE TABLE [dbo].[TrainingRoleInType](
	[Id]					INT PRIMARY KEY,
	[WorkTypeId]			INT NOT NULL,											--培训分类ID
	[ObjectName]			NVARCHAR(50) NOT NULL,									--角色名称					
	[LockStatus]			INT NOT NULL DEFAULT 0,									--如果是系统内置，不许改动或删除(值为对应枚举EDictionaryRecordLockStatus的3);新添加项默认为零
	[SortIndex]				INT NOT NULL DEFAULT 0,
)
GO

ALTER TABLE [TrainingRoleInType] WITH CHECK ADD
	CONSTRAINT [FK_TrainingRoleInType_WorkTypeId] FOREIGN KEY ([WorkTypeId]) REFERENCES [TrainingOnWorkType]([Id])
GO

PRINT'--约束，确保名称不重复--'
CREATE UNIQUE NONCLUSTERED INDEX [IDX_TrainingRoleInType_WorkTypeId_ObjectName] ON [dbo].[TrainingRoleInType] 
(
	[WorkTypeId] ASC,
	[ObjectName] ASC
)
GO


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
GO

ALTER TABLE [TrainingResultInType] WITH CHECK ADD
	CONSTRAINT [FK_TrainingResultInType_WorkTypeId] FOREIGN KEY ([WorkTypeId]) REFERENCES [TrainingOnWorkType]([Id])
GO


PRINT'--约束，确保名称不重复--'
CREATE UNIQUE NONCLUSTERED INDEX [IDX_TrainingResultInType_WorkTypeId_ParentId_ObjectName] ON [dbo].[TrainingResultInType] 
(
	[WorkTypeId] ASC,
	[ParentId] ASC,
	[ObjectName] ASC
)
GO

CREATE UNIQUE NONCLUSTERED INDEX [IDX_TrainingResultInType_FullPath_WorkTypeId] ON [dbo].[TrainingResultInType] 
(
	[FullPath] ASC,
	[WorkTypeId] ASC
)
GO


PRINT '------ 培训事务类型对应的单位 ------'
CREATE TABLE [dbo].[TrainingUnitInType](
	[Id]				INT PRIMARY KEY,
	[WorkTypeId]		INT NOT NULL,
	[ObjectName]		NVARCHAR(50) NOT NULL,
	[LockStatus]		INT NOT NULL DEFAULT 0,					--如果是系统内置，不许改动或删除(值为对应枚举EDictionaryRecordLockStatus的3);新添加项默认为零
	[SortIndex]			INT NOT NULL DEFAULT 0,
)
GO

ALTER TABLE [TrainingUnitInType] WITH CHECK ADD
	CONSTRAINT [FK_TrainingUnitInType_WorkTypeId] FOREIGN KEY ([WorkTypeId]) REFERENCES [TrainingOnWorkType]([Id])
GO

PRINT'--约束，确保名称不重复--'
CREATE UNIQUE NONCLUSTERED INDEX [IDX_TrainingUnitInType_WorkTypeId_ObjectName] ON [dbo].[TrainingUnitInType] 
(
	[WorkTypeId] ASC,
	[ObjectName] ASC
)
GO


PRINT  '------ 培训事务类型对应的学分规则 ------'
CREATE TABLE [dbo].[TrainingCreditsRule](
	[Id]				INT PRIMARY KEY,
	[WorkTypeId]		INT NOT NULL,						--事务类型
	[CreditsRule]		VARBINARY(MAX) NOT NULL,			--学分规则，序列化存储
)
GO

ALTER TABLE [TrainingCreditsRule] WITH CHECK ADD
	CONSTRAINT [FK_TrainingCreditsRule_WorkTypeId] FOREIGN KEY ([WorkTypeId]) REFERENCES [TrainingOnWorkType]([Id])
GO



PRINT '------ 培训费用分类 ------'
CREATE TABLE  [dbo].[TrainingBillCategory](
	[Id]					INT PRIMARY KEY,
	[ObjectName]			NVARCHAR(50) NOT NULL,									-- 培训费用分类名称	
	[ParentId]				INT NOT NULL,
	[FullPath]				NVARCHAR(260) NOT NULL UNIQUE,							-- 全路径，不能有两个相同的路径
	[LockStatus]			INT NOT NULL,							
	[SortIndex]				INT NOT NULL DEFAULT 0,
)

CREATE UNIQUE NONCLUSTERED INDEX [IDX_TrainingBillCategory_ParentId_ObjectName] ON [dbo].[TrainingBillCategory] 
(
	[ParentId] ASC,
	[ObjectName] ASC
)
GO








PRINT '------ 培训事务级别 ------'
CREATE TABLE [dbo].[TrainingOnWorkLevel](
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,
	[ObjectName]			NVARCHAR(50) NOT NULL,									-- 级别(国家级、国网公司级、省公司级等)
	[IsDefault]				BIT NOT NULL,											-- 是否是系统内置(如果内置，则在界面不显示出来)
	[IsRootLevel]			BIT NOT NULL DEFAULT 0,									-- 是否对应系统内的根部门级别				
	[LockStatus]			INT NOT NULL DEFAULT 0,									-- 如果是系统内置，不许改动或删除(值为对应枚举EDictionaryRecordLockStatus的3);新添加项默认为零
	[SortIndex]				INT NOT NULL DEFAULT 0,	
)
GO

PRINT '------ 培训分类 ------'
CREATE TABLE  [dbo].[TrainingCategory](
	[Id]					INT PRIMARY KEY,
	[ObjectName]			NVARCHAR(50) NOT NULL,									-- 培训项目分类名称	
	[ParentId]				INT NOT NULL,
	[FullPath]				NVARCHAR(260) NOT NULL,									-- 全路径，不能有两个相同的路径
	[Dimension]				INT NOT NULL,											-- 培训分类的维度（TrainingCategoryDimensionEnum是否在岗，专业等等）
	[LockStatus]			INT NOT NULL,							
	[SortIndex]				INT NOT NULL DEFAULT 0,
)
PRINT'--培训约束，确保一个培训内容分类下的子节点名称不重复--'
CREATE UNIQUE NONCLUSTERED INDEX [IDX_TrainingCategory_ParentId_ObjectName_Dimension] ON [dbo].[TrainingCategory] 
(
	[ParentId] ASC,
	[ObjectName] ASC,
	[Dimension] ASC
)
GO

CREATE UNIQUE NONCLUSTERED INDEX [IDX_TrainingCategory_FullPath_Dimension] ON [dbo].[TrainingCategory] 
(
	[FullPath] ASC,
	[Dimension] ASC
)
GO




