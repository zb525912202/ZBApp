

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeGroup]') AND type in (N'U'))
BEGIN
PRINT '------ 人员分组 ------'
CREATE TABLE  [dbo].[EmployeeGroup](
	[Id]					INT PRIMARY KEY,
	[ObjectName]			NVARCHAR(50) NOT NULL,
	[ParentId]				INT NOT NULL,
	[FullPath]				NVARCHAR(260) NOT NULL UNIQUE,	-- 部门全路径，不能有两个相同的路径
	[SortIndex]				INT NOT NULL DEFAULT 0,
	[Depth]					INT NOT NULL DEFAULT 0,			-- 深度
)
--确保一个分组下的子节点名称不重复
CREATE UNIQUE NONCLUSTERED INDEX [IDX_EmployeeGroup_ParentId_ObjectName] ON [dbo].[EmployeeGroup] 
(
	[ParentId] ASC,
	[ObjectName] ASC
)
END



IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeInEmployeeGroup]') AND type in (N'U'))
BEGIN
PRINT '------ 人员分组与人员对应关系表 ------'
CREATE TABLE  [dbo].[EmployeeInEmployeeGroup](
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,
	[EmployeeGroupId]		INT NOT NULL,					-- 人员分组Id
	[EmployeeId]			INT NOT NULL,					-- 人员Id
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
	PRINT '添加Employee表内的ManageEmployeeGroupId成功';
END



PRINT'--增加IDX_Dept_ParentId_ObjectName--'
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Dept]') AND name = N'IDX_Dept_ParentId_ObjectName')
BEGIN
PRINT'--确保一个部门下的子节点名称不重复--'
CREATE UNIQUE NONCLUSTERED INDEX [IDX_Dept_ParentId_ObjectName] ON [dbo].[Dept] 
(
	[ParentId] ASC,
	[ObjectName] ASC
)
END
