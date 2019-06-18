IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CertType]') AND type in (N'U'))
BEGIN

PRINT '------ 证书驳回提示表 ------'
CREATE TABLE  [dbo].[CertRejectInfo](
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,
	[ObjectName]			NVARCHAR(50) NOT NULL,									-- 培训师级别表
	[SortIndex]				INT NOT NULL DEFAULT 0,	
)

PRINT '------ 续证任务 ------'
CREATE TABLE  [dbo].[CertTask](
	[Id]					INT PRIMARY KEY NOT NULL,
	[ObjectName]			NVARCHAR(50) NOT NULL,									-- 培训项目内容
	[FinishDate]			DATETIME NOT NULL,										-- 完成日期
	[CreatorId]				INT NOT NULL,											-- 创建人Id
	[CreatorName]			NVARCHAR(50) NOT NULL,									-- 创建人姓名	
)

PRINT '------ 续证任务负责人 ------'
CREATE TABLE  [dbo].[CertTaskDirector](
	[Id]					INT PRIMARY KEY NOT NULL,
	[CertTaskId]			INT NOT NULL,												
	[DirectorId]			INT NOT NULL,											-- 负责人Id
	[DirectorName]			NVARCHAR(50) NOT NULL,									-- 负责人姓名	
)
ALTER TABLE [CertTaskDirector] WITH CHECK ADD
	CONSTRAINT [FK_CertTaskDirector_CertTask] FOREIGN KEY([CertTaskId]) REFERENCES [CertTask]([Id])



PRINT '------ 证书类型 ------'
CREATE TABLE [dbo].[CertType]
(
	[Id]					INT PRIMARY KEY,
	[ObjectName]			NVARCHAR(50) NOT NULL UNIQUE,
	[SortIndex]				INT NOT NULL,
	[LockStatus]			INT NOT NULL				--如果是系统内置默认的证书类型，不许改动或删除(值为对应枚举EDictionaryRecordLockStatus的3)
)

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

PRINT '------ 证书类型等级 ------'
CREATE TABLE [dbo].[CertTypeLevel]
(
	[Id]					INT PRIMARY KEY,
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

CREATE UNIQUE NONCLUSTERED INDEX [IDX_EmployeeId_CertTypeId_CertTypeLevelId_CertTypeKindId_ExpiredDate] ON [dbo].[EmployeeCert] 
(
	EmployeeId ASC,
	CertTypeId ASC,
	CertTypeLevelId ASC,
	CertTypeKindId ASC,
	ExpiredDate DESC
)


PRINT '------ 人员证书影印件 ------'
CREATE TABLE  [dbo].[EmployeeCertPhoto](
	[Id]					INT PRIMARY KEY,
	[EmployeeId]			INT NOT NULL,
	[EmployeeCertId]		INT NOT NULL,											-- 人员证书Id
	[EmployeeCertPhotoType]	INT NOT NULL,											-- 影印件类型(1:封面  2:内页)
	[Photo]					VARBINARY(MAX),										    -- 人员证书影印件
)
ALTER TABLE [EmployeeCertPhoto] WITH CHECK ADD
	CONSTRAINT [FK_EmployeeCertPhoto_Employee] FOREIGN KEY([EmployeeId]) REFERENCES [Employee]([Id]),
	CONSTRAINT [FK_EmployeeCertPhoto_EmployeeCert] FOREIGN KEY([EmployeeCertId]) REFERENCES [EmployeeCert]([Id])

CREATE UNIQUE NONCLUSTERED INDEX [IDX_EmployeeCertPhoto_CertType_EmployeeCertPhotoType] ON [dbo].[EmployeeCertPhoto] 
(
	[EmployeeCertId] ASC,
	[EmployeeCertPhotoType] ASC
)	

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


PRINT '------ 向证书驳回提示表插入数据 ------'
insert into [CertRejectInfo] ([ObjectName],[SortIndex]) VALUES('非本人证书影印件',1)
insert into [CertRejectInfo] ([ObjectName],[SortIndex]) VALUES('证书影印件不清晰',2)
insert into [CertRejectInfo] ([ObjectName],[SortIndex]) VALUES('证书基本信息填写有误',3)


PRINT '------ 向证书类型、级别表插入数据 ------'
insert into [CertType] ([Id],[ObjectName],[SortIndex],[LockStatus]) VALUES(1,'职业资格',1,3)
insert into [CertTypeLevel] ([Id],[CertTypeId],[ObjectName],[SortIndex]) VALUES(101,1,'初级工',1)
insert into [CertTypeLevel] ([Id],[CertTypeId],[ObjectName],[SortIndex]) VALUES(102,1,'中级工',2)
insert into [CertTypeLevel] ([Id],[CertTypeId],[ObjectName],[SortIndex]) VALUES(103,1,'高级工',3)
insert into [CertTypeLevel] ([Id],[CertTypeId],[ObjectName],[SortIndex]) VALUES(104,1,'技师',4)
insert into [CertTypeLevel] ([Id],[CertTypeId],[ObjectName],[SortIndex]) VALUES(105,1,'高级技师',5)

insert into [CertType] ([Id],[ObjectName],[SortIndex],[LockStatus]) VALUES(2,'专业技术资格',2,3)
insert into [CertTypeLevel] ([Id],[CertTypeId],[ObjectName],[SortIndex]) VALUES(201,2,'初级',1)
insert into [CertTypeLevel] ([Id],[CertTypeId],[ObjectName],[SortIndex]) VALUES(202,2,'中级',2)
insert into [CertTypeLevel] ([Id],[CertTypeId],[ObjectName],[SortIndex]) VALUES(203,2,'高级',3)
insert into [CertTypeLevel] ([Id],[CertTypeId],[ObjectName],[SortIndex]) VALUES(204,2,'副高',4)
insert into [CertTypeLevel] ([Id],[CertTypeId],[ObjectName],[SortIndex]) VALUES(205,2,'正高',5)

insert into [CertType] ([Id],[ObjectName],[SortIndex],[LockStatus]) VALUES(3,'学历',3,3)
insert into [CertTypeLevel] ([Id],[CertTypeId],[ObjectName],[SortIndex]) VALUES(301,3,'小学',1)
insert into [CertTypeLevel] ([Id],[CertTypeId],[ObjectName],[SortIndex]) VALUES(302,3,'初中',2)
insert into [CertTypeLevel] ([Id],[CertTypeId],[ObjectName],[SortIndex]) VALUES(303,3,'高中(中专)',3)
insert into [CertTypeLevel] ([Id],[CertTypeId],[ObjectName],[SortIndex]) VALUES(304,3,'大专',4)
insert into [CertTypeLevel] ([Id],[CertTypeId],[ObjectName],[SortIndex]) VALUES(305,3,'本科',5)
insert into [CertTypeLevel] ([Id],[CertTypeId],[ObjectName],[SortIndex]) VALUES(306,3,'硕士研究生',6)
insert into [CertTypeLevel] ([Id],[CertTypeId],[ObjectName],[SortIndex]) VALUES(307,3,'博士研究生',7)

insert into [CertType] ([Id],[ObjectName],[SortIndex],[LockStatus]) VALUES(4,'学位',4,3)
insert into [CertTypeLevel] ([Id],[CertTypeId],[ObjectName],[SortIndex]) VALUES(401,4,'学士',1)
insert into [CertTypeLevel] ([Id],[CertTypeId],[ObjectName],[SortIndex]) VALUES(402,4,'硕士',2)
insert into [CertTypeLevel] ([Id],[CertTypeId],[ObjectName],[SortIndex]) VALUES(403,4,'博士',3)

END

GO