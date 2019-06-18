

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('Ballot') AND name='BallotItemMaxVoteTimes')
BEGIN
	ALTER TABLE Ballot ADD BallotItemMaxVoteTimes INT NOT NULL DEFAULT 0;		-- 单个投票项最多投票次数
	PRINT '添加Ballot表内的BallotItemMaxVoteTimes成功';
END
