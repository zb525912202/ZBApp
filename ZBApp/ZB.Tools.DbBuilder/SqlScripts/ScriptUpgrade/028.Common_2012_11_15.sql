

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OperationLog]') AND type in (N'U'))
BEGIN
PRINT'-----删除Common库的OperationLog表-----'
DROP TABLE OperationLog;
END

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SponsorLog]') AND type in (N'U'))
BEGIN
PRINT'-----删除Common库的SponsorLog表-----'
DROP TABLE SponsorLog;	
END

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FunctionLog]') AND type in (N'U'))
BEGIN
PRINT'-----删除Common库的FunctionLog表-----'
DROP TABLE FunctionLog;	
END

