PRINT'-----删除EmployeeStudyDetailStat表的所有非聚集索引-----'

IF EXISTS(SELECT * FROM syscolumns WHERE id = object_id('EmployeeStudyDetailStat') AND name='LearningPoint' AND(prec<>18 OR scale<>2))
BEGIN

DECLARE indexCursor CURSOR LOCAL FOR
SELECT name FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeStudyDetailStat]') AND is_unique='FALSE'

OPEN indexCursor
DECLARE @indexName nvarchar(1000);
DECLARE @dropIndexSql nvarchar(1000);

FETCH NEXT FROM indexCursor INTO @indexName;
WHILE @@FETCH_STATUS=0
BEGIN
SET @dropIndexSql = 'DROP INDEX ' + @indexName + ' ON EmployeeStudyDetailStat';
execute (@dropIndexSql);
FETCH NEXT FROM indexCursor INTO @indexName;
END

CLOSE indexCursor
DEALLOCATE indexCursor

PRINT'-----删除成功-----'


ALTER TABLE EmployeeStudyDetailStat ALTER COLUMN LearningPoint DECIMAL(18,2);
PRINT '修改‘EmployeeStudyDetailStat’内的‘LearningPoint’为Decimal类型成功';



PRINT'-----重建EmployeeStudyDetailStat表的索引-----'
CREATE NONCLUSTERED INDEX [_dta_index_EmployeeStudyDetailStat_1] ON [dbo].[EmployeeStudyDetailStat] 
(
	[StatDate] ASC,
	[Depth] ASC,
	[DeptFullPath] ASC
)
INCLUDE ( [Id],
[EmployeeId],
[EmployeeNO],
[EmployeeName],
[DeptId],
[DeptSortIndex],
[PostId],
[PostName],
[CategoryId],
[JiShuStdLevelId],
[JiNengStdLevelId],
[PostRank],
[Sex],
[Age],
[TrainerDepth],
[LeaderType],
[IsTrainer],
[StudyTimeSpan],
[LearningPoint],
[StatYear],
[StatHalfYear],
[StatQuarter],
[StatMonth]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [_dta_index_EmployeeStudyDetailStat_2] ON [dbo].[EmployeeStudyDetailStat] 
(
	[Id] ASC,
	[EmployeeId] ASC,
	[StatMonth] ASC
)
INCLUDE ( [DeptId],
[CategoryId],
[JiShuStdLevelId],
[JiNengStdLevelId],
[PostRank],
[Sex],
[Age],
[TrainerDepth],
[LeaderType],
[IsTrainer]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [_dta_index_EmployeeStudyDetailStat_3] ON [dbo].[EmployeeStudyDetailStat] 
(
	[Id] ASC,
	[EmployeeId] ASC,
	[StatHalfYear] ASC
)
INCLUDE ( [DeptId],
[CategoryId],
[JiShuStdLevelId],
[JiNengStdLevelId],
[PostRank],
[Sex],
[Age],
[TrainerDepth],
[LeaderType],
[IsTrainer]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [_dta_index_EmployeeStudyDetailStat_4] ON [dbo].[EmployeeStudyDetailStat] 
(
	[Id] ASC,
	[EmployeeId] ASC,
	[StatQuarter] ASC
)
INCLUDE ( [DeptId],
[CategoryId],
[JiShuStdLevelId],
[JiNengStdLevelId],
[PostRank],
[Sex],
[Age],
[TrainerDepth],
[LeaderType],
[IsTrainer]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [_dta_index_EmployeeStudyDetailStat_5] ON [dbo].[EmployeeStudyDetailStat] 
(
	[EmployeeId] ASC,
	[StatYear] ASC,
	[StatMonth] ASC,
	[Id] ASC,
	[StatDate] ASC,
	[Depth] ASC
)
INCLUDE ( [LearningPoint],
[StatHalfYear],
[StatQuarter]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [_dta_index_EmployeeStudyDetailStat_6] ON [dbo].[EmployeeStudyDetailStat] 
(
	[EmployeeId] ASC,
	[StatYear] ASC,
	[StatQuarter] ASC,
	[Id] ASC,
	[StatDate] ASC,
	[Depth] ASC
)
INCLUDE ( [LearningPoint]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [_dta_index_EmployeeStudyDetailStat_7] ON [dbo].[EmployeeStudyDetailStat] 
(
	[EmployeeId] ASC,
	[StatYear] ASC,
	[StatHalfYear] ASC,
	[Id] ASC,
	[StatDate] ASC,
	[Depth] ASC
)
INCLUDE ( [LearningPoint]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
END