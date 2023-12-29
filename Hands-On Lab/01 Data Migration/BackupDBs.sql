Use Master

DECLARE @SQL nvarchar(1000);
Declare @Count smallint;
Declare @StrCount varchar(2);

Set @Count=15
While @Count>2 
Begin
	Set @StrCount=RIGHT('0'+Convert(varchar,@Count),2)
	Set @SQL=N'BACKUP DATABASE [TEAM'+@StrCount+'_TenantDataDb] TO  DISK = N''C:\Backups\TEAM'+@StrCount+'_TenantDataDb.bak'' WITH NOFORMAT, NOINIT,  NAME = N''TEAM'+@StrCount+'_TenantDataDb-Full Database Backup'', SKIP, NOREWIND, NOUNLOAD,  STATS = 10'
	--Select @SQL
	Execute (@SQL)
	Set @SQL=N'BACKUP DATABASE [TEAM'+@StrCount+'_LocalMasterDataDB] TO  DISK = N''C:\Backups\TEAM'+@StrCount+'_LocalMasterDataDB.bak'' WITH NOFORMAT, NOINIT,  NAME = N''TEAM'+@StrCount+'_LocalMasterDataDB-Full Database Backup'', SKIP, NOREWIND, NOUNLOAD,  STATS = 10'
	Execute (@SQL)
	Set @SQL=N'BACKUP DATABASE [TEAM'+@StrCount+'_SharedMasterDataDB] TO  DISK = N''C:\Backups\TEAM'+@StrCount+'_SharedMasterDataDB.bak'' WITH NOFORMAT, NOINIT,  NAME = N''TEAM'+@StrCount+'_SharedMasterDataDB-Full Database Backup'', SKIP, NOREWIND, NOUNLOAD,  STATS = 10'
	Execute(@SQL)
	Set @Count=@Count-1
End