USE [$(DatabaseName)]
GO
BEGIN TRANSACTION
PRINT '------ 培训班 ------'
CREATE TABLE [dbo].[TrainingClass](
	[TrainingWorkId]		INT PRIMARY KEY NOT NULL,							-- 培训事务Id
	[TcTypeId]				INT NOT NULL,										-- 培训班类型	
)
ALTER TABLE [TrainingClass] WITH CHECK ADD	
	CONSTRAINT [FK_TrainingClass_TrainingWork] FOREIGN KEY([TrainingWorkId]) REFERENCES [TrainingWork]([Id]),
	CONSTRAINT [FK_TrainingClass_TcType] FOREIGN KEY([TcTypeId]) REFERENCES [TcType]([Id])
GO

PRINT '------ 课程 ------'
CREATE TABLE  [dbo].[TcCourse](
	[Id]						INT PRIMARY KEY NOT NULL,
	[ObjectName]				NVARCHAR(50) NOT NULL,								-- 课程名称
	[TrainingClassId]			INT NOT NULL,										-- 培训班ID
	[TcCourseTypeId]			INT NOT NULL,										-- 课程类型Id
	[IsDefaultRequired]			BIT NOT NULL,										-- 是否默认必修
	[LessonPeriod]				INT NOT NULL,										-- 课时
)
ALTER TABLE [TcCourse] WITH CHECK ADD
	CONSTRAINT [FK_TcCourse_TrainingClass] FOREIGN KEY([TrainingClassId]) REFERENCES [TrainingClass]([TrainingWorkId]),
	CONSTRAINT [FK_TcCourse_TcCourseType] FOREIGN KEY([TcCourseTypeId]) REFERENCES [TcCourseType]([Id])	
GO

PRINT '------ 培训班培训师 ------'
CREATE TABLE  [dbo].[TcTeacher](	
	[TrainingEmployeeId]		INT PRIMARY KEY NOT NULL,
	[TeacherLevelId]			INT NOT NULL,										--培训师级别
)
ALTER TABLE [TcTeacher] WITH CHECK ADD
	CONSTRAINT [FK_TcTeacher_TrainingEmployee] FOREIGN KEY([TrainingEmployeeId]) REFERENCES [TrainingEmployee]([Id])	
GO

PRINT '------ 培训师课程课时表 ------'
CREATE TABLE  [dbo].[TcTeacherCourse](
	[Id]						INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[TrainingClassId]			INT NOT NULL,										-- 培训班ID
	[TcTeacherId]				INT NOT NULL,										-- 培训师Id
	[TcCourseId]				INT NOT NULL,										-- 课程Id	
	[LessonPeriodTask]			INT NOT NULL,										-- 任务课时
	[LessonPeriod]				INT NOT NULL,										-- 课时
)
ALTER TABLE [TcTeacherCourse] WITH CHECK ADD
	CONSTRAINT [FK_TcTeacherCourse_TrainingClass] FOREIGN KEY([TrainingClassId]) REFERENCES [TrainingClass]([TrainingWorkId]),
	CONSTRAINT [FK_TcTeacherCourse_TcTeacher] FOREIGN KEY([TcTeacherId]) REFERENCES [TcTeacher]([TrainingEmployeeId]),
	CONSTRAINT [FK_TcTeacherCourse_TcCourse] FOREIGN KEY([TcCourseId]) REFERENCES [TcCourse]([Id])
GO

PRINT '------ 培训师课程违规 ------'
CREATE TABLE  [dbo].[TcTeacherMistake](
	[Id]						INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[TrainingClassId]			INT NOT NULL,										-- 培训班ID
	[TcTeacherId]				INT NOT NULL,										-- 培训师Id
	[TcCourseId]				INT NOT NULL,										-- 课程Id(课程Id为0就是培训班违规,否则是课程违规)
	[MistakeDate]				DATETIME NOT NULL,									-- 违规时间
	[MistakeLevel]				INT NOT NULL,										-- 严重程度(轻微、一般、重大)	
	[Remark]					NVARCHAR(MAX)NOT NULL,								-- 备注
)
ALTER TABLE [TcTeacherMistake] WITH CHECK ADD
	CONSTRAINT [FK_TcTeacherMistake_TrainingClass] FOREIGN KEY([TrainingClassId]) REFERENCES [TrainingClass]([TrainingWorkId]),
	CONSTRAINT [FK_TcTeacherMistake_TcTeacher] FOREIGN KEY([TcTeacherId]) REFERENCES [TcTeacher]([TrainingEmployeeId])
GO



PRINT '------ 培训班学员 ------'
CREATE TABLE  [dbo].[TcTrainee](
	[TrainingEmployeeId]		INT PRIMARY KEY NOT NULL,
	[TcResultTypeId]			INT NOT NULL,										--培训结果类型
)
ALTER TABLE [TcTrainee] WITH CHECK ADD
	CONSTRAINT [FK_TcTrainee_TrainingEmployee] FOREIGN KEY([TrainingEmployeeId]) REFERENCES [TrainingEmployee]([Id]),
	CONSTRAINT [FK_TcTrainee_TcResultType] FOREIGN KEY([TcResultTypeId]) REFERENCES [TcResultType]([Id])		
GO

PRINT '------ 学员课程课时表 ------'
CREATE TABLE  [dbo].[TcTraineeCourse](
	[Id]						INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[TrainingClassId]			INT NOT NULL,										-- 培训班ID
	[TcTraineeId]				INT NOT NULL,										-- 学员Id
	[TcCourseId]				INT NOT NULL,										-- 课程Id
	[IsRequired]				BIT NOT NULL,										-- 是否必修
	[LessonPeriod]				INT NOT NULL,										-- 课时
)
ALTER TABLE [TcTraineeCourse] WITH CHECK ADD
	CONSTRAINT [FK_TcTraineeCourse_TrainingClass] FOREIGN KEY([TrainingClassId]) REFERENCES [TrainingClass]([TrainingWorkId]),
	CONSTRAINT [FK_TcTraineeCourse_TcTrainee] FOREIGN KEY([TcTraineeId]) REFERENCES [TcTrainee]([TrainingEmployeeId]),
	CONSTRAINT [FK_TcTraineeCourse_TcCourse] FOREIGN KEY([TcCourseId]) REFERENCES [TcCourse]([Id])
GO

PRINT '------ 学员课程违规 ------'
CREATE TABLE  [dbo].[TcTraineeMistake](
	[Id]						INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[TrainingClassId]			INT NOT NULL,										-- 培训班ID
	[TcTraineeId]				INT NOT NULL,										-- 学员Id
	[TcCourseId]				INT NOT NULL,										-- 课程Id(课程Id为0就是培训班违规,否则是课程违规)
	[MistakeDate]				DATETIME NOT NULL,									-- 违规时间
	[MistakeLevel]				INT NOT NULL,										-- 严重程度(轻微、一般、重大)	
	[Remark]					NVARCHAR(MAX)NOT NULL,								-- 备注
)
ALTER TABLE [TcTraineeMistake] WITH CHECK ADD
	CONSTRAINT [FK_TcTraineeMistake_TrainingClass] FOREIGN KEY([TrainingClassId]) REFERENCES [TrainingClass]([TrainingWorkId]),
	CONSTRAINT [FK_TcTraineeMistake_TcTrainee] FOREIGN KEY([TcTraineeId]) REFERENCES [TcTrainee]([TrainingEmployeeId])
GO

COMMIT TRANSACTION
