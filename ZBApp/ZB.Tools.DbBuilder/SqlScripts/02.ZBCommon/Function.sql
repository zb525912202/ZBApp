
USE [$(DatabaseName)]
GO

BEGIN TRANSACTION
PRINT '---------INT转级别罗马数字范围------------'
GO
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[FN_RomanLevelRange]') and xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [FN_RomanLevelRange]
GO

CREATE FUNCTION [dbo].[FN_RomanLevelRange](@ProCategoryId INT)
	
	RETURNS @Table TABLE(Id INT,ObjectName NVARCHAR(50))
	AS
	BEGIN
		DECLARE @Level INT
		DECLARE @i INT 
		DECLARE @ObjectName NVARCHAR(50) 
		SET @i=0
		SELECT @Level=[Level] FROM ProfessionCategory WHERE Id=@ProCategoryId

		WHILE(@i<=@Level)
			BEGIN
				IF(@i=0)
				BEGIN
					SET @ObjectName='空层'
				END
				ELSE IF(@i=1)
				BEGIN
					SET @ObjectName='I'
				END
				ELSE IF(@i=2)
				BEGIN
					SET @ObjectName='II'
				END
				ELSE IF(@i=3)
				BEGIN
					SET @ObjectName='III'
				END
				ELSE IF(@i=4)
				BEGIN
					SET @ObjectName='IV'
				END
				ELSE IF(@i=5)
				BEGIN
					SET @ObjectName='V'
				END
					           
				INSERT INTO @Table VALUES(@i,@ObjectName)
				SET @i = @i + 1;  
			END
	RETURN
	END
GO
COMMIT TRANSACTION