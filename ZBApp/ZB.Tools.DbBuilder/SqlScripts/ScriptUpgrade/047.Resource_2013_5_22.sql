

PRINT'--����IDX_QFolder_Dept_ParentId_ObjectName--'
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[QFolder]') AND name = N'IDX_QFolder_DeptId_ParentId_ObjectName')
BEGIN
PRINT'--ȷ��һ���Ծ��ļ����µ��ӽڵ����Ʋ��ظ�--'
CREATE UNIQUE NONCLUSTERED INDEX [IDX_QFolder_DeptId_ParentId_ObjectName] ON [dbo].[QFolder] 
(
	[DeptId] ASC,
	[ParentId] ASC,
	[ObjectName] ASC
)
END

PRINT'--����IDX_PFolder_DeptId_ParentId_ObjectName--'
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PFolder]') AND name = N'IDX_RFolder_DeptId_ParentId_ObjectName')
BEGIN
PRINT'--ȷ��һ���Ծ��ļ����µ��ӽڵ����Ʋ��ظ�--'
CREATE UNIQUE NONCLUSTERED INDEX [IDX_RFolder_DeptId_ParentId_ObjectName] ON [dbo].[PFolder] 
(
	[DeptId] ASC,
	[ParentId] ASC,
	[ObjectName] ASC
)
END

PRINT'--����IDX_RFolder_DeptId_ParentId_ObjectName--'
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[RFolder]') AND name = N'IDX_RFolder_DeptId_ParentId_ObjectName')
BEGIN
PRINT'--ȷ��һ���Ծ��ļ����µ��ӽڵ����Ʋ��ظ�--'
CREATE UNIQUE NONCLUSTERED INDEX [IDX_RFolder_DeptId_ParentId_ObjectName] ON [dbo].[RFolder] 
(
	[DeptId] ASC,
	[ParentId] ASC,
	[ObjectName] ASC
)
END
