USE [$(DatabaseName)]
GO
BEGIN TRANSACTION


PRINT '------ 考试,如果是网络考试时，同时操作[WebExam]  ------'
CREATE TABLE [dbo].[TrainingWorkExam](
	[WorkId]				INT PRIMARY KEY NOT NULL,				--培训事务ID
	[ExamMode]				INT NOT NULL,							--考试形式(0：统一开考，1：随到随考)
	[ExamTimeSpan]			INT NOT NULL,							--时长(分钟)
	[TotalScore]			DECIMAL(18,1) NOT NULL,					--试卷总分
	[PassScore]				DECIMAL(18,1) NOT NULL,					--及格分
	[PaperMode]				INT NOT NULL,							--用卷方式(0、单卷 1、AB卷 2、多卷)
	[IsRandomShowQues]		BIT NOT NULL DEFAULT 0,					--是否打乱试题显示顺序	
	[AllowCommitTimeSpan]	INT NOT NULL,							--开考后，多长时间后可以交卷
	[ExamNotice]			NVARCHAR(MAX) NOT NULL DEFAULT '',		--考试须知
	[IsShowPaperResult]		BIT NOT NULL DEFAULT 0,					--交卷后，是否显示考试成绩
	[IsAllowOthersPapers]	BIT NOT NULL DEFAULT 0,					--交卷后，是否允许查看别人的试卷
	[WebExamDoPaperMode]	INT NOT NULL DEFAULT 0,					--网络考试类型(0、以试卷的方式做题，1、以试题的方式做题)
	[CanEditLookQues]		BIT NOT NULL DEFAULT 0,					--是否可以修改看过的题
	[IsValidateExaminee]	BIT NOT NULL DEFAULT 0,					--是否验证考生身份
	[IsAutoGrade]			BIT NOT NULL DEFAULT 0,					--是否主观题自动阅卷
	[RightPercentMode]		INT NOT NULL,							--最低正确率计算分数方式(0、按正确率计算,1、按最低正确率计算)
)
GO
ALTER TABLE [TrainingWorkExam] WITH CHECK ADD
	CONSTRAINT [FK_TrainingWorkExam_TrainingOnWork] FOREIGN KEY([WorkId]) REFERENCES [TrainingOnWork]([Id])
GO


PRINT '---------考试试卷----------'
CREATE TABLE [dbo].[ExamPaperSolution](
	[WorkId]			INT PRIMARY KEY NOT NULL,					--培训事务ID
	[FromPaper]			BIT NOT NULL,					--是否从卷库来
	[PaperSolution]		VARBINARY(MAX) NOT NULL,		--试卷方案（仅包含题型、题量）
)

ALTER TABLE [ExamPaperSolution] WITH CHECK ADD
	CONSTRAINT [FK_ExamPaperSolution_TrainingOnWork] FOREIGN KEY([WorkId]) REFERENCES [TrainingOnWork]([Id])
GO

PRINT '------ 考试违规记录表 ------'
CREATE TABLE [dbo].[ExamViolation](
	[WorkId]				INT NOT NULL,					--培训事务ID
	[TWEmployeeId]			INT NOT NULL,					--培训事务人员ID
	[ViolationDate]			DATETIME NOT NULL,				--违规时间
	[ViolationType]			INT NOT NULL,					--违规类型(作弊、缺考、代考)
	[Remark]				NVARCHAR(MAX) NOT NULL,			--备注			
)

ALTER TABLE [ExamViolation] WITH CHECK ADD
	CONSTRAINT [FK_ExamViolation_TrainingOnWorkEmployee] FOREIGN KEY([TWEmployeeId]) REFERENCES [TrainingOnWorkEmployee]([Id])
GO

ALTER TABLE [ExamViolation] WITH CHECK ADD
	CONSTRAINT [FK_ExamViolation_TrainingOnWork] FOREIGN KEY([WorkId]) REFERENCES [TrainingOnWork]([Id])
GO

COMMIT TRANSACTION