USE [$(DatabaseName)]
GO
BEGIN TRANSACTION
PRINT '------ 培训班,如果是网络培训班时，同时创建[NetClass] ------'

CREATE TABLE [dbo].[TrainingWorkClass](
	[WorkId]			INT PRIMARY KEY NOT NULL,
	[ClassHour]			DECIMAL(18,1) NOT NULL DEFAULT 0,			--课时
)
GO
ALTER TABLE [TrainingWorkClass] WITH CHECK ADD
	CONSTRAINT [FK_TrainingWorkClass_TrainingOnWork] FOREIGN KEY([WorkId]) REFERENCES [TrainingOnWork]([Id])
GO

PRINT '------ 培训班学员违规记录表 ------'
CREATE TABLE [dbo].[ClassEmployeeViolation](
	[Id]					INT PRIMARY KEY,			--Id
	[WorkId]				INT NOT NULL,				--培训事务ID
	[TWEmployeeId]			INT NOT NULL,				--培训事务人员ID
	[ViolationDate]			DATETIME NOT NULL,			--违规时间
	[ViolationLevel]		INT NOT NULL,				--严重程度(轻微、一般、重大)
	[Remark]				NVARCHAR(MAX) NOT NULL,		--备注			
)

ALTER TABLE [ClassEmployeeViolation] WITH CHECK ADD
	CONSTRAINT [FK_ClassEmployeeViolation_TrainingOnWorkEmployee] FOREIGN KEY([TWEmployeeId]) REFERENCES [TrainingOnWorkEmployee]([Id])
GO

ALTER TABLE [ClassEmployeeViolation] WITH CHECK ADD
	CONSTRAINT [FK_ClassEmployeeViolation_TrainingOnWork] FOREIGN KEY([WorkId]) REFERENCES [TrainingOnWork]([Id])
GO

PRINT '------ 培训班培训师 ------'
CREATE TABLE [dbo].[TrainingWorkClassTeacher](
	[Id]					INT PRIMARY KEY NOT NULL,					
	[WorkId]				INT NOT NULL,							--培训事务ID
	[EmployeeId]			INT NOT NULL,							--人员ID
	[EmployeeNO]			NVARCHAR(50) NOT NULL,					--人员编号
	[EmployeeName]			NVARCHAR(50) NOT NULL,					--人员姓名
	[Age]					INT,									--年龄
	[Sex]					INT,									--性别
	[DeptId]				INT NOT NULL,							--部门ID
	[DeptName]				NVARCHAR(255) NOT NULL,					--部门名称
	[PostId]				INT NOT NULL DEFAULT 0,					--岗位ID
	[PostName]				NVARCHAR(50),							--岗位名称
	[ClassHour]				DECIMAL(18,1) NOT NULL,					--课时
)

ALTER TABLE [TrainingWorkClassTeacher] WITH CHECK ADD
	CONSTRAINT [FK_TrainingWorkClassTeacher_TrainingOnWork] FOREIGN KEY([WorkId]) REFERENCES [TrainingOnWork]([Id])
GO

PRINT '------ 培训班培训师违规记录表 ------'
CREATE TABLE [dbo].[ClassTeacherViolation](
	[Id]					INT PRIMARY KEY,			--Id
	[WorkId]				INT NOT NULL,				--培训事务ID
	[TeacherId]				INT NOT NULL,				--培训事务人员ID
	[ViolationDate]			DATETIME NOT NULL,			--违规时间
	[ViolationLevel]		INT NOT NULL,				--严重程度(轻微、一般、重大)
	[Remark]				NVARCHAR(MAX) NOT NULL,		--备注			
)

ALTER TABLE [ClassTeacherViolation] WITH CHECK ADD
	CONSTRAINT [FK_ClassTeacherViolation_TrainingWorkClassTeacher] FOREIGN KEY([TeacherId]) REFERENCES [TrainingWorkClassTeacher]([Id])
GO

ALTER TABLE [ClassTeacherViolation] WITH CHECK ADD
	CONSTRAINT [FK_ClassTeacherViolation_TrainingOnWork] FOREIGN KEY([WorkId]) REFERENCES [TrainingOnWork]([Id])
GO



COMMIT TRANSACTION