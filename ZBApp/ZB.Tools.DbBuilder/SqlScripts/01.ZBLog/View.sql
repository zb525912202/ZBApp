print '--------------------查询日志视图------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SponsorFunctionLogView]'))
DROP VIEW [SponsorFunctionLogView]
GO
CREATE VIEW [SponsorFunctionLogView]
AS
			SELECT  SponsorLog.Id, 
					SponsorLog.SponsorId, 
					SponsorLog.ComputerName, 
					SponsorLog.UserName, 
					SponsorLog.DepartmentName, 
					SponsorLog.IpAddress, 
					SponsorLog.StartTime, 
					SponsorLog.StopTime, 
					SponsorLog.Duration, 
					SponsorLog.RequestUrl, 
					FunctionLog.Id AS FunctionId, 
					FunctionLog.LogLevel, 
					FunctionLog.LogName, 
					FunctionLog.FileName, 
					FunctionLog.LineNumber, 
					FunctionLog.ModuleName, 
					FunctionLog.FunctionName, 
					FunctionLog.Exception, 
					FunctionLog.StartTime AS FunctionStartTime, 
					FunctionLog.StopTime AS FunctionStopTime, 
					FunctionLog.Duration AS FunctionDuration, 
					FunctionLog.ExecuteContext
			FROM    SponsorLog 
					INNER JOIN FunctionLog ON SponsorLog.SponsorId = FunctionLog.SponsorId
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SponsorOperationLogView]'))
DROP VIEW [SponsorOperationLogView]
GO
CREATE VIEW [SponsorOperationLogView]
AS
			SELECT  SponsorLog.Id, 
					SponsorLog.SponsorId, 
					SponsorLog.ComputerName, 
					SponsorLog.UserName, 
					SponsorLog.DepartmentName, 
					SponsorLog.IpAddress, 
					SponsorLog.StartTime, 
					SponsorLog.StopTime, 
					SponsorLog.Duration, 
					SponsorLog.RequestUrl, 
					OperationLog.Id AS OperationId, 
					OperationLog.LogLevel, 
					OperationLog.LogName, 
					OperationLog.OperationType, 
					OperationLog.OperationModule, 
					OperationLog.OperationTarget, 
					OperationLog.Exception, 
					OperationLog.StartTime AS OperationStartTime, 
					OperationLog.StopTime AS OperationStopTime, 
					OperationLog.Duration AS OperationDuration
			FROM    SponsorLog 
					INNER JOIN OperationLog ON SponsorLog.SponsorId = OperationLog.SponsorId
GO