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
SELECT				*	
					FROM [$(ZBCommonDatabaseName)].[dbo].[Dept]
GO

print '--------------------人员组视图------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[EmpGroupView]'))
DROP VIEW [dbo].[EmpGroupView]
GO
CREATE VIEW [dbo].[EmpGroupView]
AS
SELECT				EmployeeGroup.*	,EmployeeInEmployeeGroup.EmployeeId
					FROM [$(ZBCommonDatabaseName)].[dbo].[EmployeeGroup]
					INNER JOIN [$(ZBCommonDatabaseName)].[dbo].[EmployeeInEmployeeGroup] ON EmployeeGroup.Id=EmployeeInEmployeeGroup.EmployeeGroupId
GO
