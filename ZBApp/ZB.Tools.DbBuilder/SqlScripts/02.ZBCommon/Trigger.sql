--USE [$(DatabaseName)]
--GO

--BEGIN TRANSACTION

--print '--------------------MasterLevelɾ��������------------------------------------'
--GO
-----------���ճ̶�ɾ���Զ���ǰ�ݼ���������SortIndex,�Ա�֤������---------
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

