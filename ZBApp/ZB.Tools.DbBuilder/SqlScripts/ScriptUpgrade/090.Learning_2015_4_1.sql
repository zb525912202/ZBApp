IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeNetClassStudyDetail]') AND type in (N'U'))
BEGIN
PRINT'--��Ա������ѵ��ѧϰ��ϸ��'
CREATE TABLE [dbo].[EmployeeNetClassStudyDetail](
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,
	[EmployeeId]			INT NOT NULL,										-- ��ԱId
	[EmployeeName]			NVARCHAR(50) NOT NULL,								-- ��Ա����
	[DeptId]				INT NOT NULL,										-- ����Id	
	[DeptFullPath]			NVARCHAR(260) NOT NULL,								-- ����FullPath
	[PostId]				INT NOT NULL,										-- ��λId
	[PostName]				NVARCHAR(50),										-- ��λ����
	[StudyDate]				SMALLDATETIME NOT NULL,								-- ѧϰʱ��	
	[StudyType]             INT NOT NULL,										-- ѧϰ��ʽ(�����վ�)
	[StudyMode]             INT NOT NULL,										-- ѧϰ��ʽ(���⡢�Ծ���Ƶ����Ƶ���ĵ�������)
	[RequiredTaskId]		INT NOT NULL DEFAULT ((0)),							-- ������ѵ��Id
	[RequiredTaskName]		NVARCHAR(50),										-- ������ѵ������
	[RequiredItemId]		INT NOT NULL DEFAULT ((0)),							-- ������Id
	[RequiredItemName]		NVARCHAR(50),										-- ����������
	[NetClassId]			INT NOT NULL,										-- �γ�ID	
	[NetClassName]			NVARCHAR(50),										-- �γ�����
	[StudyTimeSpan]         INT NOT NULL,										-- ��Чѧϰʱ��(��)
	[LearningPoint]	        DECIMAL(18,2) NOT NULL,								-- ѧϰ����
	[OpenStudyTimeSpan]     INT NOT NULL,										-- ��Чѧϰʱ��(��)
	[OpenLearningPoint]	    DECIMAL(18,2) NOT NULL,								-- ѧϰ����
	[CloseStudyTimeSpan]    INT NOT NULL,										-- ��Чѧϰʱ��(��)
	[CloseLearningPoint]	DECIMAL(18,2) NOT NULL,								-- ѧϰ����	
	[RightCount]			INT NOT NULL,										-- ��������
	[WrongCount]			INT NOT NULL,										-- ��������
	[Month]					INT NOT NULL,										-- ѧϰʱ��֮��
	[Quarter]				INT NOT NULL,										-- ѧϰʱ��֮��
	[HalfYear]				INT NOT NULL,										-- ѧϰʱ��֮����
	[Year]					INT NOT NULL,										-- ѧϰʱ��֮��
	[EmployeeRecordType]    INT NOT NULL,										-- ѧϰ��ʽ֮���˱����м�¼��ѧϰ����(���⡢�Ծ�ý�塢ר����������ѵ��)
)
CREATE UNIQUE NONCLUSTERED INDEX [IDX_EmployeeNetClassStudyDetail_StudyDate_EmployeeId_NetClassId] ON [dbo].[EmployeeNetClassStudyDetail] 
(
	[StudyDate] ASC,
	[EmployeeId] ASC,	
	[NetClassId] ASC
)
END
GO
