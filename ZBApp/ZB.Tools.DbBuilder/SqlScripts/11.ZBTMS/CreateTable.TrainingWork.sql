USE [$(DatabaseName)]
GO
BEGIN TRANSACTION


PRINT '------培训项目规则------'
CREATE TABLE [dbo].[TrainingProjectRule](
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,
	[TrainingProjectId]		INT NOT NULL,							--培训项目ID
	[ResponsibleId]			INT NOT NULL,							--负责人
	[ResponsibleName]		NVARCHAR(50) NOT NULL,					--负责人姓名
	[PassRule]				VARBINARY(MAX),							--通过规则（TMSTrainingProjectRuleObj）	
)
ALTER TABLE [TrainingProjectRule] WITH CHECK ADD
	CONSTRAINT [FK_TrainingProjectRule_TrainingProjectId] FOREIGN KEY ([TrainingProjectId]) REFERENCES [ProjectLibrary]([Id])
GO


PRINT '------培训期次------'
CREATE TABLE [dbo].[TrainingOnWorkPeriod](
	[Id]					INT PRIMARY KEY,					--期次ID
	[TrainingProjectId]		INT NOT NULL,						--培训项目ID
	[StartTime]				DATETIME NOT NULL,					--启动时间
	[EndTime]				DATETIME NOT NULL,					--结束时间
	[WorkState]				INT NOT NULL,						--状态(未启动，进行中，已完成)
	[ResponsibleId]			INT NOT NULL,						--负责人
	[ResponsibleName]		NVARCHAR(50) NOT NULL,				--负责人姓名
)
GO


ALTER TABLE [TrainingOnWorkPeriod] WITH CHECK ADD
	CONSTRAINT [FK_TrainingOnWorkPeriod_TrainingProjectId] FOREIGN KEY ([TrainingProjectId]) REFERENCES [ProjectLibrary]([Id])
GO


PRINT '-----培训期次人员------'
CREATE TABLE [dbo].[TrainingOnWorkPeriodEmployee](
	[Id]					INT PRIMARY KEY,
	[PeriodId]				INT NOT NULL,							--培训期次ID
	[EmployeeId]			INT NOT NULL,							--人员ID
	[EmployeeNO]			NVARCHAR(50) NOT NULL,					--人员编号
	[EmployeeName]			NVARCHAR(50) NOT NULL,					--人员姓名
	[Age]					INT,									--年龄
	[Sex]					INT,									--性别
	[DeptId]				INT NOT NULL,							--部门ID
	[DeptName]				NVARCHAR(255) NOT NULL,					--部门名称
	[Depth]					INT NOT NULL,							--部门深度
	[PostId]				INT NOT NULL DEFAULT 0,					--岗位ID
	[PostName]				NVARCHAR(50),							--岗位名称
)
GO

ALTER TABLE [TrainingOnWorkPeriodEmployee] WITH CHECK ADD
	CONSTRAINT [FK_TrainingOnWorkPeriodEmployee_PeriodId] FOREIGN KEY ([PeriodId]) REFERENCES [TrainingOnWorkPeriod]([Id])
GO

/*同一人员在同一期次内仅出现一次*/
CREATE UNIQUE NONCLUSTERED INDEX [IDX_PeriodId_EmployeeId] ON [dbo].[TrainingOnWorkPeriodEmployee]
(
	[PeriodId] ASC,
	[EmployeeId] ASC
)
GO

PRINT '-----培训事务------'
CREATE TABLE [dbo].[TrainingOnWork](
	[Id]						INT PRIMARY KEY NOT NULL,			--培训事务ID
	[DeptId]					INT,								--部门ID
	[TrainingPlanId]			INT,								--培训计划ID

	[TrainingProjectId]			INT,								--培训项目ID
	[PeriodId]					INT,								--培训期次ID

	[FlowId]					INT NOT NULL DEFAULT 0,				--事务流ID，为0时代表不在任何事务流
	[GroupId]					INT NOT NULL DEFAULT 0,				--事务组ID，为0时代表不在任何事务组
	[IsGroup]					BIT NOT NULL,						--是否为事务组
	[IsFlow]					BIT NOT NULL,						--是否为事务流
	
	[ObjectName]				NVARCHAR(50) NOT NULL,				--事务名称
	[ProjectType1]				INT NOT NULL,						--培训事务类型1(培训班、考试等，ProjectType1Enum)
	
	[OnlineId]					INT NOT NULL DEFAULT 0,				--如果培训方式为网上培训并且培训事务从网上引入时，此ID为网络(培训班、考试)的ID
	[CreateTime]				DATETIME NOT NULL,					--创建时间
	[StartTime]					DATETIME,							--启动时间
	[EndTime]					DATETIME,							--结束时间
	[WorkUnitId]				INT NULL,							--单位，对应TrainingUnitInType.Id
	[WorkUnitName]				NVARCHAR(50) NULL,					--单位名称
	[WorkState]					INT NOT NULL,						--状态(未启动，进行中，已完成, 待上报，待审，驳回，通过)
	[WorkDesc]					NVARCHAR(500),						--说明
	[WorkResultRule]			VARBINARY(MAX),						--输出结果规则	
	[RuleKey]					NVARCHAR(36) NOT NULL,				--规则Key
	[CreatorId]					INT NOT NULL,						--创建人ID
	[CreatorName]				NVARCHAR(50) NOT NULL,				--创建人姓名
	[CreatorId1]				INT,								--上报事务的创建人
	[CreatorName1]				NVARCHAR(50),						--上报事务的创建人姓名
	[ResponsibleId]				INT NOT NULL,						--负责人
	[ResponsibleName]			NVARCHAR(50) NOT NULL,				--负责人姓名
	[EndMonth]					INT NOT NULL,						--培训事务结束月份
	[EndQuarter]				INT NOT NULL,						--培训事务结束季度
	[EndHalfYear]				INT NOT NULL,						--培训事务结束半年度
	[EndYear]					INT NOT NULL,						--培训事务结束年度	
)
GO

ALTER TABLE [TrainingOnWork] WITH CHECK ADD
	CONSTRAINT [FK_TrainingOnWork_TrainingProjectId] FOREIGN KEY ([TrainingProjectId]) REFERENCES [ProjectLibrary]([Id])
GO

ALTER TABLE [TrainingOnWork] WITH CHECK ADD
	CONSTRAINT [FK_TrainingOnWork_TrainingOnWorkPeriod] FOREIGN KEY ([PeriodId]) REFERENCES [TrainingOnWorkPeriod]([Id])
GO


PRINT '---------培训事务审核历史-----------------'
CREATE TABLE [dbo].[TrainingOnWorkHistory](
	[Id]				INT PRIMARY KEY,
	[WorkId]			INT NOT NULL,					--事务ID
	[Operated]			INT NOT NULL,					--操作人
	[OperatedName]		NVARCHAR(50) NOT NULL,			--操作人名字
	[DeptId]			INT,							--当前部门ID
	[DeptName]			NVARCHAR(255) NOT NULL,			--部门名称
	[AuditDeptId]		INT NOT NULL,					--审核部门
	[AuditDeptName]		NVARCHAR(255) NOT NULL,			--审核部门名称
	[WorkState]			INT NOT NULL,					--状态
	[OperateDesc]		NVARCHAR(500),					--备注
	[OperatedTime]		DATETIME NOT NULL,				--操作时间
)
GO

ALTER TABLE [TrainingOnWorkHistory] WITH CHECK ADD
	CONSTRAINT [FK_TrainingOnWorkHistory_WorkId] FOREIGN KEY ([WorkId]) REFERENCES [TrainingOnWork]([Id])
GO


PRINT '---------培训事务依赖关系-----------------'
CREATE TABLE [dbo].[TrainingOnWorkDepend](
	[Id]				INT PRIMARY KEY,
	[WorkId]			INT NOT NULL,					--事务ID
	[DependWorkId]		INT NOT NULL,					--依赖的事务ID
)
GO

ALTER TABLE [TrainingOnWorkDepend] WITH CHECK ADD
	CONSTRAINT [FK_TrainingOnWorkDepend_WorkId] FOREIGN KEY ([WorkId]) REFERENCES [TrainingOnWork]([Id])
GO

ALTER TABLE [TrainingOnWorkDepend] WITH CHECK ADD
	CONSTRAINT [FK_TrainingOnWorkDepend_DependWorkId] FOREIGN KEY ([DependWorkId]) REFERENCES [TrainingOnWork]([Id])
GO

/*同一个培训事务之间的依赖关系仅允许一次*/
CREATE UNIQUE NONCLUSTERED INDEX [IDX_WorkId_DependWorkId] ON [dbo].[TrainingOnWorkDepend]
(
	[WorkId] ASC,
	[DependWorkId] ASC
)
GO


PRINT '-----培训事务属性------'
CREATE TABLE [dbo].[TrainingOnWorkAttribute](
	[Id]					INT PRIMARY KEY,
	[WorkId]				INT NOT NULL,
	[AttrId]				INT NOT NULL,
	[AttrFullPath]			NVARCHAR(260) NOT NULL,
	[AttrParentValueId]		INT NOT NULL,
	[AttrValueId]			INT NOT NULL,
	[AttrValueFullPath]		NVARCHAR(260) NOT NULL
)
GO

ALTER TABLE [TrainingOnWorkAttribute] WITH CHECK ADD
	CONSTRAINT [FK_TrainingOnWorkAttribute_WorkId] FOREIGN KEY ([WorkId]) REFERENCES [TrainingOnWork]([Id])
GO


PRINT '-----培训事务培训分类------'
CREATE TABLE [dbo].[TrainingOnWorkCategory](
	[Id]			INT PRIMARY KEY,
	[WorkId]		INT NOT NULL,					--事务ID
	[CategoryId]	INT NOT NULL					--培训分类ID
)
GO

ALTER TABLE [TrainingOnWorkCategory] WITH CHECK ADD
	CONSTRAINT [FK_TrainingOnWorkCategory_WorkId] FOREIGN KEY ([WorkId]) REFERENCES [TrainingOnWork]([Id])
GO

/*同一个培训分类仅能出现一次*/
CREATE UNIQUE NONCLUSTERED INDEX [IDX_WorkId_CategoryId] ON [dbo].[TrainingOnWorkCategory]
(
	[WorkId] ASC,
	[CategoryId] ASC
)
GO


PRINT '-----培训事务工作人员------'
CREATE TABLE [dbo].[TrainingOnWorkStaff](
	[Id]					INT PRIMARY KEY IDENTITY(1,1),
	[WorkId]				INT NOT NULL,							--培训事务ID
	[EmployeeId]			INT NOT NULL,							--人员ID
	[EmployeeName]			NVARCHAR(50) NOT NULL,					--人员姓名
	[DeptName]				NVARCHAR(255) NOT NULL,					--部门名称
	[PostName]				NVARCHAR(50),							--岗位名称
	[StaffRole]				INT NOT NULL,							--角色(对应不同事务类型(培训班、考试等)的工作人员角色，复合枚举)
)
GO

ALTER TABLE [TrainingOnWorkStaff] WITH CHECK ADD
	CONSTRAINT [FK_TrainingOnWorkStaff_WorkId] FOREIGN KEY ([WorkId]) REFERENCES [TrainingOnWork]([Id])
GO

/*同一个人员在同一事务内角色仅出现一次，此处为复合枚举*/
CREATE UNIQUE NONCLUSTERED INDEX [IDX_TrainingOnWorkStaff_WorkId_EmployeeId_StaffRole] ON [TrainingOnWorkStaff] 
(
	[WorkId] ASC,
	[EmployeeId] ASC,
	[StaffRole] ASC
)
GO


PRINT '-----培训事务人员------'
CREATE TABLE [dbo].[TrainingOnWorkEmployee](
	[Id]					INT PRIMARY KEY,
	[WorkId]				INT NOT NULL,							--培训事务ID
	[EmployeeId]			INT NOT NULL,							--人员ID
	[EmployeeNO]			NVARCHAR(50) NOT NULL,					--人员编号
	[EmployeeName]			NVARCHAR(50) NOT NULL,					--人员姓名
	[Age]					INT,									--年龄
	[Sex]					INT,									--性别
	[DeptId]				INT NOT NULL,							--部门ID
	[DeptName]				NVARCHAR(255) NOT NULL,					--部门名称
	[Depth]					INT NOT NULL,							--部门深度
	[PostId]				INT NOT NULL DEFAULT 0,					--岗位ID
	[PostName]				NVARCHAR(50),							--岗位名称
	[Credit]				DECIMAL(18,1),							--学分,(null:未设定)
	[MinCredit]				DECIMAL(18,1),							--最小学分范围
	[MaxCredit]				DECIMAL(18,1),							--最大学分范围
	[IsMatch]				BIT,									--是否设置学分规则
)
GO

ALTER TABLE [TrainingOnWorkEmployee] WITH CHECK ADD
	CONSTRAINT [FK_TrainingOnWorkEmployee_WorkId] FOREIGN KEY ([WorkId]) REFERENCES [TrainingOnWork]([Id])
GO

/*同一人员在同一培训事务内仅出现一次*/
CREATE UNIQUE NONCLUSTERED INDEX [IDX_WorkId_EmployeeId] ON [dbo].[TrainingOnWorkEmployee]
(
	[WorkId] ASC,
	[EmployeeId] ASC
)
GO

PRINT '-----培训事务人员结果------'
CREATE TABLE [dbo].[TrainingOnWorkEmployeeResult](
	[Id]					INT PRIMARY KEY,
	[WorkId]				INT NOT NULL,							--培训事务ID
	[EmployeeId]			INT NOT NULL,							--人员ID
	[TWEmployeeId]			INT NOT NULL,							--培训事务人员
	[UnitId]				INT NULL,								--单位ID
	[UnitName]				NVARCHAR(50) NULL,						--单位名称
	[UnitValue]				DECIMAL(18,1) NULL,						--单位值
	[DeductionValue]		DECIMAL(18,1) NOT NULL DEFAULT 0,		--扣除值
)
GO

ALTER TABLE [TrainingOnWorkEmployeeResult] WITH CHECK ADD
	CONSTRAINT [FK_TrainingOnWorkEmployeeResult_TWEmployeeId] FOREIGN KEY ([TWEmployeeId]) REFERENCES [TrainingOnWorkEmployee]([Id])
GO

PRINT  '-----培训事务人员结果明细------'
CREATE TABLE [dbo].[TrainingOnWorkEmployeeResultDetail](
	[Id]				INT PRIMARY KEY,
	[TEResultId]		INT NOT NULL,								--培训事务人员结果ID		
	[ResultTitleId]		INT NOT NULL,								--结果标题ID，对应TrainingResultInType.Id
	[ResultTitle]		NVARCHAR(50) NOT NULL,						--结果标题
	[ResultValueId]		INT NOT NULL,								--结果值ID，对应TrainingResultInType.Id
	[ResultValue]		NVARCHAR(50) NOT NULL,						--结果值
)
GO

ALTER TABLE [TrainingOnWorkEmployeeResultDetail] WITH CHECK ADD
	CONSTRAINT [FK_TrainingOnWorkEmployeeResultDetail_TEResultId] FOREIGN KEY ([TEResultId]) REFERENCES [TrainingOnWorkEmployeeResult]([Id])
GO


COMMIT TRANSACTION