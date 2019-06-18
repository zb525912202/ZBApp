-----------------------------------------
PRINT '------ 全文索引 Question ------'
--全文索引 Question
IF  EXISTS (SELECT * FROM sys.fulltext_indexes fti WHERE fti.object_id = OBJECT_ID(N'[dbo].[Question]'))
ALTER FULLTEXT INDEX ON [dbo].[Question] DISABLE
GO

IF  EXISTS (SELECT * FROM sys.fulltext_indexes fti WHERE fti.object_id = OBJECT_ID(N'[dbo].[Question]'))
DROP FULLTEXT INDEX ON [dbo].[Question]

GO

IF  EXISTS (SELECT * FROM sysfulltextcatalogs ftc WHERE ftc.name = N'FT_Question_Text')
DROP FULLTEXT CATALOG [FT_Question_Text]
GO

CREATE FULLTEXT CATALOG [FT_Question_Text]WITH ACCENT_SENSITIVITY = OFF
AS DEFAULT
AUTHORIZATION [dbo]

GO

CREATE FULLTEXT INDEX ON [dbo].[Question] KEY INDEX [PK_Question_Id] ON [FT_Question_Text] WITH CHANGE_TRACKING AUTO
GO

ALTER FULLTEXT INDEX ON [dbo].[Question] ADD ([ContentText])
GO

ALTER FULLTEXT INDEX ON [dbo].[Question] ENABLE
GO
------------------------------------
