﻿--IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('Question') AND name='IsEmptyAnswer')
--BEGIN
--	ALTER TABLE Question ADD IsEmptyAnswer BIT NOT NULL DEFAULT(0)
--	PRINT '添加Question的IsEmptyAnswer成功';
--END
--GO