
--�����±�������DEMO

--�ж����ݿ����Ƿ����ָ��������
--EXISTS ����жϴ���
--NOT EXISTS ����жϲ�����
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[����]') AND type in (N'U'))
BEGIN
	/*******************************
	����д��������ص�SQL
	*******************************/
END

--DEMO���´���һ��Person��
/*
	IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Person]') AND type in (N'U'))
	BEGIN
		CREATE TABLE [dbo].[Person]
		(
			[Id]	INT IDENTITY(1,1) PRIMARY KEY
		)
	END
*/


/****************************************************************************************************************/
--�������޸���ͼ������

--�ж����ݿ����Ƿ����ָ����ͼ�����
--�������½���ͼ�����޸���ͼ��ͳһ�߼�����Ϊ��ɾ��ָ����ͼ���󴴽�����ͼ
IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[��ͼ��]'))
	DROP VIEW [dbo].[��ͼ��]
GO
	/*******************************
	����д������ͼ��ص�SQL
	*******************************/
GO

--DEMO���´����޸�һ����ͼPersonView
/*
	IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[PersonView]'))
	BEGIN
		DROP VIEW [dbo].[PersonView]
	END
	GO

	CREATE VIEW [dbo].[PersonView]
	AS
	SELECT * FROM Person

	GO
*/

/****************************************************************************************************************/

--�������޸ı��ָ���е����SQL

--�жϱ����Ƿ����ָ����
/*
	�������ӻ��޸ĵ��в�����Ϊ�գ�����ֶ���Ҫ����Ĭ��ֵ������Ծ������ݻ����Ӱ�죬���²�������ʧ��
*/
IF EXISTS(SELECT * FROM syscolumns WHERE id = object_id('����') AND name='����')
BEGIN
	--���ڸ��ֶΣ����޸ģ�ʹ�� ALTER ���
	ALTER TABLE ���� ALTER COLUMN ���� INT NOT NULL;
	PRINT '�޸ġ��������ڵġ��������ɹ�';
END
ELSE
BEGIN
	--�����ڸ��ֶΣ�����ӣ�ʹ�� ADD ���
	ALTER TABLE ���� ADD ���� INT NOT NULL DEFAULT 0;
	PRINT '��ӡ��������ڵġ��������ɹ�';
END
GO

/*
	DEMO: ��Person������һ��Age�ֶ�
	
	IF EXISTS(SELECT * FROM syscolumns WHERE id = object_id('Person') AND name='Age')
	BEGIN
		ALTER TABLE Person ALTER COLUMN Age INT NOT NULL DEFAULT 0;
		PRINT '�޸ġ�Person���ڵġ�Age���ɹ�';
	END
	ELSE
	BEGIN
		--�����ڸ��ֶΣ�����ӣ�ʹ�� ADD ���
		ALTER TABLE Person ADD Age INT NOT NULL DEFAULT 0;
		PRINT '��ӡ�Person���ڵġ�Age���ɹ�';
	END
	GO
*/



/****************************************************************************************************************/

-- ����޸� ������������SQL

--����
--�ж�ָ����������Ƿ���ڣ�������ڣ�����ɾ�����󴴽�
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[����]') AND name = N'������')
ALTER TABLE [dbo].[����] DROP CONSTRAINT [������]
GO
--��������
ALTER TABLE [dbo].[����] ADD PRIMARY KEY CLUSTERED 
(
	[����] ASC
)WITH (PAD_INDEX  = OFF) ON [PRIMARY]
GO


--���
--�жϸ�����Ƿ���ڣ�������ڣ���ɾ�����󴴽�
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[�����]') AND parent_object_id = OBJECT_ID(N'[dbo].[����]'))
ALTER TABLE [dbo].[����] DROP CONSTRAINT [�����]
GO
--�������
ALTER TABLE [����] WITH CHECK ADD
CONSTRAINT [�����] FOREIGN KEY([����]) REFERENCES [��������]([��������])

GO




PRINT'-----ɾ��EmployeeStudyDetailStat������зǾۼ�����-----'
DECLARE indexCursor CURSOR LOCAL FOR
SELECT name FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeStudyDetailStat]') AND is_unique='FALSE'

OPEN indexCursor
DECLARE @indexName nvarchar(1000);
DECLARE @dropIndexSql nvarchar(1000);

FETCH NEXT FROM indexCursor INTO @indexName;
WHILE @@FETCH_STATUS=0
BEGIN
SET @dropIndexSql = 'DROP INDEX ' + @indexName + ' ON EmployeeStudyDetailStat';
execute (@dropIndexSql);
FETCH NEXT FROM indexCursor INTO @indexName;
END

CLOSE indexCursor
DEALLOCATE indexCursor