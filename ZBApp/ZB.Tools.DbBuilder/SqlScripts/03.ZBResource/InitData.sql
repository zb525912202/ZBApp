PRINT '------ 插入Resource部分基础数据 ------'

insert into TableSeed(TableName,Seed)
values('PaperPackageQuestion',0);

/*
PRINT '------ 题型 ------'
TABLE [dbo].[QuestionType](
	[Id]							INT PRIMARY KEY  NOT NULL,					-- 唯一标识
	[ObjectName]					NVARCHAR(50) NOT NULL,						-- 题型名称
	[IsImpersonal]					BIT NOT NULL,								-- 是否客观题
	[SortIndex]						INT NOT NULL DEFAULT ((0)),					-- 排序索引
	[NormalScore]					DECIMAL(18,1) NOT NULL DEFAULT ((0)),		-- 标准题分
	[NormalQuestionCount]			INT NOT NULL DEFAULT ((0)),					-- 标准题量
	[AnswerLines]					INT NOT NULL DEFAULT ((0)),					-- 答案行数
	[GraderType]					INT NOT NULL DEFAULT ((0)),					-- 阅卷机器人(默认无阅卷机器人)
	[MinRightPercent]				INT NOT NULL,								-- 最低正确率
	[LearningSecond]				INT NOT NULL,								-- 标准时间
	[OnlySupportOpenMode]			BIT NOT NULL,								-- 仅支持开卷学习
	[MinRightPercent_Default]		INT NOT NULL,								-- 最低正确率配置的默认值
	[LearningSecond_Default]		INT NOT NULL,								-- 标准时间配置的默认值
	[OnlySupportOpenMode_Default]	BIT NOT NULL,								-- 仅支持开卷学习配置的默认值
)
*/

insert into QuestionType(Id,ObjectName, IsImpersonal, SortIndex, NormalScore, NormalQuestionCount, AnswerLines,GraderType,MinRightPercent,LearningSecond,OnlySupportOpenMode,MinRightPercent_Default,LearningSecond_Default,OnlySupportOpenMode_Default)
values(17,	'单选题',		'True',		1,	1,	20,	0,	2,	100,	30,		0,	100,	30,		0);
insert into QuestionType(Id,ObjectName, IsImpersonal, SortIndex, NormalScore, NormalQuestionCount, AnswerLines,GraderType,MinRightPercent,LearningSecond,OnlySupportOpenMode,MinRightPercent_Default,LearningSecond_Default,OnlySupportOpenMode_Default)
values(1,	'判断题',		'True',		2,	1,	20,	0,	1,	100,	30,		0,	100,	30,		0);
insert into QuestionType(Id,ObjectName, IsImpersonal, SortIndex, NormalScore, NormalQuestionCount, AnswerLines,GraderType,MinRightPercent,LearningSecond,OnlySupportOpenMode,MinRightPercent_Default,LearningSecond_Default,OnlySupportOpenMode_Default)
values(2,	'选择题',		'True',		3,	1,	20,	0,	2,	100,	30,		0,	100,	30,		0);
insert into QuestionType(Id,ObjectName, IsImpersonal, SortIndex, NormalScore, NormalQuestionCount, AnswerLines,GraderType,MinRightPercent,LearningSecond,OnlySupportOpenMode,MinRightPercent_Default,LearningSecond_Default,OnlySupportOpenMode_Default)
values(3,	'多选题',		'True',		4,	2,	10,	0,	3,	100,	45,		0,	100,	45,		0);

insert into QuestionType(Id,ObjectName, IsImpersonal, SortIndex, NormalScore, NormalQuestionCount, AnswerLines,GraderType,MinRightPercent,LearningSecond,OnlySupportOpenMode,MinRightPercent_Default,LearningSecond_Default,OnlySupportOpenMode_Default)
values(4,	'填空题',		'False',	5,	2,	10,	0,	0,	75,	60,		0,	75,	60,		0);
insert into QuestionType(Id,ObjectName, IsImpersonal, SortIndex, NormalScore, NormalQuestionCount, AnswerLines,GraderType,MinRightPercent,LearningSecond,OnlySupportOpenMode,MinRightPercent_Default,LearningSecond_Default,OnlySupportOpenMode_Default)
values(5,	'简答题',		'False',	6,	5,	4,	4,	0,	75,	150,	0,	75,	150,	0);
insert into QuestionType(Id,ObjectName, IsImpersonal, SortIndex, NormalScore, NormalQuestionCount, AnswerLines,GraderType,MinRightPercent,LearningSecond,OnlySupportOpenMode,MinRightPercent_Default,LearningSecond_Default,OnlySupportOpenMode_Default)
values(6,	'计算题',		'False',	7,	10,	2,	6,	0,	75,	150,	0,	75,	150,	0);
insert into QuestionType(Id,ObjectName, IsImpersonal, SortIndex, NormalScore, NormalQuestionCount, AnswerLines,GraderType,MinRightPercent,LearningSecond,OnlySupportOpenMode,MinRightPercent_Default,LearningSecond_Default,OnlySupportOpenMode_Default)
values(7,	'绘图题',		'False',	8,	10,	2,	6,	0,	75,	0,		1,	75,	0,		1);
insert into QuestionType(Id,ObjectName, IsImpersonal, SortIndex, NormalScore, NormalQuestionCount, AnswerLines,GraderType,MinRightPercent,LearningSecond,OnlySupportOpenMode,MinRightPercent_Default,LearningSecond_Default,OnlySupportOpenMode_Default)
values(8,	'论述题',		'False',	9,	10,	2,	8,	0,	75,	150,	0,	75,	150,	0);
insert into QuestionType(Id,ObjectName, IsImpersonal, SortIndex, NormalScore, NormalQuestionCount, AnswerLines,GraderType,MinRightPercent,LearningSecond,OnlySupportOpenMode,MinRightPercent_Default,LearningSecond_Default,OnlySupportOpenMode_Default)
values(9,	'综合题',		'False',	10,	10,	2,	8,	0,	75,	150,	0,	75,	150,	0);
insert into QuestionType(Id,ObjectName, IsImpersonal, SortIndex, NormalScore, NormalQuestionCount, AnswerLines,GraderType,MinRightPercent,LearningSecond,OnlySupportOpenMode,MinRightPercent_Default,LearningSecond_Default,OnlySupportOpenMode_Default)
values(10,	'分析题',		'False',	11,	10,	2,	8,	0,	75,	150,	0,	75,	150,	0);
insert into QuestionType(Id,ObjectName, IsImpersonal, SortIndex, NormalScore, NormalQuestionCount, AnswerLines,GraderType,MinRightPercent,LearningSecond,OnlySupportOpenMode,MinRightPercent_Default,LearningSecond_Default,OnlySupportOpenMode_Default)
values(11,	'问答题',		'False',	12,	10,	2,	6,	0,	75,	150,	0,	75,	150,	0);
insert into QuestionType(Id,ObjectName, IsImpersonal, SortIndex, NormalScore, NormalQuestionCount, AnswerLines,GraderType,MinRightPercent,LearningSecond,OnlySupportOpenMode,MinRightPercent_Default,LearningSecond_Default,OnlySupportOpenMode_Default)
values(24,	'事故处理题',	'False',	13,	10,	2,	6,	0,	75,	150,	0,	75,	150,	0);
insert into QuestionType(Id,ObjectName, IsImpersonal, SortIndex, NormalScore, NormalQuestionCount, AnswerLines,GraderType,MinRightPercent,LearningSecond,OnlySupportOpenMode,MinRightPercent_Default,LearningSecond_Default,OnlySupportOpenMode_Default)
values(13,	'改错题',		'False',	14,	5,	2,	4,	0,	75,	90,		0,	75,	90,		0);
insert into QuestionType(Id,ObjectName, IsImpersonal, SortIndex, NormalScore, NormalQuestionCount, AnswerLines,GraderType,MinRightPercent,LearningSecond,OnlySupportOpenMode,MinRightPercent_Default,LearningSecond_Default,OnlySupportOpenMode_Default)
values(14,	'单项操作题',	'False',	15,	10,	1,	8,	0,	75,	150,	0,	75,	150,	0);
insert into QuestionType(Id,ObjectName, IsImpersonal, SortIndex, NormalScore, NormalQuestionCount, AnswerLines,GraderType,MinRightPercent,LearningSecond,OnlySupportOpenMode,MinRightPercent_Default,LearningSecond_Default,OnlySupportOpenMode_Default)
values(15,	'多项操作题',	'False',	16,	15,	1,	8,	0,	75,	180,	0,	75,	180,	0);
insert into QuestionType(Id,ObjectName, IsImpersonal, SortIndex, NormalScore, NormalQuestionCount, AnswerLines,GraderType,MinRightPercent,LearningSecond,OnlySupportOpenMode,MinRightPercent_Default,LearningSecond_Default,OnlySupportOpenMode_Default)
values(16,	'综合操作题',	'False',	17,	20,	1,	10,	0,	75,	240,	0,	75,	240,	0);
insert into QuestionType(Id,ObjectName, IsImpersonal, SortIndex, NormalScore, NormalQuestionCount, AnswerLines,GraderType,MinRightPercent,LearningSecond,OnlySupportOpenMode,MinRightPercent_Default,LearningSecond_Default,OnlySupportOpenMode_Default)
values(18,	'识图题',		'False',	18,	10,	1,	8,	0,	75,	0,		1,	75,	0,		1);
insert into QuestionType(Id,ObjectName, IsImpersonal, SortIndex, NormalScore, NormalQuestionCount, AnswerLines,GraderType,MinRightPercent,LearningSecond,OnlySupportOpenMode,MinRightPercent_Default,LearningSecond_Default,OnlySupportOpenMode_Default)
values(19,	'解释题',		'False',	19,	5,	2,	4,	0,	75,	90,		0,	75,	90,		0);
insert into QuestionType(Id,ObjectName, IsImpersonal, SortIndex, NormalScore, NormalQuestionCount, AnswerLines,GraderType,MinRightPercent,LearningSecond,OnlySupportOpenMode,MinRightPercent_Default,LearningSecond_Default,OnlySupportOpenMode_Default)
values(20,	'技能操作题',	'False',	20,	10,	1,	8,	0,	75,	150,	0,	75,	150,	0);
insert into QuestionType(Id,ObjectName, IsImpersonal, SortIndex, NormalScore, NormalQuestionCount, AnswerLines,GraderType,MinRightPercent,LearningSecond,OnlySupportOpenMode,MinRightPercent_Default,LearningSecond_Default,OnlySupportOpenMode_Default)
values(21,	'叙述题',		'False',	21,	10,	2,	8,	0,	75,	150,	0,	75,	150,	0);
insert into QuestionType(Id,ObjectName, IsImpersonal, SortIndex, NormalScore, NormalQuestionCount, AnswerLines,GraderType,MinRightPercent,LearningSecond,OnlySupportOpenMode,MinRightPercent_Default,LearningSecond_Default,OnlySupportOpenMode_Default)
values(22,	'案例分析题',	'False',	22,	20,	1,	10,	0,	75,	240,	0,	75,	240,	0);
insert into QuestionType(Id,ObjectName, IsImpersonal, SortIndex, NormalScore, NormalQuestionCount, AnswerLines,GraderType,MinRightPercent,LearningSecond,OnlySupportOpenMode,MinRightPercent_Default,LearningSecond_Default,OnlySupportOpenMode_Default)
values(12,	'名词解释',		'False',	23,	5,	2,	4,	0,	75,	90,		0,	75,	90,		0);
insert into QuestionType(Id,ObjectName, IsImpersonal, SortIndex, NormalScore, NormalQuestionCount, AnswerLines,GraderType,MinRightPercent,LearningSecond,OnlySupportOpenMode,MinRightPercent_Default,LearningSecond_Default,OnlySupportOpenMode_Default)
values(23,	'实验题',		'False',	24,	10,	1,	8,	0,	75,	150,	0,	75,	150,	0);
insert into QuestionType(Id,ObjectName, IsImpersonal, SortIndex, NormalScore, NormalQuestionCount, AnswerLines,GraderType,MinRightPercent,LearningSecond,OnlySupportOpenMode,MinRightPercent_Default,LearningSecond_Default,OnlySupportOpenMode_Default)
values(25,	'实训题',		'False',	25,	10,	1,	8,	0,	75,	150,	0,	75,	150,	0);
insert into QuestionType(Id,ObjectName, IsImpersonal, SortIndex, NormalScore, NormalQuestionCount, AnswerLines,GraderType,MinRightPercent,LearningSecond,OnlySupportOpenMode,MinRightPercent_Default,LearningSecond_Default,OnlySupportOpenMode_Default)
values(26,	'论文答辩题',	'False',	26,	15,	2,	20,	0,	75,	600,	0,	75,	600,	0);
insert into QuestionType(Id,ObjectName, IsImpersonal, SortIndex, NormalScore, NormalQuestionCount, AnswerLines,GraderType,MinRightPercent,LearningSecond,OnlySupportOpenMode,MinRightPercent_Default,LearningSecond_Default,OnlySupportOpenMode_Default)
values(27,	'手写工作票',	'False',	27,	15,	1,	20,	0,	75,	600,	0,	75,	600,	0);