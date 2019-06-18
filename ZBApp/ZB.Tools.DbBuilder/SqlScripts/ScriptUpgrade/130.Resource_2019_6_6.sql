IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QuestionInMFolder]') AND type in (N'U'))
	BEGIN
		PRINT '------ 试题与知识结构关系 ------'
		CREATE TABLE [dbo].[QuestionInMFolder](
			[Id]				INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
			[QuestionId]		INT NOT NULL DEFAULT(0),										--试题ID
			[ProCategoryId]		INT NOT NULL DEFAULT(0),										--职岗类型ID
			[MFolderId]			INT NOT NULL DEFAULT(0),										--知识结构文件夹ID
			[ModuleId]			INT NOT NULL DEFAULT(0)										--模块ID
		)
		ALTER TABLE [QuestionInMFolder] WITH CHECK ADD
			CONSTRAINT [FK_QuestionId_QuestionInMFolder] FOREIGN KEY([QuestionId]) REFERENCES [Question]([Id])
	END
GO

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PaperInMFolder]') AND type in (N'U'))
	BEGIN
		PRINT '------ 试卷与知识结构关系 ------'
		CREATE TABLE [dbo].[PaperInMFolder](
			[Id]				INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
			[PaperPackageId]	INT NOT NULL,													--试卷ID
			[ProCategoryId]		INT NOT NULL DEFAULT(0),										--职岗类型ID
			[MFolderId]			INT NOT NULL DEFAULT(0),										--知识结构文件夹ID
			[ModuleId]			INT NOT NULL DEFAULT(0)											--模块ID
		)
		ALTER TABLE [PaperInMFolder] WITH CHECK ADD
			CONSTRAINT [FK_PaperPackageId_PaperInMFolder] FOREIGN KEY([PaperPackageId]) REFERENCES [PaperPackage]([Id])
END
GO

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RFileInMFolder]') AND type in (N'U'))
	BEGIN
		PRINT '------ 多媒体与知识结构关系 ------'
		CREATE TABLE [dbo].[RFileInMFolder](
			[Id]				INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
			[RFileId]			INT NOT NULL,													--多媒体ID
			[ProCategoryId]		INT NOT NULL DEFAULT(0),										--职岗类型ID
			[MFolderId]			INT NOT NULL DEFAULT(0),										--知识结构文件夹ID
			[ModuleId]			INT NOT NULL DEFAULT(0)											--模块ID
		)
		ALTER TABLE [RFileInMFolder] WITH CHECK ADD
			CONSTRAINT [FK_RFileId_RFileInMFolder] FOREIGN KEY([RFileId]) REFERENCES [RFile]([Id])
	END
GO



