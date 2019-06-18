

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WebExamineeEmployeeGroup]') AND type in (N'U'))
BEGIN
PRINT '------ 考生人员分组表 ------'
CREATE TABLE  [dbo].[WebExamineeEmployeeGroup](
	[Id]						INT IDENTITY(1,1) PRIMARY KEY,
	[WebExamId]					INT NOT NULL,										-- 网络考试ID
	[WebExamineeId]				INT NOT NULL,										-- 考生Id	
	[EmployeeGroupId]			INT NOT NULL,										-- 人员分组Id	
	[EmployeeGroupFullPath]		NVARCHAR(260) NOT NULL,								-- 人员分组全路径
	[EmployeeGroupDepth]		INT NOT NULL DEFAULT 0,								--深度
)
ALTER TABLE [WebExamineeEmployeeGroup] WITH CHECK ADD
	CONSTRAINT [FK_WebExamineeEmployeeGroup_WebExam] FOREIGN KEY([WebExamId]) REFERENCES [WebExam] ([Id]),
	CONSTRAINT [FK_WebExamineeEmployeeGroup_WebExaminee] FOREIGN KEY([WebExamineeId]) REFERENCES [WebExaminee]([Id])

CREATE UNIQUE NONCLUSTERED INDEX [IDX_WebExamineeEmployeeGroup_WebExamineeId_EmployeeGroupId] ON [dbo].[WebExamineeEmployeeGroup] 
(
	[WebExamineeId] ASC,
	[EmployeeGroupId] ASC
)
END
