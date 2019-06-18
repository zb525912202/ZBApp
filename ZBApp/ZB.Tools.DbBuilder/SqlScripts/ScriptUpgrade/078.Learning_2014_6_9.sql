IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QuesTestSolution]') AND type in (N'U'))
BEGIN
PRINT'--����ģ������������'
CREATE TABLE  [dbo].[QuesTestSolution](
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,	
	[EmployeeId]			INT NOT NULL,										-- ��ԱId
	[QFolderId]				INT NOT NULL,										-- �����ļ���Id
	[TotalScore]			DECIMAL(18,1) NOT NULL,								-- �Ծ��ܷ�
	[PassScore]				DECIMAL(18,1) NOT NULL,								-- �����
	[TestTimeSpan]			INT NOT NULL,										-- ����ʱ�������ӣ�
	[CreateTime]			DATETIME NOT NULL,									-- ����ʱ��	
)
END
GO

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QuesTestSolutionQtDetail]') AND type in (N'U'))
BEGIN
PRINT'--����ģ������������ϸ��'
CREATE TABLE  [dbo].[QuesTestSolutionQtDetail](
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,	
	[QuesTestSolutionId]	INT NOT NULL,										-- �����Id	
	[QtId]					INT NOT NULL,										-- ����Id
	[QuesCount]				INT NOT NULL,										-- ����
	[Score]					DECIMAL(18,1) NOT NULL,								-- ���	
)
ALTER TABLE [QuesTestSolutionQtDetail]  WITH CHECK ADD  
	CONSTRAINT [FK_QuesTestSolutionQtDetail_QuesTestSolution] FOREIGN KEY([QuesTestSolutionId]) REFERENCES [QuesTestSolution] ([Id])
END
GO

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QuesTest]') AND type in (N'U'))
BEGIN
PRINT'--����ģ������'
CREATE TABLE  [dbo].[QuesTest](
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,	
	[QuesTestSolutionId]	INT NOT NULL,										-- �����Id	
	[Score]					DECIMAL(18,1) NOT NULL,								-- �÷�
	[StartTime]				DATETIME NOT NULL,									-- ��ʼʱ��
	[EndTime]				DATETIME NOT NULL,									-- ����ʱ��
)
ALTER TABLE [QuesTest]  WITH CHECK ADD  
	CONSTRAINT [FK_QuesTest_QuesTestSolution] FOREIGN KEY([QuesTestSolutionId]) REFERENCES [QuesTestSolution] ([Id])
END
GO

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QuesTestDetail]') AND type in (N'U'))
BEGIN
PRINT'--����ģ��������ϸ��'
CREATE TABLE  [dbo].[QuesTestDetail](
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,	
	[QuesTestId]			INT NOT NULL,										-- ����ģ������Id
	[QuesTestSolutionId]	INT NOT NULL,										-- �����Id
	[QuesId]				INT NOT NULL,										-- ����Id
	[QtId]					INT NOT NULL,										-- ����Id	
	[Score]					DECIMAL(18,1) NOT NULL,								-- ���	
)
ALTER TABLE [QuesTestDetail]  WITH CHECK ADD  
	CONSTRAINT [FK_QuesTestDetail_QuesTest] FOREIGN KEY([QuesTestId]) REFERENCES [QuesTest] ([Id]),
	CONSTRAINT [FK_QuesTestDetail_QuesTestSolution] FOREIGN KEY([QuesTestSolutionId]) REFERENCES [QuesTestSolution] ([Id])
END
GO

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QuesTestSolutionConfig]') AND type in (N'U'))
BEGIN
PRINT'--����ģ�����������ñ�'
CREATE TABLE  [dbo].[QuesTestSolutionConfig](
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,	
	[TotalScore]			INT NOT NULL UNIQUE,										-- ����
	[PassScore]				INT NOT NULL,										-- �ϸ��
	[TimeSpan]		        INT NOT NULL,										-- ʱ��(��)
	[SortIndex]				INT NOT NULL DEFAULT 0,
	[LockStatus]			INT NOT NULL,				
)

INSERT INTO [QuesTestSolutionConfig]([TotalScore],[PassScore],[TimeSpan],[SortIndex],[LockStatus])VALUES(100,60,60,1,2)
INSERT INTO [QuesTestSolutionConfig]([TotalScore],[PassScore],[TimeSpan],[SortIndex],[LockStatus])VALUES(150,90,90,2,0)
END
GO
