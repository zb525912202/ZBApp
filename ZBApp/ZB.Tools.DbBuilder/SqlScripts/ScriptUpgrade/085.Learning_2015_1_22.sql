IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeStudyHistory]') AND type in (N'U'))
BEGIN
PRINT'--��Ա���ѧϰ�����ʷ��'
CREATE TABLE [dbo].[EmployeeStudyHistory](
	[Id]						INT IDENTITY(1,1) PRIMARY KEY,
	[EmployeeId]				INT NOT NULL,										-- ��ԱId
	[ResourceId]				INT NOT NULL,										-- ��ԴId
	[EmployeeStudyHistoryType]	INT NOT NULL,										-- ��Դ����
	[CreateTime]				DATETIME NOT NULL,									-- ����ʱ��	
	[Tag1]						BIT NOT NULL,										-- �Ƿ�����Ӳ��ţ����������¼
	[Tag2]						INT NOT NULL,										-- ѧϰ���ͣ������վ�
)
CREATE UNIQUE NONCLUSTERED INDEX [IDX_EmployeeStudyHistory_EmployeeId_ResourceId_EmployeeStudyHistoryType] ON [dbo].[EmployeeStudyHistory] 
(
	[EmployeeId] ASC,
	[ResourceId] ASC,
	[EmployeeStudyHistoryType] ASC
)
END
GO
