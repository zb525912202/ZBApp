USE [$(DatabaseName)]
GO

BEGIN TRANSACTION

PRINT'--网络培训班--'
CREATE TABLE [dbo].[NetClass](
	[Id]							INT IDENTITY(1,1) PRIMARY KEY,
	[ObjectName]					NVARCHAR(50) NOT NULL,								-- 网络培训班名称
	[DeptId]						INT NOT NULL,										-- 部门Id	
	[StartDate]						DATETIME NOT NULL,									-- 开始时间
	[EndDate]						DATETIME NOT NULL,									-- 结束时间
	[CreateTime]					DATETIME NOT NULL,									-- 创建时间
	[CreatorId]						INT NOT NULL,										-- 创建人Id
	[CreatorName]					NVARCHAR(50) NOT NULL,								-- 创建人姓名	
	[NetClassType]					INT NOT NULL,										-- 培训班类型(单章节1、多章节2)
	[NetClassState]					INT NOT NULL,										-- 网络培训班状态(开启、暂停),已废弃
	[ClassState]					INT NOT NULL,										-- 培训班状态(未启动、进行中、已完成)
	[MustPassTest]					BIT NOT NULL,										-- 必须通过测验
	[OnlyPassTest]					BIT NOT NULL,										-- 测验达标本课程达标
	[WorkId]						INT NOT NULL DEFAULT 0,								-- 培训事务ID
)

PRINT'------网络培训班学员表------'
CREATE TABLE [dbo].[NetClassTrainee](
	[Id]							INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[NetClassId]					INT NOT NULL,										--网络培训班ID
	[EmployeeId]					INT NOT NULL,										--人员Id
	[EmployeeNO]					NVARCHAR(50) NOT NULL,								--考号
	[EmployeeName]					NVARCHAR(50) NOT NULL,								--姓名
	[Age]							INT,												--年龄
	[Sex]							INT NOT NULL,										--性别 0:无 1:男 -1:女
	[DeptId]						INT NOT NULL,										--部门Id		
	[DeptFullPath]					NVARCHAR(260) NOT NULL,								--部门全路径	
	[PostId]						INT NOT NULL,										--岗位Id	
	[PostName]						NVARCHAR(50),										--岗位
)
ALTER TABLE [NetClassTrainee]  WITH CHECK ADD  
	CONSTRAINT [FK_NetClassTrainee_NetClass] FOREIGN KEY([NetClassId]) REFERENCES [NetClass] ([Id])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_NetClassTrainee_NetClassId_EmployeeId] ON [dbo].[NetClassTrainee] 
(
	[NetClassId] ASC,
	[EmployeeId] ASC
)
GO

PRINT '------ 网络培训班测验试卷包 ------'
CREATE TABLE [dbo].[NetClassPaperPackage](
	[Id]							INT IDENTITY(1,1) PRIMARY KEY  NOT NULL,			-- 唯一标识
	[IsImpersonal]					BIT NOT NULL,										-- 是否客观卷
	[ObjectName]					NVARCHAR(255) NOT NULL,								-- 试卷包名称
	[NetClassId]					INT NOT NULL,										-- 网络培训班Id	
	[CreatorId]						INT NOT NULL,										-- 创建人Id
	[CreatorName]					NVARCHAR(50) NOT NULL,								-- 创建人Name
	[CreateTime]					DATETIME NOT NULL,									-- 创建时间
	[LastUpdateTime]				DATETIME NOT NULL,									-- 最后一次修改时间
	[HardRate]						DECIMAL(18,1) NOT NULL DEFAULT ((0)),				-- 难度系数
	[Describe]						NVARCHAR(400) NULL,									-- 描述(知识点)
	[PaperPackageQuestionCount]		INT NOT NULL DEFAULT ((0)),							-- 试卷包用题题量
	[IsIncludeSln]					BIT NOT NULL DEFAULT 0,								-- 是否包含组卷方案
	[PaperScore]					DECIMAL(18,1) NOT NULL DEFAULT ((0)),				-- 试卷总分
	[PaperQuesCount]				INT NOT NULL DEFAULT ((0)),							-- 试卷题量
	[IsRandomPaper]					BIT NOT NULL DEFAULT 0,								-- 是否随机卷
	[PaperSolutionObjBytes]			VARBINARY(MAX),										-- 组卷方案	
	[ExportConfig]					VARBINARY(MAX),										-- 课程导出配置

	[TestMinutes]					INT NOT NULL,										-- 测验时长(分钟)
	[PassTestCount]					INT NOT NULL,										-- 最少通过测验次数
	[PassTestScore]					INT NOT NULL,										-- 测验合格分
)
GO
ALTER TABLE [NetClassPaperPackage]  WITH CHECK ADD  
	CONSTRAINT [FK_NetClassPaperPackage_NetClass] FOREIGN KEY([NetClassId]) REFERENCES [NetClass] ([Id])
GO

PRINT '------ 章节 ------'
CREATE TABLE [dbo].[NetClassChapter](
	[Id]							INT PRIMARY KEY  NOT NULL,							-- 唯一标识
	[ObjectName]					NVARCHAR(50) NOT NULL,								-- 课程名称
	[NetClassId]					INT NOT NULL,										-- 所在的网络培训班Id
	[LessonId]						INT NOT NULL,										-- 原始的课程Id
	[SortIndex]						INT NOT NULL DEFAULT 0,	

	[MustPassTest]					BIT NOT NULL,										-- 必须通过测验
	[OnlyPassTest]					BIT NOT NULL,										-- 测验达标本章节达标
	[TestMinutes]					INT NOT NULL,										-- 测验时长(分钟)
	[PassTestCount]					INT NOT NULL,										-- 最少通过测验次数
	[PassTestScore]					INT NOT NULL,										-- 测验合格分
)
GO
ALTER TABLE [NetClassChapter] WITH CHECK ADD
	CONSTRAINT [FK_NetClassChapter_NetClass] FOREIGN KEY([NetClassId]) REFERENCES [NetClass]([Id])
GO

PRINT '------ 章节学习条件 ------'
CREATE TABLE [dbo].[NetClassChapterRely](
	[Id]							INT PRIMARY KEY  NOT NULL,							-- 唯一标识
	[NetClassId]					INT NOT NULL,										-- 课程Id		
	[NetClassChapterId]				INT NOT NULL,										-- 章节Id
	[LessonId]						INT NOT NULL,										-- 原始的课程Id
	[NotRelyNetClassChapterId]		INT NOT NULL,										-- 不依赖章节Id
)
GO
ALTER TABLE [NetClassChapterRely] WITH CHECK ADD
	CONSTRAINT [FK_NetClassChapterRely_NetClass] FOREIGN KEY([NetClassId]) REFERENCES [NetClass] ([Id]),
	CONSTRAINT [FK_NetClassChapterRely_NetClassChapter] FOREIGN KEY([NetClassChapterId]) REFERENCES [NetClassChapter]([Id])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_NetClassChapterRely_NetClassChapterId_NotRelyNetClassChapterId] ON [dbo].[NetClassChapterRely] 
(
	[NetClassChapterId] ASC,
	[NotRelyNetClassChapterId] ASC
)
GO

PRINT '------ 章节测验试卷包 ------'
CREATE TABLE [dbo].[NetClassChapterPaperPackage](
	[Id]							INT IDENTITY(1,1) PRIMARY KEY  NOT NULL,			-- 唯一标识
	[IsImpersonal]					BIT NOT NULL,										-- 是否客观卷
	[ObjectName]					NVARCHAR(255) NOT NULL,								-- 试卷包名称
	[NetClassId]					INT NOT NULL,										-- 课程Id
	[NetClassChapterId]				INT NOT NULL,										-- 网络考试Id
	[LessonId]						INT NOT NULL,										-- 原始的课程Id
	[CreatorId]						INT NOT NULL,										-- 创建人Id
	[CreatorName]					NVARCHAR(50) NOT NULL,								-- 创建人Name
	[CreateTime]					DATETIME NOT NULL,									-- 创建时间
	[LastUpdateTime]				DATETIME NOT NULL,									-- 最后一次修改时间
	[HardRate]						DECIMAL(18,1) NOT NULL DEFAULT ((0)),				-- 难度系数
	[Describe]						NVARCHAR(400) NULL,									-- 描述(知识点)
	[PaperPackageQuestionCount]		INT NOT NULL DEFAULT ((0)),							-- 试卷包用题题量
	[IsIncludeSln]					BIT NOT NULL DEFAULT 0,								-- 是否包含组卷方案
	[PaperScore]					DECIMAL(18,1) NOT NULL DEFAULT ((0)),				-- 试卷总分
	[PaperQuesCount]				INT NOT NULL DEFAULT ((0)),							-- 试卷题量
	[IsRandomPaper]					BIT NOT NULL DEFAULT 0,								-- 是否随机卷
	[PaperSolutionObjBytes]			VARBINARY(MAX),										-- 组卷方案	
	[ExportConfig]					VARBINARY(MAX),										-- 导出配置
)
GO
ALTER TABLE [NetClassChapterPaperPackage]  WITH CHECK ADD  
	CONSTRAINT [FK_NetClassChapterPaperPackage_NetClass] FOREIGN KEY([NetClassId]) REFERENCES [NetClass] ([Id]),
	CONSTRAINT [FK_NetClassChapterPaperPackage_NetClassChapter] FOREIGN KEY([NetClassChapterId]) REFERENCES [NetClassChapter] ([Id])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_NetClassChapterPaperPackage_SectionId] ON [dbo].[NetClassChapterPaperPackage] 
(
	[NetClassChapterId] ASC
)
GO

PRINT '------ 模块 ------'
CREATE TABLE [dbo].[NetClassSection](
	[Id]								INT PRIMARY KEY  NOT NULL,							-- 唯一标识
	[ObjectName]						NVARCHAR(50) NOT NULL,								-- 课程名称
	[NetClassId]						INT NOT NULL,
	[NetClassChapterId]					INT NOT NULL,
	[LessonId]							INT NOT NULL,										-- 原始的课程Id
	[SortIndex]							INT NOT NULL DEFAULT 0,

	[IsOpenStudyPass]					BIT NOT NULL,										-- 开卷达标要求
	[IsCloseStudyPass]					BIT NOT NULL,										-- 闭卷达标要求
	[MustPassTest]						BIT NOT NULL,										-- 必须通过测验
	[OnlyPassTest]						BIT NOT NULL,										-- 测验达标本模块达标
	[TestMinutes]						INT NOT NULL,										-- 测验时长(分钟)
	[PassTestCount]						INT NOT NULL,										-- 最少通过测验次数
	[PassTestScore]						INT NOT NULL,										-- 测验合格分
)
GO
ALTER TABLE [NetClassSection] WITH CHECK ADD
	CONSTRAINT [FK_NetClassSection_NetClass] FOREIGN KEY([NetClassId]) REFERENCES [NetClass]([Id]),
	CONSTRAINT [FK_NetClassSection_NetClassChapter] FOREIGN KEY([NetClassChapterId]) REFERENCES [NetClassChapter]([Id])
GO

PRINT '------ 模块学习条件 ------'
CREATE TABLE [dbo].[NetClassSectionRely](
	[Id]								INT PRIMARY KEY  NOT NULL,							-- 唯一标识
	[NetClassId]						INT NOT NULL,										-- 课程Id
	[NetClassSectionId]					INT NOT NULL,										-- 章节Id
	[NotRelyNetClassSectionId]			INT NOT NULL,										-- 不依赖章节Id
)
GO
ALTER TABLE [NetClassSectionRely] WITH CHECK ADD
	CONSTRAINT [FK_NetClassSectionRely_NetClass] FOREIGN KEY([NetClassId]) REFERENCES [NetClass] ([Id]),
	CONSTRAINT [FK_NetClassSectionRely_NetClassSection] FOREIGN KEY([NetClassSectionId]) REFERENCES [NetClassSection]([Id])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_NetClassSectionRely_NetClassSectionId_NotRelyNetClassSectionId] ON [dbo].[NetClassSectionRely] 
(
	[NetClassSectionId] ASC,
	[NotRelyNetClassSectionId] ASC
)
GO

PRINT '------ 模块测验试卷包 ------'
CREATE TABLE [dbo].[NetClassSectionPaperPackage](
	[Id]								INT IDENTITY(1,1) PRIMARY KEY  NOT NULL,			-- 唯一标识
	[IsImpersonal]						BIT NOT NULL,										-- 是否客观卷
	[ObjectName]						NVARCHAR(255) NOT NULL,								-- 试卷包名称
	[NetClassId]						INT NOT NULL,										-- 网络培训班Id
	[NetClassSectionId]					INT NOT NULL,										-- 网络培训班模块Id			
	[LessonId]							INT NOT NULL,										-- 原始课程Id
	[CreatorId]							INT NOT NULL,										-- 创建人Id
	[CreatorName]						NVARCHAR(50) NOT NULL,								-- 创建人Name
	[CreateTime]						DATETIME NOT NULL,									-- 创建时间
	[LastUpdateTime]					DATETIME NOT NULL,									-- 最后一次修改时间
	[HardRate]							DECIMAL(18,1) NOT NULL DEFAULT ((0)),				-- 难度系数
	[Describe]							NVARCHAR(400) NULL,									-- 描述(知识点)
	[PaperPackageQuestionCount]			INT NOT NULL DEFAULT ((0)),							-- 试卷包用题题量
	[IsIncludeSln]						BIT NOT NULL DEFAULT 0,								-- 是否包含组卷方案
	[PaperScore]						DECIMAL(18,1) NOT NULL DEFAULT ((0)),				-- 试卷总分
	[PaperQuesCount]					INT NOT NULL DEFAULT ((0)),							-- 试卷题量
	[IsRandomPaper]						BIT NOT NULL DEFAULT 0,								-- 是否随机卷
	[PaperSolutionObjBytes]				VARBINARY(MAX),										-- 组卷方案	
	[ExportConfig]						VARBINARY(MAX),										-- 导出配置
)
GO
ALTER TABLE [NetClassSectionPaperPackage]  WITH CHECK ADD  
	CONSTRAINT [FK_NetClassSectionPaperPackage_NetClass] FOREIGN KEY([NetClassId]) REFERENCES [NetClass] ([Id]),
	CONSTRAINT [FK_NetClassSectionPaperPackage_NetClassSection] FOREIGN KEY([NetClassSectionId]) REFERENCES [NetClassSection] ([Id])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_NetClassSectionPaperPackage_NetClassSectionId] ON [dbo].[NetClassSectionPaperPackage] 
(
	[NetClassSectionId] ASC
)
GO

PRINT'--模块媒体资源表'
CREATE TABLE [dbo].[NetClassSectionFile](
	[Id]								INT PRIMARY KEY NOT NULL,							-- 唯一标识
	[ObjectName]						NVARCHAR(255) NOT NULL,								-- 文件名称	
	[SourceName]						NVARCHAR(255) NOT NULL,								-- 原始文件名称	
	[ConvertName]						NVARCHAR(255) NOT NULL,								-- 转换文件名称	
	[SourceId]							INT NOT NULL,										-- 原始资源ID	
	[ParentId]							INT NOT NULL,										-- 【注意：此处为NetClassSectionId】
	[FileType]							INT NOT NULL,										-- 文件类型
	[FileTypeExt]						INT NOT NULL,										-- 文件扩展名（后缀名）
	[FileSize]							BIGINT NOT NULL,									-- 文件大小
	[UploadPathIndex]					INT NOT NULL,										-- 文件存放的上传目录索引
	[PreviewCount]						INT NOT NULL DEFAULT ((0)),							-- 缩略图数量
	[ContentLength]						BIGINT NOT NULL,									-- 内容长度(时长、页数)
	[GUID]								NVARCHAR(50) NOT NULL,								-- Guid	
	[Md5]								NVARCHAR(50) NOT NULL,								-- Md5	
	[SortIndex]							INT NOT NULL DEFAULT ((0)),							-- 排序索引
	[StudyTimeSpan]						INT NOT NULL,										-- 学习时长(秒)
	[RecommendCount]					INT NOT NULL DEFAULT ((0)),							-- 推荐次数
	[UnRecommendCount]					INT NOT NULL DEFAULT ((0)),							-- 不推荐次数
	[StudyTimes]						INT NOT NULL DEFAULT ((0)),							-- 学习人次

	[NetClassId]						INT NOT NULL,										-- 网络培训班Id
	[LessonId]							INT NOT NULL,										-- 原始课程Id
	[IsAFile]							BIT NOT NULL,										-- 是否专辑子文件
	[PassStudyTimeSpan]					INT,												-- 达标要求学习时长(分)

	[NetClassSectionContentSortIndex]	INT NOT NULL DEFAULT ((0)),							-- 排序索引
)
ALTER TABLE [NetClassSectionFile]  WITH CHECK ADD
	CONSTRAINT [FK_NetClassSectionFile_NetClass] FOREIGN KEY([NetClassId]) REFERENCES [NetClass] ([Id]),
	CONSTRAINT [FK_NetClassSectionFile_NetClassSectionPaperPackage] FOREIGN KEY([ParentId]) REFERENCES [NetClassSection] ([Id])
GO


PRINT'--模块试题文件夹表'
CREATE TABLE [dbo].[NetClassSectionQFolder](
	[Id]								INT PRIMARY KEY NOT NULL,							-- 唯一标识
	[NetClassId]						INT NOT NULL,										-- 课程Id
	[NetClassSectionId]					INT NOT NULL,										
	[LessonId]							INT NOT NULL,										-- 原始课程Id
	[QFolderId]							INT NOT NULL,										
	[ObjectName]						NVARCHAR(50) NOT NULL,								-- 文件名称（也包括文件夹名称）
	[FullPath]							NVARCHAR(255) NOT NULL,								-- 全路径（文件夹/……/文件）

	[StudyTimeSpan]						INT,												-- 达标要求学习时长(分)
	[RightQuesCount]					INT,												-- 答对题量
	[RightPercent]						DECIMAL(18,2),										-- 正确率

	[NetClassSectionContentSortIndex]	INT NOT NULL DEFAULT ((0)),							-- 排序索引
)
ALTER TABLE [NetClassSectionQFolder]  WITH CHECK ADD  
	CONSTRAINT [FK_NetClassSectionQFolder_NetClass] FOREIGN KEY([NetClassId]) REFERENCES [NetClass] ([Id]),
	CONSTRAINT [FK_NetClassSectionQFolder_NetClassSection] FOREIGN KEY([NetClassSectionId]) REFERENCES NetClassSection ([Id])
GO


PRINT '------ 模块试题表 ------'
CREATE TABLE [dbo].[NetClassSectionQues](
	[Id]								INT IDENTITY(1,1) PRIMARY KEY  NOT NULL,			-- 唯一标识	
	[QuestionId]				        INT NOT NULL,										
	[FolderId]							INT NOT NULL,										
	[NetClassId]						INT NOT NULL,										-- 课程Id
	[NetClassSectionId]					INT NOT NULL,										
	[NetClassSectionQFolderId]			INT NOT NULL,										
	[HardLevel]							INT NOT NULL,										-- 难度
	[QtId]								INT NOT NULL,										-- 题型ID
	[ContentText]						NVARCHAR(400) NULL,									-- 试题内容
	[AnswerText]						NVARCHAR(MAX) NULL,									-- 试题答案
	[AnalysisText]						NVARCHAR(MAX) NULL,									-- 试题解析
	[Content]							VARBINARY(MAX) NOT NULL,							-- 试题内容Rtf
	[Answer]							VARBINARY(MAX) NULL,								-- 试题答案Rtf
	[Analysis]							VARBINARY(MAX) NULL,								-- 试题解析Rtf
	[ContentLength]						INT NOT NULL,										-- 试题内容Rtf字节数
	[AnswerLength]						INT NOT NULL,										-- 试题答案Rtf字节数
	[AnalysisLength]					INT NOT NULL,										-- 试题解析Rtf字节数
)
GO
ALTER TABLE [NetClassSectionQues]  WITH CHECK ADD  
	CONSTRAINT [FK_NetClassSectionQues_NetClass] FOREIGN KEY([NetClassId]) REFERENCES [NetClass] ([Id]),
	CONSTRAINT [FK_NetClassSectionQues_NetClassSection] FOREIGN KEY([NetClassSectionId]) REFERENCES [NetClassSection] ([Id]),
	CONSTRAINT [FK_NetClassSectionQues_NetClassSectionQFolder] FOREIGN KEY([NetClassSectionQFolderId]) REFERENCES [NetClassSectionQFolder] ([Id])
GO

PRINT '------ 模块练习试卷包 ------'
CREATE TABLE [dbo].[NetClassSectionPractisePaperPackage](
	[Id]									INT IDENTITY(1,1) PRIMARY KEY  NOT NULL,			-- 唯一标识
	[IsImpersonal]							BIT NOT NULL,										-- 是否客观卷
	[ObjectName]							NVARCHAR(255) NOT NULL,								-- 试卷包名称
	[NetClassId]							INT NOT NULL,										-- 课程Id
	[NetClassSectionId]						INT NOT NULL,													
	[LessonId]								INT NOT NULL,										-- 原始课程Id
	[CreatorId]								INT NOT NULL,										-- 创建人Id
	[CreatorName]							NVARCHAR(50) NOT NULL,								-- 创建人Name
	[CreateTime]							DATETIME NOT NULL,									-- 创建时间
	[LastUpdateTime]						DATETIME NOT NULL,									-- 最后一次修改时间
	[HardRate]								DECIMAL(18,1) NOT NULL DEFAULT ((0)),				-- 难度系数
	[Describe]								NVARCHAR(400) NULL,									-- 描述(知识点)
	[PaperPackageQuestionCount]				INT NOT NULL DEFAULT ((0)),							-- 试卷包用题题量
	[IsIncludeSln]							BIT NOT NULL DEFAULT 0,								-- 是否包含组卷方案
	[PaperScore]							DECIMAL(18,1) NOT NULL DEFAULT ((0)),				-- 试卷总分
	[PaperQuesCount]						INT NOT NULL DEFAULT ((0)),							-- 试卷题量
	[IsRandomPaper]							BIT NOT NULL DEFAULT 0,								-- 是否随机卷
	[PaperSolutionObjBytes]					VARBINARY(MAX),										-- 组卷方案	
	[ExportConfig]							VARBINARY(MAX),										-- 导出配置

	[PassScore]								INT,												-- 合格分
	[PassCount]								INT,												-- 合格次数
	[StudyTimeSpan]		     				INT,												-- 达标要求时长

	[NetClassSectionContentSortIndex]		INT NOT NULL DEFAULT ((0)),							-- 排序索引
)
GO
ALTER TABLE [NetClassSectionPractisePaperPackage]  WITH CHECK ADD
	CONSTRAINT [FK_NetClassSectionPractisePaperPackage_NetClass] FOREIGN KEY([NetClassId]) REFERENCES [NetClass] ([Id]),
	CONSTRAINT [FK_NetClassSectionPractisePaperPackage_NetClassSection] FOREIGN KEY([NetClassSectionId]) REFERENCES [NetClassSection] ([Id])
GO

COMMIT TRANSACTION