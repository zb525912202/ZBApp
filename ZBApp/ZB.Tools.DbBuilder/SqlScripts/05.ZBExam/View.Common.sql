print '--------------------������ͼ------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[DeptView]'))
DROP VIEW [dbo].[DeptView]
GO
CREATE VIEW [dbo].[DeptView]
AS
SELECT				*	
					FROM [$(ZBCommonDatabaseName)].[dbo].[Dept]
GO

print '--------------------�����Ա��ͼ------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeBaseInfoView]'))
DROP VIEW [dbo].[EmployeeBaseInfoView]
GO
CREATE VIEW [dbo].[EmployeeBaseInfoView]
AS
SELECT				Employee.Id AS EmployeeId,																		--��Աid
					Employee.EmployeeNO,																			--��Ա����
					Employee.ObjectName AS EmployeeName,															--��Ա����
					ISNULL([$(ZBCommonDatabaseName)].[dbo].GetAge(Employee.Birthday, GETDATE()), 0) AS Age,		--����
					Dept.Id AS DeptId,																				--��Ա���ڵĲ���id
					Dept.ObjectName AS DeptName,																	--��Ա���ڵĲ�������
					ParentId,																						--������Id
					FullPath,																						--����ȫ·��
					FullPath + '/' AS DeptFullPath_Search,															--��ѯ�Ӳ�����
					Dept.SortIndex,																					--����
					Depth,																							--�������ڵ����
					DeptType																						--��������
					FROM [$(ZBCommonDatabaseName)].[dbo].[Employee] AS Employee 
					LEFT JOIN [$(ZBCommonDatabaseName)].[dbo].[Dept] AS Dept ON Employee.DeptId=Dept.Id
GO
