--088.Common_2015_3_5
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[NoticeAnnex]') AND type in (N'U'))
BEGIN
	PRINT '------ 公告附件 ------'
	CREATE TABLE [dbo].[NoticeAnnex](
		[Id]				INT IDENTITY(1,1) PRIMARY KEY,	-- 唯一标识
		[NoticeId]			INT NOT NULL,					-- 公告ID
		[StoreFileName]		NVARCHAR(200) NOT NULL,			-- 存储所用文件名
		[TrueFileName]		NVARCHAR(200) NOT NULL			-- 真实文件名
	)
	ALTER TABLE [NoticeAnnex] WITH CHECK ADD
		CONSTRAINT [FK_NoticeAnnex_Notice] FOREIGN KEY([NoticeId]) REFERENCES [Notice]([Id])
END



