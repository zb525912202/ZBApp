	USE [$(DatabaseName)]
GO
BEGIN TRANSACTION
PRINT '------ 考试 ------'
CREATE TABLE [dbo].[TrainingExam](
	[TrainingWorkId]		INT PRIMARY KEY NOT NULL,							-- 考试事务Id
	[TeTypeId]				INT NOT NULL,										-- 考试类型	
	[ExamCheatPolicy]		INT NOT NULL,										-- 作弊策略	
	[ExamMissPolicy]		INT NOT NULL,										-- 缺考策略
	[ExamReplacePolicy]		INT NOT NULL,										-- 代考策略
)
ALTER TABLE [TrainingExam] WITH CHECK ADD	
	CONSTRAINT [FK_TrainingExam_TrainingWork] FOREIGN KEY([TrainingWorkId]) REFERENCES [TrainingWork]([Id]),
	CONSTRAINT [FK_TrainingExam_TeType] FOREIGN KEY([TeTypeId]) REFERENCES [TeType]([Id])
GO

PRINT '------ 科目 ------'
CREATE TABLE  [dbo].[TeSubject](
	[Id]						INT PRIMARY KEY NOT NULL,
	[TrainingExamId]			INT NOT NULL,										-- 考试ID
	[ObjectName]				NVARCHAR(50) NOT NULL,								-- 课程名称
)
ALTER TABLE [TeSubject] WITH CHECK ADD
	CONSTRAINT [FK_TeSubject_TrainingExam] FOREIGN KEY([TrainingExamId]) REFERENCES [TrainingExam]([TrainingWorkId])
GO
--同一考试下，科目名称不能重复
CREATE UNIQUE NONCLUSTERED INDEX [IDX_TeSubject_TrainingExamId_ObjectName] ON [dbo].[TeSubject] 
(
	[TrainingExamId] ASC,
	[ObjectName] ASC
)
GO

PRINT '------ 场次 ------'
CREATE TABLE  [dbo].[TeExamRoom](
	[Id]						INT PRIMARY KEY NOT NULL,
	[TrainingExamId]			INT NOT NULL,										-- 考试ID
	[WebExamId]					INT NOT NULL,										-- 网络考试ID
	[TeSubjectId]				INT NOT NULL,										-- 科目ID
	[ObjectName]				NVARCHAR(50) NOT NULL,								-- 场次名称		
	[TeExamRoomType]			INT NOT NULL,										-- 场次类型
	[TeExamRoomMode]			INT NOT NULL,										--考试形式(0、统一开考 1、随到随考)
	[TeExamRoomPaperMode]		INT NOT NULL,										--用卷方式(0、单卷 1、AB卷 2、多卷)
	[StartTime]					DATETIME ,											--开考时间		
	[ExamTimeSpan]				INT NOT NULL,										--时长（分钟）
	[CloseTime]					DATETIME ,											--闭考时间	
	[TotalScore]				DECIMAL(18,1) NOT NULL,								--满分
	[PassScore]					DECIMAL(18,1) NOT NULL,								--及格分
	[LastUpdateCreditTime]			DATETIME ,											--最后一次同步学分时间
)
ALTER TABLE [TeExamRoom] WITH CHECK ADD
	CONSTRAINT [FK_TeExamRoom_TeSubject] FOREIGN KEY([TeSubjectId]) REFERENCES [TeSubject]([Id])
GO
--相同科目下，场次名称不能重复
CREATE UNIQUE NONCLUSTERED INDEX [IDX_TeExamRoom_TeSubjectId_ObjectName] ON [dbo].[TeExamRoom] 
(
	[TeSubjectId] ASC,
	[ObjectName] ASC
)
GO

PRINT '------ 考生 ------'
CREATE TABLE  [dbo].[TeTrainee](
	[TrainingEmployeeId]		INT PRIMARY KEY NOT NULL,
	[TeResultTypeId]			INT NOT NULL,										--考试结果类型
	[TeAwardResult]				NVARCHAR(50),										--获奖结果
)
ALTER TABLE [TeTrainee] WITH CHECK ADD
	CONSTRAINT [FK_TeTrainee_TrainingEmployee] FOREIGN KEY([TrainingEmployeeId]) REFERENCES [TrainingEmployee]([Id]),
	CONSTRAINT [FK_TeTrainee_TeResultType] FOREIGN KEY([TeResultTypeId]) REFERENCES [TeResultType]([Id])	
GO

PRINT '------ 考生场次 ------'
CREATE TABLE  [dbo].[TeTraineeExamRoom](
	[Id]						INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[TrainingExamId]			INT NOT NULL,										-- 考试ID
	[TeTraineeId]				INT NOT NULL,										-- 考生Id
	[TeSubjectId]				INT NOT NULL,										-- 科目Id
	[TeExamRoomId]				INT NOT NULL,										-- 场次Id
	[IsRequired]				BIT NOT NULL,										-- 是否必修
	[ExamScore]					DECIMAL(18,1),										-- 考试得分(null:未设定)
	[ExamRoomState]				INT NOT NULL,										-- 状态(1:正常 2:作弊 3:缺考)
)
ALTER TABLE [TeTraineeExamRoom] WITH CHECK ADD
	CONSTRAINT [FK_TeTraineeExamRoom_TrainingExam] FOREIGN KEY([TrainingExamId]) REFERENCES [TrainingExam]([TrainingWorkId]),
	CONSTRAINT [FK_TeTraineeExamRoom_TeTrainee] FOREIGN KEY([TeTraineeId]) REFERENCES [TeTrainee]([TrainingEmployeeId]),
	CONSTRAINT [FK_TeTraineeExamRoom_TeSubject] FOREIGN KEY([TeSubjectId]) REFERENCES [TeSubject]([Id]),
	CONSTRAINT [FK_TeTraineeExamRoom_TeExamRoom] FOREIGN KEY([TeExamRoomId]) REFERENCES [TeExamRoom]([Id])
GO

COMMIT TRANSACTION
