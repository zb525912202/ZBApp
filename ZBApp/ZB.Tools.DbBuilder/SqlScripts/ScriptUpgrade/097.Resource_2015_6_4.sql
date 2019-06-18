
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QFolderInStandard]') AND type in (N'U'))
BEGIN

PRINT '------ 试题文件夹与岗位标准对应关系 ------'
CREATE TABLE [dbo].[QFolderInStandard](
	[Id]				INT PRIMARY KEY NOT NULL,								--ID
	[FolderId]			INT NOT NULL,											--文件夹ID				
	[StandardId]		INT NOT NULL,											--岗位标准ID
	[IsIncludeSub]		BIT NOT NULL DEFAULT(0)									--是否包含子文件夹
)

ALTER TABLE [QFolderInStandard]  WITH CHECK ADD  
	CONSTRAINT [FK_QFolderInStandard_QFolder] FOREIGN KEY([FolderId]) REFERENCES [QFolder] ([Id])

CREATE UNIQUE NONCLUSTERED INDEX [IDX_FolderId_StandardId] ON [dbo].[QFolderInStandard]
(
	[FolderId] ASC,
	[StandardId] ASC
)

END


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PFolderInStandard]') AND type in (N'U'))
BEGIN

PRINT '------ 试卷文件夹与岗位标准对应关系 ------'
CREATE TABLE [dbo].[PFolderInStandard](
	[Id]				INT PRIMARY KEY NOT NULL,								--ID
	[FolderId]			INT NOT NULL,											--文件夹ID				
	[StandardId]		INT NOT NULL,											--岗位标准ID
	[IsIncludeSub]		BIT NOT NULL DEFAULT(0)									--是否包含子文件夹
)

ALTER TABLE [PFolderInStandard]  WITH CHECK ADD  
	CONSTRAINT [FK_PFolderInStandard_QFolder] FOREIGN KEY([FolderId]) REFERENCES [PFolder] ([Id])

CREATE UNIQUE NONCLUSTERED INDEX [IDX_FolderId_StandardId] ON [dbo].[PFolderInStandard]
(
	[FolderId] ASC,
	[StandardId] ASC
)

END



IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RFolderInStandard]') AND type in (N'U'))
BEGIN

PRINT '------ 媒体文件夹与岗位标准对应关系 ------'
CREATE TABLE [dbo].[RFolderInStandard](
	[Id]				INT PRIMARY KEY NOT NULL,								--ID
	[FolderId]			INT NOT NULL,											--文件夹ID				
	[StandardId]		INT NOT NULL,											--岗位标准ID
	[IsIncludeSub]		BIT NOT NULL DEFAULT(0)									--是否包含子文件夹
)

ALTER TABLE [RFolderInStandard]  WITH CHECK ADD  
	CONSTRAINT [FK_RFolderInStandard_QFolder] FOREIGN KEY([FolderId]) REFERENCES [RFolder] ([Id])


CREATE UNIQUE NONCLUSTERED INDEX [IDX_FolderId_StandardId] ON [dbo].[RFolderInStandard]
(
	[FolderId] ASC,
	[StandardId] ASC
)

END

