
IF NOT EXISTS(SELECT * FROM Dept WHERE Id = -10000000)
BEGIN	
	INSERT INTO Dept([Id],[ObjectName],[ParentId],[FullPath],[SortIndex],[Depth],[DeptType],[DeptNO]) VALUES (-10000000,'�ⲿ',0,'�ⲿ',0,1,0,'')
	PRINT '��ӡ�Dept�����ڵ��ⲿ���Ÿ��ڵ�ɹ�';
END
GO
