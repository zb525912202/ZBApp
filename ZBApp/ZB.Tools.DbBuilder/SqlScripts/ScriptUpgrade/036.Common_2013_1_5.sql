

IF EXISTS(SELECT * FROM syscolumns WHERE id = object_id('Dept') AND name='IsOutside')
BEGIN		
	declare @name varchar(50) --�ж�ӦԼ���� 
	select @name =b.name from sysobjects b join syscolumns a on b.id = a.cdefault 
	where a.id = object_id('Dept')  --������ 
	and a.name ='IsOutside'  --������
	exec('alter table Dept drop constraint ' + @name) 
	exec('alter table Dept drop column IsOutside')
	PRINT 'ɾ����Dept���ڵġ�IsOutside���ɹ�';
END
GO
