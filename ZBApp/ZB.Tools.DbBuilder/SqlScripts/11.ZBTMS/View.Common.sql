
print '--------------------人员视图------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeView]'))
DROP VIEW [dbo].[EmployeeView]
GO
CREATE VIEW [dbo].[EmployeeView]
AS
SELECT				*	
					FROM [$(ZBCommonDatabaseName)].[dbo].[Employee]
GO

print '--------------------部门视图------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[DeptView]'))
DROP VIEW [dbo].[DeptView]
GO
CREATE VIEW [dbo].[DeptView]
AS
SELECT	*,
	FullPath + '/' AS DeptFullPath_Search								--部门查询条件	
	FROM [$(ZBCommonDatabaseName)].[dbo].[Dept]
GO

print '--------------------岗位视图------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[PostView]'))
DROP VIEW [dbo].[PostView]
GO
CREATE VIEW [dbo].[PostView]
AS
SELECT				*	
					FROM [$(ZBCommonDatabaseName)].[dbo].[Post]
GO

print '--------------------培训员视图------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[TrainerView]'))
DROP VIEW [dbo].[TrainerView]
GO
CREATE VIEW [dbo].[TrainerView]
AS
SELECT				*	
					FROM [$(ZBCommonDatabaseName)].[dbo].[Trainer]
GO

print '--------------------培训师视图------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[TeacherView]'))
DROP VIEW [dbo].[TeacherView]
GO

CREATE VIEW [dbo].[TeacherView]
AS
	SELECT EmployeeId, TeacherLevelId, IsOutSideTeacher
	FROM [$(ZBCommonDatabaseName)].[dbo].[Teacher]
GO


