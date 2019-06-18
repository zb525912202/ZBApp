IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WebExamGradeAnswerText]') AND type in (N'U'))
BEGIN
PRINT '------考生身份核实表------'
CREATE TABLE [dbo].[WebExamGradeAnswerText](
	[Id]							INT PRIMARY KEY NOT NULL,		
	[WebExamId]						INT NOT NULL,										-- 网络考试ID	
	[PaperPackageQuestionId]		INT NOT NULL,										-- 网络考试试卷包试题ID
	[AnswerText]					NVARCHAR(400) NOT NULL DEFAULT '',					-- 答案文本			
	[Score]							DECIMAL(18,1) NOT NULL DEFAULT 0,					-- 得分	
)
ALTER TABLE [WebExamGradeAnswerText]  WITH CHECK ADD  
	CONSTRAINT [FK_WebExamGradeAnswerText_WebExam] FOREIGN KEY([WebExamId]) REFERENCES [WebExam] ([Id])
CREATE UNIQUE NONCLUSTERED INDEX [IDX_WebExamGradeAnswerText_WebExamId_PaperIdPaperPackageQuestionId] ON [dbo].[WebExamGradeAnswerText] 
(
	[WebExamId] ASC,
	[PaperPackageQuestionId] ASC,
	[AnswerText] ASC
)
ENd