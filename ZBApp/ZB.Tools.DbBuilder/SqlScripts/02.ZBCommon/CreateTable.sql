
USE [$(DatabaseName)]
GO
BEGIN TRANSACTION
PRINT '------ 环境变量和系统配置 ------'
--系统配置
CREATE TABLE [dbo].[SystemConfig]
(
	[Id]			INT IDENTITY(1,1) PRIMARY KEY,
	[GroupName]		NVARCHAR(50) NOT NULL,
	[ItemName]		NVARCHAR(50) NOT NULL,
	[ItemValue]		VARBINARY(max) NULL,
)
GO

--IP地址黑名单(登录时使用)
CREATE TABLE [dbo].[IPBlackList](
	[Id]			INT IDENTITY(1,1) PRIMARY KEY,
	[StartIP]		NVARCHAR(50) NOT NULL,
	[EndIP]			NVARCHAR(50) NULL
)
GO

PRINT '------ 角色 ------'
CREATE TABLE [dbo].[Role]
(
	[Id]			INT IDENTITY(1,1) PRIMARY KEY,
	[ObjectName]	NVARCHAR(50) NOT NULL UNIQUE,	-- 角色名称
	[RoleDesc]		NVARCHAR(50) NOT NULL,			-- 权限描述	
	[IsDefault]		BIT NOT NULL,					-- 是否默认角色
	[IsSystem]		BIT NOT NULL,					-- 是否系统内置角色（如果是则此角色不能删除，不能修改权限）。
)
GO

PRINT '------ 角色权限 ------'
CREATE TABLE [dbo].[RoleInPrivilege]
(
	[Id]		INT IDENTITY(1,1) PRIMARY KEY,
	[RoleId]	INT,
	[PrvgName]	NVARCHAR(50) NOT NULL,				-- 权限名称
)
GO
ALTER TABLE [RoleInPrivilege]  WITH CHECK ADD  
	CONSTRAINT [FK_RoleInPrivilege_Role] FOREIGN KEY([RoleId]) REFERENCES [Role] ([Id])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_RoleInPrivilege_RP] ON [dbo].[RoleInPrivilege] 
(
	[RoleId] ASC,
	[PrvgName] ASC
)
GO

PRINT '------ 公告 ------'
CREATE TABLE [dbo].[Notice](
	[Id]				INT IDENTITY(1,1) PRIMARY KEY,	-- 唯一标识
	[DeptId]			INT NOT NULL DEFAULT 0,								-- 部门Id
	[Title]				NVARCHAR(100) NULL,									-- 标题
	[CreatorId]			INT NOT NULL DEFAULT 0,								-- 创建人Id
	[CreatorName]		NVARCHAR(50) NULL,									-- 创建人姓名
	[Content]			VARBINARY(MAX) NULL,								-- 公告内容
	[HoldDays]			INT NOT NULL,										-- 持续天数
	[CreateDate]		DATETIME NOT NULL,									-- 创建时间
	[StartDate]			DATETIME NOT NULL,									-- 开始时间
	[EndDate]			DATETIME NOT NULL,									-- 结束时间
)
GO

PRINT '------ 公告部门 ------'
CREATE TABLE [dbo].[NoticeDept](
	[Id]				INT IDENTITY(1,1) PRIMARY KEY,	-- 唯一标识
	[NoticeId]			INT NOT NULL,								-- 公告Id
	[DeptId]			INT NOT NULL,								-- 部门Id
)
GO
ALTER TABLE [NoticeDept]  WITH CHECK ADD  
	CONSTRAINT [FK_NoticeDept_Notice] FOREIGN KEY([NoticeId]) REFERENCES [Notice] ([Id])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_NoticeDept_NoticeId_DeptId] ON [dbo].[NoticeDept] 
(
	[NoticeId] ASC,
	[DeptId] ASC
)
GO

PRINT '------ 公告附件 ------'
CREATE TABLE [dbo].[NoticeAnnex](
	[Id]				INT IDENTITY(1,1) PRIMARY KEY,	-- 唯一标识
	[NoticeId]			INT NOT NULL,					-- 公告ID
	[StoreFileName]		NVARCHAR(200) NOT NULL,			-- 存储时实际文件名
	[TrueFileName]		NVARCHAR(200) NOT NULL			-- 显示文件名
)
GO
ALTER TABLE [NoticeAnnex] WITH CHECK ADD
	CONSTRAINT [FK_NoticeAnnex_Notice] FOREIGN KEY([NoticeId]) REFERENCES [Notice]([Id])
GO


PRINT '------ [MappingData映射表] ------'
CREATE TABLE [dbo].[MappingData]
(
	[Id]				INT IDENTITY(1,1) PRIMARY KEY,
	[GroupKey]			NVARCHAR(50) NULL,
	[Source]			NVARCHAR(200) NULL,	
	[Target]			NVARCHAR(200) NULL
)
GO

PRINT '----------[Sync Data 日志表]-------------'
CREATE TABLE [dbo].[SyncDataLog]
(
	[Id]			INT IDENTITY(1,1) PRIMARY KEY,
	[ErrorType]		INT NOT NULL,							--错误类型
	[ErrorInfo]		NVARCHAR(MAX) NOT NULL,					--错误信息
	[ErrorDate]		DATETIME NOT NULL,						--记录日期
	[ErrorData]		VARBINARY(MAX)							--错误数据（序列化存储，为获取的部门数据，人员数据，映射数据）
)
GO

PRINT '----------[通知消息]-------------'
CREATE TABLE [dbo].[BuzMessage](
	[Id]							INT PRIMARY KEY,
	[TypeId]						INT NOT NULL,
	[Text]							NVARCHAR(50) NOT NULL,		
	[ObjectId]						INT NOT NULL,
	[ObjectMD5]						NVARCHAR(50) NULL,
	[CreateTime]					DATETIME NOT NULL,
	[LastUpdateTime]				DATETIME NOT NULL,
	[ExpirationTime]				DATETIME,
	[Attachment]					VARBINARY(MAX)
)
CREATE UNIQUE NONCLUSTERED INDEX [IDX_ObjectId_TypeId] ON [dbo].[BuzMessage] 
(
	[ObjectId] ASC,
	[TypeId] ASC
)
GO

PRINT '----------[通知消息]-------------'
CREATE TABLE [dbo].[BuzEmployeeMessage](
	[Id]							INT PRIMARY KEY,
	[BuzMessageId]					INT NOT NULL,
	[EmployeeId]					INT NOT NULL,
	[EmployeeTypeId]				INT NOT NULL,
	[MarkedTime]					DATETIME,
	[LastUpdateTime]				DATETIME NOT NULL,
	[Text]							NVARCHAR(50) NULL,
	[Attachment]					VARBINARY(MAX)	
)
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_BuzMessageId_EmployeeId_EmployeeTypeId] ON [dbo].[BuzEmployeeMessage] 
(
	[BuzMessageId] ASC,
	[EmployeeId] ASC,
	[EmployeeTypeId] ASC
)
GO

PRINT '----------[Sync Data 友情链接表]-------------'
CREATE TABLE [dbo].[FriendLink]
(
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,
	[FriendLinkTitle]		NVARCHAR(20) NOT NULL,						--友情链接标题
	[FriendLinkUrl]			NVARCHAR(2000) NOT NULL,					--友情链接地址
	[SortIndex]				INT NOT NULL,								--排序索引
	[IsLoginShow]			BIT NOT NULL DEFAULT 0,						--是否显示在登录页
)
GO
COMMIT TRANSACTION