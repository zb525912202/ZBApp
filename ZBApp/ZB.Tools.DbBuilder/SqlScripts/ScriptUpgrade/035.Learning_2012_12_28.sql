

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeQuesStudyDetail]') AND name = N'IDX_EmployeeQuesStudyDetail_EmpId_StudyDate')
BEGIN
	DROP INDEX [IDX_EmployeeQuesStudyDetail_EmpId_StudyDate] ON [dbo].[EmployeeQuesStudyDetail];
	PRINT 'ɾ��IDX_EmployeeQuesStudyDetail_EmpId_StudyDate�����ɹ�'
END
GO

PRINT '�ؽ�IDX_EmployeeQuesStudyDetail_EmpId_StudyDate�����ɹ�'
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
	PRINT 'ɾ��IDX_EmployeePaperStudyDetail_EmpId_StudyDate����';
	DROP INDEX [IDX_EmployeePaperStudyDetail_EmpId_StudyDate] ON [dbo].[EmployeePaperStudyDetail];
END
GO

PRINT '�ؽ�IDX_EmployeePaperStudyDetail_EmpId_StudyDate����';
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
	PRINT 'ɾ��IDX_EmployeeResourceStudyDetail_EmpId_StudyDate����';
	DROP INDEX [IDX_EmployeeResourceStudyDetail_EmpId_StudyDate] ON [dbo].[EmployeeResourceStudyDetail] WITH ( ONLINE = OFF )
END
GO


PRINT '�ؽ�IDX_EmployeeResourceStudyDetail_EmpId_StudyDate����';
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
