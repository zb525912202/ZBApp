

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeGroup]') AND type in (N'U'))
BEGIN
PRINT '------ ��Ա���� ------'
CREATE TABLE  [dbo].[EmployeeGroup](
	[Id]					INT PRIMARY KEY,
	[ObjectName]			NVARCHAR(50) NOT NULL,
	[ParentId]				INT NOT NULL,
	[FullPath]				NVARCHAR(260) NOT NULL UNIQUE,	-- ����ȫ·����������������ͬ��·��
	[SortIndex]				INT NOT NULL DEFAULT 0,
	[Depth]					INT NOT NULL DEFAULT 0,			-- ���
)
--ȷ��һ�������µ��ӽڵ����Ʋ��ظ�
CREATE UNIQUE NONCLUSTERED INDEX [IDX_EmployeeGroup_ParentId_ObjectName] ON [dbo].[EmployeeGroup] 
(
	[ParentId] ASC,
	[ObjectName] ASC
)
END



IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeInEmployeeGroup]') AND type in (N'U'))
BEGIN
PRINT '------ ��Ա��������Ա��Ӧ��ϵ�� ------'
CREATE TABLE  [dbo].[EmployeeInEmployeeGroup](
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,
	[EmployeeGroupId]		INT NOT NULL,					-- ��Ա����Id
	[EmployeeId]			INT NOT NULL,					-- ��ԱId
)
ALTER TABLE [EmployeeInEmployeeGroup] WITH CHECK ADD
	CONSTRAINT [FK_EmployeeInEmployeeGroup_EmployeeGroup] FOREIGN KEY([EmployeeGroupId]) REFERENCES [EmployeeGroup]([Id]),
	CONSTRAINT [FK_EmployeeInEmployeeGroup_Employee] FOREIGN KEY([EmployeeId]) REFERENCES [Employee]([Id])
CREATE UNIQUE NONCLUSTERED INDEX [IDX_EmployeeInEmployeeGroup_EmployeeGroupId_EmployeeId] ON [dbo].[EmployeeInEmployeeGroup] 
(
	[EmployeeGroupId] ASC,
	[EmployeeId] ASC
)
END



IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('Employee') AND name='ManageEmployeeGroupId')
BEGIN
	ALTER TABLE Employee ADD ManageEmployeeGroupId INT NOT NULL DEFAULT 0;
	PRINT '���Employee���ڵ�ManageEmployeeGroupId�ɹ�';
END



PRINT'--����IDX_Dept_ParentId_ObjectName--'
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Dept]') AND name = N'IDX_Dept_ParentId_ObjectName')
BEGIN
PRINT'--ȷ��һ�������µ��ӽڵ����Ʋ��ظ�--'
CREATE UNIQUE NONCLUSTERED INDEX [IDX_Dept_ParentId_ObjectName] ON [dbo].[Dept] 
(
	[ParentId] ASC,
	[ObjectName] ASC
)
END
