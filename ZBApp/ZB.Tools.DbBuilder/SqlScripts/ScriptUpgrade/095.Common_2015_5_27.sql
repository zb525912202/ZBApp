
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StandardCategory]') AND type in (N'U'))
BEGIN
PRINT '------ 标准分类 ------'
CREATE TABLE [dbo].[StandardCategory](
	[Id]					INT PRIMARY KEY,			--分类ID
	[ObjectName]			NVARCHAR(50) NOT NULL,					--分类名称
	[SortIndex]				INT NOT NULL DEFAULT 0,					--排序序号
	[LockStatus]			INT NOT NULL DEFAULT 0,					--内置的岗位标准，不许改动或删除(值为对应枚举EDictionaryRecordLockStatus的3);新添加项默认为零
)

PRINT '----------向岗位标准类型表插入默认数据（其他）---------------------'
IF((SELECT COUNT(*) FROM StandardCategory WHERE ObjectName = '其他')=0)
BEGIN
	INSERT INTO StandardCategory(Id, ObjectName, SortIndex, LockStatus)
	SELECT ISNULL(MAX(Id)+1,1), '其他', 0, 3 FROM StandardCategory
END

END
GO


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PostSubject]') AND type in (N'U'))
BEGIN
PRINT '--------专业---------------'
CREATE TABLE [dbo].[PostSubject](
	[Id]					INT PRIMARY KEY,			--专业ID
	[CategoryId]			INT NOT NULL,							--标准分类ID
	[ObjectName]			NVARCHAR(50) NOT NULL,					--专业名称
	[SortIndex]				INT NOT NULL DEFAULT 0,					--排序序号	
)

ALTER TABLE [PostSubject] WITH CHECK ADD
	CONSTRAINT [FK_PostSubject_CategoryId] FOREIGN KEY([CategoryId]) REFERENCES [StandardCategory]([Id])

CREATE UNIQUE NONCLUSTERED INDEX [IDX_PostSubject_ObjectName] ON [dbo].[PostSubject] 
(
	[CategoryId] ASC,
	[ObjectName] ASC
)
END
GO


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PostStandard]') AND type in (N'U'))
BEGIN
PRINT '--------岗位标准---------------'
CREATE TABLE [dbo].[PostStandard](
	[Id]					INT PRIMARY KEY,			--岗位标准ID
	[CategoryId]			INT NOT NULL,							--标准分类ID
	[SubjectId]				INT,									--专业ID（可为空）
	[ObjectName]			NVARCHAR(50) NOT NULL,					--岗位标准名称
	[Describe]				VARBINARY(MAX),							--描叙
	[SortIndex]				INT NOT NULL DEFAULT 0,					--排序序号
)

ALTER TABLE [PostStandard] WITH CHECK ADD
	CONSTRAINT [FK_PostStandard_CategoryId] FOREIGN KEY([CategoryId]) REFERENCES [StandardCategory]([Id])

ALTER TABLE [PostStandard] WITH CHECK ADD
	CONSTRAINT [FK_PostStandard_SubjectId] FOREIGN KEY([SubjectId]) REFERENCES [PostSubject]([Id])

CREATE UNIQUE NONCLUSTERED INDEX [IDX_PostStandard_ObjectName] ON [dbo].[PostStandard] 
(
	[CategoryId] ASC,
	[ObjectName] ASC
)

END
GO


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PostInStandard]') AND type in (N'U'))
BEGIN
PRINT '--------岗位与岗位标准的对应关系-------------'
/*现在的规则是一个岗位仅能对应一个岗位标准，建立此表的原因是考虑后期一个岗位可对应多个标准的情况*/
CREATE TABLE [dbo].[PostInStandard](
	[PostId]			INT NOT NULL PRIMARY KEY,					--岗位ID
	[StandardId]		INT NOT NULL,								--标准ID
)

ALTER TABLE [PostInStandard] WITH CHECK ADD
	CONSTRAINT [FK_PostInStandard_PostId] FOREIGN KEY([PostId]) REFERENCES [Post]([Id])

ALTER TABLE [PostInStandard] WITH CHECK ADD
	CONSTRAINT [FK_PostInStandard_StandardId] FOREIGN KEY([StandardId]) REFERENCES [PostStandard]([Id])

END


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AttachFileLibary]') AND type in (N'U'))
BEGIN

PRINT '------附件库------'
CREATE TABLE [dbo].[AttachFileLibary](
	[Id]					INT PRIMARY KEY,				--附件Id
	[ObjectType]			INT NOT NULL,					--对象类型(AttachFileTypeEnum的值)
	[ObjectId]				INT NOT NULL,					--对象Id（如：公告、培训项目、培训班、考试等等的ID..）
	[AttachName]			NVARCHAR(50) NOT NULL,			--附件名称
	[SourceFileName]		NVARCHAR(50) NOT NULL,			--附件对应的源文件名
	[DisplayFileName]		NVARCHAR(50) NOT NULL,			--附件对应的转换后的文件名
	[IsPreview]				BIT NOT NULL DEFAULT 0,			--是否可以预览
)

END

GO
