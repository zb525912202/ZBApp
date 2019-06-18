PRINT '------ ����Resource���ֻ������� ------'

insert into TableSeed(TableName,Seed)
values('PaperPackageQuestion',0);

/*
PRINT '------ ���� ------'
TABLE [dbo].[QuestionType](
	[Id]							INT PRIMARY KEY  NOT NULL,					-- Ψһ��ʶ
	[ObjectName]					NVARCHAR(50) NOT NULL,						-- ��������
	[IsImpersonal]					BIT NOT NULL,								-- �Ƿ�͹���
	[SortIndex]						INT NOT NULL DEFAULT ((0)),					-- ��������
	[NormalScore]					DECIMAL(18,1) NOT NULL DEFAULT ((0)),		-- ��׼���
	[NormalQuestionCount]			INT NOT NULL DEFAULT ((0)),					-- ��׼����
	[AnswerLines]					INT NOT NULL DEFAULT ((0)),					-- ������
	[GraderType]					INT NOT NULL DEFAULT ((0)),					-- �ľ������(Ĭ�����ľ������)
	[MinRightPercent]				INT NOT NULL,								-- �����ȷ��
	[LearningSecond]				INT NOT NULL,								-- ��׼ʱ��
	[OnlySupportOpenMode]			BIT NOT NULL,								-- ��֧�ֿ���ѧϰ
	[MinRightPercent_Default]		INT NOT NULL,								-- �����ȷ�����õ�Ĭ��ֵ
	[LearningSecond_Default]		INT NOT NULL,								-- ��׼ʱ�����õ�Ĭ��ֵ
	[OnlySupportOpenMode_Default]	BIT NOT NULL,								-- ��֧�ֿ���ѧϰ���õ�Ĭ��ֵ
)
*/

insert into QuestionType(Id,ObjectName, IsImpersonal, SortIndex, NormalScore, NormalQuestionCount, AnswerLines,GraderType,MinRightPercent,LearningSecond,OnlySupportOpenMode,MinRightPercent_Default,LearningSecond_Default,OnlySupportOpenMode_Default)
values(17,	'��ѡ��',		'True',		1,	1,	20,	0,	2,	100,	30,		0,	100,	30,		0);
insert into QuestionType(Id,ObjectName, IsImpersonal, SortIndex, NormalScore, NormalQuestionCount, AnswerLines,GraderType,MinRightPercent,LearningSecond,OnlySupportOpenMode,MinRightPercent_Default,LearningSecond_Default,OnlySupportOpenMode_Default)
values(1,	'�ж���',		'True',		2,	1,	20,	0,	1,	100,	30,		0,	100,	30,		0);
insert into QuestionType(Id,ObjectName, IsImpersonal, SortIndex, NormalScore, NormalQuestionCount, AnswerLines,GraderType,MinRightPercent,LearningSecond,OnlySupportOpenMode,MinRightPercent_Default,LearningSecond_Default,OnlySupportOpenMode_Default)
values(2,	'ѡ����',		'True',		3,	1,	20,	0,	2,	100,	30,		0,	100,	30,		0);
insert into QuestionType(Id,ObjectName, IsImpersonal, SortIndex, NormalScore, NormalQuestionCount, AnswerLines,GraderType,MinRightPercent,LearningSecond,OnlySupportOpenMode,MinRightPercent_Default,LearningSecond_Default,OnlySupportOpenMode_Default)
values(3,	'��ѡ��',		'True',		4,	2,	10,	0,	3,	100,	45,		0,	100,	45,		0);

insert into QuestionType(Id,ObjectName, IsImpersonal, SortIndex, NormalScore, NormalQuestionCount, AnswerLines,GraderType,MinRightPercent,LearningSecond,OnlySupportOpenMode,MinRightPercent_Default,LearningSecond_Default,OnlySupportOpenMode_Default)
values(4,	'�����',		'False',	5,	2,	10,	0,	0,	75,	60,		0,	75,	60,		0);
insert into QuestionType(Id,ObjectName, IsImpersonal, SortIndex, NormalScore, NormalQuestionCount, AnswerLines,GraderType,MinRightPercent,LearningSecond,OnlySupportOpenMode,MinRightPercent_Default,LearningSecond_Default,OnlySupportOpenMode_Default)
values(5,	'�����',		'False',	6,	5,	4,	4,	0,	75,	150,	0,	75,	150,	0);
insert into QuestionType(Id,ObjectName, IsImpersonal, SortIndex, NormalScore, NormalQuestionCount, AnswerLines,GraderType,MinRightPercent,LearningSecond,OnlySupportOpenMode,MinRightPercent_Default,LearningSecond_Default,OnlySupportOpenMode_Default)
values(6,	'������',		'False',	7,	10,	2,	6,	0,	75,	150,	0,	75,	150,	0);
insert into QuestionType(Id,ObjectName, IsImpersonal, SortIndex, NormalScore, NormalQuestionCount, AnswerLines,GraderType,MinRightPercent,LearningSecond,OnlySupportOpenMode,MinRightPercent_Default,LearningSecond_Default,OnlySupportOpenMode_Default)
values(7,	'��ͼ��',		'False',	8,	10,	2,	6,	0,	75,	0,		1,	75,	0,		1);
insert into QuestionType(Id,ObjectName, IsImpersonal, SortIndex, NormalScore, NormalQuestionCount, AnswerLines,GraderType,MinRightPercent,LearningSecond,OnlySupportOpenMode,MinRightPercent_Default,LearningSecond_Default,OnlySupportOpenMode_Default)
values(8,	'������',		'False',	9,	10,	2,	8,	0,	75,	150,	0,	75,	150,	0);
insert into QuestionType(Id,ObjectName, IsImpersonal, SortIndex, NormalScore, NormalQuestionCount, AnswerLines,GraderType,MinRightPercent,LearningSecond,OnlySupportOpenMode,MinRightPercent_Default,LearningSecond_Default,OnlySupportOpenMode_Default)
values(9,	'�ۺ���',		'False',	10,	10,	2,	8,	0,	75,	150,	0,	75,	150,	0);
insert into QuestionType(Id,ObjectName, IsImpersonal, SortIndex, NormalScore, NormalQuestionCount, AnswerLines,GraderType,MinRightPercent,LearningSecond,OnlySupportOpenMode,MinRightPercent_Default,LearningSecond_Default,OnlySupportOpenMode_Default)
values(10,	'������',		'False',	11,	10,	2,	8,	0,	75,	150,	0,	75,	150,	0);
insert into QuestionType(Id,ObjectName, IsImpersonal, SortIndex, NormalScore, NormalQuestionCount, AnswerLines,GraderType,MinRightPercent,LearningSecond,OnlySupportOpenMode,MinRightPercent_Default,LearningSecond_Default,OnlySupportOpenMode_Default)
values(11,	'�ʴ���',		'False',	12,	10,	2,	6,	0,	75,	150,	0,	75,	150,	0);
insert into QuestionType(Id,ObjectName, IsImpersonal, SortIndex, NormalScore, NormalQuestionCount, AnswerLines,GraderType,MinRightPercent,LearningSecond,OnlySupportOpenMode,MinRightPercent_Default,LearningSecond_Default,OnlySupportOpenMode_Default)
values(24,	'�¹ʴ�����',	'False',	13,	10,	2,	6,	0,	75,	150,	0,	75,	150,	0);
insert into QuestionType(Id,ObjectName, IsImpersonal, SortIndex, NormalScore, NormalQuestionCount, AnswerLines,GraderType,MinRightPercent,LearningSecond,OnlySupportOpenMode,MinRightPercent_Default,LearningSecond_Default,OnlySupportOpenMode_Default)
values(13,	'�Ĵ���',		'False',	14,	5,	2,	4,	0,	75,	90,		0,	75,	90,		0);
insert into QuestionType(Id,ObjectName, IsImpersonal, SortIndex, NormalScore, NormalQuestionCount, AnswerLines,GraderType,MinRightPercent,LearningSecond,OnlySupportOpenMode,MinRightPercent_Default,LearningSecond_Default,OnlySupportOpenMode_Default)
values(14,	'���������',	'False',	15,	10,	1,	8,	0,	75,	150,	0,	75,	150,	0);
insert into QuestionType(Id,ObjectName, IsImpersonal, SortIndex, NormalScore, NormalQuestionCount, AnswerLines,GraderType,MinRightPercent,LearningSecond,OnlySupportOpenMode,MinRightPercent_Default,LearningSecond_Default,OnlySupportOpenMode_Default)
values(15,	'���������',	'False',	16,	15,	1,	8,	0,	75,	180,	0,	75,	180,	0);
insert into QuestionType(Id,ObjectName, IsImpersonal, SortIndex, NormalScore, NormalQuestionCount, AnswerLines,GraderType,MinRightPercent,LearningSecond,OnlySupportOpenMode,MinRightPercent_Default,LearningSecond_Default,OnlySupportOpenMode_Default)
values(16,	'�ۺϲ�����',	'False',	17,	20,	1,	10,	0,	75,	240,	0,	75,	240,	0);
insert into QuestionType(Id,ObjectName, IsImpersonal, SortIndex, NormalScore, NormalQuestionCount, AnswerLines,GraderType,MinRightPercent,LearningSecond,OnlySupportOpenMode,MinRightPercent_Default,LearningSecond_Default,OnlySupportOpenMode_Default)
values(18,	'ʶͼ��',		'False',	18,	10,	1,	8,	0,	75,	0,		1,	75,	0,		1);
insert into QuestionType(Id,ObjectName, IsImpersonal, SortIndex, NormalScore, NormalQuestionCount, AnswerLines,GraderType,MinRightPercent,LearningSecond,OnlySupportOpenMode,MinRightPercent_Default,LearningSecond_Default,OnlySupportOpenMode_Default)
values(19,	'������',		'False',	19,	5,	2,	4,	0,	75,	90,		0,	75,	90,		0);
insert into QuestionType(Id,ObjectName, IsImpersonal, SortIndex, NormalScore, NormalQuestionCount, AnswerLines,GraderType,MinRightPercent,LearningSecond,OnlySupportOpenMode,MinRightPercent_Default,LearningSecond_Default,OnlySupportOpenMode_Default)
values(20,	'���ܲ�����',	'False',	20,	10,	1,	8,	0,	75,	150,	0,	75,	150,	0);
insert into QuestionType(Id,ObjectName, IsImpersonal, SortIndex, NormalScore, NormalQuestionCount, AnswerLines,GraderType,MinRightPercent,LearningSecond,OnlySupportOpenMode,MinRightPercent_Default,LearningSecond_Default,OnlySupportOpenMode_Default)
values(21,	'������',		'False',	21,	10,	2,	8,	0,	75,	150,	0,	75,	150,	0);
insert into QuestionType(Id,ObjectName, IsImpersonal, SortIndex, NormalScore, NormalQuestionCount, AnswerLines,GraderType,MinRightPercent,LearningSecond,OnlySupportOpenMode,MinRightPercent_Default,LearningSecond_Default,OnlySupportOpenMode_Default)
values(22,	'����������',	'False',	22,	20,	1,	10,	0,	75,	240,	0,	75,	240,	0);
insert into QuestionType(Id,ObjectName, IsImpersonal, SortIndex, NormalScore, NormalQuestionCount, AnswerLines,GraderType,MinRightPercent,LearningSecond,OnlySupportOpenMode,MinRightPercent_Default,LearningSecond_Default,OnlySupportOpenMode_Default)
values(12,	'���ʽ���',		'False',	23,	5,	2,	4,	0,	75,	90,		0,	75,	90,		0);
insert into QuestionType(Id,ObjectName, IsImpersonal, SortIndex, NormalScore, NormalQuestionCount, AnswerLines,GraderType,MinRightPercent,LearningSecond,OnlySupportOpenMode,MinRightPercent_Default,LearningSecond_Default,OnlySupportOpenMode_Default)
values(23,	'ʵ����',		'False',	24,	10,	1,	8,	0,	75,	150,	0,	75,	150,	0);
insert into QuestionType(Id,ObjectName, IsImpersonal, SortIndex, NormalScore, NormalQuestionCount, AnswerLines,GraderType,MinRightPercent,LearningSecond,OnlySupportOpenMode,MinRightPercent_Default,LearningSecond_Default,OnlySupportOpenMode_Default)
values(25,	'ʵѵ��',		'False',	25,	10,	1,	8,	0,	75,	150,	0,	75,	150,	0);
insert into QuestionType(Id,ObjectName, IsImpersonal, SortIndex, NormalScore, NormalQuestionCount, AnswerLines,GraderType,MinRightPercent,LearningSecond,OnlySupportOpenMode,MinRightPercent_Default,LearningSecond_Default,OnlySupportOpenMode_Default)
values(26,	'���Ĵ����',	'False',	26,	15,	2,	20,	0,	75,	600,	0,	75,	600,	0);
insert into QuestionType(Id,ObjectName, IsImpersonal, SortIndex, NormalScore, NormalQuestionCount, AnswerLines,GraderType,MinRightPercent,LearningSecond,OnlySupportOpenMode,MinRightPercent_Default,LearningSecond_Default,OnlySupportOpenMode_Default)
values(27,	'��д����Ʊ',	'False',	27,	15,	1,	20,	0,	75,	600,	0,	75,	600,	0);