--088.Common_2015_3_5
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[NoticeAnnex]') AND type in (N'U'))
BEGIN
	PRINT '------ ���渽�� ------'
	CREATE TABLE [dbo].[NoticeAnnex](
		[Id]				INT IDENTITY(1,1) PRIMARY KEY,	-- Ψһ��ʶ
		[NoticeId]			INT NOT NULL,					-- ����ID
		[StoreFileName]		NVARCHAR(200) NOT NULL,			-- �洢�����ļ���
		[TrueFileName]		NVARCHAR(200) NOT NULL			-- ��ʵ�ļ���
	)
	ALTER TABLE [NoticeAnnex] WITH CHECK ADD
		CONSTRAINT [FK_NoticeAnnex_Notice] FOREIGN KEY([NoticeId]) REFERENCES [Notice]([Id])
END



