IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('PaperPackage') AND name='IsElecPaperPackage')
BEGIN
	ALTER TABLE PaperPackage ADD IsElecPaperPackage	BIT NOT NULL DEFAULT 1;
	PRINT '添加PaperPackage内的IsElecPaperPackage成功';
END

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('PaperPackage') AND name='IsLocalPaperPackage')
BEGIN
	ALTER TABLE PaperPackage ADD IsLocalPaperPackage	BIT NOT NULL DEFAULT 0;
	PRINT '添加PaperPackage内的IsLocalPaperPackage成功';
END

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LocalPaperPackageFile]') AND type in (N'U'))
BEGIN
PRINT '------ 试卷包 ------'
CREATE TABLE [dbo].[LocalPaperPackageFile](
	[Id]							INT PRIMARY KEY  NOT NULL,							-- 唯一标识
	[PaperPackageId]				INT NOT NULL,										-- 文件夹ID
	[PaperPackageFileType]			INT NOT NULL,										-- 本地试卷文件类型(试题卷、答案卷、合并卷)
	[SourceName]					NVARCHAR(255) NOT NULL,								-- 原始文件名称	
	[RtfName]						NVARCHAR(255) NOT NULL,								-- RTF文件名称
	[CreateTime]					DATETIME NOT NULL,									-- 创建时间
)
ALTER TABLE [LocalPaperPackageFile]  WITH CHECK ADD  
	CONSTRAINT [FK_LocalPaperPackageFile_PaperPackage] FOREIGN KEY([PaperPackageId]) REFERENCES [PaperPackage] ([Id])
END

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PaperPackageConvertConfig]') AND type in (N'U'))
BEGIN
PRINT '------ 人员试卷转换配置表 ------'
CREATE TABLE [dbo].[PaperPackageConvertConfig](
	[Id]							INT IDENTITY(1,1) PRIMARY KEY  NOT NULL,			-- 唯一标识
	[EmployeeId]					INT NOT NULL,										-- 人员ID
	[ConvertConfig]					VARBINARY(MAX),										-- 试卷转换配置
)
END