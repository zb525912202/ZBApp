
IF NOT EXISTS(SELECT * FROM Dept WHERE Id = -10000000)
BEGIN	
	INSERT INTO Dept([Id],[ObjectName],[ParentId],[FullPath],[SortIndex],[Depth],[DeptType],[DeptNO]) VALUES (-10000000,'外部',0,'外部',0,1,0,'')
	PRINT '添加‘Dept’表内的外部部门根节点成功';
END
GO
