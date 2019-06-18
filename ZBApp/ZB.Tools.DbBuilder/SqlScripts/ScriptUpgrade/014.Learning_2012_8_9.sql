

PRINT'--更新月内学习相同资源次数与系数'
UPDATE [LearningRateRuleItem] SET [DefaultRate]=0.5,[Rate]=0.5 WHERE [LearningGroupRuleId]=3 AND [RuleKey]=2 AND [DefaultRate]<>0.5
UPDATE [LearningRateRuleItem] SET [DefaultRate]=0.2,[Rate]=0.2 WHERE [LearningGroupRuleId]=3 AND [RuleKey]=3 AND [DefaultRate]<>0.2


