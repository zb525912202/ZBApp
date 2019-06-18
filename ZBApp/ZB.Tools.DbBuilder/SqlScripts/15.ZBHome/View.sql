USE [$(DatabaseName)]
GO

print '--------------------��ѯ�ͻ��б���ͼ------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[SQ_CustomerListView]'))
DROP VIEW [dbo].[SQ_CustomerListView]
GO
CREATE VIEW [dbo].[SQ_CustomerListView]
AS
SELECT				Customer.Id,																--Id
					Customer.ObjectName,														--��λ����
					CustomerKey1,																--�ͻ����
					CustomerKey2,																--�ͻ����
					Contractor,																	--��ϵ��
					Tel,																		--��ϵ��ʽ
					Province.ObjectName AS ProvinceName,										--ʡ��
					Area.ObjectName AS AreaName, 												--����
					CustomerFolder.FullPath,													--����
					CustomerFolder.FullPath + '/' AS FullPath_Search							--��ѯ��Ŀ¼��
					FROM CustomerFolder
					INNER JOIN Customer ON CustomerFolder.Id = Customer.FolderId
					INNER JOIN Province ON Customer.ProvinceId = Province.Id
					INNER JOIN Area ON Customer.AreaId = Area.Id
GO