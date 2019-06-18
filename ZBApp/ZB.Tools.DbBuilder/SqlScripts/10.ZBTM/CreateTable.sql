USE [$(DatabaseName)]
GO
BEGIN TRANSACTION
PRINT '------ 培训计划 ------'
CREATE TABLE  [dbo].[TrainingPlan](
	[Id]					INT PRIMARY KEY NOT NULL,
	[ObjectName]			NVARCHAR(50) NOT NULL,								-- 计划名称	
	[DeptId]				INT NOT NULL,										-- 计划所在的部门	
	[DeptFullPath]			NVARCHAR(260) NOT NULL,								-- 计划所在部门全路径
	[PlanYear]				INT NOT NULL,										-- 年度
	[PlanType]				INT NOT NULL,										-- 类型
	[StartTime]				DATETIME NOT NULL,									-- 开始时间
	[EndTime]				DATETIME NOT NULL,									-- 结束时间
	[CreatorId]				INT NOT NULL,										-- 创建人Id
	[CreatorName]			NVARCHAR(50) NOT NULL,								-- 创建用户姓名
	[CreateTime]			DATETIME NOT NULL,									-- 创建时间
)
--ALTER TABLE [TrainingPlan] WITH CHECK ADD
--	CONSTRAINT [FK_TrainingPlan_TrainingPlanType] FOREIGN KEY([PlanTypeId]) REFERENCES [TrainingPlanType]([Id])
GO

PRINT '------ 培训计划上报流程 ------'
CREATE TABLE  [dbo].[PlanFlow](
	[Id]					INT PRIMARY KEY NOT NULL,
	[PlanId]				INT NOT NULL,										-- 计划Id	
	[ReporterId]			INT NOT NULL,										-- 上报人Id
	[ReporterName]			NVARCHAR(50) NOT NULL,								-- 上报人姓名
	[ReportInfo]			NVARCHAR(MAX),										-- 上报内容
	[AuditorId]				INT NOT NULL,										-- 审核人Id
	[AuditorName]			NVARCHAR(50) NOT NULL,								-- 审核人姓名
	[AuditInfo]				NVARCHAR(MAX),										-- 审核答复
	[AuditResult]			INT NOT NULL,										-- 审核结果(0:未审核,1:通过,2:退回,3:终审)
	[ReportTime]			DATETIME NOT NULL,									-- 上报时间	
	[AuditTime]				DATETIME,											-- 审核时间(可空)	
)
ALTER TABLE [PlanFlow] WITH CHECK ADD
	CONSTRAINT [FK_PlanFlow_Plan] FOREIGN KEY([PlanId]) REFERENCES [TrainingPlan]([Id])
GO

PRINT '------ 培训项目 ------'
CREATE TABLE  [dbo].[TrainingProject](
	[Id]							INT PRIMARY KEY NOT NULL,
	[PlanId]						INT NOT NULL,										-- 计划Id	
	[ObjectName]					NVARCHAR(50) NOT NULL,								-- 项目名称	
	[DeptId]						INT NOT NULL,										-- 计划所在的部门	
	[DeptFullPath]					NVARCHAR(260) NOT NULL,								-- 培训事务所在部门全路径		
	[DirectorName]					NVARCHAR(50),										-- 负责人姓名
	[Budget]						DECIMAL(18,5),										-- 项目预算
	[StartTimeSpan]					NVARCHAR(50),										-- 计划时间段
	[TrainingContentTypeId]			INT NOT NULL,										-- 培训内容ID
	[TrainingContent]				NVARCHAR(200),										-- 培训内容描述
	[TrainingModeId]				INT NOT NULL,										-- 培训形式Id
	[CreatorId]						INT NOT NULL,										-- 创建人Id
	[StartTime]						DATETIME,											-- 启动时间(可空)	
	[EndTime]						DATETIME,											-- 结束时间(可空)	
	[CreatorName]					NVARCHAR(50) NOT NULL,								-- 创建人姓名
	[ProjectState]					INT NOT NULL,										-- 培训项目状态
)
ALTER TABLE [TrainingProject] WITH CHECK ADD
	CONSTRAINT [FK_TrainingProject_Plan] FOREIGN KEY([PlanId]) REFERENCES [TrainingPlan]([Id]),
	CONSTRAINT [FK_TrainingProject_TrainingContentType] FOREIGN KEY([TrainingContentTypeId]) REFERENCES [TrainingContentType]([Id]),
	CONSTRAINT [FK_TrainingProject_TrainingMode] FOREIGN KEY([TrainingModeId]) REFERENCES [TrainingMode]([Id])
GO

PRINT '------ 培训事务 ------'
CREATE TABLE [dbo].[TrainingWork](
	[Id]					INT PRIMARY KEY NOT NULL,
	[ObjectName]			NVARCHAR(50) NOT NULL,								-- 培训事务名称	
	[TrainingWorkTypeId]	INT NOT NULL,										-- 培训类型(培训班、考试、发证等)
	[TrainingPlanId]		INT NOT NULL,										-- 培训计划ID
	[TrainingProjectId]		INT NOT NULL,										-- 培训项目ID
	[TrainingContentTypeId]	INT NOT NULL,										-- 培训内容ID
	[DeptId]				INT NOT NULL,										-- 培训事务所在的部门	
	[DeptFullPath]			NVARCHAR(260) NOT NULL,								-- 培训事务所在部门全路径	
	[TrainingLevelId]		INT NOT NULL,										-- 培训级别
	[TrainingModeId]		INT NOT NULL,										-- 培训形式
	[TrainingKindId]		INT NOT NULL,										-- 培训分类
	[StartTime]				DATETIME,											-- 启动时间
	[EndTime]				DATETIME,											-- 结束时间	
	[TrainingWorkState]		INT NOT NULL,										-- 状态(进行中，已完成)
	[CreatorId]				INT NOT NULL,										-- 创建人Id
	[CreatorName]			NVARCHAR(50) NOT NULL,								-- 创建用户姓名
	[CreateTime]			DATETIME NOT NULL,									-- 创建时间
	[EndMonth]				INT NOT NULL,										-- 培训事务结束日期之月
	[EndQuarter]			INT NOT NULL,										-- 培训事务结束日期之季
	[EndHalfYear]			INT NOT NULL,										-- 培训事务结束日期之半年
	[EndYear]				INT NOT NULL,										-- 培训事务结束日期之年
)
ALTER TABLE [TrainingWork] WITH CHECK ADD
	CONSTRAINT [FK_TrainingWork_TrainingWorkType] FOREIGN KEY([TrainingWorkTypeId]) REFERENCES [TrainingWorkType]([Id]),	
	CONSTRAINT [FK_TrainingWork_TrainingContentType] FOREIGN KEY([TrainingContentTypeId]) REFERENCES [TrainingContentType]([Id]),	
	CONSTRAINT [FK_TrainingWork_TrainingLevel] FOREIGN KEY([TrainingLevelId]) REFERENCES [TrainingLevel]([Id]),	
	CONSTRAINT [FK_TrainingWork_TrainingKind] FOREIGN KEY([TrainingKindId]) REFERENCES [TrainingKind]([Id]),
	CONSTRAINT [FK_TrainingWork_TrainingMode] FOREIGN KEY([TrainingModeId]) REFERENCES [TrainingMode]([Id])		
GO

PRINT '------ 培训工作人员 ------'
CREATE TABLE  [dbo].[TrainingStaff](	
	[Id]						INT PRIMARY KEY IDENTITY(1,1) NOT NULL,		
	[TrainingStaffWorkType]		INT NOT NULL,										--工作人人员作类型(计划、项目、培训事务)	
	[WorkId]					INT NOT NULL,										--工作ID	
	[EmployeeId]				INT NOT NULL,										--人员Id
	[EmployeeNO]				NVARCHAR(50) NOT NULL,								--工号
	[EmployeeName]				NVARCHAR(50) NOT NULL,								--姓名
	[Age]						INT,												--年龄
	[Sex]						INT NOT NULL,										--性别 0:无 1:男 -1:女
	[DeptId]					INT NOT NULL,										--部门Id
	[DeptFullPath]				NVARCHAR(260) NOT NULL,								--部门
	[PostId]					INT NOT NULL,										--岗位Id	
	[PostName]					NVARCHAR(50),										--岗位
	[TrainingStaffRole]			INT NOT NULL										--培训工作人员角色(根据培训事务类型的不同对应不同的枚举)
)
CREATE UNIQUE NONCLUSTERED INDEX [IDX_TrainingStaffWorkType_TrainingWorkId_EmployeeId] ON [dbo].[TrainingStaff] 
(	
	[TrainingStaffWorkType] ASC,
	[WorkId] ASC,
	[EmployeeId] ASC
)
GO

PRINT '------ 培训相关人员 ------'
CREATE TABLE  [dbo].[TrainingEmployee](	
	[Id]						INT PRIMARY KEY NOT NULL,	
	[TrainingWorkId]			INT NOT NULL,										--培训事务ID	
	[EmployeeId]				INT NOT NULL,										--人员Id
	[EmployeeNO]				NVARCHAR(50) NOT NULL,								--工号
	[EmployeeName]				NVARCHAR(50) NOT NULL,								--姓名
	[Age]						INT,												--年龄
	[Sex]						INT NOT NULL,										--性别 0:无 1:男 -1:女
	[DeptId]					INT NOT NULL,										--部门Id
	[DeptFullPath]				NVARCHAR(260) NOT NULL,								--部门
	[PostId]					INT NOT NULL,										--岗位Id	
	[PostName]					NVARCHAR(50),										--岗位	
	[Credit]					DECIMAL(18,1),										--学分 null:未设定
	[MinCredit]					DECIMAL(18,1),										--最小学分范围
	[MaxCredit]					DECIMAL(18,1),										--最大学分范围
	[IsMatch]					BIT,												--是否设置学分规则
)
ALTER TABLE [TrainingEmployee] WITH CHECK ADD
	CONSTRAINT [FK_TrainingEmployee_TrainingWork] FOREIGN KEY([TrainingWorkId]) REFERENCES [TrainingWork]([Id])
GO
CREATE NONCLUSTERED INDEX [IDX_TrainingWorkId_DeptFullPath] ON [dbo].[TrainingEmployee]
(
	[TrainingWorkId] ASC,
	[DeptFullPath] ASC
)
GO

PRINT '------ 培训费用 ------'
CREATE TABLE  [dbo].[TrainingBill](
	[Id]							INT PRIMARY KEY NOT NULL,	
	[TrainingWorkTypeId]			INT NOT NULL,										-- 培训事务类型
	[TrainingWorkId]				INT NOT NULL,										-- 培训事务Id
	[BillType]						INT NOT NULL,										-- 费用类型(支出、收入)	
	[TrainingBillTypeId]			INT NOT NULL,										-- 费用分类ID
	[HappenDate]					DATETIME NOT NULL,									-- 费用产生日期(手动修改)
	[Amount]						DECIMAL(18,5) NOT NULL,								-- 金额	
	[Handler]						NVARCHAR(50),										-- 经手人
	[Remark]						NVARCHAR(400),										-- 备注、摘要
	[RecorderId]					INT NOT NULL,										-- 录入人ID
	[RecorderName]					NVARCHAR(50),										-- 录入人
	[DeptId]						INT NOT NULL,										-- 部门Id
	[DeptFullPath]					NVARCHAR(260) NOT NULL,								-- 部门
	[LastUpdateTime]				DATETIME NOT NULL,									-- 最后一次修改时间
	[Month]							INT NOT NULL,										-- 费用产生日期之月
	[Quarter]						INT NOT NULL,										-- 费用产生日期之季
	[HalfYear]						INT NOT NULL,										-- 费用产生日期之半年
	[Year]							INT NOT NULL,										-- 费用产生日期之年
)
ALTER TABLE [TrainingBill] WITH CHECK ADD	
	CONSTRAINT [FK_TrainingBill_TrainingBillType] FOREIGN KEY([TrainingBillTypeId]) REFERENCES [TrainingBillType]([Id]),
	CONSTRAINT [FK_TrainingBill_TrainingWork] FOREIGN KEY([TrainingWorkId]) REFERENCES [TrainingWork]([Id])
GO
CREATE NONCLUSTERED INDEX [IDX_TrainingWorkId] ON [dbo].[TrainingBill] 
(		
	[TrainingWorkId] ASC	
)
GO

PRINT '------ 人员培训费用详细分拆表 ------'
CREATE TABLE  [dbo].[EmployeeTrainingBillSplit](
	[Id]							INT PRIMARY KEY NOT NULL,
	[TrainingBillId]				INT NOT NULL,										-- 事务费用ID	
	[TrainingWorkTypeId]			INT NOT NULL,										-- 培训事务类型
	[TrainingWorkId]				INT NOT NULL,										-- 培训事务Id
	[BillType]						INT NOT NULL,										-- 费用类型(支出、收入)	
	[EmployeeId]					INT NOT NULL,										-- 人员Id
	[EmployeeNO]					NVARCHAR(50) NOT NULL,								-- 工号
	[EmployeeName]					NVARCHAR(50) NOT NULL,								-- 姓名
	[Age]							INT,												-- 年龄
	[Sex]							INT NOT NULL,										-- 性别 0:无 1:男 -1:女
	[DeptId]						INT NOT NULL,										-- 部门Id
	[DeptFullPath]					NVARCHAR(260) NOT NULL,								-- 部门全路径	
	[PostId]						INT NOT NULL,										-- 岗位Id	
	[PostName]						NVARCHAR(50),										-- 岗位	
)
ALTER TABLE [EmployeeTrainingBillSplit] WITH CHECK ADD	
	CONSTRAINT [FK_EmployeeTrainingBillSplit_TrainingBill] FOREIGN KEY([TrainingBillId]) REFERENCES [TrainingBill]([Id]),
	CONSTRAINT [FK_EmployeeTrainingBillSplit_TrainingWork] FOREIGN KEY([TrainingWorkId]) REFERENCES [TrainingWork]([Id])
GO

PRINT '------ 人员培训费用详细 ------'
CREATE TABLE  [dbo].[EmployeeTrainingBill](
	[Id]									INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[EmployeeTrainingBillSplitId]			INT NOT NULL,										-- 费用分拆ID
	[TrainingBillId]						INT NOT NULL,										-- 事务费用ID	
	[TrainingWorkTypeId]					INT NOT NULL,										-- 培训事务类型
	[TrainingWorkId]						INT NOT NULL,										-- 培训事务Id
	[BillType]								INT NOT NULL,										-- 费用类型(支出、收入)	
	[EmployeeId]							INT NOT NULL,										-- 人员Id
	[EmployeeNO]							NVARCHAR(50) NOT NULL,								-- 工号
	[EmployeeName]							NVARCHAR(50) NOT NULL,								-- 姓名
	[Age]									INT,												-- 年龄
	[Sex]									INT NOT NULL,										-- 性别 0:无 1:男 -1:女
	[DeptId]								INT NOT NULL,										-- 部门Id
	[DeptFullPath]							NVARCHAR(260) NOT NULL,								-- 部门全路径	
	[PostId]								INT NOT NULL,										-- 岗位Id	
	[PostName]								NVARCHAR(50),										-- 岗位
	[Amount]								DECIMAL(18,5) NOT NULL,								-- 金额	
)
ALTER TABLE [EmployeeTrainingBill] WITH CHECK ADD	
	CONSTRAINT [FK_EmployeeTrainingBill_TrainingBill] FOREIGN KEY([TrainingBillId]) REFERENCES [TrainingBill]([Id]),
	CONSTRAINT [FK_EmployeeTrainingBill_TrainingWork] FOREIGN KEY([TrainingWorkId]) REFERENCES [TrainingWork]([Id])
GO
COMMIT TRANSACTION
