print '--------------------�����Ա��ͼ------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeView]'))
DROP VIEW [dbo].[EmployeeView]
GO
CREATE VIEW [dbo].[EmployeeView]
AS
SELECT				*	
					FROM [$(ZBCommonDatabaseName)].[dbo].[Employee]
GO

print '--------------------��ⲿ����ͼ------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[DeptView]'))
DROP VIEW [dbo].[DeptView]
GO
CREATE VIEW [dbo].[DeptView]
AS
SELECT				*,
					FullPath + '/' AS DeptFullPath_Search								--���Ų�ѯ����
					FROM [$(ZBCommonDatabaseName)].[dbo].[Dept]
GO

print '--------------------����λ��ͼ------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[PostView]'))
DROP VIEW [dbo].[PostView]
GO
CREATE VIEW [dbo].[PostView]
AS
SELECT				*	
					FROM [$(ZBCommonDatabaseName)].[dbo].[Post]
GO

print '--------------------����λ��׼��ͼ------------------------------------'
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[PostStandardView]'))
DROP VIEW [dbo].[PostStandardView]
GO

CREATE VIEW [dbo].[PostStandardView]
AS
	SELECT P.*,C.ObjectName AS CategoryName FROM [$(ZBCommonDatabaseName)].[dbo].[PostStandard] P
	JOIN [$(ZBCommonDatabaseName)].[dbo].[StandardCategory] C ON P.CategoryId = C.Id
GO


print '--------------------����λ��׼������ͼ------------------------------------'
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[PostStandardLevelView]'))
DROP VIEW [dbo].[PostStandardLevelView]
GO

CREATE VIEW [dbo].[PostStandardLevelView]
AS
	SELECT * FROM [$(ZBCommonDatabaseName)].[dbo].[PostStandardLevel]
GO


print '--------------------�����Ա֤����ͼ------------------------------------'
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[EmmployeeCertInfoView]'))
DROP VIEW [dbo].[EmmployeeCertInfoView]
GO
CREATE VIEW [dbo].[EmmployeeCertInfoView]
	AS

	SELECT C.*,CT.ObjectName AS CertTypeName FROM [$(ZBCommonDatabaseName)].[dbo].EmployeeCert AS C
	JOIN [$(ZBCommonDatabaseName)].[dbo].CertType AS CT ON C.CertTypeId = CT.Id
GO
