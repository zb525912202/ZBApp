
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RequiredTraineeEmployeeGroup]') AND type in (N'U'))
BEGIN
PRINT '------ 学员人员分组表 ------'
CREATE TABLE  [dbo].[RequiredTraineeEmployeeGroup](
	[Id]						INT IDENTITY(1,1) PRIMARY KEY,
	[RequiredTaskId]			INT NOT NULL,										--网络培训班ID
	[RequiredTraineeId]			INT NOT NULL,										--网络培训班学员Id	
	[EmployeeGroupId]			INT NOT NULL,										--人员分组Id	
	[EmployeeGroupFullPath]		NVARCHAR(260) NOT NULL,								--人员分组全路径
	[EmployeeGroupDepth]		INT NOT NULL DEFAULT 0,								--深度
)
ALTER TABLE [RequiredTraineeEmployeeGroup] WITH CHECK ADD
	CONSTRAINT [FK_RequiredTraineeEmployeeGroup_RequiredTask] FOREIGN KEY([RequiredTaskId]) REFERENCES [RequiredTask] ([Id]),
	CONSTRAINT [FK_RequiredTraineeEmployeeGroup_RequiredTrainee] FOREIGN KEY([RequiredTraineeId]) REFERENCES [RequiredTrainee]([Id])

CREATE UNIQUE NONCLUSTERED INDEX [IDX_RequiredTraineeEmployeeGroup_RequiredTraineeId_EmployeeGroupId] ON [dbo].[RequiredTraineeEmployeeGroup]
(
	[RequiredTraineeId] ASC,
	[EmployeeGroupId] ASC
)
END
