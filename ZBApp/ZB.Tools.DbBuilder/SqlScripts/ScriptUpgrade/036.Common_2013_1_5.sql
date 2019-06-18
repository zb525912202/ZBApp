

IF EXISTS(SELECT * FROM syscolumns WHERE id = object_id('Dept') AND name='IsOutside')
BEGIN		
	declare @name varchar(50) --列对应约束名 
	select @name =b.name from sysobjects b join syscolumns a on b.id = a.cdefault 
	where a.id = object_id('Dept')  --表名称 
	and a.name ='IsOutside'  --列名称
	exec('alter table Dept drop constraint ' + @name) 
	exec('alter table Dept drop column IsOutside')
	PRINT '删除‘Dept’内的‘IsOutside’成功';
END
GO
