

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ExportHistory]') AND type in (N'U'))
BEGIN
PRINT '------ ������ʷ�� ------'
CREATE TABLE [dbo].[ExportHistory](
	[Id]						INT IDENTITY(1,1) PRIMARY KEY NOT NULL,				-- Ψһ��ʶ
	[PaperPackageId]				INT NOT NULL,									-- �Ծ��ID
	[ExportEmployeeId]			INT NOT NULL,										-- ������Id
	[ExportEmployeeName]		NVARCHAR(50) NOT NULL,								-- ����������
	[ExportTime]				DATETIME NOT NULL,									-- ����ʱ��
)
ALTER TABLE [ExportHistory]  WITH CHECK ADD  
	CONSTRAINT [FK_ExportHistory_PaperPackage] FOREIGN KEY([PaperPackageId]) REFERENCES PaperPackage ([Id])

END


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ExportHistoryPaper]') AND type in (N'U'))
BEGIN
PRINT '------ ������ʷ�Ծ�� ------'
CREATE TABLE [dbo].[ExportHistoryPaper](
	[Id]							INT PRIMARY KEY NOT NULL,					
	[PaperPackageId]				INT NOT NULL,											-- �Ծ��ID
	[ExportHistoryId]				INT NOT NULL,											-- ��ʷ��ID
	[ObjectName]					NVARCHAR(50) NOT NULL,									-- �Ծ�����
	[PaperScore]					DECIMAL(18,1) NOT NULL DEFAULT ((0)),					-- �Ծ��ܷ�
	[PaperQuesCount]				INT NOT NULL DEFAULT ((0)),								-- �Ծ�����
	[IsRandomPaper]					BIT NOT NULL DEFAULT 0,									-- �Ƿ������
)
ALTER TABLE [ExportHistoryPaper]  WITH CHECK ADD  
	CONSTRAINT [FK_ExportHistoryPaper_ExportHistory] FOREIGN KEY([ExportHistoryId]) REFERENCES ExportHistory ([Id])
ENd


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ExportHistoryPaperDetail]') AND type in (N'U'))
BEGIN
PRINT '------ ������ʷ�Ծ���ϸ�� ------'
CREATE TABLE [dbo].[ExportHistoryPaperDetail](
	[Id]						INT IDENTITY(1,1) PRIMARY KEY NOT NULL,				-- Ψһ��ʶ
	[PaperPackageId]			INT NOT NULL,										-- �Ծ��ID
	[ExportHistoryId]			INT NOT NULL,										-- ��ʷ��ID
	[ExportHistoryPaperId]		INT NOT NULL,										-- ������ʷ�Ծ��Id
	[PaperPackageQuestionId]	INT NOT NULL,										-- �Ծ������Id
	[TotalScore]				DECIMAL(18,1) NOT NULL DEFAULT ((0)),				-- �Ծ���������
)
ALTER TABLE [ExportHistoryPaperDetail]  WITH CHECK ADD  
	CONSTRAINT [FK_ExportHistoryPaperDetail_ExportHistoryPaper] FOREIGN KEY([ExportHistoryPaperId]) REFERENCES ExportHistoryPaper ([Id])
END

GO
