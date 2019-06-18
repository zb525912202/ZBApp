
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RequiredTraineeEmployeeGroup]') AND type in (N'U'))
BEGIN
PRINT '------ ѧԱ��Ա����� ------'
CREATE TABLE  [dbo].[RequiredTraineeEmployeeGroup](
	[Id]						INT IDENTITY(1,1) PRIMARY KEY,
	[RequiredTaskId]			INT NOT NULL,										--������ѵ��ID
	[RequiredTraineeId]			INT NOT NULL,										--������ѵ��ѧԱId	
	[EmployeeGroupId]			INT NOT NULL,										--��Ա����Id	
	[EmployeeGroupFullPath]		NVARCHAR(260) NOT NULL,								--��Ա����ȫ·��
	[EmployeeGroupDepth]		INT NOT NULL DEFAULT 0,								--���
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
