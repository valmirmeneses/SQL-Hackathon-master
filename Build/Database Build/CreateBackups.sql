Use Master

DECLARE @SQL nvarchar(1000);
Declare @Count smallint;
Declare @StrCount varchar(2);

Set @Count=20
While @Count>0
Begin
	Set @StrCount=RIGHT('0'+Convert(varchar,@Count),2)
	Set @SQL=N'BACKUP DATABASE [TEAM'+@StrCount+'_AdventureWorks] TO  DISK = N''C:\_SQLHACK_\LABS\01-Data_Migration\Backups\TEAM'+@StrCount+'_AdventureWorks.bak'' WITH NOFORMAT, NOINIT,  NAME = N''TEAM'+@StrCount+'_AdventureWorks-Full Database Backup'', SKIP, NOREWIND, NOUNLOAD,  STATS = 10'
	--Select @SQL
	Execute (@SQL)
	Set @SQL=N'BACKUP DATABASE [TEAM'+@StrCount+'_Northwind] TO  DISK = N''C:\_SQLHACK_\LABS\01-Data_Migration\Backups\TEAM'+@StrCount+'_Northwind.bak'' WITH NOFORMAT, NOINIT,  NAME = N''TEAM'+@StrCount+'_Northwind-Full Database Backup'', SKIP, NOREWIND, NOUNLOAD,  STATS = 10'
	Execute (@SQL)
	Set @Count=@Count-1
End