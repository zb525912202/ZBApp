USE master
GO

/*��sql�����ϸ��½ű�ʹ�á������ط�����ʹ��*/



PRINT '�ؽ����ݿ� --> $(DatabaseName)'
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
