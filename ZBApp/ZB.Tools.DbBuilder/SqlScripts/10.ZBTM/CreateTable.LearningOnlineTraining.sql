USE [$(DatabaseName)]
GO
BEGIN TRANSACTION
PRINT '--------网络自主学习人员详细---------'
CREATE TABLE [dbo].[LearningOnlineTraineeDetail]
(
	[Id]						INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[TrainingEmployeeId]		INT NOT NULL,							
	[TrainingWorkId]			INT NOT NULL,										-- 培训事务ID(冗余)
	[LearningOnlineStudyType]	INT NOT NULL,										-- 网络学习类型(看题、做题、看卷、做卷、媒体学习)
	[StudyTimeSpan]				INT NOT NULL,										-- 有效学习时长(秒)
	[LearningPoint]				DECIMAL(18,1) NOT NULL,								-- 积分	
	[Credit]					DECIMAL(18,1) NOT NULL,								-- 学分
)
ALTER TABLE [LearningOnlineTraineeDetail] WITH CHECK ADD
	CONSTRAINT [FK_LearningOnlineTraineeDetail_TrainingEmployee] FOREIGN KEY([TrainingEmployeeId]) REFERENCES [TrainingEmployee]([Id])
GO
CREATE NONCLUSTERED INDEX [IDX_TrainingEmployeeId] ON [dbo].[LearningOnlineTraineeDetail]
(
	[TrainingEmployeeId] ASC
)
GO
COMMIT TRANSACTION
