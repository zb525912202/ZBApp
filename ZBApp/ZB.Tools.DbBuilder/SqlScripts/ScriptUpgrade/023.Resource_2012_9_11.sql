
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[QFolder]') AND name = N'IDX_QFolder_DeptId')
BEGIN
PRINT'--Ìí¼ÓË÷Òý[IDX_QFolder_DeptId]'
CREATE NONCLUSTERED INDEX [IDX_QFolder_DeptId] ON [dbo].[QFolder]
(
	[DeptId] ASC,
	[Id] ASC	
)
END
GO
