USE [$(DatabaseName)]
GO
BEGIN TRANSACTION


PRINT '------培训项目规则------'
CREATE TABLE [dbo].[TrainingOnWorkCreditsRule](
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,
	[CreditRuleType]		INT NOT NULL,							--规则类型
	[RuleKey]				INT NOT NULL,							--规则ID
	[RuleValue]				DECIMAL(18,1),							--系数
)

COMMIT TRANSACTION