

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RequiredTrainee]') AND type in (N'U'))
BEGIN



PRINT'--------------ɾ���ϳ���������ѵ���------------'
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeQuesRequiredItemDetail]') AND type in (N'U'))
DROP TABLE dbo.EmployeeQuesRequiredItemDetail;
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmployeePaperRequiredItemDetail]') AND type in (N'U'))
DROP TABLE dbo.EmployeePaperRequiredItemDetail;
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeResourceRequiredItemDetail]') AND type in (N'U'))
DROP TABLE dbo.EmployeeResourceRequiredItemDetail;

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AFileRequiredItem]') AND type in (N'U'))
DROP TABLE dbo.AFileRequiredItem;
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RFileRequiredItem]') AND type in (N'U'))
DROP TABLE dbo.RFileRequiredItem;

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PQRequiredItemRule]') AND type in (N'U'))
DROP TABLE dbo.PQRequiredItemRule;
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PQRequiredPaperPackage]') AND type in (N'U'))
DROP TABLE dbo.PQRequiredPaperPackage;
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PQRequiredItem]') AND type in (N'U'))
DROP TABLE dbo.PQRequiredItem;
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RequiredTaskFinishInfo]') AND type in (N'U'))
DROP TABLE dbo.RequiredTaskFinishInfo;
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RequiredTaskPassInfo]') AND type in (N'U'))
DROP TABLE dbo.RequiredTaskPassInfo;

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RequiredTask]') AND type in (N'U'))
DROP TABLE dbo.RequiredTask;

PRINT'--------------���ѧ��30����ʱѧϰ��¼��ļ�¼------------'
TRUNCATE TABLE dbo.EmployeeStudyInfo;

PRINT'--������ѵ���'
CREATE TABLE  [dbo].[RequiredTask](
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,	
	[ObjectName]			NVARCHAR(50) NOT NULL,								-- ��������
	[DeptId]				INT NOT NULL,										-- ����Id	
	[EndTime]				SMALLDATETIME NOT NULL,								-- ����ʱ��
	[CreateTime]			DATETIME NOT NULL,									-- ����ʱ��
	[CreatorId]				INT NOT NULL,										-- ������Id
	[CreatorName]			NVARCHAR(50) NOT NULL,								-- ����������	
	[RequiredTaskState]     INT NOT NULL,										-- ������ѵ��״̬(��������ͣ)
	[RequiredTaskExByte]    VARBINARY(MAX),										-- ������ѵ����չ����(�����ѯ)
)

PRINT '------������ѵ��ѧԱ------'
CREATE TABLE [dbo].[RequiredTrainee](
	[Id]						INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[RequiredTaskId]			INT NOT NULL,										--������ѵ��ID	
	[EmployeeId]				INT NOT NULL,										--��ԱId
	[EmployeeNO]				NVARCHAR(50) NOT NULL,								--����
	[TraineeName]				NVARCHAR(50) NOT NULL,								--����
	[Age]						INT,												--����
	[Sex]						INT NOT NULL,										--�Ա� 0:�� 1:�� -1:Ů
	[DeptFullPath]				NVARCHAR(260) NOT NULL,								--����
	[PostName]					NVARCHAR(50),										--��λ
)
ALTER TABLE [RequiredTrainee]  WITH CHECK ADD  
	CONSTRAINT [FK_RequiredTrainee_RequiredTask] FOREIGN KEY([RequiredTaskId]) REFERENCES [RequiredTask] ([Id])

CREATE UNIQUE NONCLUSTERED INDEX [IDX_RequiredTaskId_EmployeeId] ON [dbo].[RequiredTrainee] 
(
	[RequiredTaskId] ASC,
	[EmployeeId] ASC
)


PRINT'--���������'
CREATE TABLE  [dbo].[PQRequiredItem](
	[Id]						INT IDENTITY(1,1) PRIMARY KEY,	
	[RequiredTaskId]			INT NOT NULL,										-- ������ѵ��Id	
	[PassScore]					DECIMAL(18,1) NOT NULL,								-- �ϸ��	
	[PaperScore]				DECIMAL(18,1) NOT NULL,								-- �Ծ��ܷ�
	[RuleDescribe]				NVARCHAR(400) NULL,									-- ����������Ҫ������
)
ALTER TABLE [PQRequiredItem]  WITH CHECK ADD  
	CONSTRAINT [FK_PQRequiredItem_RequiredTask] FOREIGN KEY([RequiredTaskId]) REFERENCES RequiredTask ([Id])

PRINT'--����������Ҫ���'
CREATE TABLE  [dbo].[PQRequiredItemRule](
	[Id]						INT IDENTITY(1,1) PRIMARY KEY,	
	[RequiredTaskId]			INT NOT NULL,										-- ������ѵ��Id
	[PQRequiredItemId]			INT NOT NULL,										-- ��������Id
	[QtId]						INT NOT NULL,										-- ����Id
	[RightQuesCount]			INT NOT NULL DEFAULT ((0)),							-- �������
	[RightPercent]				DECIMAL(18,2) NOT NULL DEFAULT ((0)),				-- ��ȷ��
)
ALTER TABLE [PQRequiredItemRule]  WITH CHECK ADD  
	CONSTRAINT [FK_PQRequiredItemRule_PQRequiredItem] FOREIGN KEY([PQRequiredItemId]) REFERENCES PQRequiredItem ([Id])


PRINT'--�Ծ��'
CREATE TABLE [dbo].[PQRequiredPaperPackage](
	[Id]							INT IDENTITY(1,1) PRIMARY KEY  NOT NULL,			-- Ψһ��ʶ
	[RequiredTaskId]				INT NOT NULL,										-- ������ѵ��Id
	[PQRequiredItemId]				INT NOT NULL,										-- ��������Id
	[IsImpersonal]					BIT NOT NULL,										-- �Ƿ�͹۾�
	[ObjectName]					VARCHAR(50) NOT NULL,								-- �Ծ������	
	[CreatorId]						INT NOT NULL,										-- ������Id
	[CreatorName]					NVARCHAR(50) NOT NULL,								-- ������Name	
	[CreateTime]					DATETIME NOT NULL,									-- ����ʱ��	
	[LastUpdateTime]				DATETIME NOT NULL,									-- ���һ���޸�ʱ��
	[HardRate]						DECIMAL(18,1) NOT NULL DEFAULT ((0)),				-- �Ѷ�ϵ��
	[Describe]						NVARCHAR(400) NULL,									-- ����(֪ʶ��)
	[PaperPackageQuestionCount]		INT NOT NULL DEFAULT ((0)),							-- �Ծ����������
	[IsIncludeSln]					BIT NOT NULL DEFAULT 0,								-- �Ƿ���������
	[PaperScore]					DECIMAL(18,1) NOT NULL DEFAULT ((0)),				-- �Ծ��ܷ�
	[PaperQuesCount]				INT NOT NULL DEFAULT ((0)),							-- �Ծ�����
	[PaperSolutionObjBytes]			VARBINARY(MAX),										-- �����
	[ExportConfig]					VARBINARY(MAX),										-- �Ծ�������	
)
ALTER TABLE [PQRequiredPaperPackage]  WITH CHECK ADD  
	CONSTRAINT [FK_PQRequiredPaperPackage_PQRequiredItem] FOREIGN KEY([PQRequiredItemId]) REFERENCES PQRequiredItem ([Id])


--�Ծ��������ñ�̬���ɣ�����Ϊ��PQRequiredPaperPackageQuestion_�� + ���Ծ��ID��
/*
CREATE TABLE [dbo].[PQRequiredPaperPackageQuestion_{0}](
	[Id]					INT PRIMARY KEY  NOT NULL,				--��ʶ
	[QuestionId]			INT NOT NULL,							--����ID
	[PaperPackageId]		INT NOT NULL,							--�Ծ��ID
	[HardLevel]	    		INT NOT NULL,							--���׶�
	[QtId]					INT NOT NULL,							--����ID
	[ContentText]			NVARCHAR(400) NULL,						--�����ı�
	[AnswerText]			NVARCHAR(MAX) NULL,						--���ı�
	[AnalysisText]			NVARCHAR(MAX) NULL,						--�����ı�	
	[Content]				VARBINARY(MAX) NOT NULL,				--����
	[Answer]				VARBINARY(MAX) NULL,					--��
	[Analysis]				VARBINARY(MAX) NULL						--����
	[ContentLength]			INT NOT NULL,							-- ��������Rtf�ֽ���
	[AnswerLength]			INT NOT NULL,							-- �����Rtf�ֽ���
	[AnalysisLength]		INT NOT NULL,							-- �������Rtf�ֽ���
)
*/

PRINT'--ý��������(RFile)'
CREATE TABLE [dbo].[RFileRequiredItem](
	[Id]						INT PRIMARY KEY NOT NULL,							-- Ψһ��ʶ
	[ObjectName]				NVARCHAR(255) NOT NULL,								-- �ļ�����	
	[SourceName]				NVARCHAR(255) NOT NULL,								-- ԭʼ�ļ�����	
	[ConvertName]				NVARCHAR(255) NOT NULL,								-- ת���ļ�����	
	[SourceId]					INT NOT NULL,										-- ԭʼ��ԴID
	[ParentId]					INT NOT NULL,										-- RequiredTaskId
	[FileType]					INT NOT NULL,										-- �ļ�����
	[FileTypeExt]				INT NOT NULL,										-- �ļ���չ������׺����
	[FileSize]					BIGINT NOT NULL,									-- �ļ���С
	[UploadPathIndex]			INT NOT NULL,										-- �ļ���ŵ��ϴ�Ŀ¼����
	[PreviewCount]				INT NOT NULL DEFAULT ((0)),							-- ����ͼ����
	[ContentLength]				BIGINT NOT NULL,									-- ���ݳ���(ʱ����ҳ��)
	[GUID]						NVARCHAR(50) NOT NULL,								-- Guid	
	[Md5]						NVARCHAR(50) NOT NULL,								-- Md5	
	[SortIndex]					INT NOT NULL DEFAULT ((0)),							-- ��������
	[StudyTimeSpan]				INT NOT NULL,										-- ѧϰʱ��(��)
	[RecommendCount]			INT NOT NULL DEFAULT ((0)),							-- �Ƽ�����
	[UnRecommendCount]			INT NOT NULL DEFAULT ((0)),							-- ���Ƽ�����
	[StudyTimes]				INT NOT NULL DEFAULT ((0)),							-- ѧϰ�˴�
)

PRINT'--ý��������(AFile)'
CREATE TABLE [dbo].[AFileRequiredItem](
	[Id]						INT PRIMARY KEY NOT NULL,							-- Ψһ��ʶ
	[ObjectName]				NVARCHAR(255) NOT NULL,								-- �ļ�����	
	[SourceName]				NVARCHAR(255) NOT NULL,								-- ԭʼ�ļ�����	
	[ConvertName]				NVARCHAR(255) NOT NULL,								-- ת���ļ�����	
	[SourceId]					INT NOT NULL,										-- ԭʼ��ԴID
	[ParentId]					INT NOT NULL,										-- RFileRequiredItemId
	[FileType]					INT NOT NULL,										-- �ļ�����
	[FileTypeExt]				INT NOT NULL,										-- �ļ���չ������׺����
	[FileSize]					BIGINT NOT NULL,									-- �ļ���С
	[UploadPathIndex]			INT NOT NULL,										-- �ļ���ŵ��ϴ�Ŀ¼����
	[PreviewCount]				INT NOT NULL DEFAULT ((0)),							-- ����ͼ����
	[ContentLength]				BIGINT NOT NULL,									-- ���ݳ���(ʱ����ҳ��)
	[GUID]						NVARCHAR(50) NOT NULL,								-- Guid	
	[Md5]						NVARCHAR(50) NOT NULL,								-- Md5	
	[SortIndex]					INT NOT NULL DEFAULT ((0)),							-- ��������
	[StudyTimeSpan]				INT NOT NULL,										-- ѧϰʱ��(��)	
	[RecommendCount]			INT NOT NULL DEFAULT ((0)),							-- �Ƽ�����
	[UnRecommendCount]			INT NOT NULL DEFAULT ((0)),							-- ���Ƽ�����
	[StudyTimes]				INT NOT NULL DEFAULT ((0)),							-- ѧϰ�˴�
)
ALTER TABLE [AFileRequiredItem]  WITH CHECK ADD  
	CONSTRAINT [FK_AFileRequiredItem_RFileRequiredItem] FOREIGN KEY([ParentId]) REFERENCES RFileRequiredItem ([Id])


PRINT'--������ѵ����������(RequiredTaskPassInfo)'
CREATE TABLE [dbo].[RequiredTaskPassInfo](
	[Id]							INT IDENTITY(1,1) PRIMARY KEY  NOT NULL,			-- Ψһ��ʶ
	[RequiredTaskId]			INT NOT NULL,										-- ������ѵ��Id
	[EmployeeId]				INT NOT NULL,										-- ��ԱId
	[EmployeeNO]				NVARCHAR(50) NOT NULL,								-- ����
	[TraineeName]				NVARCHAR(50) NOT NULL,								-- ����
	[Age]						INT,												-- ����
	[Sex]						INT NOT NULL,										-- �Ա� 0:�� 1:�� -1:Ů
	[DeptFullPath]				NVARCHAR(260) NOT NULL,								-- ����
	[PostName]					NVARCHAR(50),										-- ��λ
	[PassTime]					DATETIME NOT NULL,									-- ���ʱ��
)

CREATE UNIQUE NONCLUSTERED INDEX [IDX_RequiredTaskId_EmployeeId] ON [dbo].[RequiredTaskPassInfo] 
(
	[RequiredTaskId] ASC,
	[EmployeeId] ASC
)


-------------------------------������ѧϰ���-----------------------------{
PRINT'--��Ա�����������'
CREATE TABLE [dbo].[EmployeeQuesRequiredItemDetail](
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,
	[EmployeeId]			INT NOT NULL,										-- ��ԱId	
	[DeptId]				INT NOT NULL,										-- ����ID	
	[RequiredTaskId]		INT NOT NULL,										-- ������ѵ��Id
	[RequiredItemId]		INT NOT NULL,										-- ��������Id
	[QtId]					INT NOT NULL,										-- ����ID
	[RightCount]			INT NOT NULL,										-- ��������
	[WrongCount]			INT NOT NULL,										-- ��������
)
CREATE NONCLUSTERED INDEX [IDX_RequiredItemId_QtId] ON [dbo].[EmployeeQuesRequiredItemDetail] 
(
	[RequiredItemId] ASC,
	[QtId] ASC
)


PRINT'--��Ա�Ծ��������'
CREATE TABLE [dbo].[EmployeePaperRequiredItemDetail](
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,
	[EmployeeId]			INT NOT NULL,										-- ��ԱId	
	[DeptId]				INT NOT NULL,										-- ����ID	
	[RequiredTaskId]		INT NOT NULL,										-- ������ѵ��Id
	[RequiredItemId]		INT NOT NULL,										-- ��������Id	
	[Score]					DECIMAL(18,1) NOT NULL,								-- �÷�
	[PassScore]				DECIMAL(18,1) NOT NULL,								-- ͨ����
	[PaperScore]			DECIMAL(18,1) NOT NULL,								-- �Ծ��ܷ�
	[PaperQuesCount]		INT NOT NULL,										-- �Ծ�����
	[IsPassed]				BIT NOT NULL,										-- �Ƿ�ͨ��
	[SubmitTime]			DateTime NOT NULL,									-- ����ʱ��
)

PRINT'--��Աý���������'
CREATE TABLE [dbo].[EmployeeResourceRequiredItemDetail](
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,
	[EmployeeId]			INT NOT NULL,										-- ��ԱId	
	[DeptId]				INT NOT NULL,										-- ����ID	
	[RequiredTaskId]		INT NOT NULL,										-- ������ѵ��Id
	[RequiredItemId]		INT NOT NULL,										-- ý�������Id	
	[StudyTimeSpan]         INT NOT NULL,										-- ��Чѧϰʱ��(��)
)
CREATE NONCLUSTERED INDEX [IDX_RequiredItemId] ON [dbo].[EmployeeResourceRequiredItemDetail] 
(
	[RequiredItemId] ASC
)

-------------------------------������ѧϰ���-----------------------------}




END
