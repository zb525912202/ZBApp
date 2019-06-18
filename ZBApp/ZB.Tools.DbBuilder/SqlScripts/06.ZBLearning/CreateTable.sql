USE [$(DatabaseName)]
GO

BEGIN TRANSACTION

PRINT'--积分系数规则项组表'
CREATE TABLE [dbo].[LearningRateRuleGroup](
	[Id]					INT PRIMARY KEY,
	[XTitle]				NVARCHAR(50) NOT NULL,								-- 积分系数规则项组X轴标题
	[MaxRate]				DECIMAL(18,1) NOT NULL,								-- 积分系数最大值
	[MinRate]				DECIMAL(18,1) NOT NULL,								-- 积分系数最小值
	[CalcMode]				INT NOT NULL DEFAULT 0,								-- 计算方式,CalcModeEnum值
)

PRINT'--积分系数规则项表'
CREATE TABLE [dbo].[LearningRateRuleItem](
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,
	[LearningGroupRuleId]	INT NOT NULL,										-- 积分系数规则项组Id
	[RuleKey]				INT NOT NULL,										-- 积分系数规则项Key
	[ObjectName]			NVARCHAR(50) NOT NULL,								-- 积分系数规则项名称
	[ComputeType]			INT NOT NULL,										-- 积分系数规则项匹配类型
	[IsReadOnly]			BIT NOT NULL,										-- 是否只读
	[DefaultRate]			DECIMAL(18,1) NOT NULL,								-- 积分系数规则项默认值
	[Rate]					DECIMAL(18,1) NOT NULL,								-- 积分系数规则项值
)
ALTER TABLE [LearningRateRuleItem] WITH CHECK ADD  
	CONSTRAINT [FK_LearningRateRuleItem_LearningRateRuleGroup] FOREIGN KEY([LearningGroupRuleId]) REFERENCES [LearningRateRuleGroup] ([Id])
GO

PRINT'--人员学习情况表'
CREATE TABLE [dbo].[EmployeeStudyInfo](
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,
	[EmployeeId]			INT NOT NULL,										-- 人员Id
	[StudyDate]				SMALLDATETIME NOT NULL,								-- 学习日期(保留7天的数据)
	[StudyInfoObjBytes]		VARBINARY(MAX),										-- 学习情况
)
CREATE UNIQUE NONCLUSTERED INDEX [IDX_EmployeeId_StudyDate] ON [dbo].[EmployeeStudyInfo] 
(	
	[EmployeeId] ASC,
	[StudyDate] DESC
)
GO

PRINT'--人员最近学习情况历史表'
CREATE TABLE [dbo].[EmployeeStudyHistory](
	[Id]							INT IDENTITY(1,1) PRIMARY KEY,
	[EmployeeId]					INT NOT NULL,										-- 人员Id
	[ResourceId]					INT NOT NULL,										-- 资源Id
	[EmployeeStudyHistoryType]		INT NOT NULL,										-- 资源类型
	[CreateTime]					DATETIME NOT NULL,									-- 创建时间	
	[Tag1]							BIT NOT NULL,										-- 是否包含子部门，用于试题记录			
	[Tag2]							INT NOT NULL,										-- 学习类型，开卷、闭卷
)
CREATE UNIQUE NONCLUSTERED INDEX [IDX_EmployeeStudyHistory_EmployeeId_ResourceId_EmployeeStudyHistoryType] ON [dbo].[EmployeeStudyHistory] 
(
	[EmployeeId] ASC,
	[ResourceId] ASC,
	[EmployeeStudyHistoryType] ASC
)
GO


PRINT'--人员试题学习明细表'
CREATE TABLE [dbo].[EmployeeQuesStudyDetail](
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,
	[EmployeeId]			INT NOT NULL,										-- 人员Id
	[EmployeeName]			NVARCHAR(50) NOT NULL,								-- 人员姓名
	[DeptId]				INT NOT NULL,										-- 部门Id	
	[DeptFullPath]			NVARCHAR(260) NOT NULL,								-- 部门FullPath
	[PostId]				INT NOT NULL,										-- 岗位Id
	[PostName]				NVARCHAR(50),										-- 岗位名称
	[StudyDate]				SMALLDATETIME NOT NULL,								-- 学习时间	
	[StudyType]             INT NOT NULL,										-- 学习方式(开卷、闭卷)
	[StudyMode]             INT NOT NULL,										-- 学习形式(试题、试卷、视频、音频、文档、必修)
	[RequiredTaskId]		INT NOT NULL DEFAULT ((0)),							-- 网络培训班Id
	[RequiredTaskName]		NVARCHAR(50),										-- 网络培训班名称
	[RequiredItemId]		INT NOT NULL DEFAULT ((0)),							-- 必修项Id
	[RequiredItemName]		NVARCHAR(50),										-- 必修项名称
	[StudyTimeSpan]         INT NOT NULL,										-- 有效学习时长(秒)
	[LearningPoint]	        DECIMAL(18,2) NOT NULL,								-- 学习积分
	[AppStudyTimeSpan]      INT NOT NULL,										-- APP有效学习时长(秒)
	[AppLearningPoint]	    DECIMAL(18,2) NOT NULL,								-- APP学习积分
	[FolderId]				INT NOT NULL,										-- 试题文件夹ID	
	[FolderFullPath]		NVARCHAR(260),										-- 试题文件夹FullPath
	[RightCount]			INT NOT NULL,										-- 做对题量
	[WrongCount]			INT NOT NULL,										-- 做错题量
	[AppRightCount]			INT NOT NULL,										-- 做对题量
	[AppWrongCount]			INT NOT NULL,										-- 做错题量
	[Month]					INT NOT NULL,										-- 学习时间之月
	[Quarter]				INT NOT NULL,										-- 学习时间之季
	[HalfYear]				INT NOT NULL,										-- 学习时间之半年
	[Year]					INT NOT NULL,										-- 学习时间之年
	[EmployeeRecordType]    INT NOT NULL,										-- 学习形式之个人报表行记录的学习类型(试题、试卷、媒体、专辑、网络培训班)
)
CREATE UNIQUE NONCLUSTERED INDEX [IDX_StudyDate_EmployeeId_StudyMode_FolderId] ON [dbo].[EmployeeQuesStudyDetail] 
(
	[StudyDate] ASC,
	[EmployeeId] ASC,
	[StudyMode] ASC,
	[FolderId] ASC
)
GO

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

PRINT'--人员试卷学习明细表'
CREATE TABLE [dbo].[EmployeePaperStudyDetail](
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,
	[EmployeeId]			INT NOT NULL,										-- 人员Id
	[EmployeeName]			NVARCHAR(50) NOT NULL,								-- 人员姓名
	[DeptId]				INT NOT NULL,										-- 部门Id	
	[DeptFullPath]			NVARCHAR(260) NOT NULL,								-- 部门FullPath
	[PostId]				INT NOT NULL,										-- 岗位Id
	[PostName]				NVARCHAR(50),										-- 岗位名称
	[StudyDate]				SMALLDATETIME NOT NULL,								-- 学习时间	
	[StudyType]             INT NOT NULL,										-- 学习方式(开卷、闭卷)
	[StudyMode]             INT NOT NULL,										-- 学习形式(试题、试卷、视频、音频、文档、必修)
	[RequiredTaskId]		INT NOT NULL DEFAULT ((0)),							-- 网络培训班Id
	[RequiredTaskName]		NVARCHAR(50),										-- 网络培训班名称
	[RequiredItemId]		INT NOT NULL DEFAULT ((0)),							-- 必修项Id
	[RequiredItemName]		NVARCHAR(50),										-- 必修项名称
	[StudyTimeSpan]         INT NOT NULL,										-- 有效学习时长(秒)
	[LearningPoint]	        DECIMAL(18,2) NOT NULL,								-- 学习积分
	[AppStudyTimeSpan]      INT NOT NULL,										-- APP有效学习时长(秒)
	[AppLearningPoint]	    DECIMAL(18,2) NOT NULL,								-- APP学习积分
	[PaperPackageId]        INT NOT NULL,										-- 组卷方案Id
	[PaperName]				NVARCHAR(50) NOT NULL,								-- 试卷名称
	[Score]					DECIMAL(18,1) NOT NULL,								-- 得分
	[TotalScore]			DECIMAL(18,1) NOT NULL,								-- 总分
	[Month]					INT NOT NULL,										-- 学习时间之月
	[Quarter]				INT NOT NULL,										-- 学习时间之季
	[HalfYear]				INT NOT NULL,										-- 学习时间之半年
	[Year]					INT NOT NULL,										-- 学习时间之年
	[EmployeeRecordType]    INT NOT NULL,										-- 学习形式之个人报表行记录的学习类型(试题、试卷、媒体、专辑、网络培训班)
)
GO

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

PRINT'--人员媒体学习明细表'
CREATE TABLE [dbo].[EmployeeResourceStudyDetail](
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,
	[EmployeeId]			INT NOT NULL,										-- 人员Id
	[EmployeeName]			NVARCHAR(50) NOT NULL,								-- 人员姓名
	[DeptId]				INT NOT NULL,										-- 部门Id	
	[DeptFullPath]			NVARCHAR(260) NOT NULL,								-- 部门FullPath
	[PostId]				INT NOT NULL,										-- 岗位Id
	[PostName]				NVARCHAR(50),										-- 岗位名称
	[StudyDate]				SMALLDATETIME NOT NULL,								-- 学习时间	
	[StudyType]             INT NOT NULL,										-- 学习方式(开卷、闭卷)
	[StudyMode]             INT NOT NULL,										-- 学习形式(试题、试卷、视频、音频、文档、必修)
	[RequiredTaskId]		INT NOT NULL DEFAULT ((0)),							-- 网络培训班Id
	[RequiredTaskName]		NVARCHAR(50),										-- 网络培训班名称
	[RequiredItemId]		INT NOT NULL DEFAULT ((0)),							-- 必修项Id
	[RequiredItemName]		NVARCHAR(255),										-- 必修项名称(注意：此处为资源的名称，所以长度为255)
	[StudyTimeSpan]         INT NOT NULL,										-- 有效学习时长(秒)
	[LearningPoint]	        DECIMAL(18,2) NOT NULL,								-- 学习积分	
	[AppStudyTimeSpan]      INT NOT NULL,										-- APP有效学习时长(秒)
	[AppLearningPoint]	    DECIMAL(18,2) NOT NULL,								-- APP学习积分
	[AlbumId]		        INT NOT NULL,										-- 资源Id
	[AlbumName]				NVARCHAR(255) NOT NULL,								-- 专辑名称	
	[ResourceId]            INT NOT NULL,										-- 资源Id
	[ResourceName]			NVARCHAR(255) NOT NULL,								-- 资源名称	
	[Month]					INT NOT NULL,										-- 学习时间之月
	[Quarter]				INT NOT NULL,										-- 学习时间之季
	[HalfYear]				INT NOT NULL,										-- 学习时间之半年
	[Year]					INT NOT NULL,										-- 学习时间之年
	[EmployeeRecordType]    INT NOT NULL,										-- 学习形式之个人报表行记录的学习类型(试题、试卷、媒体、专辑、网络培训班)
)
CREATE UNIQUE NONCLUSTERED INDEX [IDX_StudyDate_EmployeeId_StudyMode_ResourceId] ON [dbo].[EmployeeResourceStudyDetail] 
(
	[StudyDate] ASC,
	[EmployeeId] ASC,
	[StudyMode] ASC,
	[ResourceId] ASC
)
GO

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

PRINT'--人员课程学习明细表'
CREATE TABLE [dbo].[EmployeeLessonStudyDetail](
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,
	[EmployeeId]			INT NOT NULL,										-- 人员Id
	[EmployeeName]			NVARCHAR(50) NOT NULL,								-- 人员姓名
	[DeptId]				INT NOT NULL,										-- 部门Id	
	[DeptFullPath]			NVARCHAR(260) NOT NULL,								-- 部门FullPath
	[PostId]				INT NOT NULL,										-- 岗位Id
	[PostName]				NVARCHAR(50),										-- 岗位名称
	[StudyDate]				SMALLDATETIME NOT NULL,								-- 学习时间	
	[StudyType]             INT NOT NULL,										-- 学习方式(开卷、闭卷)
	[StudyMode]             INT NOT NULL,										-- 学习形式(试题、试卷、视频、音频、文档、必修)
	[RequiredTaskId]		INT NOT NULL DEFAULT ((0)),							-- 网络培训班Id
	[RequiredTaskName]		NVARCHAR(50),										-- 网络培训班名称
	[RequiredItemId]		INT NOT NULL DEFAULT ((0)),							-- 必修项Id
	[RequiredItemName]		NVARCHAR(50),										-- 必修项名称
	[LessonId]				INT NOT NULL,										-- 课程ID	
	[LessonName]			NVARCHAR(50),										-- 课程名称
	[StudyTimeSpan]         INT NOT NULL,										-- 有效学习时长(秒)
	[LearningPoint]	        DECIMAL(18,2) NOT NULL,								-- 学习积分
	[OpenStudyTimeSpan]     INT NOT NULL,										-- 有效学习时长(秒)
	[OpenLearningPoint]	    DECIMAL(18,2) NOT NULL,								-- 学习积分
	[CloseStudyTimeSpan]    INT NOT NULL,										-- 有效学习时长(秒)
	[CloseLearningPoint]	DECIMAL(18,2) NOT NULL,								-- 学习积分	
	[RightCount]			INT NOT NULL,										-- 做对题量
	[WrongCount]			INT NOT NULL,										-- 做错题量
	[Month]					INT NOT NULL,										-- 学习时间之月
	[Quarter]				INT NOT NULL,										-- 学习时间之季
	[HalfYear]				INT NOT NULL,										-- 学习时间之半年
	[Year]					INT NOT NULL,										-- 学习时间之年
	[EmployeeRecordType]    INT NOT NULL,										-- 学习形式之个人报表行记录的学习类型(试题、试卷、媒体、专辑、网络培训班)
)
CREATE UNIQUE NONCLUSTERED INDEX [IDX_EmployeeLessonStudyDetail_StudyDate_EmployeeId_LessonId] ON [dbo].[EmployeeLessonStudyDetail] 
(
	[StudyDate] ASC,
	[EmployeeId] ASC,	
	[LessonId] ASC
)
GO

PRINT'--人员网络培训班学习明细表'
CREATE TABLE [dbo].[EmployeeNetClassStudyDetail](
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,
	[EmployeeId]			INT NOT NULL,										-- 人员Id
	[EmployeeName]			NVARCHAR(50) NOT NULL,								-- 人员姓名
	[DeptId]				INT NOT NULL,										-- 部门Id	
	[DeptFullPath]			NVARCHAR(260) NOT NULL,								-- 部门FullPath
	[PostId]				INT NOT NULL,										-- 岗位Id
	[PostName]				NVARCHAR(50),										-- 岗位名称
	[StudyDate]				SMALLDATETIME NOT NULL,								-- 学习时间	
	[StudyType]             INT NOT NULL,										-- 学习方式(开卷、闭卷)
	[StudyMode]             INT NOT NULL,										-- 学习形式(试题、试卷、视频、音频、文档、必修)
	[RequiredTaskId]		INT NOT NULL DEFAULT ((0)),							-- 网络培训班Id
	[RequiredTaskName]		NVARCHAR(50),										-- 网络培训班名称
	[RequiredItemId]		INT NOT NULL DEFAULT ((0)),							-- 必修项Id
	[RequiredItemName]		NVARCHAR(50),										-- 必修项名称
	[NetClassId]			INT NOT NULL,										-- 课程ID	
	[NetClassName]			NVARCHAR(50),										-- 课程名称
	[StudyTimeSpan]         INT NOT NULL,										-- 有效学习时长(秒)
	[LearningPoint]	        DECIMAL(18,2) NOT NULL,								-- 学习积分
	[OpenStudyTimeSpan]     INT NOT NULL,										-- 有效学习时长(秒)
	[OpenLearningPoint]	    DECIMAL(18,2) NOT NULL,								-- 学习积分
	[CloseStudyTimeSpan]    INT NOT NULL,										-- 有效学习时长(秒)
	[CloseLearningPoint]	DECIMAL(18,2) NOT NULL,								-- 学习积分	
	[RightCount]			INT NOT NULL,										-- 做对题量
	[WrongCount]			INT NOT NULL,										-- 做错题量
	[Month]					INT NOT NULL,										-- 学习时间之月
	[Quarter]				INT NOT NULL,										-- 学习时间之季
	[HalfYear]				INT NOT NULL,										-- 学习时间之半年
	[Year]					INT NOT NULL,										-- 学习时间之年
	[EmployeeRecordType]    INT NOT NULL,										-- 学习形式之个人报表行记录的学习类型(试题、试卷、媒体、专辑、网络培训班)
)
CREATE UNIQUE NONCLUSTERED INDEX [IDX_EmployeeNetClassStudyDetail_StudyDate_EmployeeId_NetClassId] ON [dbo].[EmployeeNetClassStudyDetail] 
(
	[StudyDate] ASC,
	[EmployeeId] ASC,	
	[NetClassId] ASC
)
GO

PRINT'--学员媒体评分表'
CREATE TABLE [dbo].[EmployeeResourceGrade]
(
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,
	[EmployeeId]			INT NOT NULL,									--人员Id
	[ResourceGradeType]		INT NOT NULL,									--人员媒体评分类型
	[ResourceId]			INT NOT NULL,									--资源Id
	[IsRecommend]			BIT NOT NULL,									--是否推荐			
	[GradeDate]				SMALLDATETIME NOT NULL,                         --评分日期
)

PRINT'--学员试题学习位置表'
CREATE TABLE [dbo].[QuesStudyPosition]
(
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,
	[EmployeeId]			INT NOT NULL,									--人员Id
	[StudyMode]				INT NOT NULL,									--学习模式
	[QFolderId]				INT NOT NULL,									--试题文件夹Id
	[QtId]					INT NOT NULL,									--题型Id，等于-1就是全部题型
	[QuestionId]			INT NOT NULL,									--试题Id
	[LastUpdateDate]		DATETIME NOT NULL,								--最后修改时间
)
CREATE UNIQUE NONCLUSTERED INDEX [IDX_EmployeeId_StudyMode_QFolderId] ON [dbo].[QuesStudyPosition] 
(
	[EmployeeId] ASC,
	[StudyMode] ASC,
	[QFolderId] ASC
)
GO

PRINT'--学员媒体学习位置表'
CREATE TABLE [dbo].[ResourceStudyPosition]
(
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,
	[EmployeeId]			INT NOT NULL,									--人员Id
	[Md5]					NVARCHAR(50) NOT NULL,							--Md5
	[StudyPosition]			INT NOT NULL,									--学习位置(时长、页码)
	[LastUpdateDate]		DATETIME NOT NULL,								--最后修改时间
)
CREATE UNIQUE NONCLUSTERED INDEX [IDX_EmployeeId_Md5] ON [dbo].[ResourceStudyPosition] 
(
	[EmployeeId] ASC,
	[Md5] ASC
)

PRINT'--学员专辑学习位置表'
CREATE TABLE [dbo].[AlbumStudyPosition]
(
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,
	[EmployeeId]			INT NOT NULL,									--人员Id
	[StudyMode]				INT NOT NULL,									--学习模式
	[AlbumId]               INT NOT NULL,									--专辑Id
	[Md5]					NVARCHAR(50) NOT NULL,							--Md5	
)
CREATE UNIQUE NONCLUSTERED INDEX [IDX_EmployeeId_StudyMode_AlbumId] ON [dbo].[AlbumStudyPosition] 
(
	[EmployeeId] ASC,
	[StudyMode] ASC,
	[AlbumId] ASC
)
GO

PRINT'--学员排名表'
CREATE TABLE [dbo].[EmployeePaiMing]
(
	[Id]								INT IDENTITY(1,1) PRIMARY KEY,
	[EmployeeId]						INT NOT NULL UNIQUE,							--人员Id
	[IntegratePaiMing]					INT NOT NULL,									--综合排名
	[QuestionPaiMing]					INT NOT NULL,									--试题排名
	[PaperPaiMing]						INT NOT NULL,									--试卷排名
	[MultimediaPaiMing]					INT NOT NULL,									--媒体排名
	[PreIntegratePaiMing]				INT NOT NULL,									--上一次综合排名
	[PreQuestionPaiMing]				INT NOT NULL,									--上一次试题排名
	[PrePaperPaiMing]					INT NOT NULL,									--上一次试卷排名
	[PreMultimediaPaiMing]				INT NOT NULL,									--上一次媒体排名
)
GO

PRINT'--学员排名计算时间表'
CREATE TABLE [dbo].[EmployeePaiMingComputeDate]
(
	[ComputeDate]								DATETIME NOT NULL,					--排名计算时间
)
GO
COMMIT TRANSACTION