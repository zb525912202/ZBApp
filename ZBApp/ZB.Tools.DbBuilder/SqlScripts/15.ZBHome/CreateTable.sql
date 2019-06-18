USE [$(DatabaseName)]
GO
BEGIN TRANSACTION

PRINT '------ 省份 ------'
CREATE TABLE [dbo].[Province](
	[Id]					INT PRIMARY KEY  NOT NULL,							-- 唯一标识
	[ObjectName]			NVARCHAR(100) NOT NULL,								-- 省份
)
GO

PRINT '------ 地区 ------'
CREATE TABLE [dbo].[Area](
	[Id]					INT PRIMARY KEY  NOT NULL,							-- 唯一标识
	[ProvinceId]			INT NOT NULL,										-- 所属省份Id
	[ObjectName]			NVARCHAR(100) NOT NULL,								-- 地区
)
GO
ALTER TABLE [Area]  WITH CHECK ADD  
	CONSTRAINT [FK_Area_Province] FOREIGN KEY([ProvinceId]) REFERENCES [Province] ([Id])
GO

PRINT '------ 客户分类 ------'
CREATE TABLE [dbo].[CustomerFolder](
	[Id]				INT PRIMARY KEY NOT NULL,							-- 唯一标识
	[ParentId]			INT NOT NULL,										-- 父文件夹Id（根文件夹的话，要更新）
	[ObjectName]		NVARCHAR(50) NOT NULL,								-- 文件名称（也包括文件夹名称）
	[FullPath]			NVARCHAR(260) NOT NULL UNIQUE,						-- 全路径（文件夹/……/文件）
	[SortIndex]			INT NOT NULL DEFAULT ((0)),							-- 排序索引
)
GO

PRINT '------ 客户 ------'
CREATE TABLE [dbo].[Customer](
	[Id]					INT PRIMARY KEY  NOT NULL,							-- 唯一标识
	[ObjectName]			NVARCHAR(100) NOT NULL,								-- 客户名称
	[FolderId]				INT NOT NULL,										-- 所属分类Id
	[ProvinceId]			INT NOT NULL,										-- 省份	
	[AreaId]				INT NOT NULL,										-- 地区
	[Contractor]			NVARCHAR(100) NULL,									-- 联系人
	[Tel]					NVARCHAR(50) NULL,									-- 联系电话
	[Remark]				NVARCHAR(200) NULL,									-- 备注
	[CustomerKey1]			NVARCHAR(44) NOT NULL,								-- 09版系统客户编号
	[CustomerKey2]			INT NOT NULL,										-- 新系统客户编号
	[CreateTime]			DATETIME NOT NULL,									-- 创建时间
	[GrantHome]             INT NOT NULL,                                       -- 不知道做什么的
)
GO
ALTER TABLE [Customer]  WITH CHECK ADD  
	CONSTRAINT [FK_Customer_CustomerFolder] FOREIGN KEY([FolderId]) REFERENCES [CustomerFolder] ([Id])
GO
ALTER TABLE [Customer]  WITH CHECK ADD  
	CONSTRAINT [FK_Customer_Province] FOREIGN KEY([ProvinceId]) REFERENCES [Province] ([Id])
GO
ALTER TABLE [Customer]  WITH CHECK ADD  
	CONSTRAINT [FK_Customer_Area] FOREIGN KEY([AreaId]) REFERENCES [Area] ([Id])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_Customer_ObjectName] ON [dbo].[Customer] 
(
	[ObjectName] ASC
)
GO

PRINT '------ 试题打包历史记录 ------'
CREATE TABLE [dbo].[QuesPackageExportHistory](
	[Id]						INT PRIMARY KEY  NOT NULL,							-- 唯一标识
	[CustomerId]				INT NOT NULL,										-- 客户Id
	[QuesPackageGuid]			NVARCHAR(100) NOT NULL,								-- 试题包Guid	
	[FolderCount]				INT NOT NULL,										-- 文件夹数量
	[QuesCount]					INT NOT NULL,										-- 题量
	[ExportTime]				DATETIME NOT NULL,									-- 创建时间
	[ExportHistoryObjBytes]		VARBINARY(MAX) NOT NULL,							-- 导出历史详细
)
GO
ALTER TABLE [QuesPackageExportHistory]  WITH CHECK ADD  
	CONSTRAINT [FK_QuesPackageExportHistory_Customer] FOREIGN KEY([CustomerId]) REFERENCES [Customer] ([Id])
GO

PRINT '------ 客户授权表 ------'
CREATE TABLE [dbo].[ZBEmpower](
	[Id]						INT IDENTITY(1,1) PRIMARY KEY,						-- 唯一标识
	[HId]						NVARCHAR(100) NOT NULL UNIQUE,						-- 设备Id
	[CustomerId]				INT NOT NULL,										-- 客户Id	
	[CreateTime]				DATETIME NOT NULL,									-- 创建时间
	[LastUpdateTime]			DATETIME NOT NULL,									-- 最后一次记录这条数据的时间
	[LastOperaterId]			INT NOT NULL,										-- 操作人的id
	[LastOperaterName]			NVARCHAR(100) NOT NULL,								-- 最后一次的操作人的姓名
)
GO
ALTER TABLE [ZBEmpower]  WITH CHECK ADD  
	CONSTRAINT [FK_ZBEmpower_Customer] FOREIGN KEY([CustomerId]) REFERENCES  [Customer] ([Id])
GO

PRINT '------ 题卷单机版客户授权表 ------'
CREATE TABLE [dbo].[ZBPQEmpower](
	[Id]						INT IDENTITY(1,1) PRIMARY KEY,						-- 唯一标识
	[ZBEmpowerId]				INT NOT NULL,										-- 授权Id	
	[EmpowerDate]				DATETIME,											-- 有效时间(若为空，就是永久有效)	
)
GO
ALTER TABLE [ZBPQEmpower]  WITH CHECK ADD  
	CONSTRAINT [FK_ZBPQEmpower_ZBEmpower] FOREIGN KEY([ZBEmpowerId]) REFERENCES  [ZBEmpower] ([Id])
GO

PRINT '------ 高级题卷单机版客户授权表 ------'
CREATE TABLE [dbo].[ZBPQEXEmpower](
	[Id]						INT IDENTITY(1,1) PRIMARY KEY,						-- 唯一标识
	[ZBEmpowerId]				INT NOT NULL,										-- 授权Id	
	[EmpowerDate]				DATETIME,											-- 有效时间(若为空，就是永久有效)	
)
GO
ALTER TABLE [ZBPQEXEmpower]  WITH CHECK ADD  
	CONSTRAINT [FK_ZBPQEXEmpower_ZBEmpower] FOREIGN KEY([ZBEmpowerId]) REFERENCES  [ZBEmpower] ([Id])
GO

PRINT '------ 持证单机版客户授权表 ------'
CREATE TABLE [dbo].[ZBCertEmpower](
	[Id]						INT IDENTITY(1,1) PRIMARY KEY,						-- 唯一标识
	[ZBEmpowerId]				INT NOT NULL,										-- 授权Id	
	[EmpowerDate]				DATETIME,											-- 有效时间(若为空，就是永久有效)	
	[OperatorLimit]				INT NOT NULL,										-- 培训员账户数量限制
)
GO
ALTER TABLE [ZBCertEmpower]  WITH CHECK ADD  
	CONSTRAINT [FK_ZBCertEmpower_ZBEmpower] FOREIGN KEY([ZBEmpowerId]) REFERENCES  [ZBEmpower] ([Id])
GO

PRINT '------ 客户JDK生成历史 ------'
CREATE TABLE [dbo].[CustomerJDK](
	[Id]					INT IDENTITY(1,1) PRIMARY KEY  NOT NULL,			-- 唯一标识
	[CustomerId]			INT NOT NULL,										-- 客户Id	

	[CreateTime]			DATETIME NOT NULL,									-- 创建时间
	[CreatorId]				INT NOT NULL,										-- 操作人id
	[CreatorName]			NVARCHAR(100) NOT NULL,								-- 操作人姓名
)
GO
ALTER TABLE [CustomerJDK]  WITH CHECK ADD  
	CONSTRAINT [FK_CustomerJDK_Customer] FOREIGN KEY([CustomerId]) REFERENCES [Customer] (Id)
GO

PRINT '------ 客户JDK生成历史明细 ------'
CREATE TABLE [dbo].[CustomerJDKDetail](
	[Id]					INT IDENTITY(1,1) PRIMARY KEY  NOT NULL,			-- 唯一标识
	[CustomerJDKId]			INT NOT NULL,										-- 客户JDK生成历史Id

	[ZBSystemKey]			INT NOT NULL,										-- ZBSystemKeyEnum类型
	[EmpowerDate]			DATETIME NOT NULL,									-- 授权截止日期
)
GO
ALTER TABLE [CustomerJDKDetail]  WITH CHECK ADD  
	CONSTRAINT [FK_CustomerJDKDetail_CustomerJDK] FOREIGN KEY([CustomerJDKId]) REFERENCES [CustomerJDK] ([Id])
GO



COMMIT TRANSACTION
