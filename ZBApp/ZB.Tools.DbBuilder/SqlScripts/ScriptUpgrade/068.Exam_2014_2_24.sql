--PRINT'--WebPaperPackageQuestion添加字段GraderId'
--DECLARE c1 CURSOR LOCAL FOR
--SELECT TABLE_NAME FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE WHERE TABLE_NAME IN (SELECT Name FROM sysobjects WHERE Name LIKE 'WebPaperPackageQuestion_%')

--OPEN c1
--DECLARE @tablename1 nvarchar(1000);
--DECLARE @addcloumnsql nvarchar(1000);

--FETCH NEXT FROM c1 INTO @tablename1;
--WHILE @@FETCH_STATUS=0
--BEGIN
--SET @addcloumnsql ='IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('''+@tablename1+''') AND name=''GraderId'') BEGIN ' + 'ALTER TABLE ' + @tablename1 + ' ADD GraderId INT NOT NULL DEFAULT 0; END';
--execute (@addcloumnsql);
--FETCH NEXT FROM c1 INTO @tablename1;
--END

--CLOSE c1
--DEALLOCATE c1

--PRINT'--WebPaperPackageQuestion添加字段GraderName'
--DECLARE c2 CURSOR LOCAL FOR
--SELECT TABLE_NAME FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE WHERE TABLE_NAME IN (SELECT Name FROM sysobjects WHERE Name LIKE 'WebPaperPackageQuestion_%')

--OPEN c2
--DECLARE @tablename2 nvarchar(1000);
--DECLARE @addcloumnsql2 nvarchar(1000);

--FETCH NEXT FROM c2 INTO @tablename2;
--WHILE @@FETCH_STATUS=0
--BEGIN
--SET @addcloumnsql2 ='IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('''+@tablename2+''') AND name=''GraderName'') BEGIN ' + 'ALTER TABLE ' + @tablename2 + ' ADD GraderName NVARCHAR(50) NOT NULL DEFAULT ''''; END';
--execute (@addcloumnsql2);
--FETCH NEXT FROM c2 INTO @tablename2;
--END

--CLOSE c2
--DEALLOCATE c2