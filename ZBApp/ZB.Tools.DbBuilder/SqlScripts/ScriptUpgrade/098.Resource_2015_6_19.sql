IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AttachFile]') AND type in (N'U'))
BEGIN

PRINT '------附件库------'
CREATE TABLE [dbo].[AttachFile](
	[Id]					INT PRIMARY KEY,				--附件Id
	[AttachFileName]		NVARCHAR(50) NOT NULL,			--附件名称
	[SourceFileName]		NVARCHAR(50) NOT NULL,			--附件对应的源文件名
	[DisplayFileName]		NVARCHAR(50) NOT NULL,			--附件对应的转换后的文件名
	[GUID]					CHAR(36) NOT NULL,				--GUID	
	[FileTypeExt]			INT NOT NULL,					--文件扩展名（后缀名）
	[FileSize]				BIGINT NOT NULL,				--文件大小		
	[UploadPathIndex]		INT NOT NULL,					--文件存放的上传目录索引
	[ContentLength]			BIGINT NOT NULL,				--内容长度(时长、页数)
	[IsPreview]				BIT NOT NULL DEFAULT 0,			--是否可以预览
	[AttachFileState]		INT NOT NULL,					--附件状态(共用ResourceStateEnum枚举的值)
	[CreateDate]			DATETIME NOT NULL,				--创建时间
)

END


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AttachFileInObject]') AND type in (N'U'))
BEGIN

PRINT '------各类对象的附件------'
CREATE TABLE [dbo].[AttachFileInObject](
	[Id]				INT IDENTITY(1,1) PRIMARY KEY,
	[ObjectType]		INT NOT NULL,					--对象类型(AttachFileTypeEnum的值)
	[ObjectId]			INT NOT NULL,					--对象Id（如：公告、培训项目、培训班、考试等等的ID..）
	[AttachFileId]		INT NOT NULL,					--附件ID
)

ALTER TABLE [AttachFileInObject] WITH CHECK ADD
	CONSTRAINT [FK_AttachFileInObject_FileGUID] FOREIGN KEY([AttachFileId]) REFERENCES [AttachFile]([Id])

CREATE UNIQUE NONCLUSTERED INDEX [IDX_ObjectType_ObjectId_AttachFileId] ON [dbo].[AttachFileInObject] 
(
	[ObjectType] ASC,
	[ObjectId] ASC,
	[AttachFileId] ASC
)

END


IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('AttachFileInObject') AND name='AttachFileType')
BEGIN

	ALTER TABLE AttachFileInObject ADD AttachFileType INT NOT NULL DEFAULT 0;
	PRINT '添加‘AttachFileInObject’内的‘AttachFileType’成功';

END