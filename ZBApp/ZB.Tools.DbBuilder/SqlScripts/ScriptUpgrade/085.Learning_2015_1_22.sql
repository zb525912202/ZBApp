IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeStudyHistory]') AND type in (N'U'))
BEGIN
PRINT'--人员最近学习情况历史表'
CREATE TABLE [dbo].[EmployeeStudyHistory](
	[Id]						INT IDENTITY(1,1) PRIMARY KEY,
	[EmployeeId]				INT NOT NULL,										-- 人员Id
	[ResourceId]				INT NOT NULL,										-- 资源Id
	[EmployeeStudyHistoryType]	INT NOT NULL,										-- 资源类型
	[CreateTime]				DATETIME NOT NULL,									-- 创建时间	
	[Tag1]						BIT NOT NULL,										-- 是否包含子部门，用于试题记录
	[Tag2]						INT NOT NULL,										-- 学习类型，开卷、闭卷
)
CREATE UNIQUE NONCLUSTERED INDEX [IDX_EmployeeStudyHistory_EmployeeId_ResourceId_EmployeeStudyHistoryType] ON [dbo].[EmployeeStudyHistory] 
(
	[EmployeeId] ASC,
	[ResourceId] ASC,
	[EmployeeStudyHistoryType] ASC
)
END
GO
