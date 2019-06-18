USE [$(DatabaseName)]
GO
BEGIN TRANSACTION
PRINT'--学分任务表'
CREATE TABLE  [dbo].[TrainingTask](
	[Id]							INT IDENTITY(1,1) PRIMARY KEY,
	[ObjectName]					NVARCHAR(50) NOT NULL,								-- 任务名称	
	[StartTime]						DATETIME NOT NULL,									-- 开始时间
	[EndTime]						DATETIME NOT NULL,									-- 结束时间
	[CreateTime]					DATETIME NOT NULL,									-- 创建时间
	[CreatorId]						INT NOT NULL,										-- 创建人Id
	[CreatorName]					NVARCHAR(50) NOT NULL,								-- 创建人姓名
	[OrgType]						INT NOT NULL,										-- 组织机构类型(部门、人员组)
	[OrgId]							INT NOT NULL,										-- 组织机构Id
	[TaskRule]						VARBINARY(MAX),										-- 网络学习积分规则
	[EmployeeRule]					VARBINARY(MAX),										-- 网络学习人员积分规则
)

COMMIT TRANSACTION
