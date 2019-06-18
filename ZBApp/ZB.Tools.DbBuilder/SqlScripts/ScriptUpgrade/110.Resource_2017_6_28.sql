IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ResourceModule]') AND type in (N'U'))
BEGIN

PRINT '------ 标签 ------'
CREATE TABLE [dbo].[ResourceModule](
	[Id]							INT PRIMARY KEY  NOT NULL,					-- 唯一标识
	[ObjectName]					NVARCHAR(25) UNIQUE NOT NULL,						-- 标签名称
)

END

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QuestionInModule]') AND type in (N'U'))
BEGIN

CREATE TABLE [dbo].[QuestionInModule](
	[Id]				INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[QuestionId]		INT NOT NULL,										--试题ID
	[ModuleId]			INT NOT NULL										--标签ID
)

ALTER TABLE [QuestionInModule] WITH CHECK ADD
	CONSTRAINT [FK_QuestionId_Question] FOREIGN KEY([QuestionId]) REFERENCES [Question]([Id]),
	CONSTRAINT [FK_QuestionId_Module] FOREIGN KEY([ModuleId]) REFERENCES [ResourceModule]([Id])

END


PRINT'-----修改标签长度-----'
IF EXISTS(SELECT * FROM syscolumns WHERE id = object_id('ResourceModule') AND name='ObjectName')
BEGIN
	ALTER TABLE ResourceModule ALTER COLUMN ObjectName NVARCHAR(50);
	PRINT'-----修改标签长度成功-----'
END
GO

PRINT '--------增加题型----------'


IF NOT EXISTS (SELECT * FROM QuestionType WHERE Id = 25)
BEGIN
insert into QuestionType(Id,ObjectName, IsImpersonal, SortIndex, NormalScore, NormalQuestionCount, AnswerLines,GraderType,MinRightPercent,LearningSecond,OnlySupportOpenMode,MinRightPercent_Default,LearningSecond_Default,OnlySupportOpenMode_Default)
values(25,	'实训题',		'False',	25,	10,	1,	8,	0,	75,	150,	0,	75,	150,	0);
END
GO

IF NOT EXISTS (SELECT * FROM QuestionType WHERE Id = 26)
BEGIN
insert into QuestionType(Id,ObjectName, IsImpersonal, SortIndex, NormalScore, NormalQuestionCount, AnswerLines,GraderType,MinRightPercent,LearningSecond,OnlySupportOpenMode,MinRightPercent_Default,LearningSecond_Default,OnlySupportOpenMode_Default)
values(26,	'论文答辩题',	'False',	26,	15,	2,	20,	0,	75,	600,	0,	75,	600,	0);
END
GO

IF NOT EXISTS (SELECT * FROM QuestionType WHERE Id = 27)
BEGIN
	insert into QuestionType(Id,ObjectName, IsImpersonal, SortIndex, NormalScore, NormalQuestionCount, AnswerLines,GraderType,MinRightPercent,LearningSecond,OnlySupportOpenMode,MinRightPercent_Default,LearningSecond_Default,OnlySupportOpenMode_Default)
	values(27,	'手写工作票',	'False',	27,	15,	1,	20,	0,	75,	600,	0,	75,	600,	0);
END
GO

