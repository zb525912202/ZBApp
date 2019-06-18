USE [$(DatabaseName)]
GO
BEGIN TRANSACTION

PRINT'--课程完成情况表'
CREATE TABLE [dbo].[NetClassPassInfo](
	[Id]								INT IDENTITY(1,1) PRIMARY KEY  NOT NULL,			--唯一标识
	[EmployeeId]						INT NOT NULL,										--人员Id
	[NetClassId]						INT NOT NULL,										--课程Id	
	[NetClassStartTime]					DATETIME NOT NULL,									--课程开始学习时间
	[NetClassPassTime]					DATETIME,											--课程达标时间
)
GO
ALTER TABLE [NetClassPassInfo]  WITH CHECK ADD 	 
	CONSTRAINT [FK_NetClassPassInfo_NetClass] FOREIGN KEY([NetClassId]) REFERENCES [NetClass] ([Id])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_NetClassPassInfo_EmployeeId_NetClassId] ON [dbo].[NetClassPassInfo] 
(	
	[EmployeeId] ASC,
	[NetClassId] ASC
)
GO

PRINT'--课程测验情况表'
CREATE TABLE [dbo].[NetClassTestInfo](
	[Id]								INT IDENTITY(1,1) PRIMARY KEY  NOT NULL,			-- 唯一标识
	[EmployeeId]						INT NOT NULL,										-- 人员Id
	[NetClassId]						INT NOT NULL,										-- 课程Id	
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
ALTER TABLE [NetClassTestInfo]  WITH CHECK ADD
	CONSTRAINT [FK_NetClassTestInfo_NetClass] FOREIGN KEY([NetClassId]) REFERENCES [NetClass] ([Id]),
	CONSTRAINT [FK_NetClassTestInfo_NetClassPaperPackage] FOREIGN KEY([PaperPackageId]) REFERENCES [NetClassPaperPackage] ([Id])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_NetClassTestInfo_EmployeeId_NetClassId_SubmitTime] ON [dbo].[NetClassTestInfo] 
(	
	[EmployeeId] ASC,
	[NetClassId] ASC,
	[SubmitTime] ASC
)
GO



PRINT'--章节完成情况表'
CREATE TABLE [dbo].[NetClassChapterPassInfo](
	[Id]								INT IDENTITY(1,1) PRIMARY KEY  NOT NULL,			--唯一标识
	[EmployeeId]						INT NOT NULL,										--人员Id
	[NetClassId]						INT NOT NULL,										-- 课程Id
	[NetClassChapterId]					INT NOT NULL,										--章节Id	
	[NetClassChapterPassTime]			DATETIME NOT NULL,									--章节达标时间
)
GO
ALTER TABLE [NetClassChapterPassInfo]  WITH CHECK ADD
	CONSTRAINT [FK_NetClassChapterPassInfo_NetClass] FOREIGN KEY([NetClassId]) REFERENCES [NetClass] ([Id]),
	CONSTRAINT [FK_NetClassChapterPassInfo_NetClassChapter] FOREIGN KEY([NetClassChapterId]) REFERENCES [NetClassChapter] ([Id])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_NetClassChapterPassInfo_EmployeeId_NetClassChapterId] ON [dbo].[NetClassChapterPassInfo] 
(	
	[EmployeeId] ASC,
	[NetClassChapterId] ASC
)
GO

PRINT'--章节测验情况表'
CREATE TABLE [dbo].[NetClassChapterTestInfo](
	[Id]								INT IDENTITY(1,1) PRIMARY KEY  NOT NULL,			--唯一标识
	[EmployeeId]						INT NOT NULL,										--人员Id
	[NetClassId]						INT NOT NULL,										-- 课程Id
	[NetClassChapterId]					INT NOT NULL,										--章节Id		
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
ALTER TABLE [NetClassChapterTestInfo]  WITH CHECK ADD  
	CONSTRAINT [FK_NetClassChapterTestInfo_NetClass] FOREIGN KEY([NetClassId]) REFERENCES [NetClass] ([Id]),
	CONSTRAINT [FK_NetClassChapterTestInfo_NetClassChapter] FOREIGN KEY([NetClassChapterId]) REFERENCES [NetClassChapter] ([Id]),
	CONSTRAINT [FK_NetClassChapterTestInfo_NetClassChapterPaperPackage] FOREIGN KEY([PaperPackageId]) REFERENCES [NetClassChapterPaperPackage] ([Id])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_NetClassChapterTestInfo_EmployeeId_NetClassChapterId_TestPassTime] ON [dbo].[NetClassChapterTestInfo] 
(	
	[EmployeeId] ASC,
	[NetClassChapterId] ASC,
	[SubmitTime] ASC
)
GO




PRINT'--模块完成情况表'
CREATE TABLE [dbo].[NetClassSectionPassInfo](
	[Id]								INT IDENTITY(1,1) PRIMARY KEY  NOT NULL,			--唯一标识
	[EmployeeId]						INT NOT NULL,										--人员Id
	[NetClassId]						INT NOT NULL,										-- 课程Id
	[NetClassSectionId]					INT NOT NULL,										--模块Id	
	[NetClassSectionPassTime]			DATETIME NOT NULL,									--模块达标时间
)
GO
ALTER TABLE [NetClassSectionPassInfo]  WITH CHECK ADD  
	CONSTRAINT [FK_NetClassSectionPassInfo_NetClass] FOREIGN KEY([NetClassId]) REFERENCES [NetClass] ([Id]),
	CONSTRAINT [FK_NetClassSectionPassInfo_NetClassSection] FOREIGN KEY([NetClassSectionId]) REFERENCES [NetClassSection] ([Id])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_NetClassSectionPassInfo_EmployeeId_NetClassSectionId] ON [dbo].[NetClassSectionPassInfo] 
(	
	[EmployeeId] ASC,
	[NetClassSectionId] ASC
)
GO

PRINT'--模块测验完成情况表'
CREATE TABLE [dbo].[NetClassSectionTestInfo](
	[Id]								INT IDENTITY(1,1) PRIMARY KEY  NOT NULL,			--唯一标识
	[EmployeeId]						INT NOT NULL,										--人员Id
	[NetClassId]						INT NOT NULL,										-- 课程Id
	[NetClassSectionId]					INT NOT NULL,										--模块Id			
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
ALTER TABLE [NetClassSectionTestInfo]  WITH CHECK ADD  
	CONSTRAINT [FK_NetClassSectionTestInfo_NetClass] FOREIGN KEY([NetClassId]) REFERENCES [NetClass] ([Id]),
	CONSTRAINT [FK_NetClassSectionTestInfo_NetClassSection] FOREIGN KEY([NetClassSectionId]) REFERENCES [NetClassSection] ([Id]),
	CONSTRAINT [FK_NetClassSectionTestInfo_NetClassSectionPaperPackage] FOREIGN KEY([PaperPackageId]) REFERENCES [NetClassSectionPaperPackage] ([Id])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_NetClassSectionTestInfo_EmployeeId_NetClassSectionId_SubmitTime] ON [dbo].[NetClassSectionTestInfo] 
(	
	[EmployeeId] ASC,
	[NetClassSectionId] ASC,
	[SubmitTime] ASC
)
GO

PRINT'--模块媒体达标情况表'
CREATE TABLE [dbo].[NetClassSectionFileStudyDetail](
	[Id]								INT IDENTITY(1,1) PRIMARY KEY,
	[EmployeeId]						INT NOT NULL,										-- 人员Id
	[NetClassId]						INT NOT NULL,										-- 课程Id
	[NetClassSectionId]					INT NOT NULL,										-- 模块Id	
	[NetClassSectionFileId]				INT NOT NULL,										-- 媒体必修项Id
	[StudyTimeSpan]						INT NOT NULL,										-- 有效学习时长(秒)	
)
ALTER TABLE [NetClassSectionFileStudyDetail]  WITH CHECK ADD  
	CONSTRAINT [FK_NetClassSectionFileStudyDetail_NetClass] FOREIGN KEY([NetClassId]) REFERENCES [NetClass] ([Id]),
	CONSTRAINT [FK_NetClassSectionFileStudyDetail_NetClassSection] FOREIGN KEY([NetClassSectionId]) REFERENCES [NetClassSection] ([Id]),
	CONSTRAINT [FK_NetClassSectionFileStudyDetail_NetClassSectionFile] FOREIGN KEY([NetClassSectionFileId]) REFERENCES NetClassSectionFile ([Id])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_NetClassSectionFileStudyDetail_EmployeeId_NetClassSectionFileId] ON [dbo].[NetClassSectionFileStudyDetail] 
(
	[EmployeeId] ASC,
	[NetClassSectionFileId] ASC
)
GO

PRINT'--模块试题达标情况表'
CREATE TABLE [dbo].[NetClassSectionQuesStudyDetail](
	[Id]								INT IDENTITY(1,1) PRIMARY KEY,
	[EmployeeId]						INT NOT NULL,										-- 人员Id
	[NetClassId]						INT NOT NULL,										-- 课程Id
	[NetClassSectionId]					INT NOT NULL,										-- 模块Id
	[NetClassSectionQFolderId]			INT NOT NULL,										-- 模块试题文件夹Id	
	[StudyTimeSpan]						INT NOT NULL,										-- 有效学习时长(秒)
	[RightCount]						INT NOT NULL,										-- 做对题量
	[WrongCount]						INT NOT NULL,										-- 做错题量
	[SubmitCount]						INT NOT NULL,										-- 提交答卷次数
)
ALTER TABLE [NetClassSectionQuesStudyDetail]  WITH CHECK ADD  
	CONSTRAINT [FK_NetClassSectionQuesStudyDetail_NetClass] FOREIGN KEY([NetClassId]) REFERENCES [NetClass] ([Id]),
	CONSTRAINT [FK_NetClassSectionQuesStudyDetail_NetClassSection] FOREIGN KEY([NetClassSectionId]) REFERENCES [NetClassSection] ([Id]),
	CONSTRAINT [FK_NetClassSectionQuesStudyDetail_NetClassSectionQFolder] FOREIGN KEY([NetClassSectionQFolderId]) REFERENCES [NetClassSectionQFolder] ([Id])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_NetClassSectionQuesStudyDetail_EmployeeId_NetClassSectionQFolderId] ON [dbo].[NetClassSectionQuesStudyDetail] 
(
	[EmployeeId] ASC,
	[NetClassSectionQFolderId] ASC
)
GO

PRINT'--模块试题答案记录表'
CREATE TABLE [dbo].[NetClassSectionQuesAnswerHistory](
	[Id]								INT IDENTITY(1,1) PRIMARY KEY,
	[EmployeeId]						INT NOT NULL,										-- 人员Id
	[NetClassId]						INT NOT NULL,										-- 课程Id
	[NetClassSectionId]					INT NOT NULL,										-- 模块Id
	[NetClassSectionQFolderId]			INT NOT NULL,										-- 模块试题文件夹Id	
	[NetClassSectionQuesId]				INT NOT NULL,										-- 试题Id
	[AnswerText]						NVARCHAR(MAX) NULL,									-- 试题答案
	[Answer]							VARBINARY(MAX) NULL,								-- 试题答案Rtf
)
ALTER TABLE [NetClassSectionQuesAnswerHistory]  WITH CHECK ADD  
	CONSTRAINT [FK_NetClassSectionQuesAnswerHistory_NetClass] FOREIGN KEY([NetClassId]) REFERENCES [NetClass] ([Id]),
	CONSTRAINT [FK_NetClassSectionQuesAnswerHistory_NetClassSection] FOREIGN KEY([NetClassSectionId]) REFERENCES [NetClassSection] ([Id]),
	CONSTRAINT [FK_NetClassSectionQuesAnswerHistory_NetClassSectionQFolder] FOREIGN KEY([NetClassSectionQFolderId]) REFERENCES [NetClassSectionQFolder] ([Id]),
	CONSTRAINT [FK_NetClassSectionQuesAnswerHistory_NetClassSectionQues] FOREIGN KEY([NetClassSectionQuesId]) REFERENCES [NetClassSectionQues] ([Id])
GO
CREATE NONCLUSTERED INDEX [IDX_NetClassSectionQuesAnswerHistory_EmployeeId_NetClassSectionQFolderId] ON [dbo].[NetClassSectionQuesAnswerHistory] 
(
	[EmployeeId] ASC,
	[NetClassSectionQFolderId] ASC
)
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_NetClassSectionQuesAnswerHistory_EmployeeId_NetClassSectionQuesId] ON [dbo].[NetClassSectionQuesAnswerHistory] 
(
	[EmployeeId] ASC,
	[NetClassSectionQuesId] ASC
)
GO

PRINT'--模块试卷学习达标情况表'
CREATE TABLE [dbo].[NetClassSectionPaperOpenStudyDetail](
	[Id]								INT IDENTITY(1,1) PRIMARY KEY,
	[EmployeeId]						INT NOT NULL,										-- 人员Id
	[NetClassId]						INT NOT NULL,										-- 课程Id
	[NetClassSectionId]					INT NOT NULL,										-- 模块Id
	[PaperPackageId]					INT NOT NULL,										
	[StudyTimeSpan]						INT NOT NULL,										-- 有效学习时长(秒)	
)
ALTER TABLE [NetClassSectionPaperOpenStudyDetail]  WITH CHECK ADD  
	CONSTRAINT [FK_NetClassSectionPaperOpenStudyDetail_NetClass] FOREIGN KEY([NetClassId]) REFERENCES [NetClass] ([Id]),
	CONSTRAINT [FK_NetClassSectionPaperOpenStudyDetail_NetClassSection] FOREIGN KEY([NetClassSectionId]) REFERENCES [NetClassSection] ([Id]),
	CONSTRAINT [FK_NetClassSectionPaperOpenStudyDetail_NetClassSectionPractisePaperPackage] FOREIGN KEY([PaperPackageId]) REFERENCES [NetClassSectionPractisePaperPackage] ([Id])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_NetClassSectionPaperOpenStudyDetail_EmployeeId_PaperPackageId] ON [dbo].[NetClassSectionPaperOpenStudyDetail] 
(
	[EmployeeId] ASC,
	[PaperPackageId] ASC
)
GO


PRINT'--模块试卷练习达标情况表'
CREATE TABLE [dbo].[NetClassSectionPaperCloseStudyDetail](
	[Id]								INT IDENTITY(1,1) PRIMARY KEY,
	[EmployeeId]						INT NOT NULL,										-- 人员Id
	[NetClassId]						INT NOT NULL,										-- 课程Id
	[NetClassSectionId]					INT NOT NULL,										-- 模块Id
	[PaperPackageId]					INT NOT NULL,											
	[Score]								DECIMAL(18,1) NOT NULL,								-- 得分
	[PassScore]							INT,												-- 通过分
	[PaperScore]						DECIMAL(18,1) NOT NULL,								-- 试卷总分
	[PaperQuesCount]					INT NOT NULL,										-- 试卷题量
	[IsPassed]							BIT NOT NULL,										-- 是否通过
	[SubmitTime]						DateTime NOT NULL,									-- 交卷时间
)
ALTER TABLE [NetClassSectionPaperCloseStudyDetail]  WITH CHECK ADD  
	CONSTRAINT [FK_NetClassSectionPaperCloseStudyDetail_NetClass] FOREIGN KEY([NetClassId]) REFERENCES [NetClass] ([Id]),
	CONSTRAINT [FK_NetClassSectionPaperCloseStudyDetail_NetClassSection] FOREIGN KEY([NetClassSectionId]) REFERENCES [NetClassSection] ([Id]),
	CONSTRAINT [FK_NetClassSectionPaperCloseStudyDetail_NetClassSectionPractisePaperPackage] FOREIGN KEY([PaperPackageId]) REFERENCES NetClassSectionPractisePaperPackage ([Id])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_NetClassSectionPaperCloseStudyDetail_EmployeeId_PaperPackageId_SubmitTime] ON [dbo].[NetClassSectionPaperCloseStudyDetail] 
(
	[EmployeeId] ASC,
	[PaperPackageId] ASC,
	[SubmitTime] ASC
)
GO

PRINT'--模块试题学习位置表'
CREATE TABLE [dbo].[NetClassSectionQuesStudyPosition]
(
	[Id]								INT IDENTITY(1,1) PRIMARY KEY,
	[EmployeeId]						INT NOT NULL,									--人员Id
	[NetClassId]						INT NOT NULL,									-- 课程Id
	[NetClassSectionId]					INT NOT NULL,									-- 模块Id
	[StudyMode]							INT NOT NULL,									--学习模式
	[NetClassSectionQFolderId]			INT NOT NULL,									--试题文件夹Id
	[QtId]								INT NOT NULL,									--题型Id，等于-1就是全部题型
	[NetClassSectionQuesId]				INT NOT NULL,									--试题Id
)
ALTER TABLE [NetClassSectionQuesStudyPosition]  WITH CHECK ADD  
	CONSTRAINT [FK_NetClassSectionQuesStudyPosition_NetClass] FOREIGN KEY([NetClassId]) REFERENCES [NetClass] ([Id]),
	CONSTRAINT [FK_NetClassSectionQuesStudyPosition_NetClassSection] FOREIGN KEY([NetClassSectionId]) REFERENCES [NetClassSection] ([Id])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_NetClassSectionQuesStudyPosition_EmployeeId_StudyMode_NetClassSectionQFolderId] ON [dbo].[NetClassSectionQuesStudyPosition] 
(
	[EmployeeId] ASC,
	[StudyMode] ASC,
	[NetClassSectionQFolderId] ASC
)
GO
COMMIT TRANSACTION