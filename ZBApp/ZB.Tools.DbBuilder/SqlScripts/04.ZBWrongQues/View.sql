print '--------------------跨库试题视图------------------------------------'
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[QuestionView]'))
DROP VIEW [dbo].[QuestionView]
GO
CREATE VIEW [dbo].[QuestionView]
AS
SELECT Id,
	   FolderId,
	   HardLevel,
	   QtId,
	   ContentText 
FROM [$(ZBResourceDatabaseName)].[dbo].[Question]
GO


print '--------------------跨库试题目录视图------------------------------------'
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[QFolderView]'))
DROP VIEW [dbo].[QFolderView]
GO
CREATE VIEW [dbo].[QFolderView]
AS
SELECT * FROM [$(ZBResourceDatabaseName)].[dbo].[QFolder]
GO

print '--------------------跨库人员信息视图------------------------------------'
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeInfoView]'))
DROP VIEW [dbo].[EmployeeInfoView]
GO
CREATE VIEW [dbo].[EmployeeInfoView]
AS
	SELECT E.*,D.FullPath FROM [$(ZBCommonDatabaseName)].dbo.Employee E
	JOIN [$(ZBCommonDatabaseName)].dbo.Dept D ON D.Id = E.DeptId
GO
