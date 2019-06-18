print '--------------------���������ͼ------------------------------------'
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


print '--------------------�������Ŀ¼��ͼ------------------------------------'
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[QFolderView]'))
DROP VIEW [dbo].[QFolderView]
GO
CREATE VIEW [dbo].[QFolderView]
AS
SELECT * FROM [$(ZBResourceDatabaseName)].[dbo].[QFolder]
GO

print '--------------------�����Ա��Ϣ��ͼ------------------------------------'
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeInfoView]'))
DROP VIEW [dbo].[EmployeeInfoView]
GO
CREATE VIEW [dbo].[EmployeeInfoView]
AS
	SELECT E.*,D.FullPath FROM [$(ZBCommonDatabaseName)].dbo.Employee E
	JOIN [$(ZBCommonDatabaseName)].dbo.Dept D ON D.Id = E.DeptId
GO
