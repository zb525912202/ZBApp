

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WebExamIPConfig]') AND type in (N'U'))
BEGIN
PRINT '------考试IP配置表------'
CREATE TABLE [dbo].[WebExamIPConfig](
	[Id]					INT IDENTITY(1,1) PRIMARY KEY NOT NULL,		
	[WebExamId]				INT NOT NULL,										--网络考试Id	
	[StarIP]				NVARCHAR(50) NOT NULL,							--起始IP
	[EndIP]					NVARCHAR(50) NOT NULL,							--起始IP
)
ALTER TABLE [WebExamIPConfig]  WITH CHECK ADD  
	CONSTRAINT [FK_WebExamIPConfig_WebExam] FOREIGN KEY([WebExamId]) REFERENCES [WebExam] ([Id])

END
