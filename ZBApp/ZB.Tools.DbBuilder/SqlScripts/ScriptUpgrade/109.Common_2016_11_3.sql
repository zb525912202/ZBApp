

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PostStandardCertDemand]') AND type in (N'U'))
BEGIN

PRINT '------ 岗位标准持证要求 ------'
CREATE TABLE  [dbo].[PostStandardCertDemand](
	[Id]					INT PRIMARY KEY NOT NULL,
	[StandardId]			INT NOT NULL,                                       -- 岗位标准
	[CertTypeId]			INT NOT NULL,										-- 证书类型Id
	[CertTypeLevelId]		INT,												-- 证书类型级别Id(最低级别要求)
	[CertTypeKindId]		INT NOT NULL,										-- 证书类型分类Id
)

ALTER TABLE [PostStandardCertDemand] WITH CHECK ADD
	CONSTRAINT [FK_PostStandardCertDemand_PostStandard] FOREIGN KEY([StandardId]) REFERENCES [PostStandard]([Id]),
	CONSTRAINT [FK_PostStandardCertDemand_CertType] FOREIGN KEY([CertTypeId]) REFERENCES [CertType]([Id]),
	CONSTRAINT [FK_PostStandardCertDemand_CertTypeLevel] FOREIGN KEY([CertTypeLevelId]) REFERENCES [CertTypeLevel]([Id]),
	CONSTRAINT [FK_PostStandardCertDemand_CertTypeKind] FOREIGN KEY([CertTypeKindId]) REFERENCES [CertTypeKind]([Id])
END



IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PostStandardLevel]') AND type in (N'U'))
BEGIN

PRINT '-------岗位标准级别---------'
CREATE TABLE [dbo].[PostStandardLevel](
	[Id]				INT PRIMARY KEY,
	[ObjectName]		NVARCHAR(50) NOT NULL,
	[SortIndex]			INT NOT NULL DEFAULT 0
)

END




IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StandardLevelInCertTypeLevel]') AND type in (N'U'))
BEGIN

PRINT '-------不同岗位标准分类的岗位标准级别对应证书级别---------'
CREATE TABLE [dbo].[StandardLevelInCertTypeLevel](
	[Id]					INT PRIMARY KEY,
	[CategoryId]			INT NOT NULL,
	[StandardLevel]			INT NOT NULL,
	[CertTypeId]			INT NOT NULL,
	[CertTypeLevel]			INT NOT NULL
)


ALTER TABLE [StandardLevelInCertTypeLevel] WITH CHECK ADD
	CONSTRAINT [FK_StandardLevelInCertTypeLevel_CategoryId] FOREIGN KEY([CategoryId]) REFERENCES [StandardCategory]([Id]),
	CONSTRAINT [FK_StandardLevelInCertTypeLevel_StandardLevel] FOREIGN KEY([StandardLevel]) REFERENCES [PostStandardLevel]([Id]),
	CONSTRAINT [FK_StandardLevelInCertTypeLevel_CertTypeId] FOREIGN KEY([CertTypeId]) REFERENCES [CertType]([Id]),
	CONSTRAINT [FK_StandardLevelInCertTypeLevel_CertTypeLevel] FOREIGN KEY([CertTypeLevel]) REFERENCES [CertTypeLevel]([Id])
END




IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AbilityItemCategory]') AND type in (N'U'))
BEGIN

PRINT '------ 能力种类 ------'
CREATE TABLE [dbo].[AbilityItemCategory](
	[Id]					INT PRIMARY KEY,
	[StandardId]			INT NOT NULL,							--标准ID
	[ObjectName]			NVARCHAR(100) NOT NULL,					--能力种类名称
	[ItemKind]				NVARCHAR(50),							--能力种类类别(知识、技能、素养)											
	[Number]				VARCHAR(10) NOT NULL,					--能力种类编码
	[SortIndex]				INT NOT NULL DEFAULT 0,								
)

ALTER TABLE [AbilityItemCategory] WITH CHECK ADD
	CONSTRAINT [FK_AbilityItemCategory_StandardId] FOREIGN KEY([StandardId]) REFERENCES [PostStandard]([Id])

--同一标准下能力种类不允许重复
CREATE UNIQUE NONCLUSTERED INDEX [IDX_PostStandard_ObjectName] ON [dbo].[AbilityItemCategory] 
(
	[StandardId] ASC,
	[ObjectName] ASC
)

--同一标准下能力种类编码不允许重复
CREATE UNIQUE NONCLUSTERED INDEX [IDX_PostStandard_Number] ON [dbo].[AbilityItemCategory] 
(
	[StandardId] ASC,
	[Number] ASC
)
END

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AbilityItem]') AND type in (N'U'))
BEGIN
PRINT '------ 能力项 ------'
CREATE TABLE [dbo].[AbilityItem](
	[Id]					INT PRIMARY KEY,
	[AICategoryId]			INT NOT NULL,					--能力种类ID
	[ObjectName]			NVARCHAR(100) NOT NULL,			--能力项名称
	[SortIndex]				INT NOT NULL,					--序号
	[Number]				VARCHAR(10) NOT NULL,			--能力项编码
)

ALTER TABLE [AbilityItem] WITH CHECK ADD
	CONSTRAINT [FK_AbilityItem_AICategoryId] FOREIGN KEY([AICategoryId]) REFERENCES [AbilityItemCategory]([Id])

--同一能力种类下的能力项不允许重复
CREATE UNIQUE NONCLUSTERED INDEX [IDX_AbilityItemCategory_ObjectName] ON [dbo].[AbilityItem] 
(
	[AICategoryId] ASC,
	[ObjectName] ASC
)

--同一能力种类下的能力项编码不允许重复
CREATE UNIQUE NONCLUSTERED INDEX [IDX_AbilityItemCategory_Number] ON [dbo].[AbilityItem] 
(
	[AICategoryId] ASC,
	[Number] ASC
)

END


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AbilityItemLevel]') AND type in (N'U'))
BEGIN

PRINT '------ 能力项+级别 ------'
CREATE TABLE [dbo].[AbilityItemLevel](
	[Id]					INT PRIMARY KEY,
	[ItemId]				INT NOT NULL,
	[LevelId]				INT NOT NULL,
	[LevelDesc]				NVARCHAR(500) NOT NULL
)

ALTER TABLE [AbilityItemLevel] WITH CHECK ADD
	CONSTRAINT [FK_AbilityItemLevel_ItemId] FOREIGN KEY([ItemId]) REFERENCES [AbilityItem]([Id])

ALTER TABLE [AbilityItemLevel] WITH CHECK ADD
	CONSTRAINT [FK_AbilityItemLevel_LevelId] FOREIGN KEY([LevelId]) REFERENCES [PostStandardLevel]([Id])

--同一能力项,同一级别不允许重复
CREATE UNIQUE NONCLUSTERED INDEX [IDX_ItemId_LevelId] ON [dbo].[AbilityItemLevel] 
(
	[ItemId] ASC,
	[LevelId] ASC
)

END



IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TrainingSubject]') AND type in (N'U'))
BEGIN

PRINT '------ 培训科目 ------'
CREATE TABLE [dbo].[TrainingSubject](
	[Id]					INT PRIMARY KEY NOT NULL,
	[Number]				NVARCHAR(50) NOT NULL,				--科目编码
	[ObjectName]			NVARCHAR(100) NOT NULL,				--科目名称
	[SubjectCategory]		INT NOT NULL,						--类别
	[TrainingMode]			INT NOT NULL,						--培训方式
	[TrainingPeriod]		DECIMAL(18,1) NOT NULL,				--培训学时
	[TrainingGoal]			NVARCHAR(500) NOT NULL,				--培训目标
	[AddInfo1]				NVARCHAR(500),						--附加信息（场地、设施，设备等）
	[AddInfo2]				NVARCHAR(500),						--附加信息（安全事项，防护措施）
	[AssessMode]			NVARCHAR(150) NOT NULL,				--考核方式
)

END



IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AbilityItemInSubject]') AND type in (N'U'))
BEGIN

PRINT '------ 能力项级别 + 培训科目 ------'
CREATE TABLE [dbo].[AbilityItemInSubject](
	[Id]				INT PRIMARY KEY NOT NULL,
	[ItemLevelId]		INT NOT NULL,
	[SubjectId]			INT NOT NULL,
)

ALTER TABLE [AbilityItemInSubject] WITH CHECK ADD
	CONSTRAINT [FK_AbilityItemInSubject_ItemLevelId] FOREIGN KEY([ItemLevelId]) REFERENCES [AbilityItemLevel]([Id])

ALTER TABLE [AbilityItemInSubject] WITH CHECK ADD
	CONSTRAINT [FK_AbilityItemInSubject_SubjectId] FOREIGN KEY([SubjectId]) REFERENCES [TrainingSubject]([Id])
END



/*---------------------------------------培训课程----------------------------------------------*/



IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TrainingLesson]') AND type in (N'U'))
BEGIN

PRINT '------培训课程------'
CREATE TABLE [dbo].[TrainingLesson](
	[Id]				INT PRIMARY KEY NOT NULL,				--课程ID
	[ObjectName]		NVARCHAR(100) NOT NULL,					--课程名称
	[StandardId]		INT,									--标准名称
	[SortIndex]			INT NOT NULL,							
)

ALTER TABLE [TrainingLesson] WITH CHECK ADD
	CONSTRAINT [FK_TrainingLesson_StandardId] FOREIGN KEY([StandardId]) REFERENCES [PostStandard]([Id])

--同一标准下课程名称不允许重复
CREATE UNIQUE NONCLUSTERED INDEX [IDX_ObjectName_StandardId] ON [dbo].[TrainingLesson] 
(
	[ObjectName] ASC,
	[StandardId] ASC
)

END



IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TrainingChapter]') AND type in (N'U'))
BEGIN

PRINT '------课程章节------'
CREATE TABLE [dbo].[TrainingChapter](
	[Id]				INT PRIMARY KEY NOT NULL,
	[ObjectName]		NVARCHAR(100) NOT NULL,					--章节名称
	[LessonId]			INT NOT NULL,							--课程ID
	[SortIndex]			INT NOT NULL,
)

ALTER TABLE [TrainingChapter] WITH CHECK ADD
	CONSTRAINT [FK_TrainingChapter_LessonId] FOREIGN KEY([LessonId]) REFERENCES [TrainingLesson]([Id])

--同一标准下课程名称不允许重复
CREATE UNIQUE NONCLUSTERED INDEX [IDX_ObjectName_LessonId] ON [dbo].[TrainingChapter] 
(
	[ObjectName] ASC,
	[LessonId] ASC
)
END



IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TrainingSection]') AND type in (N'U'))
BEGIN

PRINT '------课程模块------'
CREATE TABLE [dbo].[TrainingSection](
	[Id]					INT PRIMARY KEY NOT NULL,
	[Number]				NVARCHAR(50) UNIQUE  NOT NULL,					--模块编码
	[ObjectName]			NVARCHAR(100) NOT NULL,							--模块名称
	[StandardLevelId]		INT NOT NULL,									--模块级别
	[SectionInfo]			NVARCHAR(500) NOT NULL,							--模块描述
)

ALTER TABLE [TrainingSection] WITH CHECK ADD
	CONSTRAINT [FK_TrainingSection_StandardLevelId] FOREIGN KEY([StandardLevelId]) REFERENCES [PostStandardLevel]([Id])

--同一编码下，模块名称不允许重复
CREATE UNIQUE NONCLUSTERED INDEX [IDX_ObjectName_Number] ON [dbo].[TrainingSection] 
(
	[ObjectName] ASC,
	[Number] ASC
)

END


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TrainingSectionInChapter]') AND type in (N'U'))
BEGIN

PRINT '------章节+模块------'
CREATE TABLE [dbo].[TrainingSectionInChapter](
	[Id]				INT PRIMARY KEY NOT NULL,
	[SectionId]			INT NOT NULL,					--模块ID
	[ChapterId]			INT NOT NULL,					--章节ID
)

--同一章节下，模块不允许重复
CREATE UNIQUE NONCLUSTERED INDEX [IDX_SectionId_ChapterId] ON [dbo].[TrainingSectionInChapter] 
(
	[SectionId] ASC,
	[ChapterId] ASC
)

END



IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TrainingSectionInSubject]') AND type in (N'U'))
BEGIN

PRINT '---------科目+模块-----------------'
CREATE TABLE [dbo].[TrainingSectionInSubject](
	[Id]				INT PRIMARY KEY NOT NULL,
	[SectionId]			INT NOT NULL,						--模块ID
	[SubjectId]			INT NOT NULL,						--章节ID
	[SectionIndex]			INT NOT NULL,					--检索序号
)

--同一科目下，模块名称不允许重复
CREATE UNIQUE NONCLUSTERED INDEX [IDX_SectionId_ChapterId] ON [dbo].[TrainingSectionInSubject] 
(
	[SectionId] ASC,
	[SubjectId] ASC
)
END




IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AbilityItemProficiency]') AND type in (N'U'))
BEGIN

PRINT '------------能力项熟练程度-------------------'
CREATE TABLE [dbo].[AbilityItemProficiency](
	[Id]				INT PRIMARY KEY NOT NULL,
	[ObjectName]		NVARCHAR(10) NOT NULL,			--了解、掌握、熟练、精通
	[SortIndex]			INT NOT NULL,
)

END



IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TrainingRequ]') AND type in (N'U'))
BEGIN

PRINT '------培训需求调差-------'
CREATE TABLE [dbo].[TrainingRequ](
	[Id]					INT PRIMARY KEY NOT NULL,
	[ObjectName]			NVARCHAR(50),					--需求调差名称
	[DeptId]				INT NOT NULL,					--需求调差所在的部门
	[StartTime]				DATETIME NOT NULL,				--开始时间
	[EndTime]				DATETIME NOT NULL,				--结束时间
	[DataStartTime]			DATETIME,						--数据有效性开始时间
	[DataEndTime]			DATETIME,						--数据有效性结束时间
	[RequLevel]				INT NOT NULL,					--调查级别(全部，仅二级)
	[IncludeUpLevel]		BIT NOT NULL,					--是否进行各岗位标准的上一级别的调差
)

END



IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TrainingRequIncludeDept]') AND type in (N'U'))
BEGIN

PRINT '------培训需求调差包含的部门范围-------'
CREATE TABLE [dbo].[TrainingRequIncludeDept](
	[Id]				INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[RequId]			INT NOT NULL,			--需求调差ID
	[DeptId]			INT NOT NULL			--部门ID
)

ALTER TABLE [TrainingRequIncludeDept] WITH CHECK ADD
	CONSTRAINT [FK_TrainingRequIncludeDept_RequId] FOREIGN KEY([RequId]) REFERENCES [TrainingRequ]([Id])

END




IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TrainingRequIncludeStandard]') AND type in (N'U'))
BEGIN

PRINT '------培训需求调差包含的标准分类、专业、标准ID-------'
CREATE TABLE [dbo].[TrainingRequIncludeStandard](
	[Id]				INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[RequId]			INT NOT NULL,					--需求调差ID
	[CategoryId]		INT NOT NULL,					--标准分类ID
	[SubjectId]			INT,							--专业ID
	[StandardId]		INT								--标准ID
)

ALTER TABLE [TrainingRequIncludeStandard] WITH CHECK ADD
	CONSTRAINT [FK_TrainingRequIncludeStandard_RequId] FOREIGN KEY([RequId]) REFERENCES [TrainingRequ]([Id])
END




IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TrainingRequResult]') AND type in (N'U'))
BEGIN
PRINT '------培训需求调差结果-------'
CREATE TABLE [dbo].[TrainingRequResult](
	[Id]					INT PRIMARY KEY	NOT NULL,	--结果ID
	[RequId]				INT NOT NULL,				--需求调差ID
	[EmployeeId]			INT NOT NULL,				--人员ID
	[EmployeeName]			NVARCHAR(50) NOT NULL,		--人员姓名
	[StandardId]			INT NOT NULL,				--标准ID
	[StandarName]			NVARCHAR(50) NOT NULL,		--标准名称
	[StandarLevel]			INT NOT NULL,				--标准级别
	[StandarLevelName]		NVARCHAR(50) NOT NULL,		--标准级别名称
	[IsUpLevel]				BIT NOT NULL,				--是否晋升
	[RequSubmitTime]		DATETIME NOT NULL,			--需求提交时间
)

ALTER TABLE [TrainingRequResult] WITH CHECK ADD
	CONSTRAINT [FK_TrainingRequResult_RequId] FOREIGN KEY([RequId]) REFERENCES [TrainingRequ]([Id])
END


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TrainingRequResultDetail]') AND type in (N'U'))
BEGIN
PRINT '培训需求调差结果明细'
CREATE TABLE [dbo].[TrainingRequResultDetail](
	[Id]					INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[ResultId]				INT NOT NULL,				--需求调差结果ID
	[RequId]				INT NOT NULL,				--需求调差ID
	[EmployeeId]			INT NOT NULL,				--人员ID
	[TrainingSectionId]		INT NOT NULL,				--模块ID
	[ProficiencyLevel]		INT NOT NULL,				--熟练程度
)
ALTER TABLE [TrainingRequResultDetail] WITH CHECK ADD
	CONSTRAINT [FK_TrainingRequResultDetail_ResultId] FOREIGN KEY([ResultId]) REFERENCES [TrainingRequResult]([Id])


ALTER TABLE [TrainingRequResultDetail] WITH CHECK ADD
	CONSTRAINT [FK_TrainingRequResultDetail_RequId] FOREIGN KEY([RequId]) REFERENCES [TrainingRequ]([Id])

END