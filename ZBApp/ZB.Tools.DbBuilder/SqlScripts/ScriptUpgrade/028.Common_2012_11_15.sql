

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OperationLog]') AND type in (N'U'))
BEGIN
PRINT'-----ɾ��Common���OperationLog��-----'
DROP TABLE OperationLog;
END

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SponsorLog]') AND type in (N'U'))
BEGIN
PRINT'-----ɾ��Common���SponsorLog��-----'
DROP TABLE SponsorLog;	
END

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FunctionLog]') AND type in (N'U'))
BEGIN
PRINT'-----ɾ��Common���FunctionLog��-----'
DROP TABLE FunctionLog;	
END

