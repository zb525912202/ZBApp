
IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('Employee') AND name='PMSUserId')
BEGIN
	ALTER TABLE Employee ADD PMSUserId NVARCHAR(50) NULL;
	PRINT '添加Employee内的PMSUserId成功';
END

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ManageType]') AND type in (N'U'))
BEGIN
PRINT '------ 专属类型表 ------'
CREATE TABLE  [dbo].[ManageType](
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,
	[ObjectName]			NVARCHAR(50) NOT NULL,									-- 专属类型表
	[IsDefault]		BIT NOT NULL,				--是否是系统内置默认人员状态，只会有一个系统内置的'在岗'
	[LockStatus]	INT NOT NULL,				--如果是系统内置默认的人员状态，不许改动或删除(值为对应枚举EDictionaryRecordLockStatus的3);新添加项默认为零
	[SortIndex]				INT NOT NULL DEFAULT 0,	
)
END


IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('Trainer') AND name='ManageType')
BEGIN
	ALTER TABLE Trainer ADD ManageType INT NOT NULL DEFAULT 0;
	PRINT '添加Trainer内的ManageType成功';
END


IF NOT EXISTS (SELECT * FROM [ManageType] WHERE ObjectName = '培训专属')
BEGIN
	INSERT INTO [ManageType] ([ObjectName],LockStatus,IsDefault,[SortIndex]) VALUES('培训专属',1,1,1)
END
GO


