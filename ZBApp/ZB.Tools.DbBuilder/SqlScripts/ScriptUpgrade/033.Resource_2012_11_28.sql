

PRINT '------ �����ļ��й��� ------'
IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('QFolderShare') AND name='SharedId')
BEGIN
	DROP TABLE [dbo].[QFolderShare];

	PRINT 'ɾ�������ļ��й���ɹ�';

	PRINT '------���������ļ��й����------';
	
	CREATE TABLE [dbo].[QFolderShare](
		[Id]				INT PRIMARY KEY NOT NULL,							-- Ψһ��ʶ
		[FolderId]			INT NOT NULL,										-- �ļ���Id
		[SharedType]		INT NOT NULL,										-- ��������(0:������, 1:���в���, 2:��Ա, 3:���ţ� 4:��λ)
		[SharedId]			INT NOT NULL,										-- ����ID(��ԱID,����ID,��λID)
		[SharedName]		NVARCHAR(320) NOT NULL,								-- ��������(����)
		[SharedMode]		INT NOT NULL DEFAULT(0)								-- ����ģʽ(0:ֻ����1:��д)
	)

	ALTER TABLE [QFolderShare]  WITH CHECK ADD  
		CONSTRAINT [FK_QFolderShare_QFolder] FOREIGN KEY([FolderId]) REFERENCES [QFolder] ([Id])

	PRINT '------���������ļ��й����ɹ�------'
END





PRINT '------ �Ծ��ļ��й��� ------'
IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('PFolderShare') AND name='SharedId')
BEGIN
	DROP TABLE [dbo].[PFolderShare];

	PRINT 'ɾ���Ծ��ļ��й���ɹ�';

	PRINT '------�����Ծ��ļ��й����------';
	
	CREATE TABLE [dbo].[PFolderShare](
		[Id]				INT PRIMARY KEY NOT NULL,							-- Ψһ��ʶ
		[FolderId]			INT NOT NULL,										-- �ļ���Id
		[SharedType]		INT NOT NULL,										-- ��������(0:������, 1:���в���, 2:��Ա, 3:���ţ� 4:��λ)
		[SharedId]			INT NOT NULL,										-- ����ID(��ԱID,����ID,��λID)
		[SharedName]		NVARCHAR(320) NOT NULL,								-- ��������(����)
		[SharedMode]		INT NOT NULL DEFAULT(0)								-- ����ģʽ(0:ֻ����1:��д)
	)

	ALTER TABLE [PFolderShare]  WITH CHECK ADD  
		CONSTRAINT [FK_PFolderShare_PFolder] FOREIGN KEY([FolderId]) REFERENCES [PFolder] ([Id])

	PRINT '------�����Ծ��ļ��й����ɹ�------'
END



PRINT '------ ��Դ�ļ��й��� ------'
IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('RFolderShare') AND name='SharedId')
BEGIN
	DROP TABLE [dbo].[RFolderShare];

	PRINT 'ɾ����Դ�ļ��й���ɹ�';

	PRINT '------������Դ�ļ��й����------';
	
	CREATE TABLE [dbo].[RFolderShare](
		[Id]				INT PRIMARY KEY NOT NULL,							-- Ψһ��ʶ
		[FolderId]			INT NOT NULL,										-- �ļ���Id
		[SharedType]		INT NOT NULL,										-- ��������(0:������, 1:���в���, 2:��Ա, 3:���ţ� 4:��λ)
		[SharedId]			INT NOT NULL,										-- ����ID(��ԱID,����ID,��λID)
		[SharedName]		NVARCHAR(320) NOT NULL,								-- ��������(����)
		[SharedMode]		INT NOT NULL DEFAULT(0)								-- ����ģʽ(0:ֻ����1:��д)
	)

	ALTER TABLE [RFolderShare]  WITH CHECK ADD  
		CONSTRAINT [FK_RFolderShare_RFolder] FOREIGN KEY([FolderId]) REFERENCES [RFolder] ([Id])

	PRINT '------������Դ�ļ��й����ɹ�------'
END


PRINT '------ �ؽ������ļ��й������� ------'
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[QFolder]') AND name = N'Index_QFolder_Shared')
DROP INDEX [Index_QFolder_Shared] ON [dbo].[QFolder] WITH ( ONLINE = OFF )
GO

CREATE NONCLUSTERED INDEX [Index_QFolder_Shared] ON [dbo].[QFolder] 
(
	[DeptId] ASC,
	[FullPath] ASC,
	[Id] ASC
)
INCLUDE (
	[ParentId],
	[ObjectName],
	[Comment],
	[SortIndex]
)
GO
