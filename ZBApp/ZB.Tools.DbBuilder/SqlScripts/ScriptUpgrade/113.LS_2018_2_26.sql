IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LessionTrainee]') AND type in (N'U'))
BEGIN

PRINT '-----------------课程人员---------------------------'
CREATE TABLE [dbo].[LessionTrainee](
	[Id]							INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[LessionId]						INT NOT NULL,										--课程ID
	[EmployeeId]					INT NOT NULL,										--人员Id
	[EmployeeNO]					NVARCHAR(50) NOT NULL,								--考号
	[EmployeeName]					NVARCHAR(50) NOT NULL,								--姓名
	[Age]							INT,												--年龄
	[Sex]							INT NOT NULL,										--性别 0:无 1:男 -1:女
	[DeptId]						INT NOT NULL,										--部门Id		
	[DeptFullPath]					NVARCHAR(260) NOT NULL,								--部门全路径	
	[PostId]						INT NOT NULL,										--岗位Id	
	[PostName]						NVARCHAR(50),										--岗位

	[AuditState]					BIT NOT NULL DEFAULT 0,								--0 待审， 1审核通过
	[StartDate]						DATETIME,											--开始学习时间
	[Period]						INT,												--周期
)
ALTER TABLE [LessionTrainee]  WITH CHECK ADD  
	CONSTRAINT [FK_LessionTrainee_Lession] FOREIGN KEY([LessionId]) REFERENCES [Lesson] ([Id])

CREATE UNIQUE NONCLUSTERED INDEX [IDX_LessionTrainee_LessionId_EmployeeId] ON [dbo].[LessionTrainee] 
(
	[LessionId] ASC,
	[EmployeeId] ASC
)

END


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LessonExamPaperPackage]') AND type in (N'U'))
BEGIN

PRINT '------ 课程考试试卷包 ------'
CREATE TABLE [dbo].[LessonExamPaperPackage](
	[Id]							INT IDENTITY(1,1) PRIMARY KEY  NOT NULL,			-- 唯一标识
	[IsImpersonal]					BIT NOT NULL,										-- 是否客观卷
	[ObjectName]					NVARCHAR(255) NOT NULL,								-- 试卷包名称
	[LessonId]						INT NOT NULL,										-- 课程Id			
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
	[ExportConfig]					VARBINARY(MAX),										-- 课程导出配置
	[ExamDuration]					INT NOT NULL,										-- 考试时长
	[ExamPassScore]					DECIMAL(18,1) NOT NULL,								-- 考试通过分
	[IncludeOffline]				BIT NOT NULL,										-- 是否包含线下考试
	[OfflinePassScore]				DECIMAL(18,1) NOT NULL DEFAULT 0,										-- 线下考试合格分
	[IsDelete]						BIT NOT NULL DEFAULT 0,								-- 是否删除
)

ALTER TABLE [LessonExamPaperPackage]  WITH CHECK ADD  
	CONSTRAINT [FK_LessonExamPaperPackage_Lesson] FOREIGN KEY([LessonId]) REFERENCES [Lesson] ([Id])
                                                                                                
END


IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('LessonExamPaperPackage') AND name='IncludeOffline')
BEGIN
	ALTER TABLE LessonExamPaperPackage ADD IncludeOffline BIT NOT NULL DEFAULT 0;
	PRINT '添加‘LessonExamPaperPackage’的字段(IncludeOffline)’成功';
END


IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('LessonExamPaperPackage') AND name='OfflinePassScore')
BEGIN
	ALTER TABLE LessonExamPaperPackage ADD OfflinePassScore DECIMAL(18,1) NOT NULL DEFAULT 0;
	PRINT '添加‘LessonExamPaperPackage’的字段(OfflinePassScore)’成功';
END


IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('Lesson') AND name='StandardId')
BEGIN
	ALTER TABLE Lesson ADD StandardId INT;
	PRINT '添加‘Lesson’的字段(StandardId)’成功';
END


IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('Lesson') AND name='LevelId')
BEGIN
	ALTER TABLE Lesson ADD LevelId INT;
	PRINT '添加‘Lesson’的字段(LevelId)’成功';
END


PRINT '添加‘Lesson’的字段IDX_LessionId_StandardId_LevelId’约束';
IF NOT EXISTS(SELECT * FROM sysindexes WHERE id = object_id('Lesson') AND name='IDX_LessionId_StandardId_LevelId')
BEGIN
	CREATE UNIQUE NONCLUSTERED INDEX [IDX_LessionId_StandardId_LevelId] ON [dbo].[Lesson] 
	(
		[Id]		ASC,
		[StandardId] ASC,
		[LevelId] ASC
	)
END



IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LessonExaminee]') AND type in (N'U'))
BEGIN

PRINT '-------课程考试人员表------------'
CREATE TABLE [dbo].[LessonExaminee](
	[Id]					INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[EmployeeId]			INT NOT NULL,									--人员Id
	[LessonId]				INT NOT NULL,									--课程Id	
	[ReportDate]			DATETIME NOT NULL,								--报名时间		
	[AuditStatus]			BIT NOT NULL,									--审核状态
	[IsPass]				BIT NULL,										--是否通过									
)

ALTER TABLE [LessonExaminee]  WITH CHECK ADD  
	CONSTRAINT [FK_LessonExaminee_Lesson] FOREIGN KEY([LessonId]) REFERENCES [Lesson] ([Id])

END



IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LessonWebExamineePaper]') AND type in (N'U'))
BEGIN

PRINT '------课程考试考生试卷------'
CREATE TABLE [dbo].[LessonWebExamineePaper](
	[Id]							INT PRIMARY KEY NOT NULL,				
	[LessonId]						INT NOT NULL,										-- 课程ID
	[LessonExamineeId]				INT NOT NULL,										-- 考生Id
	[WebExamTotalScore]				DECIMAL(18,1) NOT NULL DEFAULT 0,					-- 考试试卷总分
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
	[OfflineScore]					DECIMAL(18,1) NOT NULL DEFAULT 0,										-- 线下考试得分
	[CloseTime]						DATETIME,											-- (个人)考试结束时间
)

ALTER TABLE [LessonWebExamineePaper]  WITH CHECK ADD  
	CONSTRAINT [FK_LessonWebExamineePaper_Lesson] FOREIGN KEY([LessonId]) REFERENCES [Lesson] ([Id]),
	CONSTRAINT [FK_LessonWebExamineePaper_LessonExaminee] FOREIGN KEY([LessonExamineeId]) REFERENCES [LessonExaminee] ([Id])

CREATE UNIQUE NONCLUSTERED INDEX [IDX_LessonWebExamineePaper_LessonExamineeId] ON [dbo].[LessonWebExamineePaper] 
(
	[LessonExamineeId] ASC
) ON [PRIMARY]

END


IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('LessonWebExamineePaper') AND name='OfflineScore')
BEGIN
	ALTER TABLE LessonWebExamineePaper ADD OfflineScore DECIMAL(18,1) NOT NULL DEFAULT 0;
	PRINT '添加‘LessonWebExamineePaper’的字段(OfflineScore)’成功';
END


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LessonExamineePaperDetail]') AND type in (N'U'))
BEGIN

PRINT '------课程考试考生试卷详细------'
CREATE TABLE [dbo].[LessonExamineePaperDetail](
	[Id]							INT PRIMARY KEY NOT NULL,		
	[LessonId]						INT NOT NULL,										-- 课程ID
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
	[IsLook]						BIT	NOT NULL DEFAULT 0,								-- 是否看过	
)
ALTER TABLE [LessonExamineePaperDetail]  WITH CHECK ADD  
	CONSTRAINT [FK_LessonExamineePaperDetail_Lesson] FOREIGN KEY([LessonId]) REFERENCES [Lesson] ([Id]),
	CONSTRAINT [FK_LessonExamineePaperDetail_LessonWebExamineePaper] FOREIGN KEY([PaperId]) REFERENCES [LessonWebExamineePaper] ([Id])

CREATE UNIQUE NONCLUSTERED INDEX [IDX_LessonExamineePaperDetail_PaperIdPaperPackageQuestionId] ON [dbo].[LessonExamineePaperDetail] 
(
	[PaperId] ASC,
	[PaperPackageQuestionId] ASC
) ON [PRIMARY]

END




