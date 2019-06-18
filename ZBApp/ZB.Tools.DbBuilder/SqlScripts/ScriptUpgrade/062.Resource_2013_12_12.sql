

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ExportHistory]') AND type in (N'U'))
BEGIN
PRINT '------ 导出历史表 ------'
CREATE TABLE [dbo].[ExportHistory](
	[Id]						INT IDENTITY(1,1) PRIMARY KEY NOT NULL,				-- 唯一标识
	[PaperPackageId]				INT NOT NULL,									-- 试卷包ID
	[ExportEmployeeId]			INT NOT NULL,										-- 导出人Id
	[ExportEmployeeName]		NVARCHAR(50) NOT NULL,								-- 导出人姓名
	[ExportTime]				DATETIME NOT NULL,									-- 导出时间
)
ALTER TABLE [ExportHistory]  WITH CHECK ADD  
	CONSTRAINT [FK_ExportHistory_PaperPackage] FOREIGN KEY([PaperPackageId]) REFERENCES PaperPackage ([Id])

END


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ExportHistoryPaper]') AND type in (N'U'))
BEGIN
PRINT '------ 导出历史试卷表 ------'
CREATE TABLE [dbo].[ExportHistoryPaper](
	[Id]							INT PRIMARY KEY NOT NULL,					
	[PaperPackageId]				INT NOT NULL,											-- 试卷包ID
	[ExportHistoryId]				INT NOT NULL,											-- 历史表ID
	[ObjectName]					NVARCHAR(50) NOT NULL,									-- 试卷名称
	[PaperScore]					DECIMAL(18,1) NOT NULL DEFAULT ((0)),					-- 试卷总分
	[PaperQuesCount]				INT NOT NULL DEFAULT ((0)),								-- 试卷题量
	[IsRandomPaper]					BIT NOT NULL DEFAULT 0,									-- 是否随机卷
)
ALTER TABLE [ExportHistoryPaper]  WITH CHECK ADD  
	CONSTRAINT [FK_ExportHistoryPaper_ExportHistory] FOREIGN KEY([ExportHistoryId]) REFERENCES ExportHistory ([Id])
ENd


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ExportHistoryPaperDetail]') AND type in (N'U'))
BEGIN
PRINT '------ 导出历史试卷详细表 ------'
CREATE TABLE [dbo].[ExportHistoryPaperDetail](
	[Id]						INT IDENTITY(1,1) PRIMARY KEY NOT NULL,				-- 唯一标识
	[PaperPackageId]			INT NOT NULL,										-- 试卷包ID
	[ExportHistoryId]			INT NOT NULL,										-- 历史表ID
	[ExportHistoryPaperId]		INT NOT NULL,										-- 导出历史试卷表Id
	[PaperPackageQuestionId]	INT NOT NULL,										-- 试卷包试题Id
	[TotalScore]				DECIMAL(18,1) NOT NULL DEFAULT ((0)),				-- 试卷包试题分数
)
ALTER TABLE [ExportHistoryPaperDetail]  WITH CHECK ADD  
	CONSTRAINT [FK_ExportHistoryPaperDetail_ExportHistoryPaper] FOREIGN KEY([ExportHistoryPaperId]) REFERENCES ExportHistoryPaper ([Id])
END

GO
