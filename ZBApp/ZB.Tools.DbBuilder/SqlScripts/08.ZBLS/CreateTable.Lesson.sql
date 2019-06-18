USE [$(DatabaseName)]
GO
BEGIN TRANSACTION

PRINT '------ 课程文件夹 ------'
CREATE TABLE [dbo].[LFolder](
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
CREATE UNIQUE NONCLUSTERED INDEX [IDX_LFolder_DeptIdFullPath] ON [dbo].[LFolder] 
(
	[DeptId] ASC,
	[FullPath] ASC
)
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_LFolder_DeptId_ParentId_ObjectName] ON [dbo].[LFolder] 
(
	[DeptId] ASC,
	[ParentId] ASC,
	[ObjectName] ASC
)
GO

PRINT '------ 课程文件夹共享 ------'
CREATE TABLE [dbo].[LFolderShare](
	[Id]				INT PRIMARY KEY NOT NULL,							-- 唯一标识
	[FolderId]			INT NOT NULL,										-- 文件夹Id
	[SharedType]		INT NOT NULL,										-- 共享类型(0:所有人, 1:所有部门, 2:人员, 3:部门， 4:岗位)
	[SharedId]			INT NOT NULL,										-- 共享ID(人员ID,部门ID,岗位ID)
	[SharedName]		NVARCHAR(320) NOT NULL,								-- 共享名称(冗余)
	[SharedMode]		INT NOT NULL DEFAULT(0),								-- 共享模式(0:只读，1:读写)
	[AllowStudy]		BIT NOT NULL DEFAULT(0),									-- 是否允许学习
	[IsIncludeSubDept]	BIT NOT NULL DEFAULT(0)										-- 是否包含子部门
)
GO
ALTER TABLE [LFolderShare]  WITH CHECK ADD  
	CONSTRAINT [FK_LFolderShare_QFolder] FOREIGN KEY([FolderId]) REFERENCES [LFolder] ([Id])
GO

PRINT '------ 课程 ------'
CREATE TABLE [dbo].[Lesson](
	[Id]							INT PRIMARY KEY  NOT NULL,							-- 唯一标识
	[FolderId]						INT NOT NULL,										-- 文件夹ID
	[ObjectName]					NVARCHAR(50) NOT NULL,								-- 课程名称	
	[HardRate]						INT NOT NULL,										-- 难度系数
	[LessonType]					INT NOT NULL,										-- 课程类型(单章节1、多章节2)
	[LessonState]					INT NOT NULL,										-- 课程状态(开启、暂停)
	[AuthorSummary]					NVARCHAR(1000) NOT NULL,							-- 作者简介
	[LessonSummary]					NVARCHAR(1000) NOT NULL,							-- 课程简介

	[MustPassTest]					BIT NOT NULL,										-- 必须通过测验
	[OnlyPassTest]					BIT NOT NULL,										-- 测验达标本课程达标
	[TestMinutes]					INT NOT NULL,										-- 测验时长(分钟)
	[PassTestCount]					INT NOT NULL,										-- 最少通过测验次数
	[PassTestScore]					INT NOT NULL,										-- 测验合格分

	[CreatorId]						INT NOT NULL,										-- 创建人Id
	[CreatorName]					NVARCHAR(50) NOT NULL,								-- 创建人姓名	
	[CreateTime]					DATETIME NOT NULL,									-- 创建时间
	[LastUpdateTime]				DATETIME NOT NULL,									-- 最后一次修改时间

	[StandardId]					INT,												--标准ID						
	[LevelId]						INT													--标准级别

)
GO
ALTER TABLE [Lesson]  WITH CHECK ADD  
	CONSTRAINT [FK_Lesson_LFolder] FOREIGN KEY([FolderId]) REFERENCES [LFolder] ([Id])
GO

/*同一个标准,同一个级别只能有一个培训课程*/
CREATE UNIQUE NONCLUSTERED INDEX [IDX_LessionId_StandardId_LevelId] ON [dbo].[Lesson] 
(
	[Id]		ASC,
	[StandardId] ASC,
	[LevelId] ASC
)
GO


PRINT '-----------------课程人员---------------------------'
CREATE TABLE [dbo].[LessionTrainee](
	[Id]							INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[LessionId]						INT NOT NULL,										--课程ID
	[EmployeeId]					INT NOT NULL,										--人员Id
	[EmployeeNO]					NVARCHAR(50) NOT NULL,								--考号
	[EmployeeName]					NVARCHAR(50) NOT NULL,								--姓名
	[Age]							INT,												--年龄
	[Sex]							INT NOT NULL,										--性别 0:无 1:男 -1:女
	[DeptId]						INT NOT NULL,										--部门Id		
	[DeptFullPath]					NVARCHAR(260) NOT NULL,								--部门全路径	
	[PostId]						INT NOT NULL,										--岗位Id	
	[PostName]						NVARCHAR(50),										--岗位

	[AuditState]					BIT NOT NULL DEFAULT 0,								--0 待审， 1审核通过
	[StartDate]						DATETIME,											--开始学习时间
	[Period]						INT,												--周期
)
ALTER TABLE [LessionTrainee]  WITH CHECK ADD  
	CONSTRAINT [FK_LessionTrainee_Lession] FOREIGN KEY([LessionId]) REFERENCES [Lesson] ([Id])
GO

CREATE UNIQUE NONCLUSTERED INDEX [IDX_LessionTrainee_LessionId_EmployeeId] ON [dbo].[LessionTrainee] 
(
	[LessionId] ASC,
	[EmployeeId] ASC
)
GO

PRINT '------ 课程测验试卷包 ------'
CREATE TABLE [dbo].[LessonPaperPackage](
	[Id]							INT IDENTITY(1,1) PRIMARY KEY  NOT NULL,			-- 唯一标识
	[IsImpersonal]					BIT NOT NULL,										-- 是否客观卷
	[ObjectName]					NVARCHAR(255) NOT NULL,								-- 试卷包名称
	[LessonId]						INT NOT NULL,										-- 课程Id			
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
)
GO
ALTER TABLE [LessonPaperPackage]  WITH CHECK ADD  
	CONSTRAINT [FK_LessonPaperPackage_Lesson] FOREIGN KEY([LessonId]) REFERENCES [Lesson] ([Id])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_LessonPaperPackage_SectionId] ON [dbo].[LessonPaperPackage] 
(
	[LessonId] ASC
)
GO


PRINT '------ 课程考试试卷包 ------'
CREATE TABLE [dbo].[LessonExamPaperPackage](
	[Id]							INT IDENTITY(1,1) PRIMARY KEY  NOT NULL,			-- 唯一标识
	[IsImpersonal]					BIT NOT NULL,										-- 是否客观卷
	[ObjectName]					NVARCHAR(255) NOT NULL,								-- 试卷包名称
	[LessonId]						INT NOT NULL,										-- 课程Id			
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
	[ExamDuration]					INT NOT NULL,										-- 考试时长
	[ExamPassScore]					DECIMAL(18,1) NOT NULL,								-- 考试通过分
	[IncludeOffline]				BIT NOT NULL,										-- 是否包含线下考试
	[OfflinePassScore]				DECIMAL(18,1),										-- 线下考试合格分
	[IsDelete]						BIT NOT NULL DEFAULT 0,								-- 是否删除
)
GO
ALTER TABLE [LessonExamPaperPackage]  WITH CHECK ADD  
	CONSTRAINT [FK_LessonExamPaperPackage_Lesson] FOREIGN KEY([LessonId]) REFERENCES [Lesson] ([Id])
GO


PRINT '------ 章节 ------'
CREATE TABLE [dbo].[Chapter](
	[Id]							INT PRIMARY KEY  NOT NULL,							-- 唯一标识
	[ObjectName]					NVARCHAR(50) NOT NULL,								-- 课程名称
	[LessonId]						INT NOT NULL,										-- 所在的部门
	[SortIndex]						INT NOT NULL DEFAULT 0,	

	[MustPassTest]					BIT NOT NULL,										-- 必须通过测验
	[OnlyPassTest]					BIT NOT NULL,										-- 测验达标本章节达标
	[TestMinutes]					INT NOT NULL,										-- 测验时长(分钟)
	[PassTestCount]					INT NOT NULL,										-- 最少通过测验次数
	[PassTestScore]					INT NOT NULL,										-- 测验合格分
)
GO
ALTER TABLE [Chapter] WITH CHECK ADD
	CONSTRAINT [FK_Chapter_Lesson] FOREIGN KEY([LessonId]) REFERENCES [Lesson]([Id])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_Chapter_LessonId_ObjectName] ON [dbo].[Chapter] 
(
	[LessonId] ASC,
	[ObjectName] ASC
)
GO


PRINT '------ 章节学习条件 ------'
CREATE TABLE [dbo].[ChapterRely](
	[Id]							INT PRIMARY KEY  NOT NULL,							-- 唯一标识
	[LessonId]						INT NOT NULL,										-- 课程Id		
	[ChapterId]						INT NOT NULL,										-- 章节Id
	[NotRelyChapterId]				INT NOT NULL,										-- 不依赖章节Id
)
GO
ALTER TABLE [ChapterRely] WITH CHECK ADD
	CONSTRAINT [FK_ChapterRely_Lesson] FOREIGN KEY([LessonId]) REFERENCES [Lesson] ([Id]),
	CONSTRAINT [FK_ChapterRely_Chapter] FOREIGN KEY([ChapterId]) REFERENCES [Chapter]([Id])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_ChapterRely_ChapterId_NotRelyChapterId] ON [dbo].[ChapterRely] 
(
	[ChapterId] ASC,
	[NotRelyChapterId] ASC
)
GO

PRINT '------ 章节测验试卷包 ------'
CREATE TABLE [dbo].[ChapterPaperPackage](
	[Id]							INT IDENTITY(1,1) PRIMARY KEY  NOT NULL,			-- 唯一标识
	[IsImpersonal]					BIT NOT NULL,										-- 是否客观卷
	[ObjectName]					NVARCHAR(255) NOT NULL,								-- 试卷包名称
	[LessonId]						INT NOT NULL,										-- 课程Id		
	[ChapterId]						INT NOT NULL,										-- 网络考试Id			
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
ALTER TABLE [ChapterPaperPackage]  WITH CHECK ADD  
	CONSTRAINT [FK_ChapterPaperPackage_Lesson] FOREIGN KEY([LessonId]) REFERENCES [Lesson] ([Id]),
	CONSTRAINT [FK_ChapterPaperPackage_Chapter] FOREIGN KEY([ChapterId]) REFERENCES [Chapter] ([Id])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_ChapterPaperPackage_SectionId] ON [dbo].[ChapterPaperPackage] 
(
	[ChapterId] ASC
)
GO










PRINT '------ 模块 ------'
CREATE TABLE [dbo].[Section](
	[Id]							INT PRIMARY KEY  NOT NULL,							-- 唯一标识
	[ObjectName]					NVARCHAR(50) NOT NULL,								-- 课程名称
	[LessonId]						INT NOT NULL,										
	[ChapterId]						INT NOT NULL,										
	[SortIndex]						INT NOT NULL DEFAULT 0,	

	[IsOpenStudyPass]				BIT NOT NULL,										-- 开卷达标要求
	[IsCloseStudyPass]				BIT NOT NULL,										-- 闭卷达标要求
	[MustPassTest]					BIT NOT NULL,										-- 必须通过测验
	[OnlyPassTest]					BIT NOT NULL,										-- 测验达标本模块达标
	[TestMinutes]					INT NOT NULL,										-- 测验时长(分钟)
	[PassTestCount]					INT NOT NULL,										-- 最少通过测验次数
	[PassTestScore]					INT NOT NULL,										-- 测验合格分
)
GO
ALTER TABLE [Section] WITH CHECK ADD
	CONSTRAINT [FK_Section_Lesson] FOREIGN KEY([LessonId]) REFERENCES [Lesson]([Id]),
	CONSTRAINT [FK_Section_Chapter] FOREIGN KEY([ChapterId]) REFERENCES [Chapter]([Id])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_Section_ChapterId_ObjectName] ON [dbo].[Section] 
(
	[ChapterId] ASC,
	[ObjectName] ASC
)
GO

PRINT '------ 模块学习条件 ------'
CREATE TABLE [dbo].[SectionRely](
	[Id]							INT PRIMARY KEY  NOT NULL,							-- 唯一标识
	[LessonId]						INT NOT NULL,										-- 课程Id		
	[SectionId]						INT NOT NULL,										-- 章节Id
	[NotRelySectionId]				INT NOT NULL,										-- 不依赖章节Id
)
GO
ALTER TABLE [SectionRely] WITH CHECK ADD
	CONSTRAINT [FK_SectionRely_Lesson] FOREIGN KEY([LessonId]) REFERENCES [Lesson] ([Id]),
	CONSTRAINT [FK_SectionRely_Section] FOREIGN KEY([SectionId]) REFERENCES [Section]([Id])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_SectionRely_SectionId_NotRelySectionId] ON [dbo].[SectionRely] 
(
	[SectionId] ASC,
	[NotRelySectionId] ASC
)
GO

PRINT '------ 模块测验试卷包 ------'
CREATE TABLE [dbo].[SectionPaperPackage](
	[Id]							INT IDENTITY(1,1) PRIMARY KEY  NOT NULL,			-- 唯一标识
	[IsImpersonal]					BIT NOT NULL,										-- 是否客观卷
	[ObjectName]					NVARCHAR(255) NOT NULL,								-- 试卷包名称
	[LessonId]						INT NOT NULL,										-- 课程Id
	[SectionId]						INT NOT NULL,										-- 网络考试Id			
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
ALTER TABLE [SectionPaperPackage]  WITH CHECK ADD  
	CONSTRAINT [FK_SectionPaperPackage_Lesson] FOREIGN KEY([LessonId]) REFERENCES [Lesson] ([Id]),
	CONSTRAINT [FK_SectionPaperPackage_Section] FOREIGN KEY([SectionId]) REFERENCES [Section] ([Id])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_SectionPaperPackage_SectionId] ON [dbo].[SectionPaperPackage] 
(
	[SectionId] ASC
)
GO

PRINT'--模块媒体资源表'
CREATE TABLE [dbo].[SectionFile](
	[Id]						INT PRIMARY KEY NOT NULL,							-- 唯一标识
	[ObjectName]				NVARCHAR(255) NOT NULL,								-- 文件名称	
	[SourceName]				NVARCHAR(255) NOT NULL,								-- 原始文件名称	
	[ConvertName]				NVARCHAR(255) NOT NULL,								-- 转换文件名称	
	[SourceId]					INT NOT NULL,										-- 原始资源ID	
	[ParentId]					INT NOT NULL,										-- 【注意：此处为SectionId】
	[FileType]					INT NOT NULL,										-- 文件类型
	[FileTypeExt]				INT NOT NULL,										-- 文件扩展名（后缀名）
	[FileSize]					BIGINT NOT NULL,									-- 文件大小
	[UploadPathIndex]			INT NOT NULL,										-- 文件存放的上传目录索引
	[PreviewCount]				INT NOT NULL DEFAULT ((0)),							-- 缩略图数量
	[ContentLength]				BIGINT NOT NULL,									-- 内容长度(时长、页数)
	[GUID]						NVARCHAR(50) NOT NULL,								-- Guid	
	[Md5]						NVARCHAR(50) NOT NULL,								-- Md5	
	[SortIndex]					INT NOT NULL DEFAULT ((0)),							-- 排序索引
	[StudyTimeSpan]				INT NOT NULL,										-- 学习时长(秒)
	[RecommendCount]			INT NOT NULL DEFAULT ((0)),							-- 推荐次数
	[UnRecommendCount]			INT NOT NULL DEFAULT ((0)),							-- 不推荐次数
	[StudyTimes]				INT NOT NULL DEFAULT ((0)),							-- 学习人次

	[LessonId]					INT NOT NULL,										-- 课程Id
	[IsAFile]					BIT NOT NULL,										-- 是否专辑子文件
	[PassStudyTimeSpan]			INT,												-- 达标要求学习时长(分)

	[SectionContentSortIndex]	INT NOT NULL DEFAULT ((0)),							-- 排序索引
)
ALTER TABLE [SectionFile]  WITH CHECK ADD  
	CONSTRAINT [FK_SectionFile_Lesson] FOREIGN KEY([LessonId]) REFERENCES [Lesson] ([Id]),
	CONSTRAINT [FK_SectionFile_SectionPaperPackage] FOREIGN KEY([ParentId]) REFERENCES [Section] ([Id])
GO


PRINT'--模块试题文件夹表'
CREATE TABLE [dbo].[SectionQFolder](
	[Id]						INT PRIMARY KEY NOT NULL,							-- 唯一标识
	[LessonId]					INT NOT NULL,										-- 课程Id
	[SectionId]					INT NOT NULL,										
	[QFolderId]					INT NOT NULL,										
	[ObjectName]				NVARCHAR(50) NOT NULL,								-- 文件名称（也包括文件夹名称）
	[FullPath]					NVARCHAR(255) NOT NULL,								-- 全路径（文件夹/……/文件）

	[StudyTimeSpan]				INT,												-- 达标要求学习时长(分)
	[RightQuesCount]			INT,												-- 答对题量
	[RightPercent]				DECIMAL(18,2),										-- 正确率

	[SectionContentSortIndex]	INT NOT NULL DEFAULT ((0)),							-- 排序索引
)
ALTER TABLE [SectionQFolder]  WITH CHECK ADD  
	CONSTRAINT [FK_SectionQFolder_Lesson] FOREIGN KEY([LessonId]) REFERENCES [Lesson] ([Id]),
	CONSTRAINT [FK_SectionQFolder_Section] FOREIGN KEY([SectionId]) REFERENCES Section ([Id])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_SectionQFolder_SectionId_QFolderId] ON [dbo].[SectionQFolder] 
(
	[SectionId] ASC,
	[QFolderId] ASC
)
GO

PRINT '------ 模块试题表 ------'
CREATE TABLE [dbo].[SectionQues](
	[Id]						INT IDENTITY(1,1) PRIMARY KEY  NOT NULL,			-- 唯一标识	
	[QuestionId]				INT NOT NULL,										
	[FolderId]					INT NOT NULL,										
	[LessonId]					INT NOT NULL,										-- 课程Id
	[SectionId]					INT NOT NULL,										
	[SectionQFolderId]			INT NOT NULL,										
	[HardLevel]					INT NOT NULL,										-- 难度
	[QtId]						INT NOT NULL,										-- 题型ID
	[ContentText]				NVARCHAR(400) NULL,									-- 试题内容
	[AnswerText]				NVARCHAR(MAX) NULL,									-- 试题答案
	[AnalysisText]				NVARCHAR(MAX) NULL,									-- 试题解析
	[Content]					VARBINARY(MAX) NOT NULL,							-- 试题内容Rtf
	[Answer]					VARBINARY(MAX) NULL,								-- 试题答案Rtf
	[Analysis]					VARBINARY(MAX) NULL,								-- 试题解析Rtf
	[ContentLength]				INT NOT NULL,										-- 试题内容Rtf字节数
	[AnswerLength]				INT NOT NULL,										-- 试题答案Rtf字节数
	[AnalysisLength]			INT NOT NULL,										-- 试题解析Rtf字节数
)
GO
ALTER TABLE [SectionQues]  WITH CHECK ADD  
	CONSTRAINT [FK_SectionQues_Lesson] FOREIGN KEY([LessonId]) REFERENCES [Lesson] ([Id]),
	CONSTRAINT [FK_SectionQues_Section] FOREIGN KEY([SectionId]) REFERENCES [Section] ([Id]),
	CONSTRAINT [FK_SectionQues_SectionQFolder] FOREIGN KEY([SectionQFolderId]) REFERENCES [SectionQFolder] ([Id])
GO

PRINT '------ 模块练习试卷包 ------'
CREATE TABLE [dbo].[SectionPractisePaperPackage](
	[Id]							INT IDENTITY(1,1) PRIMARY KEY  NOT NULL,			-- 唯一标识
	[IsImpersonal]					BIT NOT NULL,										-- 是否客观卷
	[ObjectName]					NVARCHAR(255) NOT NULL,								-- 试卷包名称
	[LessonId]						INT NOT NULL,										-- 课程Id
	[SectionId]						INT NOT NULL,													
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

	[PassScore]						INT,												-- 合格分
	[PassCount]						INT,												-- 合格次数
	[StudyTimeSpan]		     		INT,												-- 达标要求时长

	[SectionContentSortIndex]		INT NOT NULL DEFAULT ((0)),							-- 排序索引
)
GO
ALTER TABLE [SectionPractisePaperPackage]  WITH CHECK ADD
	CONSTRAINT [FK_SectionPractisePaperPackage_Lesson] FOREIGN KEY([LessonId]) REFERENCES [Lesson] ([Id]),
	CONSTRAINT [FK_SectionPractisePaperPackage_Section] FOREIGN KEY([SectionId]) REFERENCES [Section] ([Id])
GO

COMMIT TRANSACTION