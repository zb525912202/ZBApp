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

print '--------------------跨库人员视图------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeBaseInfoView]'))
DROP VIEW [dbo].[EmployeeBaseInfoView]
GO
CREATE VIEW [dbo].[EmployeeBaseInfoView]
AS
SELECT				Employee.Id AS EmployeeId,																		--人员id
					Employee.EmployeeNO,																			--人员工号
					Employee.ObjectName AS EmployeeName,															--人员姓名
					ISNULL([$(ZBCommonDatabaseName)].[dbo].GetAge(Employee.Birthday, GETDATE()), 0) AS Age,		--年龄
					Dept.Id AS DeptId,																				--人员所在的部门id
					Dept.ObjectName AS DeptName,																	--人员所在的部门名称
					ParentId,																						--父部门Id
					FullPath,																						--部门全路径
					FullPath + '/' AS DeptFullPath_Search,															--查询子部门用
					Dept.SortIndex,																					--排序
					Depth,																							--部门树节点深度
					DeptType																						--部门类型
					FROM [$(ZBCommonDatabaseName)].[dbo].[Employee] AS Employee 
					LEFT JOIN [$(ZBCommonDatabaseName)].[dbo].[Dept] AS Dept ON Employee.DeptId=Dept.Id
GO
