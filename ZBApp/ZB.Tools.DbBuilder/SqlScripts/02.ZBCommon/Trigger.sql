--USE [$(DatabaseName)]
--GO

--BEGIN TRANSACTION

--print '--------------------MasterLevel删除触发器------------------------------------'
--GO
-----------掌握程度删除自动往前递减排序索引SortIndex,以保证其连续---------
--IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[T_MasterLevel]'))
--DROP TRIGGER [T_MasterLevel]
--GO
--CREATE TRIGGER [dbo].[T_MasterLevel]
--ON [dbo].[MasteryLevel]
--AFTER DELETE
--AS
--  BEGIN
--	DECLARE @SortIndex INT
--	SELECT @SortIndex=SortIndex from deleted
--	UPDATE MasteryLevel SET SortIndex = SortIndex-1 WHERE SortIndex > @SortIndex
--  END
--GO

