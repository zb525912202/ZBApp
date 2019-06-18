DECLARE @sql NVARCHAR(500),@temp VARCHAR(1000)
DECLARE  @spid  INT  
DECLARE getspid CURSOR FOR SELECT spid FROM sysprocesses WHERE dbid = db_id('$(DatabaseName)')
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
GO

PRINT '删除数据库 --> $(DatabaseName)'
IF  EXISTS (
	SELECT name 
		FROM sys.databases 
		WHERE name = N'$(DatabaseName)'
)
DROP DATABASE [$(DatabaseName)]
GO

PRINT '重建数据库 --> $(DatabaseName)'
CREATE DATABASE [$(DatabaseName)]
ON 
( NAME = '$(DatabaseName)',
   FILENAME = '$(DbPath)$(DatabaseName).mdf'
)
LOG ON
( NAME = '$(DatabaseName)_log',
   FILENAME = '$(DbPath)$(DatabaseName)_Log.ldf'
)
GO

