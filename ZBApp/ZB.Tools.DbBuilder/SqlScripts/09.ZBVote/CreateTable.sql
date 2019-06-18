USE [$(DatabaseName)]
GO

BEGIN TRANSACTION
PRINT'--投票表'
CREATE TABLE  [dbo].[Ballot](
	[Id]								INT IDENTITY(1,1) PRIMARY KEY,
	[ObjectName]						NVARCHAR(50) NOT NULL,								-- 投票名称
	[DeptId]							INT NOT NULL,										-- 部门Id
	[DeptFullPath]						NVARCHAR(260) NOT NULL,								-- 部门全路径
	[MaxVoteItemSelectCount]			INT	NOT NULL,										-- 最多投票项选择数量
	[MaxEmployeeVoteTimes]				INT	NOT NULL,										-- 个人最多投票次数
	[BallotItemMaxVoteTimes]			INT NOT NULL,										-- 单个投票项最多投票次数
	[StartTime]							DATETIME NOT NULL,									-- 开始时间
	[EndTime]							DATETIME NOT NULL,									-- 结束时间
	[CreateTime]						DATETIME NOT NULL,									-- 创建时间
	[CreatorId]							INT NOT NULL,										-- 创建人Id
	[CreatorName]						NVARCHAR(50) NOT NULL,								-- 创建人姓名	
	[BallotState]						INT NOT NULL,										-- 投票调查状态(发布、暂停)
)

PRINT'--投票项表'
CREATE TABLE  [dbo].[BallotItem](
	[Id]								INT IDENTITY(1,1) PRIMARY KEY,
	[BallotId]							INT NOT NULL,										-- 投票Id
	[Content]							VARBINARY(MAX) NOT NULL,							-- 投票项内容Rtf	
	[SortIndex]							INT NOT NULL,										-- 排序索引
	[AttachmentObjType]					INT NOT NULL,										-- 附件类型
	[AttachmentObjBytes]				VARBINARY(MAX),										-- 附件序列化对象
)
ALTER TABLE [BallotItem]  WITH CHECK ADD  
	CONSTRAINT [FK_BallotItem_Ballot] FOREIGN KEY(BallotId) REFERENCES [Ballot] ([Id])
GO

PRINT'--人员投票表'
CREATE TABLE  [dbo].[EmployeeBallot](
	[Id]								INT IDENTITY(1,1) PRIMARY KEY,	
	[EmployeeId]						INT NOT NULL,										-- 人员Id
	[BallotId]							INT NOT NULL,										-- 投票Id	
)

PRINT'--人员投票项表'
CREATE TABLE  [dbo].[EmployeeBallotItem](
	[Id]								INT IDENTITY(1,1) PRIMARY KEY,	
	[EmployeeBallotId]					INT NOT NULL,										-- 人员投票Id
	[EmployeeId]						INT NOT NULL,										-- 人员Id
	[BallotId]							INT NOT NULL,										-- 投票Id
	[BallotItemId]						INT NOT NULL,										-- 人员Id
)
ALTER TABLE [EmployeeBallotItem]  WITH CHECK ADD  
	CONSTRAINT [FK_EmployeeBallotItem_EmployeeBallot] FOREIGN KEY(EmployeeBallotId) REFERENCES [EmployeeBallot] ([Id])
GO

PRINT'--问卷调查表'
CREATE TABLE  [dbo].[Survey](
	[Id]								INT IDENTITY(1,1) PRIMARY KEY,
	[ObjectName]						NVARCHAR(50) NOT NULL,								-- 问卷调查名称
	[DeptId]							INT NOT NULL,										-- 部门Id
	[DeptFullPath]						NVARCHAR(260) NOT NULL,								-- 部门全路径
	[MaxEmployeeVoteTimes]				INT	NOT NULL,										-- 一个人员最多参加问卷调查次数
	[StartTime]							DATETIME NOT NULL,									-- 开始时间
	[EndTime]							DATETIME NOT NULL,									-- 结束时间
	[CreateTime]						DATETIME NOT NULL,									-- 创建时间
	[CreatorId]							INT NOT NULL,										-- 创建人Id
	[CreatorName]						NVARCHAR(50) NOT NULL,								-- 创建人姓名	
	[SurveyState]						INT NOT NULL,										-- 问卷调查状态(发布、暂停)
)

PRINT'--问卷调查项表'
CREATE TABLE  [dbo].[SurveyItem](
	[Id]								INT IDENTITY(1,1) PRIMARY KEY,
	[SurveyId]							INT NOT NULL,										-- 问卷调查Id
	[Content]							VARBINARY(MAX) NOT NULL,							-- 问卷调查项内容Rtf	
	[MaxSurveyOptionSelectCount]		INT NOT NULL,										-- 问卷调查项最多选择数量
	[SortIndex]							INT NOT NULL,										-- 排序索引
	[AttachmentObjType]					INT NOT NULL,										-- 附件类型
	[AttachmentObjBytes]				VARBINARY(MAX),										-- 附件序列化对象
)
ALTER TABLE [SurveyItem]  WITH CHECK ADD  
	CONSTRAINT [FK_SurveyItem_Survey] FOREIGN KEY(SurveyId) REFERENCES [Survey] ([Id])
GO

PRINT'--问卷调查选项表'
CREATE TABLE  [dbo].[SurveyOption](
	[Id]								INT IDENTITY(1,1) PRIMARY KEY,
	[SurveyId]							INT NOT NULL,										-- 问卷调查Id
	[SurveyItemId]						INT NOT NULL,										-- 问卷调查项Id
	[Content]							NVARCHAR(MAX) NOT NULL,								-- 问卷调查选项内容
	[SortIndex]							INT NOT NULL,										-- 排序索引
)
ALTER TABLE [SurveyOption]  WITH CHECK ADD  
	CONSTRAINT [FK_SurveyOption_SurveyItem] FOREIGN KEY(SurveyItemId) REFERENCES [SurveyItem] ([Id])
GO

PRINT'--人员问卷调查表'
CREATE TABLE  [dbo].[EmployeeSurvey](
	[Id]								INT IDENTITY(1,1) PRIMARY KEY,
	[EmployeeId]						INT NOT NULL,										-- 人员Id
	[SurveyId]							INT NOT NULL,										-- 问卷调查Id
)

PRINT'--人员问卷调查选项表'
CREATE TABLE  [dbo].[EmployeeSurveyOption](
	[Id]								INT IDENTITY(1,1) PRIMARY KEY,
	[EmployeeSurveyId]					INT NOT NULL,										-- 人员问卷调查Id	
	[EmployeeId]						INT NOT NULL,										-- 人员Id
	[SurveyId]							INT NOT NULL,										-- 问卷调查Id
	[SurveyItemId]						INT NOT NULL,										-- 问卷调查项Id
	[SurveyOptionId]					INT NOT NULL,										-- 问卷调查选项Id
)
ALTER TABLE [EmployeeSurveyOption]  WITH CHECK ADD  
	CONSTRAINT [FK_EmployeeSurveyOption_EmployeeSurvey] FOREIGN KEY(EmployeeSurveyId) REFERENCES [EmployeeSurvey] ([Id])
GO

COMMIT TRANSACTION