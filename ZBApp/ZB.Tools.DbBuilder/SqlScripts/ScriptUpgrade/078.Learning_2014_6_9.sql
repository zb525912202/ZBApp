IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QuesTestSolution]') AND type in (N'U'))
BEGIN
PRINT'--试题模拟测验组卷方案表'
CREATE TABLE  [dbo].[QuesTestSolution](
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,	
	[EmployeeId]			INT NOT NULL,										-- 人员Id
	[QFolderId]				INT NOT NULL,										-- 试题文件夹Id
	[TotalScore]			DECIMAL(18,1) NOT NULL,								-- 试卷总分
	[PassScore]				DECIMAL(18,1) NOT NULL,								-- 及格分
	[TestTimeSpan]			INT NOT NULL,										-- 测验时长（分钟）
	[CreateTime]			DATETIME NOT NULL,									-- 创建时间	
)
END
GO

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QuesTestSolutionQtDetail]') AND type in (N'U'))
BEGIN
PRINT'--试题模拟测验组卷方案详细表'
CREATE TABLE  [dbo].[QuesTestSolutionQtDetail](
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,	
	[QuesTestSolutionId]	INT NOT NULL,										-- 组卷方案Id	
	[QtId]					INT NOT NULL,										-- 题型Id
	[QuesCount]				INT NOT NULL,										-- 题量
	[Score]					DECIMAL(18,1) NOT NULL,								-- 题分	
)
ALTER TABLE [QuesTestSolutionQtDetail]  WITH CHECK ADD  
	CONSTRAINT [FK_QuesTestSolutionQtDetail_QuesTestSolution] FOREIGN KEY([QuesTestSolutionId]) REFERENCES [QuesTestSolution] ([Id])
END
GO

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QuesTest]') AND type in (N'U'))
BEGIN
PRINT'--试题模拟测验表'
CREATE TABLE  [dbo].[QuesTest](
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,	
	[QuesTestSolutionId]	INT NOT NULL,										-- 组卷方案Id	
	[Score]					DECIMAL(18,1) NOT NULL,								-- 得分
	[StartTime]				DATETIME NOT NULL,									-- 开始时间
	[EndTime]				DATETIME NOT NULL,									-- 结束时间
)
ALTER TABLE [QuesTest]  WITH CHECK ADD  
	CONSTRAINT [FK_QuesTest_QuesTestSolution] FOREIGN KEY([QuesTestSolutionId]) REFERENCES [QuesTestSolution] ([Id])
END
GO

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QuesTestDetail]') AND type in (N'U'))
BEGIN
PRINT'--试题模拟测验表详细表'
CREATE TABLE  [dbo].[QuesTestDetail](
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,	
	[QuesTestId]			INT NOT NULL,										-- 试题模拟测验表Id
	[QuesTestSolutionId]	INT NOT NULL,										-- 组卷方案Id
	[QuesId]				INT NOT NULL,										-- 试题Id
	[QtId]					INT NOT NULL,										-- 题型Id	
	[Score]					DECIMAL(18,1) NOT NULL,								-- 题分	
)
ALTER TABLE [QuesTestDetail]  WITH CHECK ADD  
	CONSTRAINT [FK_QuesTestDetail_QuesTest] FOREIGN KEY([QuesTestId]) REFERENCES [QuesTest] ([Id]),
	CONSTRAINT [FK_QuesTestDetail_QuesTestSolution] FOREIGN KEY([QuesTestSolutionId]) REFERENCES [QuesTestSolution] ([Id])
END
GO

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QuesTestSolutionConfig]') AND type in (N'U'))
BEGIN
PRINT'--试题模拟测验参数配置表'
CREATE TABLE  [dbo].[QuesTestSolutionConfig](
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,	
	[TotalScore]			INT NOT NULL UNIQUE,										-- 满分
	[PassScore]				INT NOT NULL,										-- 合格分
	[TimeSpan]		        INT NOT NULL,										-- 时长(分)
	[SortIndex]				INT NOT NULL DEFAULT 0,
	[LockStatus]			INT NOT NULL,				
)

INSERT INTO [QuesTestSolutionConfig]([TotalScore],[PassScore],[TimeSpan],[SortIndex],[LockStatus])VALUES(100,60,60,1,2)
INSERT INTO [QuesTestSolutionConfig]([TotalScore],[PassScore],[TimeSpan],[SortIndex],[LockStatus])VALUES(150,90,90,2,0)
END
GO
