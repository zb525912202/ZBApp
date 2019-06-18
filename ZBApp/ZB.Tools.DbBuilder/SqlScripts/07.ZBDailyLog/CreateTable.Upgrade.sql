USE master
GO

/*此sql语句配合更新脚本使用。其他地方不用使用*/



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
