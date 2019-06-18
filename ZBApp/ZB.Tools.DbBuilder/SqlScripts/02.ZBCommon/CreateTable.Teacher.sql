
USE [$(DatabaseName)]
GO
BEGIN TRANSACTION

PRINT '------ 培训师 ------'
CREATE TABLE  [dbo].[Teacher](	
	[EmployeeId]				INT PRIMARY KEY NOT NULL,							--人员Id
	[TeacherLevelId]			INT NOT NULL,										--培训师级别
	[IsOutSideTeacher]			Bit NOT NULL,										--是否是外训师
)
ALTER TABLE [Teacher] WITH CHECK ADD
	CONSTRAINT [FK_Teacher_Employee] FOREIGN KEY([EmployeeId]) REFERENCES [Employee]([Id]),
	CONSTRAINT [FK_Teacher_TeacherLevel] FOREIGN KEY([TeacherLevelId]) REFERENCES [TeacherLevel]([Id])	
GO

PRINT '------ 培训师授课专长 ------'
CREATE TABLE  [dbo].[TeacherExpertArea](
	[Id]							INT IDENTITY(1,1) PRIMARY KEY,
	[EmployeeId]					INT NOT NULL,										--培训师Id
	[ObjectName]					NVARCHAR(50) NOT NULL,								--授课专长
	[TrainingContentTypeId]			INT NOT NULL,										--培训内容类型Id
)
ALTER TABLE [TeacherExpertArea] WITH CHECK ADD
	CONSTRAINT [FK_TeacherExpertArea_Teacher] FOREIGN KEY([EmployeeId]) REFERENCES [Teacher]([EmployeeId])
GO



PRINT '---------培训师授课记录------------'

CREATE TABLE [dbo].[TeacherGiveRecord](
	[Id]				INT IDENTITY(1,1) PRIMARY KEY,
	[EmployeeId]		INT NOT NULL,												--培训师ID
	[GiveInfo]			NVARCHAR(500) NULL,											--授课信息
	[StartDate]			DATETIME NOT NULL,											--开始时间
	[EndDate]			DATETIME,													--结束时间
	[CiveHour]			DECIMAL(18,1) NOT NULL,										--授课课时
)

ALTER TABLE [TeacherGiveRecord] WITH CHECK ADD
	CONSTRAINT [FK_TeacherGiveRecord_Teacher] FOREIGN KEY([EmployeeId]) REFERENCES [Teacher]([EmployeeId])
GO


COMMIT TRANSACTION