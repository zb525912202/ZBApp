
PRINT '------ 公告 ------'

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Notice]') AND type in (N'U'))
BEGIN

--公告表(此处为修补脚本，如果数据库内无公告表，则创建公告表)
CREATE TABLE [dbo].[Notice](
	[Id]				INT IDENTITY(1,1) PRIMARY KEY,	-- 唯一标识
	[Title]				NVARCHAR(100) NULL,									--标题
	[Content]			VARBINARY(MAX) NULL,								-- 公告内容
	[HoldDays]			INT NOT NULL,										-- 持续天数
	[CreateDate]		DATETIME NOT NULL,									-- 创建时间
	[StartDate]			DATETIME NOT NULL,									-- 开始时间
	[EndDate]			DATETIME NOT NULL,									-- 结束时间
)

END

GO

