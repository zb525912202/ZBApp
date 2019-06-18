
USE [$(DatabaseName)]
GO
BEGIN TRANSACTION

PRINT '----------培训结果------------'
CREATE TABLE [dbo].[TrainingOnWorkResult](
	[Id]						INT PRIMARY KEY NOT NULL,
	[WorkId]					INT NOT NULL,
	[EmployeeId]				INT NOT NULL,
	[UnitValue]					DECIMAL(18,1) NOT NULL,				--单位值
	[Credits]					DECIMAL(18,1) NOT NULL,				--学分
	[TrainingResult]			NVARCHAR(MAX) NOT NULL,				--培训结果
	[ViolationInfo]				NVARCHAR(MAX),						--违规情况
	[IsPass]					BIT NOT NULL,						--是否通过
)
GO

ALTER TABLE [TrainingOnWorkResult] WITH CHECK ADD
	CONSTRAINT [FK_TrainingOnWorkResult_WorkId] FOREIGN KEY ([WorkId]) REFERENCES [TrainingOnWork]([Id])
GO

/*同一人员在同一培训事务内仅出现一次*/
CREATE UNIQUE NONCLUSTERED INDEX [IDX_WorkId_EmployeeId] ON [dbo].[TrainingOnWorkResult]
(
	[WorkId] ASC,
	[EmployeeId] ASC
)
GO


PRINT '----------培训期次结果------------'
CREATE TABLE [dbo].[TrainingOnWorkPeriodResult](
	[Id]					INT PRIMARY KEY NOT NULL,
	[PeriodId]				INT NOT NULL,
	[EmployeeId]			INT NOT NULL,
	[Credits]				DECIMAL(18,1) NOT NULL,				--学分
	[TrainingResult]		NVARCHAR(MAX) NOT NULL,				--培训结果
	[ViolationInfo]			NVARCHAR(MAX),						--违规情况
	[IsPass]				BIT NOT NULL,						--是否通过	
)
GO

ALTER TABLE [TrainingOnWorkPeriodResult] WITH CHECK ADD
	CONSTRAINT [FK_TrainingOnWorkPeriodResult_PeriodId] FOREIGN KEY ([PeriodId]) REFERENCES [TrainingOnWorkPeriod]([Id])
GO

/*同一人员在同一期次内仅出现一次*/
CREATE UNIQUE NONCLUSTERED INDEX [IDX_PeriodId_EmployeeId] ON [dbo].[TrainingOnWorkPeriodResult]
(
	[PeriodId] ASC,
	[EmployeeId] ASC
)
GO

PRINT '----------培训项目结果------------'
CREATE TABLE [dbo].[TrainingProjectResult](
	[Id]					INT PRIMARY KEY NOT NULL,
	[TrainingProjectId]		INT NOT NULL,
	[EmployeeId]			INT NOT NULL,
	[Credits]				DECIMAL(18,1) NOT NULL,				--学分
	[TrainingResult]		NVARCHAR(MAX) NOT NULL,				--培训结果
	[ViolationInfo]			NVARCHAR(MAX),						--违规情况
	[IsPass]				BIT NOT NULL,						--是否通过	
)
GO

ALTER TABLE [TrainingProjectResult] WITH CHECK ADD
	CONSTRAINT [FK_TrainingProjectResult_TrainingProjectId] FOREIGN KEY ([TrainingProjectId]) REFERENCES [ProjectLibrary]([Id])
GO

/*同一人员在同一项目内仅出现一次*/
CREATE UNIQUE NONCLUSTERED INDEX [IDX_ProjectId_EmployeeId] ON [dbo].[TrainingProjectResult]
(
	[TrainingProjectId] ASC,
	[EmployeeId] ASC
)
GO

COMMIT TRANSACTION