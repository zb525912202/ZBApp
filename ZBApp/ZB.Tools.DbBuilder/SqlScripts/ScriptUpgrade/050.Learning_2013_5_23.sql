
/*
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeGroupStat]') AND type in (N'U'))
BEGIN
	PRINT '------�����Ա�����ս��------'
	CREATE TABLE  [dbo].[EmployeeGroupStat](
		[StatId]				INT IDENTITY(1,1) PRIMARY KEY,
		[Id]					INT NOT NULL,
		[ObjectName]			NVARCHAR(50) NOT NULL,
		[ParentId]				INT NOT NULL,
		[FullPath]				NVARCHAR(260) NOT NULL,			-- ȫ·����������������ͬ��·��
		[SortIndex]				INT NOT NULL DEFAULT 0,
		[Depth]					INT NOT NULL DEFAULT 0,			-- ���
		[StatDate]				SMALLDATETIME NOT NULL			--��������
	)
END


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeInEmployeeGroupStat]') AND type in (N'U'))
BEGIN
	PRINT '------�����Ա��������Ա��Ӧ��ϵ�ս�� ------'
	CREATE TABLE  [dbo].[EmployeeInEmployeeGroupStat](
		[StatId]				INT IDENTITY(1,1) PRIMARY KEY,
		[EmployeeGroupId]		INT NOT NULL,					-- ��Ա����Id
		[EmployeeId]			INT NOT NULL,					-- ��ԱId
		[StatDate]				SMALLDATETIME NOT NULL			-- ��������
	)
END
*/