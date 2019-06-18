

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeQuesStudyDetail]') AND name = N'IDX_EmployeeQuesStudyDetail_EmpId_StudyDate')
BEGIN
	DROP INDEX [IDX_EmployeeQuesStudyDetail_EmpId_StudyDate] ON [dbo].[EmployeeQuesStudyDetail];
	PRINT '删除IDX_EmployeeQuesStudyDetail_EmpId_StudyDate索引成功'
END
GO

PRINT '重建IDX_EmployeeQuesStudyDetail_EmpId_StudyDate索引成功'
CREATE NONCLUSTERED INDEX [IDX_EmployeeQuesStudyDetail_EmpId_StudyDate] ON [dbo].[EmployeeQuesStudyDetail] 
(
	[EmployeeId] ASC,
	[StudyDate] ASC,
	[Id] ASC,
	[RightCount] ASC,
	[EmployeeRecordType] ASC,
	[StudyTimeSpan] ASC,
	[LearningPoint] ASC
)
INCLUDE ( 
[StudyType],
[RequiredTaskName],
[RequiredItemName],
[FolderFullPath],
[WrongCount]
)
GO



IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[EmployeePaperStudyDetail]') AND name = N'IDX_EmployeePaperStudyDetail_EmpId_StudyDate')
BEGIN
	PRINT '删除IDX_EmployeePaperStudyDetail_EmpId_StudyDate索引';
	DROP INDEX [IDX_EmployeePaperStudyDetail_EmpId_StudyDate] ON [dbo].[EmployeePaperStudyDetail];
END
GO

PRINT '重建IDX_EmployeePaperStudyDetail_EmpId_StudyDate索引';
CREATE NONCLUSTERED INDEX [IDX_EmployeePaperStudyDetail_EmpId_StudyDate] ON [dbo].[EmployeePaperStudyDetail] 
(
	[EmployeeId] ASC,
	[StudyDate] ASC,
	[EmployeeRecordType] ASC,
	[StudyTimeSpan] ASC,
	[LearningPoint] ASC
)
INCLUDE ( 
[StudyType],
[RequiredTaskName],
[RequiredItemName],
[PaperName]
)
GO




IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeResourceStudyDetail]') AND name = N'IDX_EmployeeResourceStudyDetail_EmpId_StudyDate')
BEGIN
	PRINT '删除IDX_EmployeeResourceStudyDetail_EmpId_StudyDate索引';
	DROP INDEX [IDX_EmployeeResourceStudyDetail_EmpId_StudyDate] ON [dbo].[EmployeeResourceStudyDetail] WITH ( ONLINE = OFF )
END
GO


PRINT '重建IDX_EmployeeResourceStudyDetail_EmpId_StudyDate索引';
CREATE NONCLUSTERED INDEX [IDX_EmployeeResourceStudyDetail_EmpId_StudyDate] ON [dbo].[EmployeeResourceStudyDetail] 
(
	[EmployeeId] ASC,
	[StudyDate] ASC,
	[Id] ASC,
	[EmployeeRecordType] ASC,
	[StudyTimeSpan] ASC,
	[LearningPoint] ASC
)
INCLUDE ( 
[RequiredTaskName],
[RequiredItemName],
[AlbumName],
[ResourceName]
)
GO
