IF EXISTS(SELECT * FROM sysindexes WHERE id = object_id('AbilityItemCategory') AND name='IDX_PostStandard_Number')
BEGIN
	DROP INDEX [dbo].[AbilityItemCategory].[IDX_PostStandard_Number]
	PRINT '删除[AbilityItemCategory].[IDX_PostStandard_Number]';
END

IF EXISTS(SELECT * FROM syscolumns WHERE id = object_id('AbilityItemCategory') AND name='Number')
BEGIN
	ALTER TABLE AbilityItemCategory ALTER COLUMN Number VARCHAR(36) NOT NULL;
	PRINT '修改‘AbilityItemCategory’内的‘Number’为长度为VARCHAR(36)';
END


--同一标准下能力种类编码不允许重复
CREATE UNIQUE NONCLUSTERED INDEX [IDX_PostStandard_Number] ON [dbo].[AbilityItemCategory] 
(
	[StandardId] ASC,
	[Number] ASC
)


IF EXISTS(SELECT * FROM syscolumns WHERE id = object_id('AbilityItem') AND name='ObjectName')
BEGIN
	ALTER TABLE AbilityItem ALTER COLUMN ObjectName NVARCHAR(500) NOT NULL;
	PRINT '修改‘AbilityItem’内的‘ObjectName’为长度为NVARCHAR(500)';
END


IF EXISTS(SELECT * FROM syscolumns WHERE id = object_id('AbilityItem') AND name='Number')
BEGIN
	ALTER TABLE AbilityItem ALTER COLUMN Number VARCHAR(36) NOT NULL;
	PRINT '修改‘AbilityItem’内的‘Number’为长度为 VARCHAR(36)';
END



IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeInStandard]') AND type in (N'U'))
BEGIN

PRINT '-------------人员与岗位标准对应关系---------------------'
CREATE TABLE [dbo].[EmployeeInStandard](
	[Id]				INT NOT NULL PRIMARY KEY,		
	[EmployeeId]		INT NOT NULL,				--人员ID
	[StandardId]		INT NOT NULL,				--标准ID
	[LevelId]			INT NOT NULL,				--标准级别
	[IsMian]			BIT NOT NULL,				--是否主岗
)

ALTER TABLE [EmployeeInStandard] WITH CHECK ADD
	CONSTRAINT [FK_EmployeeInStandard_EmployeeId] FOREIGN KEY([EmployeeId]) REFERENCES [Employee]([Id])

ALTER TABLE [EmployeeInStandard] WITH CHECK ADD
	CONSTRAINT [FK_EmployeeInStandard_StandardId] FOREIGN KEY([StandardId]) REFERENCES [PostStandard]([Id])

ALTER TABLE [EmployeeInStandard] WITH CHECK ADD
	CONSTRAINT [FK_EmployeeInStandard_LevelId] FOREIGN KEY([LevelId]) REFERENCES [PostStandardLevel]([Id])

END


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TeacherGiveRecord]') AND type in (N'U'))
BEGIN

PRINT '---------培训师授课记录------------'

CREATE TABLE [dbo].[TeacherGiveRecord](
	[Id]				INT IDENTITY(1,1) PRIMARY KEY,
	[EmployeeId]		INT NOT NULL,												--培训师ID
	[GiveInfo]			NVARCHAR(500) NULL,											--授课信息
	[StartDate]			DATETIME NOT NULL,											--开始时间
	[EndDate]			DATETIME,													--结束时间
	[CiveHour]			DECIMAL(18,1) NOT NULL,										--授课课时
)

ALTER TABLE [TeacherGiveRecord] WITH CHECK ADD
	CONSTRAINT [FK_TeacherGiveRecord_Teacher] FOREIGN KEY([EmployeeId]) REFERENCES [Teacher]([EmployeeId])

END