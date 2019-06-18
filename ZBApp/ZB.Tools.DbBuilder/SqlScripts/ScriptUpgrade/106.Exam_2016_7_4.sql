


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WebExamLearningRequire]') AND type in (N'U'))
BEGIN

	PRINT '------网络考试学习要求------';
	CREATE TABLE [dbo].[WebExamLearningRequire](
		[WebExamId]			INT PRIMARY KEY NOT NULL,							--网考ID
		[IsOpen]			BIT NOT NULL,										--是否开启学习要求
		[IsRequisite]		BIT NOT NULL,										--是否要求学习必须通过	
		[StudyTimeSpan]		INT NOT NULL DEFAULT 0,								--整体学习时间要求（分钟）
		[TestPassCount]		INT NOT NULL DEFAULT 0,								--测试通过次数要求
	)

	ALTER TABLE [WebExamLearningRequire]  WITH CHECK ADD  
		CONSTRAINT [FK_WebExamLearningRequire_WebExam] FOREIGN KEY([WebExamId]) REFERENCES [WebExam] ([Id])

END


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WebExamLearningRequireByQuestion]') AND type in (N'U'))
BEGIN

	PRINT '---------网络考试学习要求-试题要求-----------';
	CREATE TABLE [dbo].[WebExamLearningRequireByQuestion](
		[WebExamId]				INT NOT NULL,
		[QtId]					INT NOT NULL,										--题型
		[RightQuesCount]		INT,												--答对题量
		[RightPercent]			DECIMAL(18,2),										--正确率
	)

	ALTER TABLE [WebExamLearningRequireByQuestion]  WITH CHECK ADD  
		CONSTRAINT [FK_WebExamLearningRequireByQuestion_WebExam] FOREIGN KEY([WebExamId]) REFERENCES [WebExam] ([Id])


	CREATE UNIQUE NONCLUSTERED INDEX [IDX_WebExamId_QuestionTypeId] ON [dbo].[WebExamLearningRequireByQuestion] 
	(
		[WebExamId] ASC,
		[QtId] ASC
	)

END


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WebExamStudyInfo]') AND type in (N'U'))
BEGIN

	PRINT '--------网络考试学习详情--------------';
	CREATE TABLE [dbo].[WebExamStudyInfo](
		[WebExamId]				INT NOT NULL,					--考试ID
		[WebExamineeId]			INT NOT NULL,					--考生ID
		[StudyTimeSpan]			INT NOT NULL,					--总计学习时间
		[PassTime]				Datetime,						--达标时间，为空代表未达标
	)

	ALTER TABLE [WebExamStudyInfo]  WITH CHECK ADD  
		CONSTRAINT [FK_WebExamStudyInfo_WebExam] FOREIGN KEY([WebExamId]) REFERENCES [WebExam] ([Id])

	ALTER TABLE [WebExamStudyInfo]  WITH CHECK ADD  
		CONSTRAINT [FK_WebExamStudyInfo_WebExaminee] FOREIGN KEY([WebExamineeId]) REFERENCES [WebExaminee] ([Id])

	CREATE UNIQUE NONCLUSTERED INDEX [IDX_WebExamId_WebExamineeId] ON [dbo].[WebExamStudyInfo] 
	(
		[WebExamId] ASC,
		[WebExamineeId] ASC
	)

END


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WebExamStudyInfoByQuestion]') AND type in (N'U'))
BEGIN

	PRINT '--------网络考试学习详情-试题-----------';
	CREATE TABLE [dbo].[WebExamStudyInfoByQuestion](
		[WebExamId]				INT NOT NULL,										--考试ID
		[WebExamineeId]			INT NOT NULL,										--考生ID
		[QtId]					INT NOT NULL,										--题型ID
		[RightQuesCount]		INT NOT NULL,										--答对题量
		[WrongQuesCount]		INT NOT NULL,										--答错题量
	)

	ALTER TABLE [WebExamStudyInfoByQuestion]  WITH CHECK ADD  
		CONSTRAINT [FK_WebExamStudyInfoByQuestion_WebExam] FOREIGN KEY([WebExamId]) REFERENCES [WebExam] ([Id])


	ALTER TABLE [WebExamStudyInfoByQuestion]  WITH CHECK ADD  
		CONSTRAINT [FK_WebExamStudyInfoByQuestion_WebExaminee] FOREIGN KEY([WebExamineeId]) REFERENCES [WebExaminee] ([Id])


	CREATE UNIQUE NONCLUSTERED INDEX [IDX_WebExamId_WebExamineeId_QuestionTypeId] ON [dbo].[WebExamStudyInfoByQuestion] 
	(
		[WebExamId] ASC,
		[WebExamineeId] ASC,
		[QtId] ASC
	)

END


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WebExamStudyInfoByQuestionPosition]') AND type in (N'U'))
BEGIN

	PRINT '--------网络考试学习详情-试题-学习位置-----------';
	CREATE TABLE [dbo].[WebExamStudyInfoByQuestionPosition](
		[WebExamId]				INT NOT NULL,						--考试ID
		[WebExamineeId]			INT NOT NULL,						--考生ID
		[QtId]					INT NOT NULL,						--题型ID
		[StudyType]				INT NOT NULL,						--学习方式
		[QuestionId]			INT NOT NULL,						--试题ID
	)

	ALTER TABLE [WebExamStudyInfoByQuestionPosition]  WITH CHECK ADD  
		CONSTRAINT [FK_WebExamStudyInfoByQuestionPosition_WebExam] FOREIGN KEY([WebExamId]) REFERENCES [WebExam] ([Id])


	ALTER TABLE [WebExamStudyInfoByQuestionPosition]  WITH CHECK ADD  
		CONSTRAINT [FK_WebExamStudyInfoByQuestionPosition_WebExaminee] FOREIGN KEY([WebExamineeId]) REFERENCES [WebExaminee] ([Id])


	CREATE UNIQUE NONCLUSTERED INDEX [IDX_WebExamId_WebExamineeId_QuestionTypeId] ON [dbo].[WebExamStudyInfoByQuestionPosition] 
	(
		[WebExamId] ASC,
		[WebExamineeId] ASC,
		[QtId] ASC,
		[StudyType] ASC
	)

END



IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WebExamStudyInfoByTest]') AND type in (N'U'))
BEGIN

	PRINT '-----------网络考试学习详情-测验--------------------';
	CREATE TABLE [dbo].[WebExamStudyInfoByTest](
		[Id]					INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
		[WebExamId]				INT NOT NULL,										--考试ID
		[WebExamineeId]			INT NOT NULL,										--考生ID
		[Score]					DECIMAL(18,1) NOT NULL,								-- 得分
		[PassScore]				DECIMAL(18,1) NOT NULL,								-- 通过分
		[PaperScore]			DECIMAL(18,1) NOT NULL,								-- 试卷总分
		[IsPassed]				BIT NOT NULL,										-- 是否通过
		[TestTime]				DateTime NOT NULL,									-- 测验交卷时间
	)


	ALTER TABLE [WebExamStudyInfoByTest]  WITH CHECK ADD  
		CONSTRAINT [FK_WebExamStudyInfoByTest_WebExam] FOREIGN KEY([WebExamId]) REFERENCES [WebExam] ([Id])


	ALTER TABLE [WebExamStudyInfoByTest]  WITH CHECK ADD  
		CONSTRAINT [FK_WebExamStudyInfoByTest_WebExaminee] FOREIGN KEY([WebExamineeId]) REFERENCES [WebExaminee] ([Id])

END
