

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TeacherLevel]') AND type in (N'U'))
BEGIN
PRINT '------ 培训师级别表 ------'
CREATE TABLE  [dbo].[TeacherLevel](
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,
	[ObjectName]			NVARCHAR(50) NOT NULL,									-- 培训师级别表
	[SortIndex]				INT NOT NULL DEFAULT 0,	
)
PRINT '------ 向培训师级别表插入数据 ------'
insert into [TeacherLevel] ([ObjectName],[SortIndex]) VALUES('初级',1)
insert into [TeacherLevel] ([ObjectName],[SortIndex]) VALUES('中级',2)
insert into [TeacherLevel] ([ObjectName],[SortIndex]) VALUES('高级',3)
END
GO

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Teacher]') AND type in (N'U'))
BEGIN
PRINT '------ 培训师 ------'
CREATE TABLE  [dbo].[Teacher](	
	[EmployeeId]				INT PRIMARY KEY NOT NULL,							--人员Id
	[TeacherLevelId]			INT NOT NULL,										--培训师级别
)
ALTER TABLE [Teacher] WITH CHECK ADD
	CONSTRAINT [FK_Teacher_Employee] FOREIGN KEY([EmployeeId]) REFERENCES [Employee]([Id]),
	CONSTRAINT [FK_Teacher_TeacherLevel] FOREIGN KEY([TeacherLevelId]) REFERENCES [TeacherLevel]([Id])	
END
GO

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TeacherExpertArea]') AND type in (N'U'))
BEGIN
PRINT '------ 培训师授课专长 ------'
CREATE TABLE  [dbo].[TeacherExpertArea](
	[Id]							INT IDENTITY(1,1) PRIMARY KEY,
	[EmployeeId]					INT NOT NULL,										--培训师Id
	[ObjectName]					NVARCHAR(50) NOT NULL,								--授课专长
	[TrainingContentTypeId]			INT NOT NULL,										--培训内容类型Id
)
ALTER TABLE [TeacherExpertArea] WITH CHECK ADD
	CONSTRAINT [FK_TeacherExpertArea_Teacher] FOREIGN KEY([EmployeeId]) REFERENCES [Teacher]([EmployeeId])
END
GO

