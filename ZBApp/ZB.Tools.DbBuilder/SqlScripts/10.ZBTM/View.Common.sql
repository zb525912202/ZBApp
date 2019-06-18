print '--------------------跨库部门视图------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[DeptBaseInfoView]'))
DROP VIEW [dbo].[DeptBaseInfoView]
GO
CREATE VIEW [dbo].[DeptBaseInfoView]
AS
SELECT				Id,																			--Id
					ObjectName,																	--名称
					ParentId,																	--父部门Id
					FullPath,																	--部门全路径
					FullPath + '/' AS DeptFullPath_Search,										--查询子部门用
					SortIndex,																	--排序
					Depth,																		--部门树节点深度
					DeptType																	--部门类型
					FROM [$(ZBCommonDatabaseName)].[dbo].[Dept]
GO

print '--------------------跨库人员视图------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeBaseInfoView]'))
DROP VIEW [dbo].[EmployeeBaseInfoView]
GO
CREATE VIEW [dbo].[EmployeeBaseInfoView]
AS
SELECT				Employee.Id AS EmployeeId,													--人员id
					Employee.EmployeeNO,														--人员工号
					Employee.ObjectName AS EmployeeName,										--人员姓名
					Dept.Id AS DeptId,															--人员所在的部门id
					Dept.ObjectName AS DeptName,												--人员所在的部门名称
					ParentId,																	--父部门Id
					FullPath,																	--部门全路径
					FullPath + '/' AS DeptFullPath_Search,										--查询子部门用
					Dept.SortIndex,																	--排序
					Depth,																		--部门树节点深度
					DeptType																	--部门类型
					FROM [$(ZBCommonDatabaseName)].[dbo].[Employee] AS Employee 
					LEFT JOIN [$(ZBCommonDatabaseName)].[dbo].[Dept] AS Dept ON Employee.DeptId=Dept.Id
GO

print '--------------------跨库岗位标准人员视图------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeCategoryView]'))
DROP VIEW [dbo].[EmployeeCategoryView]
GO
CREATE VIEW [dbo].[EmployeeCategoryView]
AS
SELECT				Employee.Id AS EmployeeId,													--人员id
					Employee.EmployeeNO,														--人员工号
					Employee.ObjectName AS EmployeeName,										--人员姓名
					Dept.Id AS DeptId,															--人员所在的部门id
					ParentId,																	--父部门Id
					FullPath,																	--部门全路径
					FullPath + '/' AS DeptFullPath_Search,										--查询子部门用
					Depth,																		--部门树节点深度
					DeptType,																	--部门类型
					PostId,																		--人员岗位
					PostCategory.Id AS PostCategoryId											--人员岗位标准
					FROM [$(ZBCommonDatabaseName)].[dbo].[Employee] AS Employee 
					LEFT JOIN [$(ZBCommonDatabaseName)].[dbo].[Dept] AS Dept ON Employee.DeptId=Dept.Id
					LEFT JOIN [$(ZBCommonDatabaseName)].[dbo].[Post] AS Post ON Employee.PostId=Post.Id
					LEFT JOIN [$(ZBCommonDatabaseName)].[dbo].[PostCategory] AS PostCategory ON Post.CategoryId=PostCategory.Id
GO

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

print '--------------------教师视图------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[TeacherView]'))
DROP VIEW [dbo].[TeacherView]
GO
CREATE VIEW [dbo].[TeacherView]
AS
SELECT				*	
					FROM [$(ZBCommonDatabaseName)].[dbo].[Teacher]
GO
