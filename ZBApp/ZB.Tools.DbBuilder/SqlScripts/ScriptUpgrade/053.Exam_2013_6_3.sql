

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[WebExamineePaperDetail]') AND name = N'IDX_WebExamineePaperDetail_WebExamId_IsImpersonal')
BEGIN
PRINT'--Ôö¼ÓIDX_QFolder_Dept_ParentId_ObjectName--'
CREATE NONCLUSTERED INDEX [IDX_WebExamineePaperDetail_WebExamId_IsImpersonal] ON [dbo].[WebExamineePaperDetail] 
(
	[WebExamId] ASC,
	[IsImpersonal] ASC
)
END

