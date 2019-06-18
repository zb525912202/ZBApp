USE [$(DatabaseName)]
GO
BEGIN TRANSACTION
PRINT '------ 评定项 ------'
CREATE TABLE [dbo].[Judge]
(
	[Id]								INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[TrainingKindId]					INT NOT NULL,										-- 评定项类型Id
	[TrainingWorkTypeId]				INT NOT NULL,										-- 事务类型Id
	[ObjectName]						NVARCHAR(50) NOT NULL,								-- 名称
	[Remark]							NVARCHAR(MAX),										-- 评定规则备注
	[TrainingCreditRuleObjBytes]		VARBINARY(MAX),										-- 评分规则对象
	[SortIndex]							INT NOT NULL DEFAULT 0								-- SortIndex
)
ALTER TABLE [Judge] WITH CHECK ADD
	CONSTRAINT [FK_Judge_TrainingKind] FOREIGN KEY([TrainingKindId]) REFERENCES [TrainingKind]([Id]),
	CONSTRAINT [FK_Judge_TrainingWorkType] FOREIGN KEY([TrainingWorkTypeId]) REFERENCES [TrainingWorkType]([Id])	
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_Judge_TrainingKindId_TrainingWorkTypeId] ON [dbo].[Judge]
(
	[TrainingKindId] ASC,
	[TrainingWorkTypeId] ASC
)
GO

PRINT '------ 人员的评定项信息 ------'
CREATE TABLE [dbo].[JudgeTrainee]
(
	[TrainingEmployeeId]				INT PRIMARY KEY NOT NULL,		
	[JudgeTypeId]						INT NOT NULL,									--评定项类型ID
	[JudgeTypeName]						NVARCHAR(50) NOT NULL,							--评定项类型(培训分类)
	[JudgeId]							INT NOT NULL,									--评定项ID
	[JudgeName]							NVARCHAR(50) NOT NULL,							--评定项名称（评定项）
	[TrainingCreditRuleFullPath]		NVARCHAR(50) NOT NULL,							--评定规则全路径（规则分类）	
	[DanWei]							NVARCHAR(10) NOT NULL,							--单位
	[Amounts]							DECIMAL(18,2) NOT NULL,							--数量
	[GetDate]							DATETIME NOT NULL,								--获取日期
	[RuleScore]							NVARCHAR(260) NOT NULL,							--规则学分
	[RecorderId]						INT NOT NULL,									--录入人ID
	[RecorderName]						NVARCHAR(50),									--录入人
	[Remark]							NVARCHAR(MAX),									--备注
	[AuditStatus]						INT NOT NULL DEFAULT 0,							--审核状态	
)
ALTER TABLE [JudgeTrainee] WITH CHECK ADD
	CONSTRAINT [FK_JudgeTrainee_TrainingEmployee] FOREIGN KEY([TrainingEmployeeId]) REFERENCES [TrainingEmployee]([Id])	
GO
COMMIT TRANSACTION
