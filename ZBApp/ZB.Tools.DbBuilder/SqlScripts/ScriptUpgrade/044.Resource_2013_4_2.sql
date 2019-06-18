

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RecommendRFile]') AND type in (N'U'))
BEGIN

PRINT '------ 媒体推荐 ------'
CREATE TABLE [dbo].[RecommendRFile](
	[Id]						INT IDENTITY(1,1) PRIMARY KEY NOT NULL,				-- 唯一标识
	[RFileId]					INT NOT NULL,										-- RFileId
	[SortIndex]					INT NOT NULL DEFAULT ((0)),							-- 排序索引
	[RecommendEmployeeId]		INT NOT NULL,										-- 推荐人ID
	[RecommendEmployeeName]		NVARCHAR(50) NOT NULL,								-- 推荐人姓名	
)
ALTER TABLE [RecommendRFile]  WITH CHECK ADD  
	CONSTRAINT [FK_RecommendRFile_RFile] FOREIGN KEY([RFileId]) REFERENCES RFile ([Id])
END
GO
