PRINT '------ 试卷文件夹 ------'
CREATE TABLE [dbo].[PFolder](
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
CREATE UNIQUE NONCLUSTERED INDEX [IDX_PFolder_DeptIdFullPath] ON [dbo].[PFolder] 
(
	[DeptId] ASC,
	[FullPath] ASC
)
GO
PRINT'--确保一个试卷文件夹下的子节点名称不重复--'
CREATE UNIQUE NONCLUSTERED INDEX [IDX_RFolder_DeptId_ParentId_ObjectName] ON [dbo].[PFolder] 
(
	[DeptId] ASC,
	[ParentId] ASC,
	[ObjectName] ASC
)
GO

PRINT '------ 试卷文件夹共享 ------'
CREATE TABLE [dbo].[PFolderShare](
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
ALTER TABLE [PFolderShare]  WITH CHECK ADD  
	CONSTRAINT [FK_PFolderShare_PFolder] FOREIGN KEY([FolderId]) REFERENCES [PFolder] ([Id])
GO

PRINT '------ 试卷包 ------'
CREATE TABLE [dbo].[PaperPackage](
	[Id]							INT IDENTITY(1,1) PRIMARY KEY  NOT NULL,			-- 唯一标识
	[FolderId]						INT NOT NULL,										-- 文件夹ID
	[IsImpersonal]					BIT NOT NULL,										-- 是否客观卷
	[ObjectName]					NVARCHAR(50) NOT NULL,								-- 试卷包名称	
	[CreatorId]						INT NOT NULL,										-- 创建人Id
	[CreatorName]					NVARCHAR(50) NOT NULL,								-- 创建人Name	
	[CreateTime]					DATETIME NOT NULL,									-- 创建时间
	[IsPrivate]						BIT NOT NULL DEFAULT ((1)),							-- 是否私有
	[LastUpdateTime]				DATETIME NOT NULL,									-- 最后一次修改时间
	[HardRate]						DECIMAL(18,1) NOT NULL DEFAULT ((0)),				-- 难度系数
	[Describe]						NVARCHAR(400) NULL,									-- 描述(知识点)
	[PaperPackageQuestionCount]		INT NOT NULL DEFAULT ((0)),							-- 试卷包用题题量
	[IsIncludeSln]					BIT NOT NULL DEFAULT 0,								-- 是否包含组卷方案
	[PaperScore]					DECIMAL(18,1) NOT NULL DEFAULT ((0)),				-- 试卷总分
	[PaperQuesCount]				INT NOT NULL DEFAULT ((0)),							-- 试卷题量
	[IsRandomPaper]					BIT NOT NULL DEFAULT 0,								-- 是否随机卷
	[PaperSolutionObjBytes]			VARBINARY(MAX),										-- 组卷方案
	[ExportConfig]					VARBINARY(MAX),										-- 试卷导出配置

	[IsElecPaperPackage]			BIT NOT NULL DEFAULT 1,								-- 是否电子卷(默认值是True)
	[IsLocalPaperPackage]			BIT NOT NULL DEFAULT 0,								-- 是否本地卷
	[Remark]						NVARCHAR(400) NULL,									-- 批注
)
GO
ALTER TABLE [PaperPackage]  WITH CHECK ADD  
	CONSTRAINT [FK_PaperPackage_PFolder] FOREIGN KEY([FolderId]) REFERENCES [PFolder] ([Id])
GO

--试卷包试题表，该表动态生成，表名为【PaperPackageQuestion_】 + 【试卷包ID】
/*
CREATE TABLE [dbo].[PaperPackageQuestion_{0}](
	[Id]					INT PRIMARY KEY  NOT NULL,				--标识
	[QuestionId]			INT NOT NULL,							--试题ID
	[PaperPackageId]		INT NOT NULL,							--试卷包ID
	[HardLevel]	    		INT NOT NULL,							--难易度
	[QtId]					INT NOT NULL,							--题型ID
	[ContentText]			NVARCHAR(400) NULL,						--内容文本
	[AnswerText]			NVARCHAR(MAX) NULL,						--答案文本
	[AnalysisText]			NVARCHAR(MAX) NULL,						--解析文本	
	[Content]				VARBINARY(MAX) NOT NULL,				--内容
	[Answer]				VARBINARY(MAX) NULL,					--答案
	[Analysis]				VARBINARY(MAX) NULL						--解析
	[ContentLength]			INT NOT NULL,							-- 试题内容Rtf字节数
	[AnswerLength]			INT NOT NULL,							-- 试题答案Rtf字节数
	[AnalysisLength]		INT NOT NULL,							-- 试题解析Rtf字节数
)
*/

PRINT '------ 本地试卷包 ------'
CREATE TABLE [dbo].[LocalPaperPackageFile](
	[Id]							INT PRIMARY KEY  NOT NULL,							-- 唯一标识
	[PaperPackageId]				INT NOT NULL,										-- 文件夹ID
	[PaperPackageFileType]			INT NOT NULL,										-- 本地试卷文件类型(试题卷、答案卷、合并卷)
	[SourceName]					NVARCHAR(255) NOT NULL,								-- 原始文件名称	
	[RtfName]						NVARCHAR(255) NOT NULL,								-- RTF文件名称
	[CreateTime]					DATETIME NOT NULL,									-- 创建时间
)
GO
ALTER TABLE [LocalPaperPackageFile]  WITH CHECK ADD  
	CONSTRAINT [FK_LocalPaperPackageFile_PaperPackage] FOREIGN KEY([PaperPackageId]) REFERENCES [PaperPackage] ([Id])
GO

PRINT '------ 人员试卷转换配置表 ------'
CREATE TABLE [dbo].[PaperPackageConvertConfig](
	[Id]							INT IDENTITY(1,1) PRIMARY KEY  NOT NULL,			-- 唯一标识
	[EmployeeId]					INT NOT NULL,										-- 人员ID
	[ConvertConfig]					VARBINARY(MAX),										-- 试卷转换配置
)
GO

PRINT '------ 导出历史表 ------'
CREATE TABLE [dbo].[ExportHistory](
	[Id]						INT IDENTITY(1,1) PRIMARY KEY NOT NULL,				-- 唯一标识
	[PaperPackageId]			INT NOT NULL,										-- 试卷包ID
	[ExportEmployeeId]			INT NOT NULL,										-- 导出人Id
	[ExportEmployeeName]		NVARCHAR(50) NOT NULL,								-- 导出人姓名
	[ExportTime]				DATETIME NOT NULL,									-- 导出时间
)
GO
ALTER TABLE [ExportHistory]  WITH CHECK ADD  
	CONSTRAINT [FK_ExportHistory_PaperPackage] FOREIGN KEY([PaperPackageId]) REFERENCES PaperPackage ([Id])
GO

PRINT '------ 导出历史试卷表 ------'
CREATE TABLE [dbo].[ExportHistoryPaper](
	[Id]							INT PRIMARY KEY NOT NULL,								
	[PaperPackageId]				INT NOT NULL,											-- 试卷包ID
	[ExportHistoryId]				INT NOT NULL,											-- 历史表ID
	[ObjectName]					NVARCHAR(50) NOT NULL,									-- 试卷名称
	[PaperScore]					DECIMAL(18,1) NOT NULL DEFAULT ((0)),					-- 试卷总分
	[PaperQuesCount]				INT NOT NULL DEFAULT ((0)),								-- 试卷题量
	[IsRandomPaper]					BIT NOT NULL DEFAULT 0,									-- 是否随机卷
)
GO
ALTER TABLE [ExportHistoryPaper]  WITH CHECK ADD  
	CONSTRAINT [FK_ExportHistoryPaper_ExportHistory] FOREIGN KEY([ExportHistoryId]) REFERENCES ExportHistory ([Id])
GO

PRINT '------ 导出历史试卷详细表 ------'
CREATE TABLE [dbo].[ExportHistoryPaperDetail](
	[Id]						INT IDENTITY(1,1) PRIMARY KEY NOT NULL,				-- 唯一标识
	[PaperPackageId]			INT NOT NULL,										-- 试卷包ID
	[ExportHistoryId]			INT NOT NULL,										-- 历史表ID
	[ExportHistoryPaperId]		INT NOT NULL,										-- 导出历史试卷表Id
	[PaperPackageQuestionId]	INT NOT NULL,										-- 试卷包试题Id
	[TotalScore]				DECIMAL(18,1) NOT NULL DEFAULT ((0)),				-- 试卷包试题分数
)
GO
ALTER TABLE [ExportHistoryPaperDetail]  WITH CHECK ADD  
	CONSTRAINT [FK_ExportHistoryPaperDetail_ExportHistoryPaper] FOREIGN KEY([ExportHistoryPaperId]) REFERENCES ExportHistoryPaper ([Id])
GO

PRINT '------ 试卷与知识结构关系 ------'
CREATE TABLE [dbo].[PaperInMFolder](
	[Id]				INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[PaperPackageId]	INT NOT NULL,													--试卷ID
	[ProCategoryId]		INT NOT NULL DEFAULT(0),										--职岗类型ID
	[MFolderId]			INT NOT NULL DEFAULT(0),										--知识结构文件夹ID
	[ModuleId]			INT NOT NULL DEFAULT(0)											--模块ID
)
GO
ALTER TABLE [PaperInMFolder] WITH CHECK ADD
	CONSTRAINT [FK_PaperPackageId_PaperInMFolder] FOREIGN KEY([PaperPackageId]) REFERENCES [PaperPackage]([Id])
GO