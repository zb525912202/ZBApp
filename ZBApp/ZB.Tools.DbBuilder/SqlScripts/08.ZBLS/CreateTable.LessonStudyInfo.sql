USE [$(DatabaseName)]
GO
BEGIN TRANSACTION

PRINT'--课程完成情况表'
CREATE TABLE [dbo].[LessonPassInfo](
	[Id]								INT IDENTITY(1,1) PRIMARY KEY  NOT NULL,			--唯一标识
	[EmployeeId]						INT NOT NULL,										--人员Id
	[LessonId]							INT NOT NULL,										--课程Id	
	[LessonStartTime]					DATETIME NOT NULL,									--课程开始学习时间
	[LessonPassTime]					DATETIME,											--课程达标时间
)
GO
ALTER TABLE [LessonPassInfo]  WITH CHECK ADD 	 
	CONSTRAINT [FK_LessonPassInfo_Lesson] FOREIGN KEY([LessonId]) REFERENCES [Lesson] ([Id])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_LessonPassInfo_EmployeeId_LessonId] ON [dbo].[LessonPassInfo] 
(	
	[EmployeeId] ASC,
	[LessonId] ASC
)
GO


PRINT '-------课程考试人员表------------'
CREATE TABLE [dbo].[LessonExaminee](
	[Id]					INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[EmployeeId]			INT NOT NULL,									--人员Id
	[LessonId]				INT NOT NULL,									--课程Id	
	[ReportDate]			DATETIME NOT NULL,								--报名时间		
	[AuditStatus]			BIT NOT NULL,									--审核状态
	[IsPass]				BIT NULL,										--是否通过	
)
GO

ALTER TABLE [LessonExaminee]  WITH CHECK ADD  
	CONSTRAINT [FK_LessonExaminee_Lesson] FOREIGN KEY([LessonId]) REFERENCES [Lesson] ([Id])
GO

PRINT '------课程考试考生试卷------'
CREATE TABLE [dbo].[LessonWebExamineePaper](
	[Id]							INT PRIMARY KEY NOT NULL,				
	[LessonId]						INT NOT NULL,										-- 课程ID
	[LessonExamineeId]				INT NOT NULL,										-- 考生Id
	[WebExamTotalScore]				DECIMAL(18,1) NOT NULL DEFAULT 0,					-- 考试试卷总分
	[PaperPackageId]				INT NOT NULL,										-- 试卷包ID
	[ObjectName]					NVARCHAR(50) NOT NULL,								-- 试卷名称
	[PaperScore]					DECIMAL(18,1) NOT NULL DEFAULT ((0)),				-- 试卷总分
	[PaperQuesCount]				INT NOT NULL DEFAULT ((0)),							-- 试卷题量
	[IsRandomPaper]					BIT NOT NULL DEFAULT 0,								-- 是否随机卷
	[CreateTime]					DATETIME NOT NULL,									-- 创建时间
	[JoinTime]						DATETIME NULL,										-- 进入考场时间
	[SubmitTime]					DATETIME NULL,										-- 交卷时间
	[ReplyTimeSpan]					INT NOT NULL,										-- 答题时长(秒)
	[PaperReplyState]				INT NOT NULL DEFAULT 0,								-- 考生答卷状态(未交卷、已交卷、缺考、作弊)
	[Score]							DECIMAL(18,1) NOT NULL DEFAULT 0,					-- 得分
	[AddedScore]					DECIMAL(18,1) NOT NULL,								-- 加分
	[OfflineScore]					DECIMAL(18,1),										-- 线下考试得分
	[CloseTime]						DATETIME,											-- (个人)考试结束时间
)

ALTER TABLE [LessonWebExamineePaper]  WITH CHECK ADD  
	CONSTRAINT [FK_LessonWebExamineePaper_Lesson] FOREIGN KEY([LessonId]) REFERENCES [Lesson] ([Id]),
	CONSTRAINT [FK_LessonWebExamineePaper_LessonExaminee] FOREIGN KEY([LessonExamineeId]) REFERENCES [LessonExaminee] ([Id])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_LessonWebExamineePaper_LessonExamineeId] ON [dbo].[LessonWebExamineePaper] 
(
	[LessonExamineeId] ASC
) ON [PRIMARY]
GO

PRINT '------课程考试考生试卷详细------'
CREATE TABLE [dbo].[LessonExamineePaperDetail](
	[Id]							INT PRIMARY KEY NOT NULL,		
	[LessonId]						INT NOT NULL,										-- 课程ID
	[PaperId]						INT NOT NULL,										-- 试卷Id	
	[QtId]							INT NOT NULL,										-- 题型ID		
	[PaperPackageQuestionId]		INT NOT NULL,										-- 网络考试试卷包试题ID
	[IsImpersonal]					BIT NOT NULL,										-- 是否客观题	
	[TotalScore]					DECIMAL(18,1) NOT NULL,								-- 满分
	[ReplyText]						NVARCHAR(MAX) NOT NULL DEFAULT '',					-- 考生试题作答		
	[Reply]							VARBINARY(MAX) NULL,								-- 考生试题作答(RTF)
	[Score]							DECIMAL(18,1) NOT NULL DEFAULT 0,					-- 得分
	[IsAudit]						BIT	NOT NULL DEFAULT 0,								-- 是否已阅		
	[IsDoubt]						BIT	NOT NULL DEFAULT 0,								-- 是否质疑	
	[IsMark]						BIT	NOT NULL DEFAULT 0,								-- 是否标记	
	[MarkContent]					NVARCHAR(200) NULL DEFAULT '',						-- 标记文本
	[GradeContent]					NVARCHAR(200) NULL DEFAULT '',						-- 阅卷评语
	[GraderId]						INT NOT NULL,										--阅卷人Id
	[GraderName]					NVARCHAR(50) NOT NULL DEFAULT '',					--阅卷人名称
	[IsLook]						BIT	NOT NULL DEFAULT 0,								-- 是否看过	
)
ALTER TABLE [LessonExamineePaperDetail]  WITH CHECK ADD  
	CONSTRAINT [FK_LessonExamineePaperDetail_Lesson] FOREIGN KEY([LessonId]) REFERENCES [Lesson] ([Id]),
	CONSTRAINT [FK_LessonExamineePaperDetail_LessonWebExamineePaper] FOREIGN KEY([PaperId]) REFERENCES [LessonWebExamineePaper] ([Id])
GO

CREATE UNIQUE NONCLUSTERED INDEX [IDX_LessonExamineePaperDetail_PaperIdPaperPackageQuestionId] ON [dbo].[LessonExamineePaperDetail] 
(
	[PaperId] ASC,
	[PaperPackageQuestionId] ASC
) ON [PRIMARY]
GO


PRINT'--课程测验情况表(本表可支持导入测验数据，导入数据的PaperPackageId为空)'
CREATE TABLE [dbo].[LessonTestInfo](
	[Id]								INT IDENTITY(1,1) PRIMARY KEY  NOT NULL,			-- 唯一标识
	[EmployeeId]						INT NOT NULL,										-- 人员Id
	[LessonId]							INT NOT NULL,										-- 课程Id	
	[PaperPackageId]					INT NOT NULL,											
	[Score]								DECIMAL(18,1) NOT NULL,								-- 得分
	[PassScore]							INT,												-- 通过分
	[PaperScore]						DECIMAL(18,1) NOT NULL,								-- 试卷总分
	[PaperQuesCount]					INT NOT NULL,										-- 试卷题量
	[IsPassed]							BIT NOT NULL,										-- 是否通过
	[StartTime]							DateTime NOT NULL,									-- 开始时间
	[SubmitTime]						DateTime NOT NULL,									-- 交卷时间
)
GO
ALTER TABLE [LessonTestInfo]  WITH CHECK ADD
	CONSTRAINT [FK_LessonTestInfo_Lesson] FOREIGN KEY([LessonId]) REFERENCES [Lesson] ([Id]),
	CONSTRAINT [FK_LessonTestInfo_LessonPaperPackage] FOREIGN KEY([PaperPackageId]) REFERENCES [LessonPaperPackage] ([Id])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_LessonTestInfo_EmployeeId_LessonId_SubmitTime] ON [dbo].[LessonTestInfo] 
(	
	[EmployeeId] ASC,
	[LessonId] ASC,
	[SubmitTime] ASC
)
GO

PRINT '---------课程考试情况表---------------------'

PRINT'--章节完成情况表'
CREATE TABLE [dbo].[ChapterPassInfo](
	[Id]								INT IDENTITY(1,1) PRIMARY KEY  NOT NULL,			--唯一标识
	[EmployeeId]						INT NOT NULL,										--人员Id
	[LessonId]							INT NOT NULL,										-- 课程Id
	[ChapterId]							INT NOT NULL,										--章节Id	
	[ChapterPassTime]					DATETIME NOT NULL,									--章节达标时间
)
GO
ALTER TABLE [ChapterPassInfo]  WITH CHECK ADD
	CONSTRAINT [FK_ChapterPassInfo_Lesson] FOREIGN KEY([LessonId]) REFERENCES [Lesson] ([Id]),
	CONSTRAINT [FK_ChapterPassInfo_Chapter] FOREIGN KEY([ChapterId]) REFERENCES [Chapter] ([Id])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_ChapterPassInfo_EmployeeId_ChapterId] ON [dbo].[ChapterPassInfo] 
(	
	[EmployeeId] ASC,
	[ChapterId] ASC
)
GO

PRINT'--章节测验情况表'
CREATE TABLE [dbo].[ChapterTestInfo](
	[Id]								INT IDENTITY(1,1) PRIMARY KEY  NOT NULL,			--唯一标识
	[EmployeeId]						INT NOT NULL,										--人员Id
	[LessonId]							INT NOT NULL,										-- 课程Id
	[ChapterId]							INT NOT NULL,										--章节Id		
	[PaperPackageId]					INT NOT NULL,											
	[Score]								DECIMAL(18,1) NOT NULL,								-- 得分
	[PassScore]							INT,												-- 通过分
	[PaperScore]						DECIMAL(18,1) NOT NULL,								-- 试卷总分
	[PaperQuesCount]					INT NOT NULL,										-- 试卷题量
	[IsPassed]							BIT NOT NULL,										-- 是否通过
	[StartTime]							DateTime NOT NULL,									-- 开始时间
	[SubmitTime]						DateTime NOT NULL,									-- 交卷时间
)
GO
ALTER TABLE [ChapterTestInfo]  WITH CHECK ADD  
	CONSTRAINT [FK_ChapterTestInfo_Lesson] FOREIGN KEY([LessonId]) REFERENCES [Lesson] ([Id]),
	CONSTRAINT [FK_ChapterTestInfo_Chapter] FOREIGN KEY([ChapterId]) REFERENCES [Chapter] ([Id]),
	CONSTRAINT [FK_ChapterTestInfo_ChapterPaperPackage] FOREIGN KEY([PaperPackageId]) REFERENCES [ChapterPaperPackage] ([Id])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_ChapterTestInfo_EmployeeId_ChapterId_TestPassTime] ON [dbo].[ChapterTestInfo] 
(	
	[EmployeeId] ASC,
	[ChapterId] ASC,
	[SubmitTime] ASC
)
GO




PRINT'--模块完成情况表'
CREATE TABLE [dbo].[SectionPassInfo](
	[Id]								INT IDENTITY(1,1) PRIMARY KEY  NOT NULL,			--唯一标识
	[EmployeeId]						INT NOT NULL,										--人员Id
	[LessonId]							INT NOT NULL,										-- 课程Id
	[SectionId]							INT NOT NULL,										--模块Id	
	[SectionPassTime]					DATETIME NOT NULL,									--模块达标时间
)
GO
ALTER TABLE [SectionPassInfo]  WITH CHECK ADD  
	CONSTRAINT [FK_SectionPassInfo_Lesson] FOREIGN KEY([LessonId]) REFERENCES [Lesson] ([Id]),
	CONSTRAINT [FK_SectionPassInfo_Section] FOREIGN KEY([SectionId]) REFERENCES [Section] ([Id])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_SectionPassInfo_EmployeeId_SectionId] ON [dbo].[SectionPassInfo] 
(	
	[EmployeeId] ASC,
	[SectionId] ASC
)
GO

PRINT'--模块测验完成情况表'
CREATE TABLE [dbo].[SectionTestInfo](
	[Id]								INT IDENTITY(1,1) PRIMARY KEY  NOT NULL,			--唯一标识
	[EmployeeId]						INT NOT NULL,										--人员Id
	[LessonId]							INT NOT NULL,										-- 课程Id
	[SectionId]							INT NOT NULL,										--模块Id			
	[PaperPackageId]					INT NOT NULL,											
	[Score]								DECIMAL(18,1) NOT NULL,								-- 得分
	[PassScore]							INT,												-- 通过分
	[PaperScore]						DECIMAL(18,1) NOT NULL,								-- 试卷总分
	[PaperQuesCount]					INT NOT NULL,										-- 试卷题量
	[IsPassed]							BIT NOT NULL,										-- 是否通过
	[StartTime]							DateTime NOT NULL,									-- 开始时间
	[SubmitTime]						DateTime NOT NULL,									-- 交卷时间
)
GO
ALTER TABLE [SectionTestInfo]  WITH CHECK ADD  
	CONSTRAINT [FK_SectionTestInfo_Lesson] FOREIGN KEY([LessonId]) REFERENCES [Lesson] ([Id]),
	CONSTRAINT [FK_SectionTestInfo_Section] FOREIGN KEY([SectionId]) REFERENCES [Section] ([Id]),
	CONSTRAINT [FK_SectionTestInfo_SectionPaperPackage] FOREIGN KEY([PaperPackageId]) REFERENCES [SectionPaperPackage] ([Id])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_SectionTestInfo_EmployeeId_SectionId_SubmitTime] ON [dbo].[SectionTestInfo] 
(	
	[EmployeeId] ASC,
	[SectionId] ASC,
	[SubmitTime] ASC
)
GO

PRINT'--模块媒体达标情况表'
CREATE TABLE [dbo].[SectionFileStudyDetail](
	[Id]								INT IDENTITY(1,1) PRIMARY KEY,
	[EmployeeId]						INT NOT NULL,										-- 人员Id
	[LessonId]							INT NOT NULL,										-- 课程Id
	[SectionId]							INT NOT NULL,										-- 模块Id	
	[SectionFileId]						INT NOT NULL,										-- 媒体必修项Id
	[StudyTimeSpan]						INT NOT NULL,										-- 有效学习时长(秒)	
)
ALTER TABLE [SectionFileStudyDetail]  WITH CHECK ADD  
	CONSTRAINT [FK_SectionFileStudyDetail_Lesson] FOREIGN KEY([LessonId]) REFERENCES [Lesson] ([Id]),
	CONSTRAINT [FK_SectionFileStudyDetail_Section] FOREIGN KEY([SectionId]) REFERENCES [Section] ([Id]),
	CONSTRAINT [FK_SectionFileStudyDetail_SectionFile] FOREIGN KEY([SectionFileId]) REFERENCES SectionFile ([Id])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_SectionFileStudyDetail_EmployeeId_SectionFileId] ON [dbo].[SectionFileStudyDetail] 
(
	[EmployeeId] ASC,
	[SectionFileId] ASC
)
GO

PRINT'--模块试题达标情况表'
CREATE TABLE [dbo].[SectionQuesStudyDetail](
	[Id]								INT IDENTITY(1,1) PRIMARY KEY,
	[EmployeeId]						INT NOT NULL,										-- 人员Id
	[LessonId]							INT NOT NULL,										-- 课程Id
	[SectionId]							INT NOT NULL,										-- 模块Id
	[SectionQFolderId]					INT NOT NULL,										-- 模块试题文件夹Id	
	[StudyTimeSpan]						INT NOT NULL,										-- 有效学习时长(秒)
	[RightCount]						INT NOT NULL,										-- 做对题量
	[WrongCount]						INT NOT NULL,										-- 做错题量
	[SubmitCount]						INT NOT NULL,										-- 提交答卷次数
)
ALTER TABLE [SectionQuesStudyDetail]  WITH CHECK ADD  
	CONSTRAINT [FK_SectionQuesStudyDetail_Lesson] FOREIGN KEY([LessonId]) REFERENCES [Lesson] ([Id]),
	CONSTRAINT [FK_SectionQuesStudyDetail_Section] FOREIGN KEY([SectionId]) REFERENCES [Section] ([Id]),
	CONSTRAINT [FK_SectionQuesStudyDetail_SectionQFolder] FOREIGN KEY([SectionQFolderId]) REFERENCES [SectionQFolder] ([Id])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_SectionQuesStudyDetail_EmployeeId_SectionQFolderId] ON [dbo].[SectionQuesStudyDetail] 
(
	[EmployeeId] ASC,
	[SectionQFolderId] ASC
)
GO

PRINT'--模块试题答案记录表'
CREATE TABLE [dbo].[SectionQuesAnswerHistory](
	[Id]								INT IDENTITY(1,1) PRIMARY KEY,
	[EmployeeId]						INT NOT NULL,										-- 人员Id
	[LessonId]							INT NOT NULL,										-- 课程Id
	[SectionId]							INT NOT NULL,										-- 模块Id
	[SectionQFolderId]					INT NOT NULL,										-- 模块试题文件夹Id	
	[SectionQuesId]						INT NOT NULL,										-- 试题Id
	[AnswerText]						NVARCHAR(MAX) NULL,									-- 试题答案
	[Answer]							VARBINARY(MAX) NULL,								-- 试题答案Rtf
)
ALTER TABLE [SectionQuesAnswerHistory]  WITH CHECK ADD  
	CONSTRAINT [FK_SectionQuesAnswerHistory_Lesson] FOREIGN KEY([LessonId]) REFERENCES [Lesson] ([Id]),
	CONSTRAINT [FK_SectionQuesAnswerHistory_Section] FOREIGN KEY([SectionId]) REFERENCES [Section] ([Id]),
	CONSTRAINT [FK_SectionQuesAnswerHistory_SectionQFolder] FOREIGN KEY([SectionQFolderId]) REFERENCES [SectionQFolder] ([Id]),
	CONSTRAINT [FK_SectionQuesAnswerHistory_SectionQues] FOREIGN KEY([SectionQuesId]) REFERENCES [SectionQues] ([Id])
GO
CREATE NONCLUSTERED INDEX [IDX_SectionQuesAnswerHistory_EmployeeId_SectionQFolderId] ON [dbo].[SectionQuesAnswerHistory] 
(
	[EmployeeId] ASC,
	[SectionQFolderId] ASC
)
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_SectionQuesAnswerHistory_EmployeeId_SectionQuesId] ON [dbo].[SectionQuesAnswerHistory] 
(
	[EmployeeId] ASC,
	[SectionQuesId] ASC
)
GO

PRINT'--模块试卷学习达标情况表'
CREATE TABLE [dbo].[SectionPaperOpenStudyDetail](
	[Id]								INT IDENTITY(1,1) PRIMARY KEY,
	[EmployeeId]						INT NOT NULL,										-- 人员Id
	[LessonId]							INT NOT NULL,										-- 课程Id
	[SectionId]							INT NOT NULL,										-- 模块Id
	[PaperPackageId]					INT NOT NULL,										
	[StudyTimeSpan]						INT NOT NULL,										-- 有效学习时长(秒)	
)
ALTER TABLE [SectionPaperOpenStudyDetail]  WITH CHECK ADD  
	CONSTRAINT [FK_SectionPaperOpenStudyDetail_Lesson] FOREIGN KEY([LessonId]) REFERENCES [Lesson] ([Id]),
	CONSTRAINT [FK_SectionPaperOpenStudyDetail_Section] FOREIGN KEY([SectionId]) REFERENCES [Section] ([Id]),
	CONSTRAINT [FK_SectionPaperOpenStudyDetail_SectionPractisePaperPackage] FOREIGN KEY([PaperPackageId]) REFERENCES [SectionPractisePaperPackage] ([Id])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_SectionPaperOpenStudyDetail_EmployeeId_PaperPackageId] ON [dbo].[SectionPaperOpenStudyDetail] 
(
	[EmployeeId] ASC,
	[PaperPackageId] ASC
)
GO


PRINT'--模块试卷练习达标情况表'
CREATE TABLE [dbo].[SectionPaperCloseStudyDetail](
	[Id]								INT IDENTITY(1,1) PRIMARY KEY,
	[EmployeeId]						INT NOT NULL,										-- 人员Id
	[LessonId]							INT NOT NULL,										-- 课程Id
	[SectionId]							INT NOT NULL,										-- 模块Id
	[PaperPackageId]					INT NOT NULL,											
	[Score]								DECIMAL(18,1) NOT NULL,								-- 得分
	[PassScore]							INT,												-- 通过分
	[PaperScore]						DECIMAL(18,1) NOT NULL,								-- 试卷总分
	[PaperQuesCount]					INT NOT NULL,										-- 试卷题量
	[IsPassed]							BIT NOT NULL,										-- 是否通过
	[SubmitTime]						DateTime NOT NULL,									-- 交卷时间
)
ALTER TABLE [SectionPaperCloseStudyDetail]  WITH CHECK ADD  
	CONSTRAINT [FK_SectionPaperCloseStudyDetail_Lesson] FOREIGN KEY([LessonId]) REFERENCES [Lesson] ([Id]),
	CONSTRAINT [FK_SectionPaperCloseStudyDetail_Section] FOREIGN KEY([SectionId]) REFERENCES [Section] ([Id]),
	CONSTRAINT [FK_SectionPaperCloseStudyDetail_SectionPractisePaperPackage] FOREIGN KEY([PaperPackageId]) REFERENCES SectionPractisePaperPackage ([Id])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_SectionPaperCloseStudyDetail_EmployeeId_PaperPackageId_SubmitTime] ON [dbo].[SectionPaperCloseStudyDetail] 
(
	[EmployeeId] ASC,
	[PaperPackageId] ASC,
	[SubmitTime] ASC
)
GO

PRINT'--模块试题学习位置表'
CREATE TABLE [dbo].[SectionQuesStudyPosition]
(
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,
	[EmployeeId]			INT NOT NULL,									--人员Id
	[LessonId]				INT NOT NULL,									-- 课程Id
	[SectionId]				INT NOT NULL,									-- 模块Id
	[StudyMode]				INT NOT NULL,									--学习模式
	[SectionQFolderId]		INT NOT NULL,									--试题文件夹Id
	[QtId]					INT NOT NULL,									--题型Id，等于-1就是全部题型
	[SectionQuesId]			INT NOT NULL,									--试题Id
)
ALTER TABLE [SectionQuesStudyPosition]  WITH CHECK ADD  
	CONSTRAINT [FK_SectionQuesStudyPosition_Lesson] FOREIGN KEY([LessonId]) REFERENCES [Lesson] ([Id]),
	CONSTRAINT [FK_SectionQuesStudyPosition_Section] FOREIGN KEY([SectionId]) REFERENCES [Section] ([Id])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_SectionQuesStudyPosition_EmployeeId_StudyMode_SectionQFolderId] ON [dbo].[SectionQuesStudyPosition] 
(
	[EmployeeId] ASC,
	[StudyMode] ASC,
	[SectionQFolderId] ASC
)
GO
COMMIT TRANSACTION