

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RecommendRFile]') AND type in (N'U'))
BEGIN

PRINT '------ ý���Ƽ� ------'
CREATE TABLE [dbo].[RecommendRFile](
	[Id]						INT IDENTITY(1,1) PRIMARY KEY NOT NULL,				-- Ψһ��ʶ
	[RFileId]					INT NOT NULL,										-- RFileId
	[SortIndex]					INT NOT NULL DEFAULT ((0)),							-- ��������
	[RecommendEmployeeId]		INT NOT NULL,										-- �Ƽ���ID
	[RecommendEmployeeName]		NVARCHAR(50) NOT NULL,								-- �Ƽ�������	
)
ALTER TABLE [RecommendRFile]  WITH CHECK ADD  
	CONSTRAINT [FK_RecommendRFile_RFile] FOREIGN KEY([RFileId]) REFERENCES RFile ([Id])
END
GO
