
PRINT '------ ���� ------'

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Notice]') AND type in (N'U'))
BEGIN

--�����(�˴�Ϊ�޲��ű���������ݿ����޹�����򴴽������)
CREATE TABLE [dbo].[Notice](
	[Id]				INT IDENTITY(1,1) PRIMARY KEY,	-- Ψһ��ʶ
	[Title]				NVARCHAR(100) NULL,									--����
	[Content]			VARBINARY(MAX) NULL,								-- ��������
	[HoldDays]			INT NOT NULL,										-- ��������
	[CreateDate]		DATETIME NOT NULL,									-- ����ʱ��
	[StartDate]			DATETIME NOT NULL,									-- ��ʼʱ��
	[EndDate]			DATETIME NOT NULL,									-- ����ʱ��
)

END

GO

