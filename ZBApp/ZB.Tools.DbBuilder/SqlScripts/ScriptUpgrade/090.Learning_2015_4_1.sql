IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeNetClassStudyDetail]') AND type in (N'U'))
BEGIN
PRINT'--人员网络培训班学习明细表'
CREATE TABLE [dbo].[EmployeeNetClassStudyDetail](
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,
	[EmployeeId]			INT NOT NULL,										-- 人员Id
	[EmployeeName]			NVARCHAR(50) NOT NULL,								-- 人员姓名
	[DeptId]				INT NOT NULL,										-- 部门Id	
	[DeptFullPath]			NVARCHAR(260) NOT NULL,								-- 部门FullPath
	[PostId]				INT NOT NULL,										-- 岗位Id
	[PostName]				NVARCHAR(50),										-- 岗位名称
	[StudyDate]				SMALLDATETIME NOT NULL,								-- 学习时间	
	[StudyType]             INT NOT NULL,										-- 学习方式(开卷、闭卷)
	[StudyMode]             INT NOT NULL,										-- 学习形式(试题、试卷、视频、音频、文档、必修)
	[RequiredTaskId]		INT NOT NULL DEFAULT ((0)),							-- 网络培训班Id
	[RequiredTaskName]		NVARCHAR(50),										-- 网络培训班名称
	[RequiredItemId]		INT NOT NULL DEFAULT ((0)),							-- 必修项Id
	[RequiredItemName]		NVARCHAR(50),										-- 必修项名称
	[NetClassId]			INT NOT NULL,										-- 课程ID	
	[NetClassName]			NVARCHAR(50),										-- 课程名称
	[StudyTimeSpan]         INT NOT NULL,										-- 有效学习时长(秒)
	[LearningPoint]	        DECIMAL(18,2) NOT NULL,								-- 学习积分
	[OpenStudyTimeSpan]     INT NOT NULL,										-- 有效学习时长(秒)
	[OpenLearningPoint]	    DECIMAL(18,2) NOT NULL,								-- 学习积分
	[CloseStudyTimeSpan]    INT NOT NULL,										-- 有效学习时长(秒)
	[CloseLearningPoint]	DECIMAL(18,2) NOT NULL,								-- 学习积分	
	[RightCount]			INT NOT NULL,										-- 做对题量
	[WrongCount]			INT NOT NULL,										-- 做错题量
	[Month]					INT NOT NULL,										-- 学习时间之月
	[Quarter]				INT NOT NULL,										-- 学习时间之季
	[HalfYear]				INT NOT NULL,										-- 学习时间之半年
	[Year]					INT NOT NULL,										-- 学习时间之年
	[EmployeeRecordType]    INT NOT NULL,										-- 学习形式之个人报表行记录的学习类型(试题、试卷、媒体、专辑、网络培训班)
)
CREATE UNIQUE NONCLUSTERED INDEX [IDX_EmployeeNetClassStudyDetail_StudyDate_EmployeeId_NetClassId] ON [dbo].[EmployeeNetClassStudyDetail] 
(
	[StudyDate] ASC,
	[EmployeeId] ASC,	
	[NetClassId] ASC
)
END
GO
