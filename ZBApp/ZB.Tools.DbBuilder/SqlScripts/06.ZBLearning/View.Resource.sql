
print '--------------------试题资源文件夹视图------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[QFolderView]'))
DROP VIEW [dbo].[QFolderView]
GO
CREATE VIEW [dbo].[QFolderView]
AS
SELECT				*	
					FROM [$(ZBResourceDatabaseName)].[dbo].[QFolder]
GO

print '--------------------试卷资源文件夹视图------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[PFolderView]'))
DROP VIEW [dbo].[PFolderView]
GO
CREATE VIEW [dbo].[PFolderView]
AS
SELECT				*	
					FROM [$(ZBResourceDatabaseName)].[dbo].[PFolder]
GO

print '--------------------媒体资源文件视图------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[RFileView]'))
DROP VIEW [dbo].[RFileView]
GO
CREATE VIEW [dbo].[RFileView]
AS
SELECT				*	
					FROM [$(ZBResourceDatabaseName)].[dbo].[RFile]
GO


print '--------------------媒体资源文件夹视图------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[RFolderView]'))
DROP VIEW [dbo].[RFolderView]
GO
CREATE VIEW [dbo].[RFolderView]
AS
SELECT				*	
					FROM [$(ZBResourceDatabaseName)].[dbo].[RFolder]
GO


print '--------------------试卷视图------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[PaperPackageView]'))
DROP VIEW [dbo].[PaperPackageView]
GO
CREATE VIEW [dbo].[PaperPackageView]
AS
SELECT				*	
					FROM [$(ZBResourceDatabaseName)].[dbo].[PaperPackage]
GO
