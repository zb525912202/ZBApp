

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MappingData]') AND type in (N'U'))
BEGIN

PRINT '------ [MappingData”≥…‰±Ì] ------'
CREATE TABLE [dbo].[MappingData]
(
	[Id]				INT IDENTITY(1,1) PRIMARY KEY,
	[GroupKey]			NVARCHAR(50) NULL,
	[Source]			NVARCHAR(200) NULL,	
	[Target]			NVARCHAR(200) NULL
)

END
GO

