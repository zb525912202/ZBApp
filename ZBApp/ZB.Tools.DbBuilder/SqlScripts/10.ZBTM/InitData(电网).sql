USE [$(DatabaseName)]
GO

PRINT '------  ------'
BEGIN TRANSACTION

PRINT '------ ����ѵ���ݱ�������� ������˾��ѵ���ݷ���   ------'
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(0,'',0,'',3,1)

insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(1,'��У���ۼ���Ӫ����ѵ',0,'��У���ۼ���Ӫ����ѵ',0,1)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(2,'������Ա��ѵ',0,'������Ա��ѵ',0,2)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(3,'������Ա��ѵ',0,'������Ա��ѵ',0,3)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(4,'������Ա��ѵ',0,'������Ա��ѵ',0,4)

insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(1001,'��У��������',1,'��У���ۼ���Ӫ����ѵ/��У��������',0,1)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(1002,'��Ӫ������ѵ',1,'��У���ۼ���Ӫ����ѵ/��Ӫ������ѵ',0,2)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(1003,'������󱸸ɲ���ѵ',1,'��У���ۼ���Ӫ����ѵ/������󱸸ɲ���ѵ',0,3)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(1004,'������ѵ',1,'��У���ۼ���Ӫ����ѵ/������ѵ',0,4)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(1005,'������ѵ',1,'��У���ۼ���Ӫ����ѵ/������ѵ',0,5)

insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(2001,'�����滮��ѵ',2,'������Ա��ѵ/�����滮��ѵ',0,1)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(2002,'���������ѵ',2,'������Ա��ѵ/���������ѵ',0,2)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(2003,'���÷�����ѵ',2,'������Ա��ѵ/���÷�����ѵ',0,3)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(2004,'������Դ��ѵ',2,'������Ա��ѵ/������Դ��ѵ',0,4)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(2005,'����Ӫ����ѵ',2,'������Ա��ѵ/����Ӫ����ѵ',0,5)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(2006,'����������ѵ',2,'������Ա��ѵ/����������ѵ',0,6)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(2007,'���̽�����ѵ',2,'������Ա��ѵ/���̽�����ѵ',0,7)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(2008,'����������ѵ',2,'������Ա��ѵ/����������ѵ',0,8)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(2009,'������ѵ',2,'������Ա��ѵ/������ѵ',0,9)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(2010,'�ۺ�����ѵ',2,'������Ա��ѵ/�ۺ�����ѵ',0,10)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(2011,'������ѵ',2,'������Ա��ѵ/������ѵ',0,11)

insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(3001,'�����Ա��ѵ',3,'������Ա��ѵ/�����Ա��ѵ',0,1)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(3002,'�����Ա��ѵ',3,'������Ա��ѵ/�����Ա��ѵ',0,2)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(3003,'�����Ա��ѵ',3,'������Ա��ѵ/�����Ա��ѵ',0,3)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(3004,'�̵籣����ѵ',3,'������Ա��ѵ/�̵籣����ѵ',0,4)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(3005,'�����Զ�����ѵ',3,'������Ա��ѵ/�����Զ�����ѵ',0,5)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(3006,'����ͨѶ��ѵ',3,'������Ա��ѵ/����ͨѶ��ѵ',0,6)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(3007,'����Ӫ����ѵ',3,'������Ա��ѵ/����Ӫ����ѵ',0,7)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(3008,'����Ա��ѵ',3,'������Ա��ѵ/����Ա��ѵ',0,8)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(3009,'������ѵ',3,'������Ա��ѵ/������ѵ',0,9)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(3010,'���鳤��ѵ',3,'������Ա��ѵ/���鳤��ѵ',0,10)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(3011,'ũ�幩��������ѵ',3,'������Ա��ѵ/ũ�幩��������ѵ',0,11)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(3012,'ũ�繤��ѵ',3,'������Ա��ѵ/ũ�繤��ѵ',0,12)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(3013,'����������ѵ',3,'������Ա��ѵ/����������ѵ',0,13)

insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(4001,'�ظ�ѹ����֪ʶ��ѵ',4,'������Ա��ѵ/�ظ�ѹ����֪ʶ��ѵ',0,1)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(4002,'���������¼�����ѵ',4,'������Ա��ѵ/���������¼�����ѵ',0,2)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(4003,'���������淶����',4,'������Ա��ѵ/���������淶����',0,3)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(4004,'��Ϣ��������ѵ',4,'������Ա��ѵ/��Ϣ��������ѵ',0,4)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(4005,'����������ѵ',4,'������Ա��ѵ/����������ѵ',0,5)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(4006,'������̵籣����ѵ',4,'������Ա��ѵ/������̵籣����ѵ',0,6)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(4007,'������ѵ',4,'������Ա��ѵ/������ѵ',0,7)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(4008,'����������ѵ',4,'������Ա��ѵ/����������ѵ',0,8)

GO


PRINT '------ ����ѵ������������ ------'
SET IDENTITY_INSERT TrainingLevel ON
insert into [TrainingLevel] ([Id],[ObjectName],[IsDefault],[LockStatus],[SortIndex]) VALUES(0,'',1,3,0)
insert into [TrainingLevel] ([Id],[ObjectName],[IsDefault],[LockStatus],[SortIndex]) VALUES(1,'���Ҽ�',0,0,1)
insert into [TrainingLevel] ([Id],[ObjectName],[IsDefault],[LockStatus],[SortIndex]) VALUES(2,'������˾��',0,0,2)
insert into [TrainingLevel] ([Id],[ObjectName],[IsDefault],[LockStatus],[SortIndex]) VALUES(3,'ʡ��˾��',0,0,3)
insert into [TrainingLevel] ([Id],[ObjectName],[IsDefault],[LockStatus],[SortIndex]) VALUES(4,'���й�˾��',0,0,4)
insert into [TrainingLevel] ([Id],[ObjectName],[IsDefault],[LockStatus],[SortIndex]) VALUES(5,'������',0,0,5)
insert into [TrainingLevel] ([Id],[ObjectName],[IsDefault],[LockStatus],[SortIndex]) VALUES(6,'���鼶',0,0,6)
SET IDENTITY_INSERT TrainingLevel OFF
GO






















COMMIT TRANSACTION