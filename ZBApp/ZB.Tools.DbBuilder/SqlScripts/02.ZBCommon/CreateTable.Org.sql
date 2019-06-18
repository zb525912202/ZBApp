
USE [$(DatabaseName)]
GO
BEGIN TRANSACTION

PRINT '------ 人员分组 ------'
CREATE TABLE  [dbo].[EmployeeGroup](
	[Id]					INT PRIMARY KEY,
	[ObjectName]			NVARCHAR(50) NOT NULL,
	[ParentId]				INT NOT NULL,
	[FullPath]				NVARCHAR(260) NOT NULL UNIQUE,	-- 部门全路径，不能有两个相同的路径
	[SortIndex]				INT NOT NULL DEFAULT 0,
	[Depth]					INT NOT NULL DEFAULT 0,			-- 深度
)
--确保一个分组下的子节点名称不重复
CREATE UNIQUE NONCLUSTERED INDEX [IDX_EmployeeGroup_ParentId_ObjectName] ON [dbo].[EmployeeGroup] 
(
	[ParentId] ASC,
	[ObjectName] ASC
)
GO

PRINT '------ 部门 ------'
CREATE TABLE  [dbo].[Dept](
	[Id]					INT PRIMARY KEY,
	[ObjectName]			NVARCHAR(50) NOT NULL,
	[ParentId]				INT NOT NULL,
	[FullPath]				NVARCHAR(260) NOT NULL UNIQUE,	-- 部门全路径，不能有两个相同的路径
	[SortIndex]				INT NOT NULL DEFAULT 0,
	[DeptIndex]				INT NOT NULL DEFAULT 0,
	[Depth]					INT NOT NULL DEFAULT 0,			-- 深度
	[DeptType]				INT NOT NULL DEFAULT 0,			-- 部门类型(0:普通部门 1:部门分组)
	[DeptNO]				NVARCHAR(50) NULL,				-- 部门编号(暂许为空)	
	[IsSync]				INT NOT NULL DEFAULT 0,			--同步标记
)
--确保一个部门下的子节点名称不重复
CREATE UNIQUE NONCLUSTERED INDEX [IDX_Dept_ParentId_ObjectName] ON [dbo].[Dept] 
(
	[ParentId] ASC,
	[ObjectName] ASC
)
GO

PRINT '------ 岗位 ------'
CREATE TABLE [dbo].[Post](
	[Id]					INT PRIMARY KEY,
	[DeptId]				INT NOT NULL,
	[ObjectName]			NVARCHAR(50) NOT NULL,	
	[SortIndex]				INT NOT NULL DEFAULT 0,
	[CategoryId]			INT NOT NULL DEFAULT 1,	
	[PCategoryId]			INT NOT NULL DEFAULT 1,			--职岗类型
	[IsSync]				INT NOT NULL DEFAULT 0,			--同步标记
)
ALTER TABLE [Post] WITH CHECK ADD
	CONSTRAINT [FK_Post_Dept] FOREIGN KEY([DeptId]) REFERENCES [Dept]([Id]),
	CONSTRAINT [FK_Post_PostCategory] FOREIGN KEY([CategoryId]) REFERENCES [PostCategory]([Id]),
	CONSTRAINT [FK_Post_ProfessionCategory] FOREIGN KEY([PCategoryId]) REFERENCES [ProfessionCategory]([Id])
GO
--确保一个部门下的岗位名称不重复
CREATE UNIQUE NONCLUSTERED INDEX [IDX_Post_DeptId_ObjectName] ON [dbo].[Post] 
(
	[DeptId] ASC,
	[ObjectName] ASC
)
GO

PRINT '------ 人员 ------'
CREATE TABLE  [dbo].[Employee](
	[Id]								INT IDENTITY(1,1) PRIMARY KEY,
	[DeptId]							INT NOT NULL,
	[EmployeeNO]						NVARCHAR(50) NOT NULL UNIQUE,		--工号
	[ObjectName]						NVARCHAR(50) NOT NULL,				--姓名
	[StatusId]							INT NOT NULL,						--人员状态Id(EmployeeStatus.Id)，默认为'在岗'
	[PostId]							INT NOT NULL DEFAULT 0,				--岗位Id(Post.Id)，0为无岗位	
	[PostRank]							DECIMAL(18,2) NOT NULL DEFAULT 0,	--岗级
	[Sex]								INT NOT NULL,						--性别 0:无 1:男 -1:女
	[Birthday]							DATETIME,							--出生日期
	[IdCard]							NVARCHAR(20),						--身份证
	[JoinTime]							DATETIME NOT NULL,					--入本部门时间
	[EmployeeType]						INT DEFAULT 1,						--人员类型(对应复合枚举EmployeeTypeEnum 1.普通人员 2.管理人员 4.培训员)
	[OutsideDeptFullPath]				NVARCHAR(260),						--外部部门全路径(内部人员此列值为空)
	[ManageEmployeeGroupId]				INT NOT NULL DEFAULT 0,				--管理的人员组Id
	[Mobile]							NVARCHAR(50) NULL,					--联系电话
	[Email]								NVARCHAR(50) NULL,					--邮箱
	[IsSync]							INT NOT NULL DEFAULT 0,				--同步标记
	[SortIndex]							INT NOT NULL DEFAULT 0,				--排序号
	[PMSUserId]							NVARCHAR(50) NULL					--第三方接口用户编号
)
ALTER TABLE [Employee] WITH CHECK ADD
	CONSTRAINT [FK_Employee_Dept] FOREIGN KEY([DeptId]) REFERENCES [Dept]([Id]),
	CONSTRAINT [FK_Employee_Status] FOREIGN KEY([StatusId]) REFERENCES [EmployeeStatus]([Id])
GO

PRINT '------ 人员分组与人员对应关系表 ------'
CREATE TABLE  [dbo].[EmployeeInEmployeeGroup](
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,
	[EmployeeGroupId]		INT NOT NULL,					-- 人员分组Id
	[EmployeeId]			INT NOT NULL,					-- 人员Id
)
ALTER TABLE [EmployeeInEmployeeGroup] WITH CHECK ADD
	CONSTRAINT [FK_EmployeeInEmployeeGroup_EmployeeGroup] FOREIGN KEY([EmployeeGroupId]) REFERENCES [EmployeeGroup]([Id]),
	CONSTRAINT [FK_EmployeeInEmployeeGroup_Employee] FOREIGN KEY([EmployeeId]) REFERENCES [Employee]([Id])
CREATE UNIQUE NONCLUSTERED INDEX [IDX_EmployeeInEmployeeGroup_EmployeeGroupId_EmployeeId] ON [dbo].[EmployeeInEmployeeGroup]
(
	[EmployeeGroupId] ASC,
	[EmployeeId] ASC
)
GO

PRINT '------ 人员的变动记录 ------'
--人员的变动记录
CREATE TABLE [dbo].[EmployeeChangeHistory]
(
	[Id]			INT IDENTITY(1,1) PRIMARY KEY,
	[EmployeeId]	INT NOT NULL,						--人员ID
	[ChangeDate]	DATETIME NOT NULL,					--变动时间
	[BeforeDeptId]	INT NOT NULL,						--变动前部门Id
	[ChangeBefore]	NVARCHAR(400) NOT NULL,				--变动前信息(部门，岗位)
	[AfterDeptId]	INT NOT NULL,						--变动后部门Id
	[ChangeAfter]	NVARCHAR(400) NOT NULL,				--变动后信息(部门，岗位)
)
ALTER TABLE [EmployeeChangeHistory] WITH CHECK ADD
	CONSTRAINT [FK_EmployeeChangeHistory_Employee] FOREIGN KEY([EmployeeId]) REFERENCES [Employee]([Id]) ON DELETE CASCADE
GO


PRINT '----------人员变动信息表-------------'
CREATE TABLE [dbo].[EmployeeChangeInfo](
	[Id]				INT IDENTITY(1,1) PRIMARY KEY,
	[EmployeeId]		INT NOT NULL,						--人员ID
	[ChangeDate]		DATETIME NOT NULL,					--变动时间
	[BeforeDeptId]		INT NOT NULL,						--变动前部门Id
	[BeforePostId]		INT NOT NULL,						--变动前岗位Id
	[AfterDeptId]		INT NOT NULL,						--变动后部门Id
	[AfterPostId]		INT NOT NULL,						--变动后岗位Id
	[AuditDeptId]		INT NOT NULL,						--审核部门
	[AuditStatus]		INT NOT NULL,						--审核状态
	[CreatorId]			INT,								--操作人
	[CreatorName]		NVARCHAR(50) NULL,					--操作人
)
ALTER TABLE [EmployeeChangeInfo] WITH CHECK ADD
	CONSTRAINT [FK_EmployeeChangeInfo_Employee] FOREIGN KEY([EmployeeId]) REFERENCES [Employee]([Id]) ON DELETE CASCADE
GO


PRINT '------ 人员用户帐户、用户角色配置 ------'
--只用来登录，业务相关所有数据存的都是EmployeeId，系统日志表除外
CREATE TABLE [dbo].[UserAccount]( 
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,
	[EmployeeId]			INT NOT NULL,							--人员Id
	[ObjectName]			NVARCHAR(50) NOT NULL UNIQUE,
	[Password]				NVARCHAR(50) NOT NULL,
	[LastLogin]				DATETIME NOT NULL,
	[LastChangePassword]	DATETIME NOT NULL,
	[Profile]				VARBINARY(MAX)							--序列化UserConfig格式存入
)
ALTER TABLE [UserAccount] WITH CHECK ADD
	CONSTRAINT [FK_UserAccount_Employee] FOREIGN KEY([EmployeeId]) REFERENCES [Employee]([Id]) ON DELETE CASCADE
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_UserAccount_EmployeeId] ON [dbo].[UserAccount] 
(
	[EmployeeId] ASC
)
GO

PRINT '------ 人员角色 ------'
CREATE TABLE [dbo].[UserInRole]
(
	[Id]			INT IDENTITY(1,1) PRIMARY KEY,
	[EmployeeId]	INT NOT NULL,							--人员Id
	[RoleId]		INT NOT NULL,
)
GO
ALTER TABLE [UserInRole]  WITH CHECK ADD  
	CONSTRAINT [FK_UserInRole_Employee] FOREIGN KEY([EmployeeId]) REFERENCES [Employee] ([Id]),
	CONSTRAINT [FK_UserInRole_Role] FOREIGN KEY([RoleId]) REFERENCES [Role] ([Id])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_UserInRole_EmployeeIdRoleId] ON [dbo].[UserInRole] 
(
	[EmployeeId] ASC,
	[RoleId] ASC
)
GO

PRINT '------ 培训员 ------'
--培训员(该表内包含培训专属的领导)
CREATE TABLE [dbo].[Trainer](	
	[EmployeeId]		INT PRIMARY KEY NOT NULL,   --人员Id
	[DeptId]			INT NOT NULL,				--管理部门
	[LeaderType]		INT NOT NULL,				--领导类型(0:无 1:正职 2:副职 3:普通)
	[IsTrainer]			BIT NOT NULL,				--是否培训员
	[IsManageTrain]		BIT NOT NULL,				--是否培训专属
	[ManageType]		INT NOT NULL DEFAULT 0		--专属类型(培训专属，证书专属)
)
GO
ALTER TABLE [Trainer] WITH CHECK ADD
	CONSTRAINT [FK_Trainer_Employee] FOREIGN KEY([EmployeeId]) REFERENCES [Employee]([Id]),
	CONSTRAINT [FK_Trainer_Dept] FOREIGN KEY([DeptId]) REFERENCES [Dept]([Id])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_Trainer_EmployeeId] ON [dbo].[Trainer] 
(
	[EmployeeId] ASC
)
GO

COMMIT TRANSACTION