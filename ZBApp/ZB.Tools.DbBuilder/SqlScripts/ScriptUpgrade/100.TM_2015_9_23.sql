
IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('JudgeTrainee') AND name='JudgeTypeId')
BEGIN
	
	DROP TABLE [dbo].[JudgeTrainee];

	PRINT '------ 重建人员的评定项信息表 ------'
	CREATE TABLE [dbo].[JudgeTrainee]
	(
		[TrainingEmployeeId]				INT PRIMARY KEY NOT NULL,		
		[JudgeTypeId]						INT NOT NULL,									--评定项类型ID
		[JudgeTypeName]						NVARCHAR(50) NOT NULL,							--评定项类型(培训分类)
		[JudgeId]							INT NOT NULL,									--评定项ID
		[JudgeName]							NVARCHAR(50) NOT NULL,							--评定项名称（评定项）
		[TrainingCreditRuleFullPath]		NVARCHAR(50) NOT NULL,							--评定规则全路径（规则分类）	
		[DanWei]							NVARCHAR(10) NOT NULL,							--单位
		[Amounts]							DECIMAL(18,2) NOT NULL,							--数量
		[GetDate]							DATETIME NOT NULL,								--获取日期
		[RuleScore]							NVARCHAR(260) NOT NULL,							--规则学分
		[RecorderId]						INT NOT NULL,									--录入人ID
		[RecorderName]						NVARCHAR(50),									--录入人
		[Remark]							NVARCHAR(MAX),									--备注	
		[AuditStatus]						INT NOT NULL DEFAULT 0,							--审核状态	

	)
	ALTER TABLE [JudgeTrainee] WITH CHECK ADD
		CONSTRAINT [FK_JudgeTrainee_TrainingEmployee] FOREIGN KEY([TrainingEmployeeId]) REFERENCES [TrainingEmployee]([Id])	

	END
GO