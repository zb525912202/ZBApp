


PRINT '--------------------评定范围列表视图------------------------------------'
GO
IF EXISTS (SELECT * FROM sys.views WHERE object_id=OBJECT_ID(N'[SQ_FiveStarEvalRangeView]'))
DROP VIEW [SQ_FiveStarEvalRangeView]
GO

CREATE VIEW [dbo].[SQ_FiveStarEvalRangeView]
AS
SELECT FSER.*, PV.ObjectName AS PostName, DV.FullPath,
(SELECT COUNT(Id) FROM EmployeeView WHERE PostId =FSER.ObjectId) AS EmployeeCount
FROM FiveStarEvalRange FSER
INNER JOIN PostView PV ON PV.Id = FSER.ObjectId
INNER JOIN DeptView DV ON DV.Id = PV.DeptId

GO


PRINT '--------------------测评项目列表视图------------------------------------'
GO
IF EXISTS (SELECT * FROM sys.views WHERE object_id=OBJECT_ID(N'[SQ_FiveStarEvalProjectView]'))
DROP VIEW [SQ_FiveStarEvalProjectView]
GO

CREATE VIEW [SQ_FiveStarEvalProjectView]
AS
SELECT FiveStarEvalProject.*, FiveStarEvalCategory.ObjectName AS CategoryName 
FROM FiveStarEvalProject
JOIN FiveStarEvalCategory on FiveStarEvalCategory.Id = FiveStarEvalProject.CategoryID

GO



PRINT '--------------------月度星级视图------------------------------------'
GO
IF EXISTS (SELECT * FROM sys.views WHERE object_id=OBJECT_ID(N'[SQ_FiveStarEvalMonthProjectView]'))
DROP VIEW [SQ_FiveStarEvalMonthProjectView]
GO

CREATE VIEW [dbo].[SQ_FiveStarEvalMonthProjectView]
AS
SELECT P.*, C.ObjectName AS CategoryName,
(SELECT COUNT(1) FROM FiveStarEvalResult R WHERE R.ProjectId = P.Id AND StarLevel = 1) AS OneStar,
(SELECT COUNT(1) FROM FiveStarEvalResult R WHERE R.ProjectId = P.Id AND StarLevel = 2) AS TwoStar,
(SELECT COUNT(1) FROM FiveStarEvalResult R WHERE R.ProjectId = P.Id AND StarLevel = 3) AS ThreeStar
 FROM FiveStarEvalProject P
JOIN FiveStarEvalCategory C ON P.CategoryID = C.Id

GO


PRINT '--------------------季度星级视图------------------------------------'
GO
IF EXISTS (SELECT * FROM sys.views WHERE object_id=OBJECT_ID(N'[SQ_FiveStarEvalQuarterProjectView]'))
DROP VIEW [SQ_FiveStarEvalQuarterProjectView]
GO

CREATE VIEW [dbo].[SQ_FiveStarEvalQuarterProjectView]
AS
SELECT P.*, C.ObjectName AS CategoryName,
(SELECT COUNT(1) FROM FiveStarEvalResult R WHERE R.ProjectId = P.Id AND StarLevel = 4) AS FourStar
FROM FiveStarEvalProject P
JOIN FiveStarEvalCategory C on P.CategoryID = C.Id
GO


PRINT '--------------------年度星级视图------------------------------------'
GO
IF EXISTS (SELECT * FROM sys.views WHERE object_id=OBJECT_ID(N'[SQ_FiveStarEvalYearProjectView]'))
DROP VIEW [SQ_FiveStarEvalYearProjectView]
GO

CREATE VIEW [dbo].[SQ_FiveStarEvalYearProjectView]
AS
SELECT P.*, C.ObjectName AS CategoryName,
(SELECT COUNT(1) FROM FiveStarEvalResult R WHERE R.ProjectId = P.Id AND StarLevel = 5) AS FiveStar
FROM FiveStarEvalProject P
JOIN FiveStarEvalCategory C on P.CategoryID = C.Id

GO
