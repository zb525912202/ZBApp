

PRINT'--ÐÞ¸´IDX_RequiredItemId_QtId'
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeQuesRequiredItemDetail]') AND name = N'IDX_RequiredItemId_QtId')
DROP INDEX [IDX_RequiredItemId_QtId] ON [EmployeeQuesRequiredItemDetail]
GO

CREATE UNIQUE NONCLUSTERED INDEX [IDX_RequiredItemId_QtId] ON [dbo].[EmployeeQuesRequiredItemDetail] 
(
	[RequiredItemId] ASC,
	[EmployeeId] ASC,
	[QtId] ASC
)
GO


