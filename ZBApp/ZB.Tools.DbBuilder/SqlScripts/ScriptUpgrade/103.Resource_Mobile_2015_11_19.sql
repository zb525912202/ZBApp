IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QuestionHtml]') AND type in (N'U'))
BEGIN

PRINT '------试题Html,为支持移动端使用------'
CREATE TABLE [dbo].[QuestionHtml](
	[Id]					INT PRIMARY KEY,				--试题Id
	[ContentHtml]			NVARCHAR(MAX) NOT NULL,			--内容Html
	[AnswerHtml]			NVARCHAR(MAX) NOT NULL,			--答案Html
	[AnalysisHtml]			NVARCHAR(MAX),					--解析Html
	[AnswerText]			NVARCHAR(MAX) NOT NULL,			--试题文本
	[ContentLength]			INT NOT NULL,					--内容字节数
	[AnswerLength]			INT NOT NULL,					--答案字节数
	[AnalysisLength]		INT NOT NULL,					--解析字节数
	[AnswerTextLength]		INT NOT NULL,					--答案文本字节数
)

ALTER TABLE [QuestionHtml]  WITH CHECK ADD  
	CONSTRAINT [FK_QuestionHtml_Question] FOREIGN KEY([Id]) REFERENCES [Question] ([Id])

END


IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('RFile') AND name='IsSupportApp')
BEGIN
	ALTER TABLE RFile ADD IsSupportApp BIT NOT NULL DEFAULT 0;
	PRINT '添加‘RFile’的‘IsSupportApp’成功';
END
GO

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('AFile') AND name='IsSupportApp')
BEGIN
	ALTER TABLE AFile ADD IsSupportApp BIT NOT NULL DEFAULT 0;
	PRINT '添加‘AFile’的‘IsSupportApp’成功';
END
GO

PRINT '------更新所有RFile内的非视频、音频、专辑的状态以支持App学习------'
UPDATE RFile SET IsSupportApp = 1 WHERE FileType != 300 AND FileType != 400 AND FileType != 600;

PRINT '------更新所有AFile内的非视频、音频、专辑的状态以支持App学习------'
UPDATE AFile SET IsSupportApp = 1 WHERE FileType != 300 AND FileType != 400 AND FileType != 600; 


PRINT '------更新RFile内的所有专辑的状态以支持App学习，根据专辑下的AFile状态更新------'
DECLARE AFile_Cursor CURSOR LOCAL FOR
SELECT ParentId AS Id, COUNT(*) AS RCount, SUM(CAST(IsSupportApp AS INT)) AS IsSupportAppCount FROM AFile GROUP BY ParentId

OPEN AFile_Cursor
DECLARE @Id NVARCHAR(50)
DECLARE @Rcount INT
DECLARE @IsSupportAppCount INT
DECLARE @UpdateSql NVARCHAR(500);

FETCH NEXT FROM AFile_Cursor INTO @Id, @RCount, @IsSupportAppCount;
WHILE @@FETCH_STATUS=0
BEGIN
	
	IF @Rcount = @IsSupportAppCount
	BEGIN
		SET @UpdateSql = 'UPDATE RFile SET IsSupportApp = 1 WHERE Id =' + @Id;
	END
	ELSE
	BEGIN
		SET @UpdateSql = 'UPDATE RFile SET IsSupportApp = 0 WHERE Id =' + @Id;
	END
	
	EXECUTE(@UpdateSql);

FETCH NEXT FROM AFile_Cursor INTO @Id, @RCount, @IsSupportAppCount;
END

CLOSE AFile_Cursor
DEALLOCATE AFile_Cursor




