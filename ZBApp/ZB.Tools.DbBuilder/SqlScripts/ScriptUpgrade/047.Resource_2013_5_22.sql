

PRINT'--增加IDX_QFolder_Dept_ParentId_ObjectName--'
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[QFolder]') AND name = N'IDX_QFolder_DeptId_ParentId_ObjectName')
BEGIN
PRINT'--确保一个试卷文件夹下的子节点名称不重复--'
CREATE UNIQUE NONCLUSTERED INDEX [IDX_QFolder_DeptId_ParentId_ObjectName] ON [dbo].[QFolder] 
(
	[DeptId] ASC,
	[ParentId] ASC,
	[ObjectName] ASC
)
END

PRINT'--增加IDX_PFolder_DeptId_ParentId_ObjectName--'
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PFolder]') AND name = N'IDX_RFolder_DeptId_ParentId_ObjectName')
BEGIN
PRINT'--确保一个试卷文件夹下的子节点名称不重复--'
CREATE UNIQUE NONCLUSTERED INDEX [IDX_RFolder_DeptId_ParentId_ObjectName] ON [dbo].[PFolder] 
(
	[DeptId] ASC,
	[ParentId] ASC,
	[ObjectName] ASC
)
END

PRINT'--增加IDX_RFolder_DeptId_ParentId_ObjectName--'
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[RFolder]') AND name = N'IDX_RFolder_DeptId_ParentId_ObjectName')
BEGIN
PRINT'--确保一个试卷文件夹下的子节点名称不重复--'
CREATE UNIQUE NONCLUSTERED INDEX [IDX_RFolder_DeptId_ParentId_ObjectName] ON [dbo].[RFolder] 
(
	[DeptId] ASC,
	[ParentId] ASC,
	[ObjectName] ASC
)
END
