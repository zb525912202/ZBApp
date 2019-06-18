PRINT '�޸�Question���FullPath';
--����id,parentid�Ĺ�ϵ�޸����нڵ��fullpath
WITH Temp(Id,DeptId,ObjectName,FullPath) AS
(
	SELECT Id, DeptId, ObjectName, CONVERT(NVARCHAR(500),ObjectName)
	FROM QFolder F1 WHERE F1.ParentId = 0
	UNION ALL
	SELECT F2.Id, Temp.DeptId, F2.ObjectName, CONVERT(NVARCHAR(500),Temp.FullPath + '/' + F2.ObjectName) FROM QFolder F2
	JOIN Temp ON F2.ParentId = Temp.Id
)
UPDATE QFolder SET FullPath = Temp.FullPath,DeptId = Temp.DeptId
FROM Temp
WHERE QFolder.Id = Temp.Id