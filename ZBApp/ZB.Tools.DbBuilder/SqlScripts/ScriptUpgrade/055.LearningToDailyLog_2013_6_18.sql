
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = '$(ZBDailyLogDatabaseName)')														   
BEGIN
	PRINT '���ݿ� ===>$(ZBDailyLogDatabaseName) �����ڣ�����ִ��DailyLog�ļ����ڵ�0.Rebuild���������ݿ�';
END
ELSE
BEGIN

PRINT 'Ǩ������ $(ZBLearningDatabaseName)--> $(ZBDailyLogDatabaseName)';


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[$(ZBLearningDatabaseName)].[dbo].[DeptStat]') AND type in (N'U'))
BEGIN
	INSERT INTO [$(ZBDailyLogDatabaseName)].dbo.DeptStat 
	SELECT 
	Id, ObjectName, ParentId, FullPath, SortIndex, Depth, DeptType, DeptNO, StatDate
	FROM [$(ZBLearningDatabaseName)].dbo.DeptStat
	
	DROP TABLE [$(ZBLearningDatabaseName)].dbo.DeptStat;
END

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[$(ZBLearningDatabaseName)].[dbo].[EmployeeGroupStat]') AND type in (N'U'))
BEGIN
	INSERT INTO [$(ZBDailyLogDatabaseName)].dbo.EmployeeGroupStat
	SELECT
	Id, ObjectName, ParentId, FullPath, SortIndex, Depth, StatDate
	FROM [$(ZBLearningDatabaseName)].dbo.EmployeeGroupStat
	
	DROP TABLE [$(ZBLearningDatabaseName)].dbo.EmployeeGroupStat;
END

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[$(ZBLearningDatabaseName)].[dbo].[EmployeeInEmployeeGroupStat]') AND type in (N'U'))
BEGIN
	INSERT INTO [$(ZBDailyLogDatabaseName)].dbo.EmployeeInEmployeeGroupStat
	SELECT
	EmployeeGroupId, EmployeeId, StatDate
	FROM [$(ZBLearningDatabaseName)].dbo.EmployeeInEmployeeGroupStat
	
	DROP TABLE [$(ZBLearningDatabaseName)].dbo.EmployeeInEmployeeGroupStat;
END

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[$(ZBLearningDatabaseName)].[dbo].[EmployeeStudyDetailStat]') AND type in (N'U'))
BEGIN
	INSERT INTO [$(ZBDailyLogDatabaseName)].dbo.EmployeeStudyDetailStat
	SELECT
	EmployeeId, EmployeeNO, EmployeeName, DeptId, DeptFullPath, DeptSortIndex, Depth, PostId, PostName, CategoryId, JiShuStdLevelId, JiNengStdLevelId, PostRank, Sex, Age, TrainerDepth, LeaderType, IsTrainer, StudyTimeSpan, LearningPoint, StatDate, StatYear, StatHalfYear, StatQuarter, StatMonth
	FROM [$(ZBLearningDatabaseName)].dbo.EmployeeStudyDetailStat
	
	DROP TABLE [$(ZBLearningDatabaseName)].dbo.EmployeeStudyDetailStat
END

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[$(ZBLearningDatabaseName)].[dbo].[EmployeeStudyDetailStatLog]') AND type in (N'U'))
BEGIN
	INSERT INTO [$(ZBDailyLogDatabaseName)].dbo.EmployeeStudyDetailStatLog
	SELECT
	StatDate, StatRecords, StatTimeSpan, StatSuccess, ErrorInfo
	FROM [$(ZBLearningDatabaseName)].dbo.EmployeeStudyDetailStatLog
	
	DROP TABLE [$(ZBLearningDatabaseName)].dbo.EmployeeStudyDetailStatLog
END

PRINT 'Ǩ������ $(ZBLearningDatabaseName)--> $(ZBDailyLogDatabaseName)�ɹ�';

END
