PRINT'--错题表'
CREATE TABLE [dbo].[WrongQuestion]
(
	[Id]								INT IDENTITY(1,1) PRIMARY KEY,
	[EmployeeId]						INT NOT NULL,									--人员Id
	[Year]								INT NOT NULL,									--年
	[Month]								INT NOT NULL,									--月
	[QuestionId]						INT NOT NULL,									--试题Id
	
	[QuesRightCount]					INT NOT NULL,									
	[QuesWrongCount]					INT NOT NULL,									
	[QuesTotalPercent]					DECIMAL(18,1) NOT NULL,	

	[PaperRightCount]					INT NOT NULL,									
	[PaperWrongCount]					INT NOT NULL,									
	[PaperTotalPercent]					DECIMAL(18,1) NOT NULL,									
	
	[LessonRightCount]					INT NOT NULL,									
	[LessonWrongCount]					INT NOT NULL,									
	[LessonTotalPercent]				DECIMAL(18,1) NOT NULL,												

	[ExamRightCount]					INT NOT NULL,									
	[ExamWrongCount]					INT NOT NULL,									
	[ExamTotalPercent]					DECIMAL(18,1) NOT NULL,										

	[NetClassRightCount]				INT NOT NULL,									
	[NetClassWrongCount]				INT NOT NULL,									
	[NetClassTotalPercent]				DECIMAL(18,1) NOT NULL,										

	[RightCount]						INT NOT NULL,									
	[WrongCount]						INT NOT NULL,									
	[TotalPercent]						DECIMAL(18,1) NOT NULL,	
	[StudyTimeSpan]						INT NOT NULL,									
	[LearningPoint]						DECIMAL(18,1) NOT NULL,														
	[ContinueRightCount]				INT NOT NULL,	
	[CreateTime]						DATETIME NOT NULL,									
	[LaseUpdateTime]					DATETIME NOT NULL,
)
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_WrongQuestion_EmployeeId_Year_Month_QuestionId] ON [dbo].[WrongQuestion] 
(
	[EmployeeId] ASC,
	[Year]		 ASC,
	[Month]		 ASC,
	[QuestionId] ASC
)
GO






PRINT'--试题模拟测验组卷方案表'
CREATE TABLE  [dbo].[WrongQuesTestSolution](
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,	
	[EmployeeId]			INT NOT NULL,										-- 人员Id	
	[TotalScore]			DECIMAL(18,1) NOT NULL,								-- 试卷总分
	[PassScore]				DECIMAL(18,1) NOT NULL,								-- 及格分
	[TestTimeSpan]			INT NOT NULL,										-- 测验时长（分钟）
	[CreateTime]			DATETIME NOT NULL,									-- 创建时间	
)

PRINT'--试题模拟测验组卷方案详细表'
CREATE TABLE  [dbo].[WrongQuesTestSolutionQtDetail](
	[Id]						INT IDENTITY(1,1) PRIMARY KEY,	
	[WrongQuesTestSolutionId]	INT NOT NULL,										-- 组卷方案Id	
	[QtId]						INT NOT NULL,										-- 题型Id
	[WrongQuesCount]			INT NOT NULL,										-- 题量
	[Score]						DECIMAL(18,1) NOT NULL,								-- 题分	
)
ALTER TABLE [WrongQuesTestSolutionQtDetail]  WITH CHECK ADD  
	CONSTRAINT [FK_WrongQuesTestSolutionQtDetail_WrongQuesTestSolution] FOREIGN KEY([WrongQuesTestSolutionId]) REFERENCES [WrongQuesTestSolution] ([Id])
GO

PRINT'--试题模拟测验表'
CREATE TABLE  [dbo].[WrongQuesTest](
	[Id]						INT IDENTITY(1,1) PRIMARY KEY,	
	[WrongQuesTestSolutionId]	INT NOT NULL,										-- 组卷方案Id	
	[Score]						DECIMAL(18,1) NOT NULL,								-- 得分
	[StartTime]					DATETIME NOT NULL,									-- 开始时间
	[EndTime]					DATETIME NOT NULL,									-- 结束时间
)
ALTER TABLE [WrongQuesTest]  WITH CHECK ADD  
	CONSTRAINT [FK_WrongQuesTest_WrongQuesTestSolution] FOREIGN KEY([WrongQuesTestSolutionId]) REFERENCES [WrongQuesTestSolution] ([Id])
GO

PRINT'--试题模拟测验表详细表'
CREATE TABLE  [dbo].[WrongQuesTestDetail](
	[Id]						INT IDENTITY(1,1) PRIMARY KEY,	
	[WrongQuesTestId]			INT NOT NULL,										-- 试题模拟测验表Id
	[WrongQuesTestSolutionId]	INT NOT NULL,										-- 组卷方案Id
	[WrongQuesId]				INT NOT NULL,										-- 试题Id
	[QtId]						INT NOT NULL,										-- 题型Id	
	[Score]						DECIMAL(18,1) NOT NULL,								-- 题分	
)
ALTER TABLE [WrongQuesTestDetail]  WITH CHECK ADD  
	CONSTRAINT [FK_WrongQuesTestDetail_WrongQuesTest] FOREIGN KEY([WrongQuesTestId]) REFERENCES [WrongQuesTest] ([Id]),
	CONSTRAINT [FK_WrongQuesTestDetail_WrongQuesTestSolution] FOREIGN KEY([WrongQuesTestSolutionId]) REFERENCES [WrongQuesTestSolution] ([Id])
GO
