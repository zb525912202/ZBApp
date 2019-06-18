

PRINT '------ 公告 ------'

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SyncDataLog]') AND type in (N'U'))
BEGIN

PRINT '----------[Sync Data 日志表]-------------'
CREATE TABLE [dbo].[SyncDataLog]
(
	[Id]			INT IDENTITY(1,1) PRIMARY KEY,
	[ErrorType]		INT NOT NULL,							--错误类型
	[ErrorInfo]		NVARCHAR(MAX) NOT NULL,					--错误信息
	[ErrorDate]		DATETIME NOT NULL,						--记录日期
	[ErrorData]		VARBINARY(MAX)							--错误数据（序列化存储，为获取的部门数据，人员数据，映射数据）
)

END

GO
