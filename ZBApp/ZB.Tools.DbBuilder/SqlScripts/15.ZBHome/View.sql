USE [$(DatabaseName)]
GO

print '--------------------查询客户列表视图------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[SQ_CustomerListView]'))
DROP VIEW [dbo].[SQ_CustomerListView]
GO
CREATE VIEW [dbo].[SQ_CustomerListView]
AS
SELECT				Customer.Id,																--Id
					Customer.ObjectName,														--单位名称
					CustomerKey1,																--客户编号
					CustomerKey2,																--客户编号
					Contractor,																	--联系人
					Tel,																		--联系方式
					Province.ObjectName AS ProvinceName,										--省域
					Area.ObjectName AS AreaName, 												--地区
					CustomerFolder.FullPath,													--分类
					CustomerFolder.FullPath + '/' AS FullPath_Search							--查询子目录用
					FROM CustomerFolder
					INNER JOIN Customer ON CustomerFolder.Id = Customer.FolderId
					INNER JOIN Province ON Customer.ProvinceId = Province.Id
					INNER JOIN Area ON Customer.AreaId = Area.Id
GO