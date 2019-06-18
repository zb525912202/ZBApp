
PRINT '------ 题型 ------'
CREATE TABLE [dbo].[ResourceModule](
	[Id]							INT PRIMARY KEY  NOT NULL,					-- 唯一标识
	[ObjectName]					NVARCHAR(25) UNIQUE NOT NULL,						-- 标签名称
)
GO


CREATE TABLE [dbo].[QuestionInModule](
	[Id]				INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[QuestionId]		INT NOT NULL,										--试题ID
	[ModuleId]			INT NOT NULL										--标签ID
)
GO

ALTER TABLE [QuestionInModule] WITH CHECK ADD
	CONSTRAINT [FK_QuestionId_Question] FOREIGN KEY([QuestionId]) REFERENCES [Question]([Id]),
	CONSTRAINT [FK_QuestionId_Module] FOREIGN KEY([ModuleId]) REFERENCES [ResourceModule]([Id])
GO



