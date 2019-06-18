print '--------------------学习记录日结查看视图------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SQ_EmployeeStudyDetailStatView]'))
DROP VIEW [SQ_EmployeeStudyDetailStatView]
GO
CREATE VIEW [SQ_EmployeeStudyDetailStatView]
AS
SELECT				*,
					DeptFullPath + '/' as FullPath_Search 
FROM EmployeeStudyDetailStat

GO