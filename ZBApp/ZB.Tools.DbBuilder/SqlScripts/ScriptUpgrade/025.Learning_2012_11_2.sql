
PRINT'-----删除EmployeeStudyInfo表的IDX_EmployeeStudyInfo_StudyDate索引-----'
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeStudyInfo]') AND name = 'IDX_EmployeeStudyInfo_StudyDate')
BEGIN
	DROP INDEX IDX_EmployeeStudyInfo_StudyDate ON EmployeeStudyInfo
END
GO

PRINT'-----创建EmployeeStudyInfo表的IDX_EmployeeId_StudyDate索引-----'
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeStudyInfo]') AND name = 'IDX_EmployeeId_StudyDate')
BEGIN
	CREATE UNIQUE NONCLUSTERED INDEX [IDX_EmployeeId_StudyDate] ON [dbo].[EmployeeStudyInfo] 
	(	
		[EmployeeId] ASC,
		[StudyDate] DESC
	)
END
GO
