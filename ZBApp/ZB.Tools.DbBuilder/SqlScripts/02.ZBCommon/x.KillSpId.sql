
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[KillSpid]') AND type in (N'P', N'PC'))
BEGIN
	DROP PROC KillSpid;
END

GO

CREATE PROC KillSpid(@dbname varchar(50))
AS
BEGIN
	DECLARE @sql NVARCHAR(500),@temp VARCHAR(1000)
	DECLARE  @spid  INT  
	SET  @sql='DECLARE getspid CURSOR FOR    
	SELECT spid FROM sysprocesses WHERE dbid = db_id('''+@dbname+''')'
	EXEC (@sql)  
	OPEN getspid  
	FETCH NEXT FROM getspid INTO @spid  
	WHILE @@FETCH_STATUS <> -1  
	BEGIN  
		SET @temp='kill ' + RTRIM(@spid)
		EXEC(@temp)
		FETCH NEXT FROM getspid INTO @spid  
	END  
	CLOSE getspid  
	DEALLOCATE getspid  
END

GO
