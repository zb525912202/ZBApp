USE [$(DatabaseName)]
GO
BEGIN TRANSACTION
insert into TableSeed(TableName,Seed)
values('WebPaperPackageQuestion',0);
COMMIT TRANSACTION