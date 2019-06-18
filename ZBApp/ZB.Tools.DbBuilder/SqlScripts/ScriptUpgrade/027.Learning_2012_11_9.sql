
PRINT'-----删除EmployeeStudyDetailStat表的所有非聚集索引-----'

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


IF EXISTS(SELECT * FROM syscolumns WHERE id = object_id('EmployeeStudyDetailStat') AND name='Age')
BEGIN
	--存在该字段，则修改，使用 ALTER 语句
	ALTER TABLE EmployeeStudyDetailStat ALTER COLUMN Age INT;
	PRINT '修改‘EmployeeStudyDetailStat’内的‘Age’类型为可空INT类型成功';
END
GO

PRINT'-----修改学习记录日结表内的岗级为decimal类型，以支持1.50-----'
--修改学习记录日结表内的岗级为decimal类型，以支持1.50
IF EXISTS(SELECT * FROM syscolumns WHERE id = object_id('EmployeeStudyDetailStat') AND name='PostRank')
BEGIN
	ALTER TABLE EmployeeStudyDetailStat ALTER COLUMN PostRank DECIMAL(18,2);
	PRINT'-----修改学习记录日结表内的岗级为decimal类型成功-----'
END
GO

--
--
--PRINT'-----重建EmployeeStudyDetailStat表的所有非聚集索引-----'
--CREATE NONCLUSTERED INDEX [_dta_index_EmployeeStudyDetailStat_1] ON [dbo].[EmployeeStudyDetailStat] 
--(
--	[StatDate] ASC,
--	[Depth] ASC,
--	[DeptFullPath] ASC
--)
--INCLUDE ( [Id],
--[EmployeeId],
--[EmployeeNO],
--[EmployeeName],
--[DeptId],
--[DeptSortIndex],
--[PostId],
--[PostName],
--[CategoryId],
--[JiShuStdLevelId],
--[JiNengStdLevelId],
--[PostRank],
--[Sex],
--[Age],
--[TrainerDepth],
--[LeaderType],
--[IsTrainer],
--[StudyTimeSpan],
--[LearningPoint],
--[StatYear],
--[StatHalfYear],
--[StatQuarter],
--[StatMonth]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
--GO
--
--CREATE NONCLUSTERED INDEX [_dta_index_EmployeeStudyDetailStat_2] ON [dbo].[EmployeeStudyDetailStat] 
--(
--	[Id] ASC,
--	[EmployeeId] ASC,
--	[StatMonth] ASC
--)
--INCLUDE ( [DeptId],
--[CategoryId],
--[JiShuStdLevelId],
--[JiNengStdLevelId],
--[PostRank],
--[Sex],
--[Age],
--[TrainerDepth],
--[LeaderType],
--[IsTrainer]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
--GO
--
--CREATE NONCLUSTERED INDEX [_dta_index_EmployeeStudyDetailStat_3] ON [dbo].[EmployeeStudyDetailStat] 
--(
--	[Id] ASC,
--	[EmployeeId] ASC,
--	[StatHalfYear] ASC
--)
--INCLUDE ( [DeptId],
--[CategoryId],
--[JiShuStdLevelId],
--[JiNengStdLevelId],
--[PostRank],
--[Sex],
--[Age],
--[TrainerDepth],
--[LeaderType],
--[IsTrainer]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
--GO
--
--CREATE NONCLUSTERED INDEX [_dta_index_EmployeeStudyDetailStat_4] ON [dbo].[EmployeeStudyDetailStat] 
--(
--	[Id] ASC,
--	[EmployeeId] ASC,
--	[StatQuarter] ASC
--)
--INCLUDE ( [DeptId],
--[CategoryId],
--[JiShuStdLevelId],
--[JiNengStdLevelId],
--[PostRank],
--[Sex],
--[Age],
--[TrainerDepth],
--[LeaderType],
--[IsTrainer]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
--GO
--
--CREATE NONCLUSTERED INDEX [_dta_index_EmployeeStudyDetailStat_5] ON [dbo].[EmployeeStudyDetailStat] 
--(
--	[EmployeeId] ASC,
--	[StatYear] ASC,
--	[StatMonth] ASC,
--	[Id] ASC,
--	[StatDate] ASC,
--	[Depth] ASC
--)
--INCLUDE ( [LearningPoint],
--[StatHalfYear],
--[StatQuarter]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
--GO
--
--CREATE NONCLUSTERED INDEX [_dta_index_EmployeeStudyDetailStat_6] ON [dbo].[EmployeeStudyDetailStat] 
--(
--	[EmployeeId] ASC,
--	[StatYear] ASC,
--	[StatQuarter] ASC,
--	[Id] ASC,
--	[StatDate] ASC,
--	[Depth] ASC
--)
--INCLUDE ( [LearningPoint]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
--GO
--
--CREATE NONCLUSTERED INDEX [_dta_index_EmployeeStudyDetailStat_7] ON [dbo].[EmployeeStudyDetailStat] 
--(
--	[EmployeeId] ASC,
--	[StatYear] ASC,
--	[StatHalfYear] ASC,
--	[Id] ASC,
--	[StatDate] ASC,
--	[Depth] ASC
--)
--INCLUDE ( [LearningPoint]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
--GO
--
--PRINT'-----重建成功-----'
--
--GO
--