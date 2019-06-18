USE [$(DatabaseName)]
GO
BEGIN TRANSACTION

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
GO

PRINT '------ 培训事务类型 ------'
CREATE TABLE  [dbo].[TrainingWorkType](
	[Id]				    INT PRIMARY KEY,
	[ObjectName]			NVARCHAR(50) NOT NULL,		
	[LockStatus]			INT NOT NULL,							
	[SortIndex]				INT NOT NULL DEFAULT 0,	
)

PRINT '------ 培训形式 ------'
CREATE TABLE  [dbo].[TrainingMode](
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,
	[ObjectName]			NVARCHAR(50) NOT NULL,									-- 培训项目形式
	[SortIndex]				INT NOT NULL DEFAULT 0,	
)

PRINT '------ 培训级别 ------'
CREATE TABLE  [dbo].[TrainingLevel](
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,
	[ObjectName]			NVARCHAR(50) NOT NULL,									-- 级别(国家级、国网公司级、省公司级等)
	[IsDefault]				BIT NOT NULL,											-- 是否是系统内置
	[LockStatus]			INT NOT NULL,											-- 如果是系统内置，不许改动或删除(值为对应枚举EDictionaryRecordLockStatus的3);新添加项默认为零
	[SortIndex]				INT NOT NULL DEFAULT 0,	
)

PRINT '------ 培训班类型 ------'
CREATE TABLE  [dbo].[TcType](
	[Id]					INT PRIMARY KEY,
	[ObjectName]			NVARCHAR(50) NOT NULL,									-- 培训班类型	
	[ParentId]				INT NOT NULL,
	[FullPath]				NVARCHAR(260) NOT NULL UNIQUE,							-- 全路径，不能有两个相同的路径
	[SortIndex]				INT NOT NULL DEFAULT 0,
)
PRINT'--确保一个培训班类型下的子节点名称不重复--'
CREATE UNIQUE NONCLUSTERED INDEX [IDX_TcType_ParentId_ObjectName] ON [dbo].[TcType] 
(
	[ParentId] ASC,
	[ObjectName] ASC
)
GO

PRINT '------ 课程类型 ------'
CREATE TABLE  [dbo].[TcCourseType](
	[Id]					INT PRIMARY KEY,
	[ObjectName]			NVARCHAR(50) NOT NULL,									-- 课程类型
	[ParentId]				INT NOT NULL,
	[FullPath]				NVARCHAR(260) NOT NULL UNIQUE,							-- 全路径，不能有两个相同的路径
	[SortIndex]				INT NOT NULL DEFAULT 0,
)
PRINT'--确保一个课程类型下的子节点名称不重复--'
CREATE UNIQUE NONCLUSTERED INDEX [IDX_TcCourseType_ParentId_ObjectName] ON [dbo].[TcCourseType] 
(
	[ParentId] ASC,
	[ObjectName] ASC
)
GO

PRINT '------ 培训班培训结果类型表 ------'
CREATE TABLE  [dbo].[TcResultType](
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,
	[ObjectName]			NVARCHAR(50) NOT NULL UNIQUE,							-- 培训班培训结果类型
	[LockStatus]			INT NOT NULL,			
	[SortIndex]				INT NOT NULL DEFAULT 0,	
)

PRINT '------ 培训费用分类 ------'
CREATE TABLE  [dbo].[TrainingBillType](
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,
	[ObjectName]			NVARCHAR(50) NOT NULL UNIQUE,							-- 培训费用类型	
	[SortIndex]				INT NOT NULL DEFAULT 0,	
)

PRINT '------ 考试类型 ------'
CREATE TABLE  [dbo].[TeType](
	[Id]					INT PRIMARY KEY,
	[ObjectName]			NVARCHAR(50) NOT NULL,										
	[ParentId]				INT NOT NULL,
	[FullPath]				NVARCHAR(260) NOT NULL UNIQUE,							-- 全路径，不能有两个相同的路径
	[SortIndex]				INT NOT NULL DEFAULT 0,
)
PRINT'--确保一个课程类型下的子节点名称不重复--'
CREATE UNIQUE NONCLUSTERED INDEX [IDX_TeType_ParentId_ObjectName] ON [dbo].[TeType] 
(
	[ParentId] ASC,
	[ObjectName] ASC
)
GO

PRINT '------ 考试考生结果类型表 ------'
CREATE TABLE  [dbo].[TeResultType](
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,
	[ObjectName]			NVARCHAR(50) NOT NULL UNIQUE,							-- 培训班培训结果类型
	[LockStatus]			INT NOT NULL,			
	[SortIndex]				INT NOT NULL DEFAULT 0,	
)

PRINT '------ 培训分类表 ------'
CREATE TABLE  [dbo].[TrainingKind](
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,
	[ObjectName]			NVARCHAR(50) NOT NULL UNIQUE,							
	[SortIndex]				INT NOT NULL DEFAULT 0,	
)

COMMIT TRANSACTION