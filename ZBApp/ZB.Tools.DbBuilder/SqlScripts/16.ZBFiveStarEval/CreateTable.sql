USE [$(DatabaseName)]
GO
BEGIN TRANSACTION

PRINT '------五星测评分类------'
CREATE TABLE [dbo].[FiveStarEvalCategory](
	[Id]					INT PRIMARY KEY,				--Id
	[ObjectName]			NVARCHAR(50) NOT NULL,			--分类名称
	[Remark]				NVARCHAR(500),					--说明	
)


PRINT '--------测评范围-----------'
CREATE TABLE [dbo].[FiveStarEvalRange](
	[Id]					INT PRIMARY KEY IDENTITY(1,1),		--Id
	[CategoryId]			INT NOT NULL,						--测评分类ID
	[ObjectType]			INT NOT NULL,						--对象类型(人、部门、岗位、人员分类等..)
	[ObjectId]				INT NOT NULL,						--对象ID
)

ALTER TABLE [FiveStarEvalRange] WITH CHECK ADD
	CONSTRAINT [FK_FiveStarEvalRange_CategoryId] FOREIGN KEY ([CategoryId]) REFERENCES [FiveStarEvalCategory]([Id])
GO

/*同一个类型的同一个对象在一个测评分类下只允许出现一次*/
CREATE UNIQUE NONCLUSTERED INDEX [IDX_CategoryId_ObjectType_ObjectId] ON [dbo].[FiveStarEvalRange]
(
	[CategoryId]	ASC,
	[ObjectType]	ASC,
	[ObjectId]		ASC
)
GO


PRINT '-----------测评项-----------------'
CREATE TABLE [dbo].[FiveStarEvalItem](
	[Id]				INT PRIMARY KEY,					--Id
	[ObjectName]		NVARCHAR(50) NOT NULL,				--测评项名称
	[CategoryId]		INT NOT NULL,						--测评分类ID
	[EvalItemType]		INT NOT NULL,						--测评项类型
	[TotalScore]		DECIMAL(18,1) NOT NULL,				--总分			
	[SortIndex]			INT NOT NULL,						--序号
)

ALTER TABLE [FiveStarEvalItem] WITH CHECK ADD
	CONSTRAINT [FK_FiveStarEvalItem_CategoryId] FOREIGN KEY ([CategoryId]) REFERENCES [FiveStarEvalCategory]([Id])
GO


PRINT '-----------测评内容-----------------'
CREATE TABLE [dbo].[FiveStarEvalContent](
	[Id]				INT PRIMARY KEY,				--Id
	[ObjectName]		NVARCHAR(100) NOT NULL,			--测评内容名称
	[CategoryId]		INT NOT NULL,					--测评分类ID
	[EvalItemId]		INT NOT NULL,					--测评项ID
	[TotalScore]		DECIMAL(18,1) NOT NULL,			--总分
	[SortIndex]			INT NOT NULL,					--序号
)

ALTER TABLE [FiveStarEvalContent] WITH CHECK ADD
	CONSTRAINT [FK_FiveStarEvalContent_CategoryId] FOREIGN KEY ([CategoryId]) REFERENCES [FiveStarEvalCategory]([Id])
GO

ALTER TABLE [FiveStarEvalContent] WITH CHECK ADD
	CONSTRAINT [FK_FiveStarEvalContent_EvalItemId] FOREIGN KEY ([EvalItemId]) REFERENCES [FiveStarEvalItem]([Id])
GO


PRINT '----------测评标准-------------------'
CREATE TABLE [dbo].[FiveStarEvalStandard](
	[Id]					INT PRIMARY KEY,					--Id
	[ObjectName]			NVARCHAR(100) NOT NULL,				--测评标准名称
	[CategoryId]			INT NOT NULL,						--测评分类ID
	[EvalContentId]			INT NOT NULL,						--测评内容ID
	[DeductScore]			DECIMAL(18,1) NOT NULL,				--每次扣除的分数
	[SortIndex]				INT NOT NULL,						--序号
)

ALTER TABLE [FiveStarEvalStandard] WITH CHECK ADD
	CONSTRAINT [FK_FiveStarEvalStandard_CategoryId] FOREIGN KEY ([CategoryId]) REFERENCES [FiveStarEvalCategory]([Id])
GO

ALTER TABLE [FiveStarEvalStandard] WITH CHECK ADD
	CONSTRAINT [FK_FiveStarEvalStandard_EvalContentId] FOREIGN KEY ([EvalContentId]) REFERENCES [FiveStarEvalContent]([Id])
GO



PRINT '----------人员测评项目-------------------'
CREATE TABLE [dbo].[FiveStarEvalProject](
	[Id]					INT PRIMARY KEY IDENTITY(1,1),			--Id
	[DeptId]				INT NOT NULL,							--所属部门
	[CategoryId]			INT NOT NULL,							--测评分类ID
	[EvalType]				INT NOT NULL,							--测评类型(年度测评、季度测评、月度测评)
	[Year]					INT NOT NULL,							--年度
	[DateKey]				INT NOT NULL,							--测评所在时间(年、季度、月)
	[EvalStatus]			INT NOT NULL,							--状态
	[JoinCondition]			VARBINARY(MAX) NOT NULL,				--准入条件
)

ALTER TABLE [FiveStarEvalProject] WITH CHECK ADD
	CONSTRAINT [FK_FiveStarEvalProject_CategoryId] FOREIGN KEY ([CategoryId]) REFERENCES [FiveStarEvalCategory]([Id])
GO

PRINT '----------人员测评结果-------------------'
CREATE TABLE [dbo].[FiveStarEvalResult](
	[Id]					INT PRIMARY KEY IDENTITY(1,1),				--Id
	[ProjectId]				INT NOT NULL,								--测评项目ID
	[EmployeeId]			INT NOT NULL,								--人员ID
	[StarLevel]				INT NOT NULL,								--星级
	[GradeScore]			DECIMAL(18,1) NOT NULL,						--评分项得分
	[CreditScore]			DECIMAL(18,1) NOT NULL,						--学分项得分
)

ALTER TABLE [FiveStarEvalResult] WITH CHECK ADD
	CONSTRAINT [FK_FiveStarEvalResult_ProjectId] FOREIGN KEY ([ProjectId]) REFERENCES [FiveStarEvalProject]([Id])
GO


PRINT '----------人员测评结果明细-------------------'
CREATE TABLE [dbo].[FiveStarEvalResultDetail](
	[Id]				INT PRIMARY KEY IDENTITY(1,1),					--Id
	[ProjectId]			INT NOT NULL,									--测评项目ID
	[EmployeeId]		INT NOT NULL,									--人员ID
	[StandardId]		INT NOT NULL,									--标准ID
	[RCount]			INT NOT NULL,									--次数
)

ALTER TABLE [FiveStarEvalResultDetail] WITH CHECK ADD
	CONSTRAINT [FK_FiveStarEvalResultDetail_ProjectId] FOREIGN KEY ([ProjectId]) REFERENCES [FiveStarEvalProject]([Id])
GO


COMMIT TRANSACTION
