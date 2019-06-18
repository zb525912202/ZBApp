USE [$(DatabaseName)]
GO
BEGIN TRANSACTION

PRINT '------网络考试基本信息表------'
CREATE TABLE [dbo].[WebExam](
	[Id]					INT IDENTITY(1,1) PRIMARY KEY NOT NULL,		
	[ObjectName]			NVARCHAR(50) NOT NULL,							--考试名称
	[ExamGroupName]			NVARCHAR(50),									--考试组
	[DeptId]				INT NOT NULL,									--考试所在的部门	
	[DeptFullPath]			NVARCHAR(260) NOT NULL,							--考试所在部门全路径
	[CreatorId]				INT NOT NULL,									--考试发起人Id
	[CreatorName]			NVARCHAR(50) NOT NULL,							--考试发起人姓名
	[CreateTime]			DATETIME NOT NULL,								--考试创建时间		
	[ExamMode]				INT NOT NULL,									--考试形式(0、统一开考 1、随到随考)
	[ExamState]				INT NOT NULL,									--考试状态(0、备考 1、进行中 2、闭考)
	[StartTime]				DATETIME NOT NULL,								--开考时间		
	[ExamTimeSpan]			INT NOT NULL,									--时长（分钟）
	[CloseTime]				DATETIME NOT NULL,								--闭考时间		
	[GradeCompletedTime]	DATETIME NULL,									--阅卷任务完成时间
	[TotalScore]			DECIMAL(18,1) NOT NULL,							--试卷总分
	[PassScore]				DECIMAL(18,1) NOT NULL,							--及格分
	[PaperMode]				INT NOT NULL,									--用卷方式(0、单卷 1、AB卷 2、多卷)
	[IsRandomShowQues]		BIT NOT NULL DEFAULT 0,							--是否打乱试题显示顺序	
	[AllowCommitTimeSpan]	INT NOT NULL,									--开考后，多长时间后可以交卷
	[ExamNotice]			NVARCHAR(MAX) NOT NULL DEFAULT '',				--考试须知
	[IsShowPaperResult]		BIT NOT NULL DEFAULT 0,							--交卷后，是否显示考试成绩
	[IsAllowOthersPapers]	BIT NOT NULL DEFAULT 0,							--交卷后，是否允许查看别人的试卷
	[DoubtTimeSpan]			INT NOT NULL DEFAULT 0,							--质疑时长,0表示不允许质疑
	[WebExamType]			INT NOT NULL DEFAULT 0,							--网络考试类型(0、网络考试，1、TM网络考试)
	[IsValidateExaminee]	BIT NOT NULL DEFAULT 0,							--是否验证考生身份
	[IsNeedFaceMatch]		BIT NOT NULL DEFAULT 0,							--是否需要进行人脸比对
	[IsReplaceScoring]		BIT NOT NULL DEFAULT 0,							--是否可由他人阅卷
	[PaperGradePolicyByte]	VARBINARY(MAX) NULL,							--阅卷设置对象

	[WebExamDoPaperMode]	INT NOT NULL DEFAULT 0,							--网络考试类型(0、以试卷的方式做题，1、以试题的方式做题)
	[CanEditLookQues]		BIT NOT NULL DEFAULT 0,							--是否可以修改看过的题
	[WorkId]				INT NOT NULL DEFAULT 0,							-- 培训事务ID
	[IsAutoGrade]			BIT NOT NULL DEFAULT 0,							--是否主观题自动阅卷
	[RightPercentMode]		INT NOT NULL,									--最低正确率计算分数方式(0、按正确率计算,1、按最低正确率计算)
	[IsShowGrader]			BIT NOT NULL DEFAULT 1,							--是否显示阅卷老师姓名
	[CanAppJoin]			BIT NOT NULL DEFAULT 1,							--手机能否进入考场
	[AfterExamTimeSpan]		INT NOT NULL,									--考试开始后多少分钟禁止考生进入考场（选择统一开考）
	[BeforeExamTimeSpan]	INT NOT NULL,									--考试结束前多少分钟禁止考生进入考场(对应随到随考)
)
GO

PRINT '------考试IP配置表------'
CREATE TABLE [dbo].[WebExamIPConfig](
	[Id]					INT IDENTITY(1,1) PRIMARY KEY NOT NULL,		
	[WebExamId]				INT NOT NULL,										--网络考试Id	
	[StarIP]				NVARCHAR(50) NOT NULL,							--起始IP
	[EndIP]					NVARCHAR(50) NOT NULL,							--起始IP
)
GO
ALTER TABLE [WebExamIPConfig]  WITH CHECK ADD  
	CONSTRAINT [FK_WebExamIPConfig_WebExam] FOREIGN KEY([WebExamId]) REFERENCES [WebExam] ([Id])
GO

PRINT '------考试工作人员------'
CREATE TABLE [dbo].[WebExamStaff](
	[Id]						INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[WebExamId]					INT NOT NULL,										--网络考试Id	
	[EmployeeId]				INT NOT NULL,										--人员Id
	[DeptFullPath]				NVARCHAR(260) NOT NULL,								--部门FullPath
	[PostName]					NVARCHAR(50),										--岗位
	[WebExamStaffName]			NVARCHAR(50) NOT NULL,								--工作人员姓名
	[ExamRole]					INT NOT NULL,										--工作人员角色(复合枚举)	
)
ALTER TABLE [WebExamStaff]  WITH CHECK ADD  
	CONSTRAINT [FK_WebExamStaff_WebExam] FOREIGN KEY([WebExamId]) REFERENCES [WebExam] ([Id])
GO

PRINT '------ 网络考试试卷包 ------'
CREATE TABLE [dbo].[WebPaperPackage](
	[Id]							INT IDENTITY(1,1) PRIMARY KEY  NOT NULL,			-- 唯一标识
	[IsImpersonal]					BIT NOT NULL,										-- 是否客观卷
	[ObjectName]					NVARCHAR(255) NOT NULL,								-- 试卷包名称
	[WebExamId]						INT NOT NULL,										-- 网络考试Id		
	[PaperGroupObjBytes]			VARBINARY(MAX),										-- 试卷组(用于存放组卷方案的抽题结果)
	[CreatorId]						INT NOT NULL,										-- 创建人Id
	[CreatorName]					NVARCHAR(50) NOT NULL,								-- 创建人Name
	[CreateTime]					DATETIME NOT NULL,									-- 创建时间
	[LastUpdateTime]				DATETIME NOT NULL,									-- 最后一次修改时间
	[HardRate]						DECIMAL(18,1) NOT NULL DEFAULT ((0)),				-- 难度系数
	[Describe]						NVARCHAR(400) NULL,									-- 描述(知识点)
	[PaperPackageQuestionCount]		INT NOT NULL DEFAULT ((0)),							-- 试卷包用题题量
	[IsIncludeSln]					BIT NOT NULL DEFAULT 0,								-- 是否包含组卷方案
	[PaperScore]					DECIMAL(18,1) NOT NULL DEFAULT ((0)),				-- 试卷总分
	[PaperQuesCount]				INT NOT NULL DEFAULT ((0)),							-- 试卷题量
	[IsRandomPaper]					BIT NOT NULL DEFAULT 0,								-- 是否随机卷
	[PaperSolutionObjBytes]			VARBINARY(MAX),										-- 组卷方案
	[ExportConfig]					VARBINARY(MAX),										-- 试卷导出配置
)
GO
ALTER TABLE [WebPaperPackage]  WITH CHECK ADD  
	CONSTRAINT [FK_WebPaperPackage_WebExam] FOREIGN KEY([WebExamId]) REFERENCES [WebExam] ([Id])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_WebPaperPackage_WebExamId] ON [dbo].[WebPaperPackage] 
(
	[WebExamId] ASC
)
GO

--网络考试试卷包试题表，该表动态生成，表名为【WebPaperPackageQuestion_】 + 【网络考试试卷包ID】
/*
CREATE TABLE [dbo].[WebPaperPackageQuestion_{0}](
	[Id]					INT PRIMARY KEY  NOT NULL,			--标识
	[QuestionId]			INT NOT NULL,						--试题ID
	[PaperPackageId]		INT NOT NULL,						--试卷包ID
	[HardLevel]	    		INT NOT NULL,						--难易度
	[QtId]					INT NOT NULL,						--题型
	[ContentText]			NVARCHAR(MAX) NULL,					--内容文本
	[AnswerText]			NVARCHAR(MAX) NULL,					--答案文本
	[AnalysisText]			NVARCHAR(MAX) NULL,					--解析文本
	[Content]				VARBINARY(MAX) NOT NULL,			--内容
	[Answer]				VARBINARY(MAX) NULL,				--答案
	[Analysis]				VARBINARY(MAX) NULL,				--解析
	[DoubtReply]			NVARCHAR(MAX) NULL					--质疑回复
)					
*/


PRINT '------考生------'
CREATE TABLE [dbo].[WebExaminee](
	[Id]						INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[WebExamId]					INT NOT NULL,										--网络考试ID
	[EmployeeId]				INT NOT NULL,										--人员Id
	[EmployeeNO]				NVARCHAR(50) NOT NULL,								--考号	
	[EmployeeName]				NVARCHAR(50) NOT NULL,								--姓名	
	[Age]						INT,												--年龄
	[Sex]						INT NOT NULL,										--性别 0:无 1:男 -1:女
	[DeptId]					INT NOT NULL,										--部门Id		
	[DeptFullPath]				NVARCHAR(260) NOT NULL,								--部门全路径	
	[PostId]					INT NOT NULL,										--岗位Id	
	[PostName]					NVARCHAR(50),										--岗位
)
ALTER TABLE [WebExaminee]  WITH CHECK ADD  
	CONSTRAINT [FK_WebExaminee_WebExam] FOREIGN KEY([WebExamId]) REFERENCES [WebExam] ([Id])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_WebExaminee_WebExamIdEmployeeNO] ON [dbo].[WebExaminee] 
(
	[WebExamId] ASC,
	[EmployeeNO] ASC
) ON [PRIMARY]
GO

PRINT '------ 考生人员分组表 ------'
CREATE TABLE  [dbo].[WebExamineeEmployeeGroup](
	[Id]						INT IDENTITY(1,1) PRIMARY KEY,
	[WebExamId]					INT NOT NULL,										--网络考试ID
	[WebExamineeId]				INT NOT NULL,										--考生Id	
	[EmployeeGroupId]			INT NOT NULL,										--人员分组Id	
	[EmployeeGroupFullPath]		NVARCHAR(260) NOT NULL,								--人员分组全路径
	[EmployeeGroupDepth]		INT NOT NULL DEFAULT 0,								--深度
)
ALTER TABLE [WebExamineeEmployeeGroup] WITH CHECK ADD
	CONSTRAINT [FK_WebExamineeEmployeeGroup_WebExam] FOREIGN KEY([WebExamId]) REFERENCES [WebExam] ([Id]),
	CONSTRAINT [FK_WebExamineeEmployeeGroup_WebExaminee] FOREIGN KEY([WebExamineeId]) REFERENCES [WebExaminee]([Id])	
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_WebExamineeEmployeeGroup_WebExamineeId_EmployeeGroupId] ON [dbo].[WebExamineeEmployeeGroup] 
(
	[WebExamineeId] ASC,
	[EmployeeGroupId] ASC
)
GO

PRINT '------网络考试考生试卷------'
CREATE TABLE [dbo].[WebExamineePaper](
	[Id]							INT PRIMARY KEY NOT NULL,				
	[WebExamId]						INT NOT NULL,										-- 网络考试ID
	[WebExamTotalScore]				DECIMAL(18,1) NOT NULL DEFAULT 0,					-- 网络考试试卷总分
	[WebExamineeId]					INT NOT NULL,										-- 考生Id
	[PaperPackageId]				INT NOT NULL,										-- 试卷包ID
	[ObjectName]					NVARCHAR(50) NOT NULL,								-- 试卷名称
	[PaperScore]					DECIMAL(18,1) NOT NULL DEFAULT ((0)),				-- 试卷总分
	[PaperQuesCount]				INT NOT NULL DEFAULT ((0)),							-- 试卷题量
	[IsRandomPaper]					BIT NOT NULL DEFAULT 0,								-- 是否随机卷

	[CreateTime]					DATETIME NOT NULL,									-- 创建时间
	[JoinTime]						DATETIME NULL,										-- 进入考场时间
	[SubmitTime]					DATETIME NULL,										-- 交卷时间
	[ReplyTimeSpan]					INT NOT NULL,										-- 答题时长(秒)
	[PaperReplyState]				INT NOT NULL DEFAULT 0,								-- 考生答卷状态(未交卷、已交卷、缺考、作弊)
	[Score]							DECIMAL(18,1) NOT NULL DEFAULT 0,					-- 得分
	[AddedScore]					DECIMAL(18,1) NOT NULL,								-- 加分
	[CloseTime]						DATETIME,											-- (个人)考试结束时间
)

ALTER TABLE [WebExamineePaper]  WITH CHECK ADD  
	CONSTRAINT [FK_WebExamineePaper_WebExam] FOREIGN KEY([WebExamId]) REFERENCES [WebExam] ([Id]),
	CONSTRAINT [FK_WebExamineePaper_WebExaminee] FOREIGN KEY([WebExamineeId]) REFERENCES [WebExaminee] ([Id])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_WebExamineePaper_WebExamineeId] ON [dbo].[WebExamineePaper] 
(
	[WebExamineeId] ASC
) ON [PRIMARY]
GO

PRINT '------网络考试考生试卷详细------'
CREATE TABLE [dbo].[WebExamineePaperDetail](
	[Id]							INT PRIMARY KEY NOT NULL,		
	[WebExamId]						INT NOT NULL,										-- 网络考试ID
	[PaperId]						INT NOT NULL,										-- 试卷Id	
	[QtId]							INT NOT NULL,										-- 题型ID		
	[PaperPackageQuestionId]		INT NOT NULL,										-- 网络考试试卷包试题ID
	[IsImpersonal]					BIT NOT NULL,										-- 是否客观题	
	[TotalScore]					DECIMAL(18,1) NOT NULL,								-- 满分
	[ReplyText]						NVARCHAR(MAX) NOT NULL DEFAULT '',					-- 考生试题作答		
	[Reply]							VARBINARY(MAX) NULL,								-- 考生试题作答(RTF)
	[Score]							DECIMAL(18,1) NOT NULL DEFAULT 0,					-- 得分
	[IsAudit]						BIT	NOT NULL DEFAULT 0,								-- 是否已阅		
	[IsDoubt]						BIT	NOT NULL DEFAULT 0,								-- 是否质疑	
	[IsMark]						BIT	NOT NULL DEFAULT 0,								-- 是否标记	
	[MarkContent]					NVARCHAR(200) NULL DEFAULT '',						-- 标记文本
	[GradeContent]					NVARCHAR(200) NULL DEFAULT '',						-- 阅卷评语
	[GraderId]						INT NOT NULL,										--阅卷人Id
	[GraderName]					NVARCHAR(50) NOT NULL DEFAULT '',					--阅卷人名称
	[IsLook]						BIT	NOT NULL DEFAULT 0,								-- 是否看过	
)
ALTER TABLE [WebExamineePaperDetail]  WITH CHECK ADD  
	CONSTRAINT [FK_WebExamineePaperDetail_WebExam] FOREIGN KEY([WebExamId]) REFERENCES [WebExam] ([Id]),
	CONSTRAINT [FK_WebExamineePaperDetail_WebExamineePaper] FOREIGN KEY([PaperId]) REFERENCES [WebExamineePaper] ([Id])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_WebExamineePaperDetail_PaperIdPaperPackageQuestionId] ON [dbo].[WebExamineePaperDetail] 
(
	[PaperId] ASC,
	[PaperPackageQuestionId] ASC
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_WebExamineePaperDetail_WebExamId_IsImpersonal] ON [dbo].[WebExamineePaperDetail] 
(
	[WebExamId] ASC,
	[IsImpersonal] ASC
)
GO

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
GO

PRINT '------阅卷答案文本表------'
CREATE TABLE [dbo].[WebExamGradeAnswerText](
	[Id]							INT PRIMARY KEY NOT NULL,		
	[WebExamId]						INT NOT NULL,										-- 网络考试ID	
	[PaperPackageQuestionId]		INT NOT NULL,										-- 网络考试试卷包试题ID
	[AnswerText]					NVARCHAR(400) NOT NULL DEFAULT '',					-- 答案文本		
	[Score]							DECIMAL(18,1) NOT NULL DEFAULT 0,					-- 得分	
)
ALTER TABLE [WebExamGradeAnswerText]  WITH CHECK ADD  
	CONSTRAINT [FK_WebExamGradeAnswerText_WebExam] FOREIGN KEY([WebExamId]) REFERENCES [WebExam] ([Id])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_WebExamGradeAnswerText_WebExamId_PaperIdPaperPackageQuestionId] ON [dbo].[WebExamGradeAnswerText] 
(
	[WebExamId] ASC,
	[PaperPackageQuestionId] ASC,
	[AnswerText] ASC
)
GO

COMMIT TRANSACTION
