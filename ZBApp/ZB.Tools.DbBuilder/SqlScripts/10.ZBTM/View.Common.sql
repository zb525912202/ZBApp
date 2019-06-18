print '--------------------��ⲿ����ͼ------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[DeptBaseInfoView]'))
DROP VIEW [dbo].[DeptBaseInfoView]
GO
CREATE VIEW [dbo].[DeptBaseInfoView]
AS
SELECT				Id,																			--Id
					ObjectName,																	--����
					ParentId,																	--������Id
					FullPath,																	--����ȫ·��
					FullPath + '/' AS DeptFullPath_Search,										--��ѯ�Ӳ�����
					SortIndex,																	--����
					Depth,																		--�������ڵ����
					DeptType																	--��������
					FROM [$(ZBCommonDatabaseName)].[dbo].[Dept]
GO

print '--------------------�����Ա��ͼ------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeBaseInfoView]'))
DROP VIEW [dbo].[EmployeeBaseInfoView]
GO
CREATE VIEW [dbo].[EmployeeBaseInfoView]
AS
SELECT				Employee.Id AS EmployeeId,													--��Աid
					Employee.EmployeeNO,														--��Ա����
					Employee.ObjectName AS EmployeeName,										--��Ա����
					Dept.Id AS DeptId,															--��Ա���ڵĲ���id
					Dept.ObjectName AS DeptName,												--��Ա���ڵĲ�������
					ParentId,																	--������Id
					FullPath,																	--����ȫ·��
					FullPath + '/' AS DeptFullPath_Search,										--��ѯ�Ӳ�����
					Dept.SortIndex,																	--����
					Depth,																		--�������ڵ����
					DeptType																	--��������
					FROM [$(ZBCommonDatabaseName)].[dbo].[Employee] AS Employee 
					LEFT JOIN [$(ZBCommonDatabaseName)].[dbo].[Dept] AS Dept ON Employee.DeptId=Dept.Id
GO

print '--------------------����λ��׼��Ա��ͼ------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeCategoryView]'))
DROP VIEW [dbo].[EmployeeCategoryView]
GO
CREATE VIEW [dbo].[EmployeeCategoryView]
AS
SELECT				Employee.Id AS EmployeeId,													--��Աid
					Employee.EmployeeNO,														--��Ա����
					Employee.ObjectName AS EmployeeName,										--��Ա����
					Dept.Id AS DeptId,															--��Ա���ڵĲ���id
					ParentId,																	--������Id
					FullPath,																	--����ȫ·��
					FullPath + '/' AS DeptFullPath_Search,										--��ѯ�Ӳ�����
					Depth,																		--�������ڵ����
					DeptType,																	--��������
					PostId,																		--��Ա��λ
					PostCategory.Id AS PostCategoryId											--��Ա��λ��׼
					FROM [$(ZBCommonDatabaseName)].[dbo].[Employee] AS Employee 
					LEFT JOIN [$(ZBCommonDatabaseName)].[dbo].[Dept] AS Dept ON Employee.DeptId=Dept.Id
					LEFT JOIN [$(ZBCommonDatabaseName)].[dbo].[Post] AS Post ON Employee.PostId=Post.Id
					LEFT JOIN [$(ZBCommonDatabaseName)].[dbo].[PostCategory] AS PostCategory ON Post.CategoryId=PostCategory.Id
GO

print '--------------------��Ա��ͼ------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeView]'))
DROP VIEW [dbo].[EmployeeView]
GO
CREATE VIEW [dbo].[EmployeeView]
AS
SELECT				*	
					FROM [$(ZBCommonDatabaseName)].[dbo].[Employee]
GO

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

print '--------------------��λ��ͼ------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[PostView]'))
DROP VIEW [dbo].[PostView]
GO
CREATE VIEW [dbo].[PostView]
AS
SELECT				*	
					FROM [$(ZBCommonDatabaseName)].[dbo].[Post]
GO

print '--------------------��ѵԱ��ͼ------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[TrainerView]'))
DROP VIEW [dbo].[TrainerView]
GO
CREATE VIEW [dbo].[TrainerView]
AS
SELECT				*	
					FROM [$(ZBCommonDatabaseName)].[dbo].[Trainer]
GO

print '--------------------��ʦ��ͼ------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[TeacherView]'))
DROP VIEW [dbo].[TeacherView]
GO
CREATE VIEW [dbo].[TeacherView]
AS
SELECT				*	
					FROM [$(ZBCommonDatabaseName)].[dbo].[Teacher]
GO
