

PRINT '------ ���� ------'

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SyncDataLog]') AND type in (N'U'))
BEGIN

PRINT '----------[Sync Data ��־��]-------------'
CREATE TABLE [dbo].[SyncDataLog]
(
	[Id]			INT IDENTITY(1,1) PRIMARY KEY,
	[ErrorType]		INT NOT NULL,							--��������
	[ErrorInfo]		NVARCHAR(MAX) NOT NULL,					--������Ϣ
	[ErrorDate]		DATETIME NOT NULL,						--��¼����
	[ErrorData]		VARBINARY(MAX)							--�������ݣ����л��洢��Ϊ��ȡ�Ĳ������ݣ���Ա���ݣ�ӳ�����ݣ�
)

END

GO
