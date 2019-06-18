
/*
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeGroupStat]') AND type in (N'U'))
BEGIN
	PRINT '------添加人员分组日结表------'
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
END


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeInEmployeeGroupStat]') AND type in (N'U'))
BEGIN
	PRINT '------添加人员分组与人员对应关系日结表 ------'
	CREATE TABLE  [dbo].[EmployeeInEmployeeGroupStat](
		[StatId]				INT IDENTITY(1,1) PRIMARY KEY,
		[EmployeeGroupId]		INT NOT NULL,					-- 人员分组Id
		[EmployeeId]			INT NOT NULL,					-- 人员Id
		[StatDate]				SMALLDATETIME NOT NULL			-- 结算日期
	)
END
*/