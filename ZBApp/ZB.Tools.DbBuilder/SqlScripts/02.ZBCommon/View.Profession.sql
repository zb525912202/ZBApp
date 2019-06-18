USE [$(DatabaseName)]
GO

BEGIN TRANSACTION

print '--------------------职业相关视图------------------------------------'
GO
--职业与岗位对应
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SQ_PostInProfessionView]'))
DROP VIEW [SQ_PostInProfessionView]
GO
CREATE VIEW [SQ_PostInProfessionView]
AS
	SELECT 
	P.Id,
	P.ObjectName,
	PIP.ProfessionId,
	D.FullPath AS DeptFullPath,
	PRO.ObjectName AS ProfessionName,
	(SELECT COUNT(1) FROM Employee WHERE PostId=P.Id) AS EmployeeCount,
	PIP.[Level]
	FROM PostInProfession PIP
	JOIN Post P ON P.Id = PIP.PostId
	JOIN Profession PRO ON PRO.Id=PIP.ProfessionId
	JOIN Dept D ON D.Id = P.DeptId
GO


--掌握程度
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SQ_MasteryLevelView]'))
DROP VIEW [SQ_MasteryLevelView]
GO
CREATE VIEW [SQ_MasteryLevelView]
AS
	SELECT CAST((ROW_NUMBER() OVER(ORDER BY SortIndex))-1 AS INT) Number, * from [dbo].[MasteryLevel]
GO

--模块
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SQ_ModuleView]'))
DROP VIEW [SQ_ModuleView]
GO
CREATE VIEW [SQ_ModuleView]
	AS
		SELECT M.*,MF.FullPath,PC.ObjectName AS ProCategoryName, PC.ObjectName+'/'+MF.FullPath AS FullPath_Search 
		FROM Module M
		INNER JOIN MFolder MF ON M.MFolderId=MF.Id
		JOIN ProfessionCategory PC ON PC.Id = M.ProCategoryId
GO


--模块与职业对应
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SQ_ModuleInProfessionView]'))
DROP VIEW [SQ_ModuleInProfessionView]
GO
CREATE VIEW SQ_ModuleInProfessionView
AS
	SELECT M.*,MP.ProfessionId FROM Module M JOIN ModuleInProfession MP ON M.Id=MP.ModuleId
GO

COMMIT TRANSACTION