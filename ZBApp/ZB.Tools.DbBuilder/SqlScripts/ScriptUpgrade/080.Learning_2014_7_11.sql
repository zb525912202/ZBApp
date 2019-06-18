IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmployeePaiMing]') AND type in (N'U'))
BEGIN
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
END
GO


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmployeePaiMingComputeDate]') AND type in (N'U'))
BEGIN
PRINT'--学员排名计算时间表'
CREATE TABLE [dbo].[EmployeePaiMingComputeDate]
(
	[ComputeDate]								DATETIME NOT NULL,					--排名计算时间
)
END
GO
