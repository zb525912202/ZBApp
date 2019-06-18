

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EGLearningTask]') AND type in (N'U'))
BEGIN
PRINT'--��Ա������ѧϰ�����'
CREATE TABLE  [dbo].[EGLearningTask](
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,
	[ObjectName]			NVARCHAR(50) NOT NULL,								-- ��������
	[EmployeeGroupId]		INT NOT NULL,										-- ��Ա��Id
	[StartTime]				DATETIME NOT NULL,									-- ��ʼʱ��
	[EndTime]				DATETIME NOT NULL,									-- ����ʱ��
	[CreateTime]			DATETIME NOT NULL,									-- ����ʱ��
	[CreatorId]				INT NOT NULL,										-- ������Id
	[CreatorName]			NVARCHAR(50) NOT NULL,								-- ����������
	[TaskRule]              VARBINARY(MAX),										-- ����ѧϰ���ֹ���
	[EmployeeRule]          VARBINARY(MAX),										-- ����ѧϰ��Ա���ֹ���
)
END
GO
