IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmployeePaiMing]') AND type in (N'U'))
BEGIN
PRINT'--ѧԱ������'
CREATE TABLE [dbo].[EmployeePaiMing]
(
	[Id]								INT IDENTITY(1,1) PRIMARY KEY,
	[EmployeeId]						INT NOT NULL UNIQUE,							--��ԱId
	[IntegratePaiMing]					INT NOT NULL,									--�ۺ�����
	[QuestionPaiMing]					INT NOT NULL,									--��������
	[PaperPaiMing]						INT NOT NULL,									--�Ծ�����
	[MultimediaPaiMing]					INT NOT NULL,									--ý������
	[PreIntegratePaiMing]				INT NOT NULL,									--��һ���ۺ�����
	[PreQuestionPaiMing]				INT NOT NULL,									--��һ����������
	[PrePaperPaiMing]					INT NOT NULL,									--��һ���Ծ�����
	[PreMultimediaPaiMing]				INT NOT NULL,									--��һ��ý������
)
END
GO


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmployeePaiMingComputeDate]') AND type in (N'U'))
BEGIN
PRINT'--ѧԱ��������ʱ���'
CREATE TABLE [dbo].[EmployeePaiMingComputeDate]
(
	[ComputeDate]								DATETIME NOT NULL,					--��������ʱ��
)
END
GO
