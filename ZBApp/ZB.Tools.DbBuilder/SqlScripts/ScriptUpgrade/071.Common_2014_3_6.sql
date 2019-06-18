PRINT '------ 友情链接 ------'

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FriendLink]') AND type in (N'U'))
BEGIN

--友情链接表(此处为修补脚本，如果数据库内无友情链接表，则创建友情链接表)
CREATE TABLE [dbo].[FriendLink]
(
	[Id]			INT IDENTITY(1,1) PRIMARY KEY,
	[FriendLinkTitle]		NVARCHAR(100) NOT NULL,							--友情链接标题
	[FriendLinkUrl]		NVARCHAR(200) NOT NULL,					--友情链接地址
	[SortIndex]		int NOT NULL,						--排序索引
)
END

GO