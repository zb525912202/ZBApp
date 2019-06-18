

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WebExamIPConfig]') AND type in (N'U'))
BEGIN
PRINT '------����IP���ñ�------'
CREATE TABLE [dbo].[WebExamIPConfig](
	[Id]					INT IDENTITY(1,1) PRIMARY KEY NOT NULL,		
	[WebExamId]				INT NOT NULL,										--���翼��Id	
	[StarIP]				NVARCHAR(50) NOT NULL,							--��ʼIP
	[EndIP]					NVARCHAR(50) NOT NULL,							--��ʼIP
)
ALTER TABLE [WebExamIPConfig]  WITH CHECK ADD  
	CONSTRAINT [FK_WebExamIPConfig_WebExam] FOREIGN KEY([WebExamId]) REFERENCES [WebExam] ([Id])

END
