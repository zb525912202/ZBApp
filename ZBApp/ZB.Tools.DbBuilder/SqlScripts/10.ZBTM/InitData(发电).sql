PRINT '------ ����ѵ���ݱ�������� ������ѵ���ݷ���   ------'
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(0,'',0,'',3,1)

insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(1,'������Ա��ѵ',0,'������Ա��ѵ',0,1)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(2,'һ����Ա��ѵ',0,'һ����Ա��ѵ',0,2)

insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(1001,'����������ѵ',1,'������Ա��ѵ/����������ѵ',0,1)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(1002,'����֪ʶ��ѵ',1,'������Ա��ѵ/����֪ʶ��ѵ',0,2)

insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(2001,'רҵ֪ʶ��ѵ',2,'һ����Ա��ѵ/רҵ֪ʶ��ѵ',0,1)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(2002,'����������ѵ',2,'һ����Ա��ѵ/����������ѵ',0,2)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(2003,'̬����ʶ��ѵ',2,'һ����Ա��ѵ/̬����ʶ��ѵ',0,3)

GO


PRINT '------ ����ѵ������������ ------'
SET IDENTITY_INSERT TrainingLevel ON
insert into [TrainingLevel] ([Id],[ObjectName],[IsDefault],[LockStatus],[SortIndex]) VALUES(0,'',1,3,0)
insert into [TrainingLevel] ([Id],[ObjectName],[IsDefault],[LockStatus],[SortIndex]) VALUES(1,'���Ҽ�',0,0,1)
insert into [TrainingLevel] ([Id],[ObjectName],[IsDefault],[LockStatus],[SortIndex]) VALUES(2,'���Ź�˾��',0,0,2)
insert into [TrainingLevel] ([Id],[ObjectName],[IsDefault],[LockStatus],[SortIndex]) VALUES(3,'ʡ��˾��',0,0,3)
insert into [TrainingLevel] ([Id],[ObjectName],[IsDefault],[LockStatus],[SortIndex]) VALUES(4,'���й�˾��',0,0,4)
insert into [TrainingLevel] ([Id],[ObjectName],[IsDefault],[LockStatus],[SortIndex]) VALUES(5,'������',0,0,5)
insert into [TrainingLevel] ([Id],[ObjectName],[IsDefault],[LockStatus],[SortIndex]) VALUES(6,'���鼶',0,0,6)
SET IDENTITY_INSERT TrainingLevel OFF
GO