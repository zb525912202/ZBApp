PRINT'--É¾³ýWebPaperPackageQuestionÍâ¼ü'
DECLARE c1 CURSOR LOCAL FOR
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE WHERE TABLE_NAME IN (SELECT Name FROM sysobjects WHERE Name LIKE 'WebPaperPackageQuestion_%')
AND CONSTRAINT_NAME='FK_' + TABLE_NAME + '_WebPaperPackage'

OPEN c1
DECLARE @tablename1 nvarchar(1000);
DECLARE @dropfksql nvarchar(1000);

FETCH NEXT FROM c1 INTO @tablename1;
WHILE @@FETCH_STATUS=0
BEGIN
SET @dropfksql = 'ALTER TABLE ' + @tablename1 + ' DROP CONSTRAINT ' + 'FK_' + @tablename1 + '_WebPaperPackage;';
execute (@dropfksql);
FETCH NEXT FROM c1 INTO @tablename1;
END

CLOSE c1
DEALLOCATE c1