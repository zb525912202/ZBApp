

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RequiredTrainee]') AND type in (N'U'))
BEGIN



PRINT'--------------删除废除的网络培训班表------------'
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeQuesRequiredItemDetail]') AND type in (N'U'))
DROP TABLE dbo.EmployeeQuesRequiredItemDetail;
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmployeePaperRequiredItemDetail]') AND type in (N'U'))
DROP TABLE dbo.EmployeePaperRequiredItemDetail;
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeResourceRequiredItemDetail]') AND type in (N'U'))
DROP TABLE dbo.EmployeeResourceRequiredItemDetail;

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AFileRequiredItem]') AND type in (N'U'))
DROP TABLE dbo.AFileRequiredItem;
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RFileRequiredItem]') AND type in (N'U'))
DROP TABLE dbo.RFileRequiredItem;

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PQRequiredItemRule]') AND type in (N'U'))
DROP TABLE dbo.PQRequiredItemRule;
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PQRequiredPaperPackage]') AND type in (N'U'))
DROP TABLE dbo.PQRequiredPaperPackage;
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PQRequiredItem]') AND type in (N'U'))
DROP TABLE dbo.PQRequiredItem;
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RequiredTaskFinishInfo]') AND type in (N'U'))
DROP TABLE dbo.RequiredTaskFinishInfo;
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RequiredTaskPassInfo]') AND type in (N'U'))
DROP TABLE dbo.RequiredTaskPassInfo;

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RequiredTask]') AND type in (N'U'))
DROP TABLE dbo.RequiredTask;

PRINT'--------------清除学生30天临时学习记录表的记录------------'
TRUNCATE TABLE dbo.EmployeeStudyInfo;

PRINT'--网络培训班表'
CREATE TABLE  [dbo].[RequiredTask](
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,	
	[ObjectName]			NVARCHAR(50) NOT NULL,								-- 任务名称
	[DeptId]				INT NOT NULL,										-- 部门Id	
	[EndTime]				SMALLDATETIME NOT NULL,								-- 结束时间
	[CreateTime]			DATETIME NOT NULL,									-- 创建时间
	[CreatorId]				INT NOT NULL,										-- 创建人Id
	[CreatorName]			NVARCHAR(50) NOT NULL,								-- 创建人姓名	
	[RequiredTaskState]     INT NOT NULL,										-- 网络培训班状态(开启、暂停)
	[RequiredTaskExByte]    VARBINARY(MAX),										-- 网络培训班扩展对象(方便查询)
)

PRINT '------网络培训班学员------'
CREATE TABLE [dbo].[RequiredTrainee](
	[Id]						INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[RequiredTaskId]			INT NOT NULL,										--网络培训班ID	
	[EmployeeId]				INT NOT NULL,										--人员Id
	[EmployeeNO]				NVARCHAR(50) NOT NULL,								--工号
	[TraineeName]				NVARCHAR(50) NOT NULL,								--姓名
	[Age]						INT,												--年龄
	[Sex]						INT NOT NULL,										--性别 0:无 1:男 -1:女
	[DeptFullPath]				NVARCHAR(260) NOT NULL,								--部门
	[PostName]					NVARCHAR(50),										--岗位
)
ALTER TABLE [RequiredTrainee]  WITH CHECK ADD  
	CONSTRAINT [FK_RequiredTrainee_RequiredTask] FOREIGN KEY([RequiredTaskId]) REFERENCES [RequiredTask] ([Id])

CREATE UNIQUE NONCLUSTERED INDEX [IDX_RequiredTaskId_EmployeeId] ON [dbo].[RequiredTrainee] 
(
	[RequiredTaskId] ASC,
	[EmployeeId] ASC
)


PRINT'--题卷必修项表'
CREATE TABLE  [dbo].[PQRequiredItem](
	[Id]						INT IDENTITY(1,1) PRIMARY KEY,	
	[RequiredTaskId]			INT NOT NULL,										-- 网络培训班Id	
	[PassScore]					DECIMAL(18,1) NOT NULL,								-- 合格分	
	[PaperScore]				DECIMAL(18,1) NOT NULL,								-- 试卷总分
	[RuleDescribe]				NVARCHAR(400) NULL,									-- 题卷必修项达标要求描述
)
ALTER TABLE [PQRequiredItem]  WITH CHECK ADD  
	CONSTRAINT [FK_PQRequiredItem_RequiredTask] FOREIGN KEY([RequiredTaskId]) REFERENCES RequiredTask ([Id])

PRINT'--题卷必修项达标要求表'
CREATE TABLE  [dbo].[PQRequiredItemRule](
	[Id]						INT IDENTITY(1,1) PRIMARY KEY,	
	[RequiredTaskId]			INT NOT NULL,										-- 网络培训班Id
	[PQRequiredItemId]			INT NOT NULL,										-- 题卷必修项Id
	[QtId]						INT NOT NULL,										-- 题型Id
	[RightQuesCount]			INT NOT NULL DEFAULT ((0)),							-- 答对题量
	[RightPercent]				DECIMAL(18,2) NOT NULL DEFAULT ((0)),				-- 正确率
)
ALTER TABLE [PQRequiredItemRule]  WITH CHECK ADD  
	CONSTRAINT [FK_PQRequiredItemRule_PQRequiredItem] FOREIGN KEY([PQRequiredItemId]) REFERENCES PQRequiredItem ([Id])


PRINT'--试卷包'
CREATE TABLE [dbo].[PQRequiredPaperPackage](
	[Id]							INT IDENTITY(1,1) PRIMARY KEY  NOT NULL,			-- 唯一标识
	[RequiredTaskId]				INT NOT NULL,										-- 网络培训班Id
	[PQRequiredItemId]				INT NOT NULL,										-- 题卷必修项Id
	[IsImpersonal]					BIT NOT NULL,										-- 是否客观卷
	[ObjectName]					VARCHAR(50) NOT NULL,								-- 试卷包名称	
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
	[PaperSolutionObjBytes]			VARBINARY(MAX),										-- 组卷方案
	[ExportConfig]					VARBINARY(MAX),										-- 试卷导出配置	
)
ALTER TABLE [PQRequiredPaperPackage]  WITH CHECK ADD  
	CONSTRAINT [FK_PQRequiredPaperPackage_PQRequiredItem] FOREIGN KEY([PQRequiredItemId]) REFERENCES PQRequiredItem ([Id])


--试卷包试题表，该表动态生成，表名为【PQRequiredPaperPackageQuestion_】 + 【试卷包ID】
/*
CREATE TABLE [dbo].[PQRequiredPaperPackageQuestion_{0}](
	[Id]					INT PRIMARY KEY  NOT NULL,				--标识
	[QuestionId]			INT NOT NULL,							--试题ID
	[PaperPackageId]		INT NOT NULL,							--试卷包ID
	[HardLevel]	    		INT NOT NULL,							--难易度
	[QtId]					INT NOT NULL,							--题型ID
	[ContentText]			NVARCHAR(400) NULL,						--内容文本
	[AnswerText]			NVARCHAR(MAX) NULL,						--答案文本
	[AnalysisText]			NVARCHAR(MAX) NULL,						--解析文本	
	[Content]				VARBINARY(MAX) NOT NULL,				--内容
	[Answer]				VARBINARY(MAX) NULL,					--答案
	[Analysis]				VARBINARY(MAX) NULL						--解析
	[ContentLength]			INT NOT NULL,							-- 试题内容Rtf字节数
	[AnswerLength]			INT NOT NULL,							-- 试题答案Rtf字节数
	[AnalysisLength]		INT NOT NULL,							-- 试题解析Rtf字节数
)
*/

PRINT'--媒体必修项表(RFile)'
CREATE TABLE [dbo].[RFileRequiredItem](
	[Id]						INT PRIMARY KEY NOT NULL,							-- 唯一标识
	[ObjectName]				NVARCHAR(255) NOT NULL,								-- 文件名称	
	[SourceName]				NVARCHAR(255) NOT NULL,								-- 原始文件名称	
	[ConvertName]				NVARCHAR(255) NOT NULL,								-- 转换文件名称	
	[SourceId]					INT NOT NULL,										-- 原始资源ID
	[ParentId]					INT NOT NULL,										-- RequiredTaskId
	[FileType]					INT NOT NULL,										-- 文件类型
	[FileTypeExt]				INT NOT NULL,										-- 文件扩展名（后缀名）
	[FileSize]					BIGINT NOT NULL,									-- 文件大小
	[UploadPathIndex]			INT NOT NULL,										-- 文件存放的上传目录索引
	[PreviewCount]				INT NOT NULL DEFAULT ((0)),							-- 缩略图数量
	[ContentLength]				BIGINT NOT NULL,									-- 内容长度(时长、页数)
	[GUID]						NVARCHAR(50) NOT NULL,								-- Guid	
	[Md5]						NVARCHAR(50) NOT NULL,								-- Md5	
	[SortIndex]					INT NOT NULL DEFAULT ((0)),							-- 排序索引
	[StudyTimeSpan]				INT NOT NULL,										-- 学习时长(秒)
	[RecommendCount]			INT NOT NULL DEFAULT ((0)),							-- 推荐次数
	[UnRecommendCount]			INT NOT NULL DEFAULT ((0)),							-- 不推荐次数
	[StudyTimes]				INT NOT NULL DEFAULT ((0)),							-- 学习人次
)

PRINT'--媒体必修项表(AFile)'
CREATE TABLE [dbo].[AFileRequiredItem](
	[Id]						INT PRIMARY KEY NOT NULL,							-- 唯一标识
	[ObjectName]				NVARCHAR(255) NOT NULL,								-- 文件名称	
	[SourceName]				NVARCHAR(255) NOT NULL,								-- 原始文件名称	
	[ConvertName]				NVARCHAR(255) NOT NULL,								-- 转换文件名称	
	[SourceId]					INT NOT NULL,										-- 原始资源ID
	[ParentId]					INT NOT NULL,										-- RFileRequiredItemId
	[FileType]					INT NOT NULL,										-- 文件类型
	[FileTypeExt]				INT NOT NULL,										-- 文件扩展名（后缀名）
	[FileSize]					BIGINT NOT NULL,									-- 文件大小
	[UploadPathIndex]			INT NOT NULL,										-- 文件存放的上传目录索引
	[PreviewCount]				INT NOT NULL DEFAULT ((0)),							-- 缩略图数量
	[ContentLength]				BIGINT NOT NULL,									-- 内容长度(时长、页数)
	[GUID]						NVARCHAR(50) NOT NULL,								-- Guid	
	[Md5]						NVARCHAR(50) NOT NULL,								-- Md5	
	[SortIndex]					INT NOT NULL DEFAULT ((0)),							-- 排序索引
	[StudyTimeSpan]				INT NOT NULL,										-- 学习时长(秒)	
	[RecommendCount]			INT NOT NULL DEFAULT ((0)),							-- 推荐次数
	[UnRecommendCount]			INT NOT NULL DEFAULT ((0)),							-- 不推荐次数
	[StudyTimes]				INT NOT NULL DEFAULT ((0)),							-- 学习人次
)
ALTER TABLE [AFileRequiredItem]  WITH CHECK ADD  
	CONSTRAINT [FK_AFileRequiredItem_RFileRequiredItem] FOREIGN KEY([ParentId]) REFERENCES RFileRequiredItem ([Id])


PRINT'--网络培训班完成情况表(RequiredTaskPassInfo)'
CREATE TABLE [dbo].[RequiredTaskPassInfo](
	[Id]							INT IDENTITY(1,1) PRIMARY KEY  NOT NULL,			-- 唯一标识
	[RequiredTaskId]			INT NOT NULL,										-- 网络培训班Id
	[EmployeeId]				INT NOT NULL,										-- 人员Id
	[EmployeeNO]				NVARCHAR(50) NOT NULL,								-- 工号
	[TraineeName]				NVARCHAR(50) NOT NULL,								-- 姓名
	[Age]						INT,												-- 年龄
	[Sex]						INT NOT NULL,										-- 性别 0:无 1:男 -1:女
	[DeptFullPath]				NVARCHAR(260) NOT NULL,								-- 部门
	[PostName]					NVARCHAR(50),										-- 岗位
	[PassTime]					DATETIME NOT NULL,									-- 达标时间
)

CREATE UNIQUE NONCLUSTERED INDEX [IDX_RequiredTaskId_EmployeeId] ON [dbo].[RequiredTaskPassInfo] 
(
	[RequiredTaskId] ASC,
	[EmployeeId] ASC
)


-------------------------------必修项学习情况-----------------------------{
PRINT'--人员试题达标情况表'
CREATE TABLE [dbo].[EmployeeQuesRequiredItemDetail](
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,
	[EmployeeId]			INT NOT NULL,										-- 人员Id	
	[DeptId]				INT NOT NULL,										-- 部门ID	
	[RequiredTaskId]		INT NOT NULL,										-- 网络培训班Id
	[RequiredItemId]		INT NOT NULL,										-- 题卷必修项Id
	[QtId]					INT NOT NULL,										-- 题型ID
	[RightCount]			INT NOT NULL,										-- 做对题量
	[WrongCount]			INT NOT NULL,										-- 做错题量
)
CREATE NONCLUSTERED INDEX [IDX_RequiredItemId_QtId] ON [dbo].[EmployeeQuesRequiredItemDetail] 
(
	[RequiredItemId] ASC,
	[QtId] ASC
)


PRINT'--人员试卷达标情况表'
CREATE TABLE [dbo].[EmployeePaperRequiredItemDetail](
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,
	[EmployeeId]			INT NOT NULL,										-- 人员Id	
	[DeptId]				INT NOT NULL,										-- 部门ID	
	[RequiredTaskId]		INT NOT NULL,										-- 网络培训班Id
	[RequiredItemId]		INT NOT NULL,										-- 题卷必修项Id	
	[Score]					DECIMAL(18,1) NOT NULL,								-- 得分
	[PassScore]				DECIMAL(18,1) NOT NULL,								-- 通过分
	[PaperScore]			DECIMAL(18,1) NOT NULL,								-- 试卷总分
	[PaperQuesCount]		INT NOT NULL,										-- 试卷题量
	[IsPassed]				BIT NOT NULL,										-- 是否通过
	[SubmitTime]			DateTime NOT NULL,									-- 交卷时间
)

PRINT'--人员媒体达标情况表'
CREATE TABLE [dbo].[EmployeeResourceRequiredItemDetail](
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,
	[EmployeeId]			INT NOT NULL,										-- 人员Id	
	[DeptId]				INT NOT NULL,										-- 部门ID	
	[RequiredTaskId]		INT NOT NULL,										-- 网络培训班Id
	[RequiredItemId]		INT NOT NULL,										-- 媒体必修项Id	
	[StudyTimeSpan]         INT NOT NULL,										-- 有效学习时长(分)
)
CREATE NONCLUSTERED INDEX [IDX_RequiredItemId] ON [dbo].[EmployeeResourceRequiredItemDetail] 
(
	[RequiredItemId] ASC
)

-------------------------------必修项学习情况-----------------------------}




END
