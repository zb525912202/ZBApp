

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('Ballot') AND name='BallotItemMaxVoteTimes')
BEGIN
	ALTER TABLE Ballot ADD BallotItemMaxVoteTimes INT NOT NULL DEFAULT 0;		-- ����ͶƱ�����ͶƱ����
	PRINT '���Ballot���ڵ�BallotItemMaxVoteTimes�ɹ�';
END
