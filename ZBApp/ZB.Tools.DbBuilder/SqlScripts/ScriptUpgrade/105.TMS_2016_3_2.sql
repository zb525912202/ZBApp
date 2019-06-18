
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ExamPaperSolution]') AND type in (N'U'))
BEGIN

PRINT '---------考试试卷----------'
CREATE TABLE [dbo].[ExamPaperSolution](
	[WorkId]			INT PRIMARY KEY NOT NULL ,					--培训事务ID
	[FromPaper]			BIT NOT NULL,					--是否从卷库来
	[PaperSolution]		VARBINARY(MAX) NOT NULL,		--试卷方案（仅包含题型、题量）
)

ALTER TABLE [ExamPaperSolution] WITH CHECK ADD
	CONSTRAINT [FK_ExamPaperSolution_TrainingOnWork] FOREIGN KEY([WorkId]) REFERENCES [TrainingOnWork]([Id])

END

