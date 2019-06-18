

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TeacherLevel]') AND type in (N'U'))
BEGIN
PRINT '------ ��ѵʦ����� ------'
CREATE TABLE  [dbo].[TeacherLevel](
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,
	[ObjectName]			NVARCHAR(50) NOT NULL,									-- ��ѵʦ�����
	[SortIndex]				INT NOT NULL DEFAULT 0,	
)
PRINT '------ ����ѵʦ������������ ------'
insert into [TeacherLevel] ([ObjectName],[SortIndex]) VALUES('����',1)
insert into [TeacherLevel] ([ObjectName],[SortIndex]) VALUES('�м�',2)
insert into [TeacherLevel] ([ObjectName],[SortIndex]) VALUES('�߼�',3)
END
GO

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Teacher]') AND type in (N'U'))
BEGIN
PRINT '------ ��ѵʦ ------'
CREATE TABLE  [dbo].[Teacher](	
	[EmployeeId]				INT PRIMARY KEY NOT NULL,							--��ԱId
	[TeacherLevelId]			INT NOT NULL,										--��ѵʦ����
)
ALTER TABLE [Teacher] WITH CHECK ADD
	CONSTRAINT [FK_Teacher_Employee] FOREIGN KEY([EmployeeId]) REFERENCES [Employee]([Id]),
	CONSTRAINT [FK_Teacher_TeacherLevel] FOREIGN KEY([TeacherLevelId]) REFERENCES [TeacherLevel]([Id])	
END
GO

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TeacherExpertArea]') AND type in (N'U'))
BEGIN
PRINT '------ ��ѵʦ�ڿ�ר�� ------'
CREATE TABLE  [dbo].[TeacherExpertArea](
	[Id]							INT IDENTITY(1,1) PRIMARY KEY,
	[EmployeeId]					INT NOT NULL,										--��ѵʦId
	[ObjectName]					NVARCHAR(50) NOT NULL,								--�ڿ�ר��
	[TrainingContentTypeId]			INT NOT NULL,										--��ѵ��������Id
)
ALTER TABLE [TeacherExpertArea] WITH CHECK ADD
	CONSTRAINT [FK_TeacherExpertArea_Teacher] FOREIGN KEY([EmployeeId]) REFERENCES [Teacher]([EmployeeId])
END
GO

