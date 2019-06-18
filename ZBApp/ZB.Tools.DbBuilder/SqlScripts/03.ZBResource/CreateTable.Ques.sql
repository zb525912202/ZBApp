PRINT '------ 题型 ------'
CREATE TABLE [dbo].[QuestionType](
	[Id]							INT PRIMARY KEY  NOT NULL,					-- 唯一标识
	[ObjectName]					NVARCHAR(50) NOT NULL,						-- 题型名称
	[IsImpersonal]					BIT NOT NULL,								-- 是否客观题
	[SortIndex]						INT NOT NULL DEFAULT ((0)),					-- 排序索引
	[NormalScore]					DECIMAL(18,1) NOT NULL DEFAULT ((0)),		-- 标准题分
	[NormalQuestionCount]			INT NOT NULL DEFAULT ((0)),					-- 标准题量
	[AnswerLines]					INT NOT NULL DEFAULT ((0)),					-- 答案行数
	[GraderType]					INT NOT NULL DEFAULT ((0)),					-- 阅卷机器人(默认无阅卷机器人)
	[MinRightPercent]				INT NOT NULL,								-- 最低正确率
	[LearningSecond]				INT NOT NULL,								-- 标准时间
	[OnlySupportOpenMode]			BIT NOT NULL,								-- 仅支持开卷学习
	[MinRightPercent_Default]		INT NOT NULL,								-- 最低正确率配置的默认值
	[LearningSecond_Default]		INT NOT NULL,								-- 标准时间配置的默认值
	[OnlySupportOpenMode_Default]	BIT NOT NULL,								-- 仅支持开卷学习配置的默认值
)
GO

PRINT '------ 试题文件夹 ------'
CREATE TABLE [dbo].[QFolder](
	[Id]				INT PRIMARY KEY NOT NULL,							-- 唯一标识
	[ParentId]			INT NOT NULL,										-- 父文件夹Id（根文件夹的话，要更新）
	[ObjectName]		NVARCHAR(50) NOT NULL,								-- 文件名称（也包括文件夹名称）
	[FullPath]			NVARCHAR(255) NOT NULL,								-- 全路径（文件夹/……/文件）
	[DeptId]			INT NOT NULL,										-- 部门Id
	[Comment]			NVARCHAR(400) NULL,									-- 批注
	[CreateTime]		DATETIME NOT NULL,									-- 创建时间
	[CreatorId]			INT NOT NULL,										-- 创建用户ID
	[CreatorName]		NVARCHAR(50) NOT NULL,								-- 创建用户姓名
	[SortIndex]			INT NOT NULL DEFAULT ((0)),							-- 排序索引
)
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_QFolder_DeptIdFullPath] ON [dbo].[QFolder] 
(
	[DeptId] ASC,
	[FullPath] ASC
)
GO
CREATE NONCLUSTERED INDEX [IDX_QFolder_DeptId] ON [dbo].[QFolder]
(
	[DeptId] ASC,
	[Id] ASC	
)
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_QFolder_DeptId_ParentId_ObjectName] ON [dbo].[QFolder] 
(
	[DeptId] ASC,
	[ParentId] ASC,
	[ObjectName] ASC
)
GO

PRINT '------ 试题文件夹共享 ------'
CREATE TABLE [dbo].[QFolderShare](
	[Id]					INT PRIMARY KEY NOT NULL,							-- 唯一标识
	[FolderId]				INT NOT NULL,										-- 文件夹Id
	[SharedType]			INT NOT NULL,										-- 共享类型(0:所有人, 1:所有部门, 2:人员, 3:部门， 4:岗位)
	[SharedId]				INT NOT NULL,										-- 共享ID(人员ID,部门ID,岗位ID)
	[SharedName]			NVARCHAR(320) NOT NULL,								-- 共享名称(冗余)
	[SharedMode]			INT NOT NULL DEFAULT(0),							-- 共享模式(0:只读，1:读写)
	[AllowStudy]			BIT NOT NULL DEFAULT(0),										-- 是否允许学习
	[IsIncludeSubDept]		BIT NOT NULL DEFAULT(0),										-- 是否包含子部门
	[IncludeSubDeptMode]	INT NOT NULL DEFAULT(0)										-- 包含子部门形式
)
GO
ALTER TABLE [QFolderShare]  WITH CHECK ADD  
	CONSTRAINT [FK_QFolderShare_QFolder] FOREIGN KEY([FolderId]) REFERENCES [QFolder] ([Id])
GO



PRINT '------ 试题 ------'
CREATE TABLE [dbo].[Question](
	[Id]					INT CONSTRAINT PK_Question_Id PRIMARY KEY  NOT NULL,-- 唯一标识	
	[FolderId]				INT NOT NULL,										-- 文件夹ID
	[HardLevel]				INT NOT NULL,										-- 难度
	[QtId]					INT NOT NULL,										-- 题型ID
	[ContentText]			NVARCHAR(400) NULL,									-- 试题内容
	[AnswerText]			NVARCHAR(MAX) NULL,									-- 试题答案
	[AnalysisText]			NVARCHAR(MAX) NULL,									-- 试题解析
	[Content]				VARBINARY(MAX) NOT NULL,							-- 试题内容Rtf
	[Answer]				VARBINARY(MAX) NULL,								-- 试题答案Rtf
	[Analysis]				VARBINARY(MAX) NULL,								-- 试题解析Rtf
	[ContentLength]			INT NOT NULL,										-- 试题内容Rtf字节数
	[AnswerLength]			INT NOT NULL,										-- 试题答案Rtf字节数
	[AnalysisLength]		INT NOT NULL,										-- 试题解析Rtf字节数
	[CreateTime]			DATETIME NOT NULL,									-- 创建时间
	[LastUpdateTime]		DATETIME NOT NULL,									-- 最后一次修改时间
	[QuestionCreateType]	INT NOT NULL DEFAULT 0,								-- 试题创建类型(试题包导入，RTF导入，试题编辑)
	--[IsEmptyAnswer]				BIT NOT NULL DEFAULT(0),						-- 是否空答案

)
GO
ALTER TABLE [Question]  WITH CHECK ADD  
	CONSTRAINT [FK_Question_QFolder] FOREIGN KEY([FolderId]) REFERENCES [QFolder] ([Id])
GO
ALTER TABLE [Question]  WITH CHECK ADD  
	CONSTRAINT [FK_Question_QuestionType] FOREIGN KEY([QtId]) REFERENCES [QuestionType] ([Id])
GO
CREATE NONCLUSTERED INDEX [IDX_Question_FolderId] ON [dbo].[Question] 
(
	[FolderId] ASC
)
GO
CREATE NONCLUSTERED INDEX [IDX_Question_ContentText] ON [dbo].[Question] 
(
	[ContentText] ASC
)
GO
CREATE NONCLUSTERED INDEX [IDX_Question_FI] ON [dbo].[Question] 
(
	[FolderId] ASC,
	[Id] ASC
)
INCLUDE ( [HardLevel],
[QtId],
[ContentText],
[AnswerText],
[AnalysisText],
[CreateTime],
[LastUpdateTime],
[ContentLength],
[AnswerLength],
[AnalysisLength])
GO
CREATE NONCLUSTERED INDEX [IDX_Question_LastUpdateTime] ON [dbo].[Question] 
(
	[LastUpdateTime] DESC
)
INCLUDE ( [Id],
[FolderId])
GO
CREATE NONCLUSTERED INDEX [IDX_Question_QuestionCreateType] ON [dbo].[Question]
(
	[QuestionCreateType] ASC	
)
GO

PRINT '------ 试题包导入历史 ------'
CREATE TABLE [dbo].[QuesPackageImportHistory](
	[Id]						INT IDENTITY(1,1) PRIMARY KEY  NOT NULL,			-- 唯一标识
	[QuesPackageGuid]			NVARCHAR(50) NOT NULL,								-- 试题包Guid
	[DeptId]					INT NOT NULL,										-- 部门ID
	[ImporterId]				INT NOT NULL,										-- 导入人员编号
	[ImporterName]				NVARCHAR(50) NOT NULL,								-- 人员名称
	[ImportTime]				DATETIME NOT NULL,									-- 导入时间
)
GO

PRINT '------ 试题与知识结构关系 ------'
CREATE TABLE [dbo].[QuestionInMFolder](
	[Id]				INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[QuestionId]		INT NOT NULL DEFAULT(0),										--试题ID
	[ProCategoryId]		INT NOT NULL DEFAULT(0),										--职岗类型ID
	[MFolderId]			INT NOT NULL DEFAULT(0),										--知识结构文件夹ID
	[ModuleId]			INT NOT NULL DEFAULT(0)										--模块ID
)
GO
ALTER TABLE [QuestionInMFolder] WITH CHECK ADD
	CONSTRAINT [FK_QuestionId_QuestionInMFolder] FOREIGN KEY([QuestionId]) REFERENCES [Question]([Id])
GO

