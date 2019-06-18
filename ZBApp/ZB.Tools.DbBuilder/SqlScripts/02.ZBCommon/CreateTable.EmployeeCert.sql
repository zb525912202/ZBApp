
USE [$(DatabaseName)]
GO
BEGIN TRANSACTION

PRINT '------ 续证任务 ------'
CREATE TABLE  [dbo].[CertTask](
	[Id]					INT PRIMARY KEY NOT NULL,
	[ObjectName]			NVARCHAR(50) NOT NULL,									-- 培训项目内容
	[FinishDate]			DATETIME NOT NULL,										-- 完成日期
	[CreatorId]				INT NOT NULL,											-- 创建人Id
	[CreatorName]			NVARCHAR(50) NOT NULL,									-- 创建人姓名	
)
GO

PRINT '------ 续证任务负责人 ------'
CREATE TABLE  [dbo].[CertTaskDirector](
	[Id]					INT PRIMARY KEY NOT NULL,
	[CertTaskId]			INT NOT NULL,												
	[DirectorId]			INT NOT NULL,											-- 负责人Id
	[DirectorName]			NVARCHAR(50) NOT NULL,									-- 负责人姓名	
)
ALTER TABLE [CertTaskDirector] WITH CHECK ADD
	CONSTRAINT [FK_CertTaskDirector_CertTask] FOREIGN KEY([CertTaskId]) REFERENCES [CertTask]([Id])
GO




PRINT '------ 证书类型 ------'
CREATE TABLE [dbo].[CertType]
(
	[Id]					INT PRIMARY KEY NOT NULL,
	[ObjectName]			NVARCHAR(50) NOT NULL UNIQUE,
	[SortIndex]				INT NOT NULL,
	[LockStatus]			INT NOT NULL				--如果是系统内置默认的证书类型，不许改动或删除(值为对应枚举EDictionaryRecordLockStatus的3)
)
GO

PRINT '----- 颁证机关 -----'
CREATE TABLE  [dbo].[CertPublisher](
	[Id]					INT PRIMARY KEY NOT NULL,
	[ObjectName]			NVARCHAR(50) NOT NULL,									-- 颁证机关名称
	[ParentId]				INT NOT NULL,
	[CertTypeId]			INT NOT NULL,											-- 证书类型Id	
	[FullPath]				NVARCHAR(260) NOT NULL,									-- 全路径+CertTypeId，不能有两个相同的路径 	
	[SortIndex]				INT NOT NULL DEFAULT 0	
)
ALTER TABLE [CertPublisher] WITH CHECK ADD
	CONSTRAINT [FK_CertPublisher_CertType] FOREIGN KEY([CertTypeId]) REFERENCES [CertType]([Id])
CREATE UNIQUE NONCLUSTERED INDEX [IDX_CertPublisher_FullPath] ON [dbo].[CertPublisher] 
(
	[CertTypeId] ASC,
	[FullPath] ASC
)
CREATE UNIQUE NONCLUSTERED INDEX [IDX_CertPublisher_ParentId_ObjectName] ON [dbo].[CertPublisher] 
(
	[CertTypeId] ASC,
	[ParentId] ASC,
	[ObjectName] ASC
)	
GO

PRINT '------ 证书类型等级 ------'
CREATE TABLE [dbo].[CertTypeLevel]
(
	[Id]					INT PRIMARY KEY NOT NULL,
	[CertTypeId]			INT NOT NULL,											-- 证书类型Id
	[ObjectName]			NVARCHAR(50) NOT NULL,									
	[SortIndex]				INT NOT NULL,
)
ALTER TABLE [CertTypeLevel] WITH CHECK ADD
	CONSTRAINT [FK_CertTypeLevel_CertType] FOREIGN KEY([CertTypeId]) REFERENCES [CertType]([Id])

CREATE UNIQUE NONCLUSTERED INDEX [IDX_CertTypeLevel_CertType_ObjectName] ON [dbo].[CertTypeLevel] 
(
	[CertTypeId] ASC,
	[ObjectName] ASC
)	
GO

PRINT '------ 证书类型分类 ------'
CREATE TABLE  [dbo].[CertTypeKind](
	[Id]					INT PRIMARY KEY NOT NULL,
	[CertTypeId]			INT NOT NULL,											-- 证书类型Id
	[ObjectName]			NVARCHAR(50) NOT NULL,									-- 培训项目内容	
	[ParentId]				INT NOT NULL,
	[FullPath]				NVARCHAR(260) NOT NULL,									-- 全路径，不能有两个相同的路径	
	[SortIndex]				INT NOT NULL DEFAULT 0,
)
ALTER TABLE [CertTypeKind] WITH CHECK ADD
	CONSTRAINT [FK_CertTypeKind_CertType] FOREIGN KEY([CertTypeId]) REFERENCES [CertType]([Id])

CREATE UNIQUE NONCLUSTERED INDEX [IDX_CertTypeKind_CertType_FullPath] ON [dbo].[CertTypeKind] 
(
	[CertTypeId] ASC,
	[FullPath] ASC
)
CREATE UNIQUE NONCLUSTERED INDEX [IDX_CertTypeKind_CertType_ParentId_ObjectName] ON [dbo].[CertTypeKind] 
(
	[CertTypeId] ASC,
	[ParentId] ASC,
	[ObjectName] ASC
)	
GO

PRINT '------ 人员证书 ------'
CREATE TABLE  [dbo].[EmployeeCert](
	[Id]					INT PRIMARY KEY NOT NULL,
	[EmployeeId]			INT NOT NULL,
	[CertTaskId]			INT,													-- 续证任务Id
	[CertNO]				NVARCHAR(200) NOT NULL,									-- 证书编号
	[CertTypeId]			INT NOT NULL,											-- 证书类型Id
	[CertTypeLevelId]		INT,													-- 证书类型级别Id
	[CertTypeKindId]		INT NOT NULL,											-- 证书类型分类Id
	[GetCertDate]			DATETIME NOT NULL,										-- 证书获取时间
	[ExpiredDate]			DATETIME NOT NULL,										-- 过期时间(NULL时插入MaxDate 方便排序)
	[CertPublisherId]		INT,													-- 颁证机关

	[ReporterId]			INT NOT NULL,											-- 上报人Id
	[ReporterName]			NVARCHAR(50) NOT NULL,									-- 上报人姓名	
	[AuditState]			INT NOT NULL,											-- 审核状态(待审、驳回、审批通过)
	[Remark]				NVARCHAR(MAX),											-- 备注	
	[CreateTime]			DATETIME NOT NULL,										-- 创建时间
)
ALTER TABLE [EmployeeCert] WITH CHECK ADD
	CONSTRAINT [FK_EmployeeCert_Employee] FOREIGN KEY([EmployeeId]) REFERENCES [Employee]([Id]),
	CONSTRAINT [FK_EmployeeCert_CertType] FOREIGN KEY([CertTypeId]) REFERENCES [CertType]([Id]),
	CONSTRAINT [FK_EmployeeCert_CertTypeLevel] FOREIGN KEY([CertTypeLevelId]) REFERENCES [CertTypeLevel]([Id]),
	CONSTRAINT [FK_EmployeeCert_CertTypeKind] FOREIGN KEY([CertTypeKindId]) REFERENCES [CertTypeKind]([Id]),
	CONSTRAINT [FK_EmployeeCert_CertPublisher] FOREIGN KEY([CertPublisherId]) REFERENCES [CertPublisher]([Id]),
	CONSTRAINT [FK_EmployeeCert_CertTask] FOREIGN KEY([CertTaskId]) REFERENCES [CertTask]([Id])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_EmployeeId_CertTypeId_CertTypeLevelId_CertTypeKindId_ExpiredDate] ON [dbo].[EmployeeCert] 
(
	EmployeeId ASC,
	CertTypeId ASC,
	CertTypeLevelId ASC,
	CertTypeKindId ASC,
	ExpiredDate DESC
)	
GO

PRINT '------ 人员证书影印件 ------'
CREATE TABLE  [dbo].[EmployeeCertPhoto](
	[Id]					INT PRIMARY KEY NOT NULL,
	[EmployeeId]			INT NOT NULL,
	[EmployeeCertId]		INT NOT NULL,											-- 人员证书Id
	[EmployeeCertPhotoType]	INT NOT NULL,											-- 影印件类型(1:封面  2:内页)
	[Photo]					VARBINARY(MAX),										    -- 人员证书影印件
)
ALTER TABLE [EmployeeCertPhoto] WITH CHECK ADD
	CONSTRAINT [FK_EmployeeCertPhoto_Employee] FOREIGN KEY([EmployeeId]) REFERENCES [Employee]([Id]),
	CONSTRAINT [FK_EmployeeCertPhoto_EmployeeCert] FOREIGN KEY([EmployeeCertId]) REFERENCES [EmployeeCert]([Id])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_EmployeeCertPhoto_CertType_EmployeeCertPhotoType] ON [dbo].[EmployeeCertPhoto] 
(
	[EmployeeCertId] ASC,
	[EmployeeCertPhotoType] ASC
)	
GO

PRINT '------ 人员证书审批流程 ------'
CREATE TABLE  [dbo].[EmployeeCertFlow](
	[Id]					INT PRIMARY KEY NOT NULL,
	[EmployeeId]			INT NOT NULL,
	[EmployeeCertId]		INT NOT NULL,										-- 人员证书Id
	[AuditState]			INT NOT NULL,										-- 审核状态(驳回、审批通过)	
	[OperaterId]			INT NOT NULL,										-- 操作人Id
	[OperaterName]			NVARCHAR(50) NOT NULL,								-- 操作人姓名
	[OperateInfo]			NVARCHAR(MAX) NOT NULL,								-- 操作信息
	[OperateTime]			DATETIME NOT NULL,									-- 操作时间
)
ALTER TABLE [EmployeeCertFlow] WITH CHECK ADD
	CONSTRAINT [FK_EmployeeCertFlow_Employee] FOREIGN KEY([EmployeeId]) REFERENCES [Employee]([Id]),
	CONSTRAINT [FK_EmployeeCertFlow_EmployeeCert] FOREIGN KEY([EmployeeCertId]) REFERENCES [EmployeeCert]([Id])
GO

PRINT '------ 岗位持证要求 ------'
CREATE TABLE  [dbo].[PostCertDemand](
	[Id]					INT PRIMARY KEY NOT NULL,
	[PostId]				INT NOT NULL,                                       -- 岗位Id
	[CertTypeId]			INT NOT NULL,										-- 证书类型Id
	[CertTypeLevelId]		INT,												-- 证书类型级别Id
	[CertTypeKindId]		INT NOT NULL,										-- 证书类型分类Id
)
ALTER TABLE [PostCertDemand] WITH CHECK ADD
	CONSTRAINT [FK_PostCertDemand_Post] FOREIGN KEY([PostId]) REFERENCES [Post]([Id]),
	CONSTRAINT [FK_PostCertDemand_CertType] FOREIGN KEY([CertTypeId]) REFERENCES [CertType]([Id]),
	CONSTRAINT [FK_PostCertDemand_CertTypeLevel] FOREIGN KEY([CertTypeLevelId]) REFERENCES [CertTypeLevel]([Id]),
	CONSTRAINT [FK_PostCertDemand_CertTypeKind] FOREIGN KEY([CertTypeKindId]) REFERENCES [CertTypeKind]([Id])
GO

COMMIT TRANSACTION