

PRINT'--设置仅支持开卷学习的试题的闭卷学习积分为0'
UPDATE QuestionType SET LearningSecond=0,LearningSecond_Default=0 WHERE OnlySupportOpenMode='TRUE'

GO