PRINT '------ 资源文件夹 ------'
CREATE TABLE [dbo].[RFolder](
	[Id]				INT PRIMARY KEY NOT NULL,							-- 唯一标识
	[ParentId]			INT NOT NULL,										-- 父文件夹Id（根文件夹的话，要更新）
	[ObjectName]		NVARCHAR(50) NOT NULL,								-- 文件名称（也包括文件夹名称）
	[FullPath]			NVARCHAR(260) NOT NULL,								-- 全路径（文件夹/……/文件）
	[DeptId]			INT NOT NULL,										-- 部门Id	
	[Comment]			NVARCHAR(400) NULL,									-- 批注
	[CreateTime]		DATETIME NOT NULL,									-- 创建时间	
	[CreatorId]			INT NOT NULL,										-- 创建用户ID
	[CreatorName]		NVARCHAR(50) NOT NULL,								-- 创建用户姓名
	[SortIndex]			INT NOT NULL DEFAULT ((0)),							-- 排序索引
)
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_RFolder_DeptIdFullPath] ON [dbo].[RFolder] 
(
	[DeptId] ASC,
	[FullPath] ASC
)
GO
PRINT'--确保一个资源文件夹下的子节点名称不重复--'
CREATE UNIQUE NONCLUSTERED INDEX [IDX_RFolder_DeptId_ParentId_ObjectName] ON [dbo].[RFolder] 
(
	[DeptId] ASC,
	[ParentId] ASC,
	[ObjectName] ASC
)
GO

PRINT '------ 资源文件夹共享 ------'
CREATE TABLE [dbo].[RFolderShare](
	[Id]				INT PRIMARY KEY NOT NULL,							-- 唯一标识
	[FolderId]			INT NOT NULL,										-- 文件夹Id
	[SharedType]		INT NOT NULL,										-- 共享类型(0:所有人, 1:所有部门, 2:人员, 3:部门， 4:岗位)
	[SharedId]			INT NOT NULL,										-- 共享ID(人员ID,部门ID,岗位ID)
	[SharedName]		NVARCHAR(320) NOT NULL,								-- 共享名称(冗余)
	[SharedMode]		INT NOT NULL DEFAULT(0),								-- 共享模式(0:只读，1:读写)
	[AllowStudy]		BIT NOT NULL DEFAULT(0),										-- 是否允许学习
	[IsIncludeSubDept]	BIT NOT NULL DEFAULT(0),										-- 是否包含子部门
	[IncludeSubDeptMode]	INT NOT NULL DEFAULT(0)										-- 包含子部门形式
)
GO
ALTER TABLE [RFolderShare]  WITH CHECK ADD  
	CONSTRAINT [FK_RFolderShare_RFolder] FOREIGN KEY([FolderId]) REFERENCES [RFolder] ([Id])
GO

PRINT '------ 资源文件 ------'
CREATE TABLE [dbo].[RFile](
	[Id]						INT PRIMARY KEY NOT NULL,							-- 唯一标识
	[ObjectName]				NVARCHAR(255) NOT NULL,								-- 文件名称	
	[SourceName]				NVARCHAR(255) NOT NULL,								-- 原始文件名称	
	[ConvertName]				NVARCHAR(255) NOT NULL,								-- 转换文件名称	
	[ParentId]					INT NOT NULL,										-- 文件夹Id
	[RecommendCount]			INT NOT NULL DEFAULT ((0)),							-- 推荐次数
	[UnRecommendCount]			INT NOT NULL DEFAULT ((0)),							-- 不推荐次数
	[StudyTimes]				INT NOT NULL DEFAULT ((0)),							-- 学习人次
	[CreateTime]				DATETIME NOT NULL,									-- 创建时间
	[LastUpdateTime]			DATETIME NOT NULL,									-- 最后一次修改时间
	[CreatorId]					INT NOT NULL,										-- 创建用户ID
	[CreatorName]				NVARCHAR(50) NOT NULL,								-- 创建用户姓名
	[FileType]					INT NOT NULL,										-- 文件类型
	[FileTypeExt]				INT NOT NULL,										-- 文件扩展名（后缀名）
	[FileSize]					BIGINT NOT NULL,									-- 文件大小		
	[ResourceState]				INT NOT NULL,										-- 资源状态
	[IsNeedAudit]				BIT NOT NULL DEFAULT ((1)),							-- 是否需要审核
	[IsDownloadEnabled]			BIT NOT NULL DEFAULT ((0)),							-- 是否允许下载
	[UploadPathIndex]			INT NOT NULL,										-- 文件存放的上传目录索引
	[PreviewCount]				INT NOT NULL DEFAULT ((0)),							-- 缩略图数量
	[ContentLength]				BIGINT NOT NULL,									-- 内容长度(时长、页数)
	[GUID]						NVARCHAR(50) NOT NULL,								-- Guid	
	[Md5]						NVARCHAR(50) NOT NULL,								-- Md5	
	[SortIndex]					INT NOT NULL DEFAULT ((0)),							-- 排序索引
	[IsSupportApp]				BIT NOT NULL DEFAULT 0,								-- 是否支持App上学习
)
GO
ALTER TABLE [RFile]  WITH CHECK ADD  
	CONSTRAINT [FK_RFile_RFolder] FOREIGN KEY([ParentId]) REFERENCES [RFolder] ([Id])
GO

PRINT '------ 专辑与文件对应关系 ------'
CREATE TABLE [dbo].[AFile](
	[Id]						INT PRIMARY KEY NOT NULL,							-- 唯一标识
	[ObjectName]				NVARCHAR(255) NOT NULL,								-- 文件名称	
	[SourceName]				NVARCHAR(255) NOT NULL,								-- 原始文件名称	
	[ConvertName]				NVARCHAR(255) NOT NULL,								-- 转换文件名称	
	[ParentId]					INT NOT NULL,										-- 对应RFile的Id
	[RecommendCount]			INT NOT NULL DEFAULT ((0)),							-- 推荐次数
	[UnRecommendCount]			INT NOT NULL DEFAULT ((0)),							-- 不推荐次数
	[StudyTimes]				INT NOT NULL DEFAULT ((0)),							-- 学习人次
	[CreateTime]				DATETIME NOT NULL,									-- 创建时间
	[LastUpdateTime]			DATETIME NOT NULL,									-- 最后一次修改时间
	[CreatorId]					INT NOT NULL,										-- 创建用户ID
	[CreatorName]				NVARCHAR(50) NOT NULL,								-- 创建用户姓名
	[FileType]					INT NOT NULL,										-- 文件类型
	[FileTypeExt]				INT NOT NULL,										-- 文件扩展名（后缀名）
	[FileSize]					BIGINT NOT NULL,									-- 文件大小		
	[ResourceState]				INT NOT NULL,										-- 资源状态
	[IsNeedAudit]				BIT NOT NULL DEFAULT ((1)),							-- 是否需要审核
	[IsDownloadEnabled]			BIT NOT NULL DEFAULT ((0)),							-- 是否允许下载
	[UploadPathIndex]			INT NOT NULL,										-- 文件存放的上传目录索引
	[PreviewCount]				INT NOT NULL DEFAULT ((0)),							-- 缩略图数量
	[ContentLength]				BIGINT NOT NULL,									-- 内容长度(时长、页数)
	[GUID]						NVARCHAR(50) NOT NULL,								-- Guid	
	[Md5]						NVARCHAR(50) NOT NULL,								-- Md5
	[SortIndex]					INT NOT NULL DEFAULT ((0)),							-- 排序索引	
	[IsSupportApp]				BIT NOT NULL DEFAULT 0,								-- 是否支持App上学习
)
GO
ALTER TABLE [AFile]  WITH CHECK ADD  
	CONSTRAINT [FK_AFile_RFile] FOREIGN KEY([ParentId]) REFERENCES RFile ([Id])
GO

PRINT '------ 评论 ------'
CREATE TABLE [dbo].[Comment](	
	[Id]						INT IDENTITY(1,1) PRIMARY KEY  NOT NULL,			-- 唯一标识
	[SourceType]				INT NOT NULL,										-- 评论来源类型
	[SourceId]					INT NOT NULL,										-- 来源Id
	[SourceName]				NVARCHAR(255),										-- 文件名称(所评论的资源的ObjectName)
	[EmployeeId]				INT NOT NULL,										-- 人员ID
	[EmployeeNO]				NVARCHAR(50),										-- 评论者工号
	[EmployeeName]				NVARCHAR(50) NOT NULL,								-- 人员姓名
	[DeptFullPath]				NVARCHAR(260),										-- 评论者部门全路径
	[CreateTime]				DATETIME NOT NULL,									-- 评论时间
	[Content]					NVARCHAR(250) NOT NULL,								-- 评论内容
	[IsIgnore]					BIT	NOT NULL DEFAULT(0),							-- 是否忽略此评论（下次查询时不再查询到）
)
GO
CREATE NONCLUSTERED INDEX [IDX_Comment_SourceTypeSourceId] ON [dbo].[Comment] 
(
	[SourceType] ASC,
	[SourceId] ASC
)
GO

PRINT '------ 媒体推荐 ------'
CREATE TABLE [dbo].[RecommendRFile](
	[Id]						INT IDENTITY(1,1) PRIMARY KEY NOT NULL,				-- 唯一标识
	[RFileId]					INT NOT NULL,										-- RFileId
	[SortIndex]					INT NOT NULL DEFAULT ((0)),							-- 排序索引
	[RecommendEmployeeId]		INT NOT NULL,										-- 推荐人ID
	[RecommendEmployeeName]		NVARCHAR(50) NOT NULL,								-- 推荐人姓名	
)
GO
ALTER TABLE [RecommendRFile]  WITH CHECK ADD  
	CONSTRAINT [FK_RecommendRFile_RFile] FOREIGN KEY([RFileId]) REFERENCES RFile ([Id])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_RecommendRFile_RFileId] ON [dbo].[RecommendRFile] 
(
	[RFileId] ASC	
)
GO


PRINT '------ 多媒体与知识结构关系 ------'
CREATE TABLE [dbo].[RFileInMFolder](
	[Id]				INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[RFileId]			INT NOT NULL,													--多媒体ID
	[ProCategoryId]		INT NOT NULL DEFAULT(0),										--职岗类型ID
	[MFolderId]			INT NOT NULL DEFAULT(0),										--知识结构文件夹ID
	[ModuleId]			INT NOT NULL DEFAULT(0)											--模块ID
)
GO
ALTER TABLE [RFileInMFolder] WITH CHECK ADD
	CONSTRAINT [FK_RFileId_RFileInMFolder] FOREIGN KEY([RFileId]) REFERENCES [RFile]([Id])
GO