PRINT '------ ����ѵ��Ŀ��ʽ��������� ------'
insert into [TrainingMode] ([ObjectName],[SortIndex]) VALUES('',0)
insert into [TrainingMode] ([ObjectName],[SortIndex]) VALUES('�ڲ�',1)
insert into [TrainingMode] ([ObjectName],[SortIndex]) VALUES('�ⲿ',2)
GO

--PRINT '------ ����ѵ��Ŀ��ʽ��������� ------'
--insert into [TrainingPlanType] ([ObjectName],[SortIndex]) VALUES('��ȼƻ�',1)
--insert into [TrainingPlanType] ([ObjectName],[SortIndex]) VALUES('����ȼƻ�',2)
--insert into [TrainingPlanType] ([ObjectName],[SortIndex]) VALUES('���ȼƻ�',3)
--insert into [TrainingPlanType] ([ObjectName],[SortIndex]) VALUES('�¶ȼƻ�',4)
--insert into [TrainingPlanType] ([ObjectName],[SortIndex]) VALUES('��ʱ�ƻ�',5)
--GO

PRINT '------ ����ѵ�������ͱ�������� ------'
insert into [TrainingWorkType] ([Id],[ObjectName],[LockStatus],[SortIndex]) VALUES(-1,'��ѵ��',3,1)
insert into [TrainingWorkType] ([Id],[ObjectName],[LockStatus],[SortIndex]) VALUES(-2,'����',3,2)
insert into [TrainingWorkType] ([Id],[ObjectName],[LockStatus],[SortIndex]) VALUES(-3,'ѧ��',3,3)
insert into [TrainingWorkType] ([Id],[ObjectName],[LockStatus],[SortIndex]) VALUES(-4,'��������ѧϰ',3,4)

GO

PRINT '------ ����ѵ�����Ͳ������� ------'
insert into [TcType] ([Id],[ObjectName],[ParentId],[FullPath],[SortIndex]) VALUES(1,'��λ��Ӧ����ѵ',0,'��λ��Ӧ����ѵ',1)
insert into [TcType] ([Id],[ObjectName],[ParentId],[FullPath],[SortIndex]) VALUES(2,'������ѵ',0,'������ѵ',2)

insert into [TcType] ([Id],[ObjectName],[ParentId],[FullPath],[SortIndex]) VALUES(1001,'��ǰ��ѵ(�ʸ���ѵ)',1,'��λ��Ӧ����ѵ/��ǰ��ѵ(�ʸ���ѵ)',1)
insert into [TcType] ([Id],[ObjectName],[ParentId],[FullPath],[SortIndex]) VALUES(1002,'��λ��ѵ',1,'��λ��Ӧ����ѵ/��λ��ѵ',2)
insert into [TcType] ([Id],[ObjectName],[ParentId],[FullPath],[SortIndex]) VALUES(1003,'���ܵȼ���ѵ',1,'��λ��Ӧ����ѵ/���ܵȼ���ѵ',3)
insert into [TcType] ([Id],[ObjectName],[ParentId],[FullPath],[SortIndex]) VALUES(1004,'רҵ������Ա��������',1,'��λ��Ӧ����ѵ/רҵ������Ա��������',4)
insert into [TcType] ([Id],[ObjectName],[ParentId],[FullPath],[SortIndex]) VALUES(1005,'�����ѵ',1,'��λ��Ӧ����ѵ/�����ѵ',5)

insert into [TcType] ([Id],[ObjectName],[ParentId],[FullPath],[SortIndex]) VALUES(2001,'���ʺ�����ѵ',2,'������ѵ/���ʺ�����ѵ',1)
GO

PRINT '------ ��γ����Ͳ������� ------'
insert into [TcCourseType] ([Id],[ObjectName],[ParentId],[FullPath],[SortIndex]) VALUES(1,'��λ��Ӧ�Կγ�',0,'��λ��Ӧ�Կγ�',1)
insert into [TcCourseType] ([Id],[ObjectName],[ParentId],[FullPath],[SortIndex]) VALUES(2,'רҵ�����γ�',0,'רҵ�����γ�',2)

insert into [TcCourseType] ([Id],[ObjectName],[ParentId],[FullPath],[SortIndex]) VALUES(1001,'��λ���޿γ�',1,'��λ��Ӧ�Կγ�/��λ���޿γ�',1)
insert into [TcCourseType] ([Id],[ObjectName],[ParentId],[FullPath],[SortIndex]) VALUES(1002,'��λ���޿γ�',1,'��λ��Ӧ�Կγ�/��λ���޿γ�',2)
insert into [TcCourseType] ([Id],[ObjectName],[ParentId],[FullPath],[SortIndex]) VALUES(1003,'��λѡ�޿γ�',1,'��λ��Ӧ�Կγ�/��λѡ�޿γ�',3)

insert into [TcCourseType] ([Id],[ObjectName],[ParentId],[FullPath],[SortIndex]) VALUES(2001,'רҵ���޿γ�',2,'רҵ�����γ�/רҵ���޿γ�',1)
insert into [TcCourseType] ([Id],[ObjectName],[ParentId],[FullPath],[SortIndex]) VALUES(2002,'רҵ���޿γ�',2,'רҵ�����γ�/רҵ���޿γ�',2)
insert into [TcCourseType] ([Id],[ObjectName],[ParentId],[FullPath],[SortIndex]) VALUES(2003,'רҵѡ�޿γ�',2,'רҵ�����γ�/רҵѡ�޿γ�',3)
GO

PRINT '------ ����ѵ�������ͱ�������� ------'
SET IDENTITY_INSERT TcResultType ON
insert into [TcResultType] ([Id],[ObjectName],[LockStatus],[SortIndex]) VALUES(0,'',3,0)

insert into [TcResultType] ([Id],[ObjectName],[LockStatus],[SortIndex]) VALUES(1,'��ҵ',0,1)
insert into [TcResultType] ([Id],[ObjectName],[LockStatus],[SortIndex]) VALUES(2,'δ��ҵ',0,2)
SET IDENTITY_INSERT TcResultType OFF
GO

PRINT '------ ��������ͱ�������� ------'
insert into [TrainingBillType] ([ObjectName],[SortIndex]) VALUES('ѧ��',1)
insert into [TrainingBillType] ([ObjectName],[SortIndex]) VALUES('ִ֤��',2)
insert into [TrainingBillType] ([ObjectName],[SortIndex]) VALUES('�������',3)
insert into [TrainingBillType] ([ObjectName],[SortIndex]) VALUES('�̲ķ�',4)
insert into [TrainingBillType] ([ObjectName],[SortIndex]) VALUES('��ͨ��',5)
insert into [TrainingBillType] ([ObjectName],[SortIndex]) VALUES('ʳ�޷�',6)
insert into [TrainingBillType] ([ObjectName],[SortIndex]) VALUES('�ڿη�',7)
insert into [TrainingBillType] ([ObjectName],[SortIndex]) VALUES('�������޷�',8)
insert into [TrainingBillType] ([ObjectName],[SortIndex]) VALUES('��ѵʦƸ��',9)
insert into [TrainingBillType] ([ObjectName],[SortIndex]) VALUES('����',10)
GO

PRINT '------ �������Ͳ������� ------'
insert into [TeType] ([Id],[ObjectName],[ParentId],[FullPath],[SortIndex]) VALUES(1,'����',0,'����',1)
insert into [TeType] ([Id],[ObjectName],[ParentId],[FullPath],[SortIndex]) VALUES(2,'����',0,'����',2)

insert into [TeType] ([Id],[ObjectName],[ParentId],[FullPath],[SortIndex]) VALUES(1001,'��ͨ����',1,'����/��ͨ����',1)
insert into [TeType] ([Id],[ObjectName],[ParentId],[FullPath],[SortIndex]) VALUES(1002,'���ܼ�������',1,'����/���ܼ�������',2)
insert into [TeType] ([Id],[ObjectName],[ParentId],[FullPath],[SortIndex]) VALUES(1003,'�鿼',1,'����/�鿼',3)
insert into [TeType] ([Id],[ObjectName],[ParentId],[FullPath],[SortIndex]) VALUES(1004,'����',1,'����/����',4)

insert into [TeType] ([Id],[ObjectName],[ParentId],[FullPath],[SortIndex]) VALUES(2001,'��������',2,'����/��������',1)
insert into [TeType] ([Id],[ObjectName],[ParentId],[FullPath],[SortIndex]) VALUES(2002,'���ܾ���',2,'����/���ܾ���',2)
GO

PRINT '------ ���Խ����������� ------'
SET IDENTITY_INSERT TeResultType ON
insert into [TeResultType] ([Id],[ObjectName],[LockStatus],[SortIndex]) VALUES(0,'',3,1)

insert into [TeResultType] ([Id],[ObjectName],[LockStatus],[SortIndex]) VALUES(1,'��',0,1)
insert into [TeResultType] ([Id],[ObjectName],[LockStatus],[SortIndex]) VALUES(2,'��',0,2)
insert into [TeResultType] ([Id],[ObjectName],[LockStatus],[SortIndex]) VALUES(3,'����',0,3)
insert into [TeResultType] ([Id],[ObjectName],[LockStatus],[SortIndex]) VALUES(4,'������',0,4)
SET IDENTITY_INSERT TeResultType OFF
GO

PRINT '------ ���������� ------'
insert into [TrainingKind] ([ObjectName],[SortIndex]) VALUES('�ڸ�ѧϰ',1)
insert into [TrainingKind] ([ObjectName],[SortIndex]) VALUES('�Ѳ�����ѧϰ',2)
insert into [TrainingKind] ([ObjectName],[SortIndex]) VALUES('����ѧϰ',3)
insert into [TrainingKind] ([ObjectName],[SortIndex]) VALUES('ѧ�ֽ���',4)
GO

--PRINT '------ ��ѧ��������ͱ�������� ------'
--SET IDENTITY_INSERT EduResultType ON
--insert into [EduResultType] ([Id],[ObjectName],[LockStatus],[SortIndex]) VALUES(0,'',3,0)
--insert into [EduResultType] ([Id],[ObjectName],[LockStatus],[SortIndex]) VALUES(1,'��ҵ',0,1)
--insert into [EduResultType] ([Id],[ObjectName],[LockStatus],[SortIndex]) VALUES(2,'��ҵ',0,2)
--insert into [EduResultType] ([Id],[ObjectName],[LockStatus],[SortIndex]) VALUES(3,'��ҵ',0,3)
--SET IDENTITY_INSERT EduResultType OFF
--GO