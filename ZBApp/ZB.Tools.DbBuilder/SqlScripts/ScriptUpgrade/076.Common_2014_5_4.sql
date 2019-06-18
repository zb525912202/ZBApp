PRINT '------ 删除EmployeeStdSort StdSort StdLevel ------'

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeStdSort]') AND type in (N'U'))
DROP TABLE [EmployeeStdSort]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeEdu]') AND type in (N'U'))
DROP TABLE [EmployeeEdu]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StdSort]') AND type in (N'U'))
DROP TABLE [StdSort]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StdLevel]') AND type in (N'U'))
DROP TABLE [StdLevel]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EduLevel]') AND type in (N'U'))
DROP TABLE [EduLevel]
GO
