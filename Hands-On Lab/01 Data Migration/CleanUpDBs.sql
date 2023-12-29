Use Master
GO
DECLARE @SQL nvarchar(1000);
Declare @Count smallint;
Set @Count=4
While @Count>0 
Begin
	Set @SQL=N'DROP DATABASE IF EXISTS TEAM'+Format(@Count,'0#')+'_TenantDataDb;'
	Execute (@SQL)
	Set @SQL=N'DROP DATABASE IF EXISTS TEAM'+Format(@Count,'0#')+'_LocalMasterDataDB;'
	Execute (@SQL)
	Set @SQL=N'DROP DATABASE IF EXISTS TEAM'+Format(@Count,'0#')+'_SharedMasterDataDB;'
	Execute(@SQL)
	Set @SQL=N'DROP LOGIN [TEAM'+Format(@Count,'0#')+'];'
	Execute(@SQL)
	Set @Count=@Count-1
End