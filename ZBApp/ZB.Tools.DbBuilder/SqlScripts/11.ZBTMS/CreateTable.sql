
USE [$(DatabaseName)]
GO
BEGIN TRANSACTION


PRINT '------ 年度培训计划 ------'
CREATE TABLE  [dbo].[TrainingYearPlan](
	[Id]					INT PRIMARY KEY NOT NULL,							-- 年度培训计划ID
	[DeptId]				INT NOT NULL,										-- 计划所在的部门	
	[DeptFullPath]			NVARCHAR(260) NOT NULL,								-- 计划所在部门全路径
	[PlanYear]				INT NOT NULL,										-- 年度
	[Deadline]				DATETIME NOT NULL,									-- 计划上报截止日期
	[IncludeOpinion]		BIT NOT NULL DEFAULT 1,								-- 是否包含领导意见（默认为： 1 包含）
	[OpenBudget]			BIT NOT NULL DEFAULT 0,								-- 是否公开项目预算(默认为：0 不公开)
	[PlanStage]				INT NOT NULL,										-- 计划阶段，(TrainingPlanStageEnum的内容)
	[Auditor]				INT NOT NULL,										-- 计划审核人员，只有该人员可以往上级上报项目
)
GO

/*一个部门一年只能有一个年度计划*/
CREATE UNIQUE NONCLUSTERED INDEX [IDX_DeptId_PlanYear] ON [dbo].[TrainingYearPlan]
(
	[DeptId] ASC,
	[PlanYear] ASC
)
GO


PRINT '------ 年度培训计划对应的部门范围------'
CREATE TABLE [dbo].[TrainingPlanDeptRange](
	[Id]				INT IDENTITY(1,1) PRIMARY KEY,							--Id
	[TrainingPlanId]	INT NOT NULL,											--培训计划Id
	[DeptId]			INT NOT NULL,											--上报部门Id	
)
GO

ALTER TABLE [TrainingPlanDeptRange] WITH CHECK ADD
	CONSTRAINT [FK_TrainingPlanDeptRange_TrainingYearPlan] FOREIGN KEY([TrainingPlanId]) REFERENCES [TrainingYearPlan]([Id])
GO

/*一个部门在培训计划内仅能出现一次*/
CREATE UNIQUE NONCLUSTERED INDEX [IDX_TrainingPlanId_DeptId] ON [dbo].[TrainingPlanDeptRange]
(
	[TrainingPlanId] ASC,
	[DeptId] ASC
)
GO

PRINT '------项目库------'
CREATE TABLE [dbo].[ProjectLibrary](
	[Id]						INT PRIMARY KEY,				--项目ID
	[ProjectName]				NVARCHAR(50) NOT NULL,			--项目名称
	[IsPublish]					BIT NOT NULL DEFAULT 0,			--是否私密项目
	[CreateId]					INT NOT NULL,					--项目创建人ID（EmployeeId）
	[CreatedName]				NVARCHAR(50) NOT NULL,			--项目创建人名字
	[ProjectType1]				INT NOT NULL,					--项目类型1(ProjectType1Enum枚举，培训班、考试等)
	[ProjectType2]				INT NOT NULL,					--培训类型2(ProjectType2Enum枚举，内部,外部等)
	[Budget]					DECIMAl(18,2) NOT NULL,			--预算
	[ProjectDesc]				NVARCHAR(500),					--说明
	[SponsorDept]				NVARCHAR(50),					--主办单位(当项目培训类型为外部时，此字段不能为空)
	[CreateDate]				DATETIME NOT NULL,				--项目创建时间
	[ProjectLibraryStatus]		INT NOT NULL DEFAULT 0,			--项目库内的项目状态(普通、变更，仅在项目库有效)
)
GO


PRINT '------项目培训分类------'
CREATE TABLE [dbo].[ProjectTrainingCategory](
	[Id]				INT PRIMARY KEY,					--
	[ProjectId]			INT NOT NULL,						--项目ID
	[CategoryId]		INT NOT NULL,						--培训分类ID
)
GO

ALTER TABLE [ProjectTrainingCategory] WITH CHECK ADD
	CONSTRAINT [FK_ProjectTrainingCategory_ProjectLibrary] FOREIGN KEY([ProjectId]) REFERENCES [ProjectLibrary]([Id])
GO

ALTER TABLE [ProjectTrainingCategory] WITH CHECK ADD
	CONSTRAINT [FK_ProjectTrainingCategory_TrainingCategory] FOREIGN KEY([CategoryId]) REFERENCES [TrainingCategory]([Id])
GO

/*一个培训分类仅有一次*/
CREATE UNIQUE NONCLUSTERED INDEX [IDX_ProjectId_CategoryId] ON [dbo].[ProjectTrainingCategory]
(
	[ProjectId] ASC,
	[CategoryId] ASC
)
GO



PRINT '-------项目相关单位----------'
CREATE TABLE [dbo].[ProjectRelatedDept](
	[Id]				INT PRIMARY KEY,					--
	[ProjectId]			INT NOT NULL,						--项目ID
	[DeptId]			INT NOT NULL,						--部门ID
	[DeptName]			NVARCHAR(255) NOT NULL,				--部门名称
	[RelatedRole]		INT NOT NULL,						--角色(ProjectRelatedDeptEnum,发起单位,主管单位,主办单位，协办单位)
)
GO
ALTER TABLE [ProjectRelatedDept] WITH CHECK ADD
	CONSTRAINT [FK_ProjectRelatedDept_ProjectLibrary] FOREIGN KEY([ProjectId]) REFERENCES [ProjectLibrary]([Id])
GO


PRINT '------项目期次------'
CREATE TABLE [dbo].[ProjectPeriod](
	[Id]					INT PRIMARY KEY,				--期次ID
	[ProjectId]				INT NOT NULL,					--项目ID
	[PeriodIndex]			INT NOT NULL,					--期次序号(从1开始)
	[StartDate]				DATETIME NOT NULL,				--开始时间
	[EndDate]				DATETIME NOT NULL,				--结束时间
	[PeopleCount]			INT NOT NULL,					--单期人数
)
GO
ALTER TABLE [ProjectPeriod] WITH CHECK ADD
	CONSTRAINT [FK_ProjectPeriod_ProjectLibrary] FOREIGN KEY([ProjectId]) REFERENCES [ProjectLibrary]([Id])
GO




PRINT '------项目历史信息明细表------'
CREATE TABLE [dbo].[ProjectHistoryDetail](
	[Id]						INT PRIMARY KEY,
	[ProjectName]				NVARCHAR(50) NOT NULL,				--项目名称
	[ProjectType1]				NVARCHAR(50) NOT NULL,				--项目类型1(培训班、考试等)
	[ProjectType2]				NVARCHAR(50) NOT NULL,				--培训类型2(内部,外部)
	[Budget]					DECIMAl(18,2) NOT NULL,				--预算
	[SponsorDept]				NVARCHAR(50),						--主办单位，外部时使用
	[ProjectDesc]				NVARCHAR(500),						--项目说明
	[ProjectManageDept]			INT NOT NULL,						--项目主管部门ID（冗余字段，报表时使用）
	[TrainingCategory]			VARBINARY(MAX),						--培训分类
	[ProjectRelatedDept]		VARBINARY(MAX),						--项目相关部门信息
	[ProjectPeriod]				VARBINARY(MAX),						--项目相关期次信息	
	[ProjectAttach]				VARBINARY(MAX),						--项目相关附件信息
	[ProjectOpinion]			VARBINARY(MAX),						--项目领导意见信息
)

PRINT '------项目历史信息表------'
CREATE TABLE [dbo].[ProjectHistory](
	[Id]						INT PRIMARY KEY,
	[ParentId]					INT NOT NULL DEFAULT 0,				--父ID
	[FullPath]					NVARCHAR(255) NOT NULL,				--全路径(以ID为路径的FullPath)
	[PlanId]					INT,								--培训计划ID
	[PlanTemporary]				BIT,								--计划是否是临时计划
	[PlanStage]					INT,								--计划阶段
	[PlanYear]					INT,								--计划年度
	[PlanDept]					NVARCHAR(255),						--计划所在部门
	[ProjectId]					INT NOT NULL,						--项目ID
	[HistoryDateTime]			DATETIME NOT NULL,					--历史记录的时间
	[HistoryType]				INT NOT NULL,						--历史记录类型(HistoryTypeEnum)
	[OperChangedType]			INT NOT NULL DEFAULT 0,				--变更类型（ChangedTypeEnum）
	[OperEmployeeNO]			NVARCHAR(50) NOT NULL,				--操作人编号
	[OperEmployeeName]			NVARCHAR(50) NOT NULL,				--操作人姓名
	[OperDeptName]				NVARCHAR(255) NOT NULL,				--操作人所在部门
	[OperDesc]					NVARCHAR(500),						--操作说明（例如审核附言）
	[DetailId]					INT NOT NULL,						--历史记录的明细
)
GO

ALTER TABLE [ProjectHistory] WITH CHECK ADD
	CONSTRAINT [FK_ProjectHistory_ProjectLibrary] FOREIGN KEY([ProjectId]) REFERENCES [ProjectLibrary]([Id])
GO

ALTER TABLE [ProjectHistory] WITH CHECK ADD
	CONSTRAINT [FK_ProjectHistory_ProjectHistoryDetail] FOREIGN KEY([DetailId]) REFERENCES [ProjectHistoryDetail]([Id])
GO



PRINT '------计划项目------'
CREATE TABLE [dbo].[PlanProject](
	[ProjectId]				INT PRIMARY KEY,					--项目ID
	[TrainingPlanId]		INT NULL,							--所属计划ID（当计划ID为空时，表示该项目为直接启动的项目，不属于任何计划）
	[TemporaryPlan]			BIT NOT NULL,						--是否临时计划
	[ProjectStatus]			INT NOT NULL,						--项目状态(ProjectStatusEnum)
)
GO
ALTER TABLE [PlanProject] WITH CHECK ADD
	CONSTRAINT [FK_PlanProject_ProjectLibrary] FOREIGN KEY([ProjectId]) REFERENCES [ProjectLibrary]([Id])
GO

ALTER TABLE [PlanProject] WITH CHECK ADD
	CONSTRAINT [FK_PlanProject_TrainingYearPlan] FOREIGN KEY([TrainingPlanId]) REFERENCES [TrainingYearPlan]([Id])
GO

/*一个培训项目只能属于一个培训计划*/
CREATE UNIQUE NONCLUSTERED INDEX [IDX_ProjectId_TrainingPlanId] ON [dbo].[PlanProject]
(
	[ProjectId] ASC,
	[TrainingPlanId] ASC
)
GO

PRINT '------ 培训内容分类 ------'
CREATE TABLE  [dbo].[TrainingContentType](
	[Id]					INT PRIMARY KEY,
	[ObjectName]			NVARCHAR(50) NOT NULL,									-- 培训项目内容	
	[ParentId]				INT NOT NULL,
	[FullPath]				NVARCHAR(260) NOT NULL UNIQUE,							-- 全路径，不能有两个相同的路径
	[LockStatus]			INT NOT NULL,							
	[SortIndex]				INT NOT NULL DEFAULT 0,
)
GO
PRINT'--确保一个培训内容分类下的子节点名称不重复--'
CREATE UNIQUE NONCLUSTERED INDEX [IDX_TrainingContentType_ParentId_ObjectName] ON [dbo].[TrainingContentType] 
(
	[ParentId] ASC,
	[ObjectName] ASC
)
GO
COMMIT TRANSACTION