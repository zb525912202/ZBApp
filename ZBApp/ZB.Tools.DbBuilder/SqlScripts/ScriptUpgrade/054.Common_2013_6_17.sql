

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BuzMessage]') AND type in (N'U'))
BEGIN
PRINT '----------[通知消息]-------------'
CREATE TABLE [dbo].[BuzMessage](
	[Id]							INT PRIMARY KEY,
	[TypeId]						INT NOT NULL,
	[Text]							NVARCHAR(50) NOT NULL,		
	[ObjectId]						INT NOT NULL,
	[ObjectMD5]						NVARCHAR(50) NULL,
	[CreateTime]					DATETIME NOT NULL,
	[LastUpdateTime]				DATETIME NOT NULL,
	[ExpirationTime]				DATETIME,
	[Attachment]					VARBINARY(MAX)
)
CREATE UNIQUE NONCLUSTERED INDEX [IDX_ObjectId_TypeId] ON [dbo].[BuzMessage] 
(
	[ObjectId] ASC,
	[TypeId] ASC
)
END

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BuzEmployeeMessage]') AND type in (N'U'))
BEGIN
PRINT '----------[通知消息]-------------'
CREATE TABLE [dbo].[BuzEmployeeMessage](
	[Id]							INT PRIMARY KEY,
	[BuzMessageId]					INT NOT NULL,
	[EmployeeId]					INT NOT NULL,
	[EmployeeTypeId]				INT NOT NULL,
	[MarkedTime]					DATETIME,
	[LastUpdateTime]				DATETIME NOT NULL,
	[Text]							NVARCHAR(50) NULL,
	[Attachment]					VARBINARY(MAX)	
)
CREATE UNIQUE NONCLUSTERED INDEX [IDX_BuzMessageId_EmployeeId_EmployeeTypeId] ON [dbo].[BuzEmployeeMessage] 
(
	[BuzMessageId] ASC,
	[EmployeeId] ASC,
	[EmployeeTypeId] ASC
)
END
