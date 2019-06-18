USE [$(DatabaseName)]
GO

BEGIN TRANSACTION

PRINT'--网络学习任务表'
CREATE TABLE  [dbo].[LearningTask](
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,
	[ObjectName]			NVARCHAR(50) NOT NULL,								-- 任务名称
	[DeptId]				INT NOT NULL,										-- 部门Id
	[StartTime]				DATETIME NOT NULL,									-- 开始时间
	[EndTime]				DATETIME NOT NULL,									-- 结束时间
	[CreateTime]			DATETIME NOT NULL,									-- 创建时间
	[CreatorId]				INT NOT NULL,										-- 创建人Id
	[CreatorName]			NVARCHAR(50) NOT NULL,								-- 创建人姓名
	[TaskRule]              VARBINARY(MAX),										-- 网络学习积分规则
	[EmployeeRule]          VARBINARY(MAX),										-- 网络学习人员积分规则
)

PRINT'--人员组网络学习任务表'
CREATE TABLE  [dbo].[EGLearningTask](
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,
	[ObjectName]			NVARCHAR(50) NOT NULL,								-- 任务名称
	[EmployeeGroupId]		INT NOT NULL,										-- 人员组Id
	[StartTime]				DATETIME NOT NULL,									-- 开始时间
	[EndTime]				DATETIME NOT NULL,									-- 结束时间
	[CreateTime]			DATETIME NOT NULL,									-- 创建时间
	[CreatorId]				INT NOT NULL,										-- 创建人Id
	[CreatorName]			NVARCHAR(50) NOT NULL,								-- 创建人姓名
	[TaskRule]              VARBINARY(MAX),										-- 网络学习积分规则
	[EmployeeRule]          VARBINARY(MAX),										-- 网络学习人员积分规则
)

COMMIT TRANSACTION