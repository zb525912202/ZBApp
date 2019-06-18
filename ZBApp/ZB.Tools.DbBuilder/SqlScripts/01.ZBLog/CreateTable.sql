PRINT '------ [FunctionLog] ------'
CREATE TABLE [dbo].[FunctionLog]
(
	[Id]				INT IDENTITY(1,1) PRIMARY KEY,
	[LogLevel]			NVARCHAR(50) NULL,
	[LogName]			NVARCHAR(100) NULL,
	[SponsorId]			NVARCHAR(50) NULL,
	[FileName]			NVARCHAR(260) NULL,
	[LineNumber]		INT NULL,
	[ModuleName]		NVARCHAR(100) NULL,
	[FunctionName]		NVARCHAR(100) NULL,
	[Exception]			NVARCHAR(MAX) NULL,
	[StartTime]			DATETIME NULL,
	[StopTime]			DATETIME NULL,
	[Duration]			BIGINT NULL,
	[ExecuteContext]	NVARCHAR(MAX) NULL,
)
GO

PRINT '------ [OperationLog] ------'
CREATE TABLE [dbo].[OperationLog]
(
	[Id] 				INT IDENTITY(1,1) PRIMARY KEY,
	[LogLevel]			NVARCHAR(50) NULL,
	[LogName]			NVARCHAR(100) NULL,
	[SponsorId]			NVARCHAR(50) NULL,
	[OperationType]		NVARCHAR(100) NULL,
	[OperationModule]	NVARCHAR(100) NULL,
	[OperationTarget]	NVARCHAR(100) NULL,
	[Exception]			NVARCHAR(MAX) NULL,
	[StartTime]			DATETIME NULL,
	[StopTime]			DATETIME NULL,
	[Duration]			BIGINT NULL,
)
GO

PRINT '------ [SponsorLog] ------'
CREATE TABLE [dbo].[SponsorLog](
	[Id]				INT IDENTITY(1,1) PRIMARY KEY,
	[SponsorId]			NVARCHAR(50) NOT NULL,
	[ComputerName]		NVARCHAR(100) NULL,
	[UserName]			NVARCHAR(100) NULL,
	[DepartmentName]	NVARCHAR(100) NULL,
	[IpAddress]			NVARCHAR(50) NULL,
	[StartTime]			DATETIME NULL,
	[StopTime]			DATETIME NULL,
	[Duration]			BIGINT NULL,
	[RequestUrl]		NVARCHAR(300) NULL,
)
GO