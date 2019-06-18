

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeChangeInfo]') AND type in (N'U'))
BEGIN

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
)

ALTER TABLE [EmployeeChangeInfo] WITH CHECK ADD
	CONSTRAINT [FK_EmployeeChangeInfo_Employee] FOREIGN KEY([EmployeeId]) REFERENCES [Employee]([Id]) ON DELETE CASCADE
END


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IPBlackList]') AND type in (N'U'))
BEGIN

--IP地址黑名单(登录时使用)
CREATE TABLE [dbo].[IPBlackList](
	[Id]			INT IDENTITY(1,1) PRIMARY KEY,
	[StartIP]		NVARCHAR(50) NOT NULL,
	[EndIP]			NVARCHAR(50) NULL
)

END

