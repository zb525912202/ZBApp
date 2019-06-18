PRINT'--学员积分日结表'
CREATE TABLE  [dbo].[EmployeeStudyDetailStat](
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,		
	[EmployeeId]			INT NOT NULL,										-- 人员Id
	[EmployeeNO]			NVARCHAR(50) NOT NULL,								-- 人员工号
	[EmployeeName]			NVARCHAR(50) NOT NULL,								-- 人员姓名
	[DeptId]				INT NOT NULL,										-- 部门Id		
	[DeptFullPath]			NVARCHAR(260) NOT NULL,								-- 部门全路径
	[DeptSortIndex]			INT NOT NULL,										-- 部门排序
	[Depth]					INT NOT NULL,										-- 部门深度
	[PostId]				INT NOT NULL,										-- 岗位Id
	[PostName]				NVARCHAR(50),										-- 岗位名称
	[CategoryId]			INT NOT NULL,										-- 岗位标准类型
	[JiShuStdLevelId]		INT NOT NULL,										-- 职称级别	
	[JiNengStdLevelId]		INT NOT NULL,										-- 职业资格级别
	[PostRank]				DECIMAL(18,2) NOT NULL,								-- 岗级
	[Sex]					INT,												-- 性别
	[Age]					INT,												-- 年龄
	[TrainerDepth]			INT NOT NULL,										-- 管辖部门的级别
	[LeaderType]			INT NOT NULL,										-- 管理人员类型(正职，副职，普通)
	[IsTrainer]				BIT NOT NULL,										-- 是否是培训员
	[StudyTimeSpan]         INT NOT NULL,										-- 有效学习时长(秒)
	[LearningPoint]		    DECIMAL(18,1) NOT NULL DEFAULT ((0)),				-- 积分
	[StatDate]				SMALLDATETIME NOT NULL,								-- 结算时间
	[StatYear]				INT NOT NULL,										-- 年
	[StatHalfYear]			INT NOT NULL,										-- 半年
	[StatQuarter]			INT NOT NULL,										-- 季度
	[StatMonth]				INT NOT NULL,										-- 月度
)


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
GO

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
GO

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
GO

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
GO

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
GO

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
GO

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
GO

PRINT'--部门信息日结表'
CREATE TABLE  [dbo].[DeptStat](
	[StatId]				INT IDENTITY(1,1) PRIMARY KEY,		
	[Id]					INT NOT NULL,						-- 部门ID
	[ObjectName]			NVARCHAR(50) NOT NULL,				-- 部门名称
	[ParentId]				INT NOT NULL,						-- 上级部门ID
	[FullPath]				NVARCHAR(260) NOT NULL,				-- 部门全路径
	[SortIndex]				INT NOT NULL DEFAULT 0,				-- 排序
	[Depth]					INT NOT NULL DEFAULT 0,				-- 深度
	[DeptType]				INT NOT NULL DEFAULT 0,				-- 部门类型(0:普通部门 1:部门分组)
	[DeptNO]				NVARCHAR(50) NULL,					-- 部门编号(暂许为空)
	[StatDate]				SMALLDATETIME NOT NULL				-- 结算日期
)
CREATE NONCLUSTERED INDEX [Index_StatDate_FullPath_Depth_StatId] ON [dbo].[DeptStat] 
(
	[StatDate] ASC,
	[FullPath] ASC,
	[Depth] ASC,
	[StatId] ASC
)
INCLUDE ([Id])
GO


PRINT '------ 人员分组日结表------'
CREATE TABLE  [dbo].[EmployeeGroupStat](
	[StatId]				INT IDENTITY(1,1) PRIMARY KEY,
	[Id]					INT NOT NULL,
	[ObjectName]			NVARCHAR(50) NOT NULL,
	[ParentId]				INT NOT NULL,
	[FullPath]				NVARCHAR(260) NOT NULL,			-- 全路径，不能有两个相同的路径
	[SortIndex]				INT NOT NULL DEFAULT 0,
	[Depth]					INT NOT NULL DEFAULT 0,			-- 深度
	[StatDate]				SMALLDATETIME NOT NULL			--结算日期
)
GO

PRINT '------ 人员分组与人员对应关系日结表 ------'
CREATE TABLE  [dbo].[EmployeeInEmployeeGroupStat](
	[StatId]				INT IDENTITY(1,1) PRIMARY KEY,
	[EmployeeGroupId]		INT NOT NULL,					-- 人员分组Id
	[EmployeeId]			INT NOT NULL,					-- 人员Id
	[StatDate]				SMALLDATETIME NOT NULL			-- 结算日期
)
GO

PRINT'--日结日志表'
CREATE TABLE [dbo].[EmployeeStudyDetailStatLog]
(
	[Id]				INT IDENTITY(1,1) PRIMARY KEY,
	[StatDate]			SMALLDATETIME NOT NULL,								--结算日期
	[StatRecords]		INT NOT NULL,										--结算记录总数
	[StatTimeSpan]		INT NOT NULL,										--结算耗时(秒)
	[StatSuccess]		BIT NOT NULL,										--结算是否成功
	[ErrorInfo]			NVARCHAR(MAX)										--结算失败错误信息
)