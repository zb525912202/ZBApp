IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('WebExam') AND name='IsValidateExaminee')
BEGIN
	ALTER TABLE WebExam ADD IsValidateExaminee	BIT NOT NULL DEFAULT 0;
	PRINT '添加WebExam内的IsValidateExaminee成功';
END

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ValidateExaminee]') AND type in (N'U'))
BEGIN
PRINT '------考生身份核实表------'
CREATE TABLE [dbo].[ValidateExaminee](
	[Id]						INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[WebExamId]					INT NOT NULL,										--网络考试Id	
	[WebExamineeId]				INT NOT NULL,										--考生Id
	[AnswerState]				INT NOT NULL,										--考生答题状态 1:进入考场 2:正在答题 3:交卷
	[CreateTime]				DATETIME NOT NULL,									--截图时间
	[ScreenShot]				VARBINARY(MAX) NOT NULL,							--截图
)
ALTER TABLE [ValidateExaminee]  WITH CHECK ADD  
	CONSTRAINT [FK_ValidateExaminee_WebExam] FOREIGN KEY([WebExamId]) REFERENCES [WebExam] ([Id]),
	CONSTRAINT [FK_ValidateExaminee_WebExaminee] FOREIGN KEY([WebExamineeId]) REFERENCES [WebExaminee] ([Id])
ENd