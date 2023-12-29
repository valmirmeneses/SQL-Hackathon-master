
/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [TEAM1]    Script Date: 3/10/2019 5:53:41 PM ******/
--Use Master

DECLARE @SQL nvarchar(1000);
Declare @Count smallint;
Declare @StrCount varchar(2);

Set @Count=20
While @Count>1
Begin
	Set @StrCount=RIGHT('0'+Convert(varchar,@Count),2)
	Set @SQL=N'Use TEAM'+@StrCount+'_AdventureWorks;'
	--Execute (@SQL)
	Set @SQL=@SQL+N'create user [TEAM'+@StrCount+'] for login [TEAM'+@StrCount+']  WITH DEFAULT_SCHEMA=[master];'
	--Execute (@SQL)
	Set @SQL=@SQL+N'exec sp_addrolemember ''db_owner'', [TEAM'+@StrCount+'];'
	Execute (@SQL)
	Set @SQL=N'Use TEAM'+@StrCount+'_Northwind;'
	--Execute (@SQL)
	Set @SQL=@SQL+N'create user [TEAM'+@StrCount+'] for login [TEAM'+@StrCount+']  WITH DEFAULT_SCHEMA=[master];'
	--Execute (@SQL)
	Set @SQL=@SQL+N'exec sp_addrolemember ''db_owner'', [TEAM'+@StrCount+'];'
	Execute (@SQL)
	Set @SQL=N'Use msdb;'
	--Execute (@SQL)
	Set @SQL=@SQL+N'create user [TEAM'+@StrCount+'] from login [TEAM'+@StrCount+'];'
	--Execute (@SQL)
	Set @SQL=@SQL+N'GRANT SELECT TO [TEAM'+@StrCount+'];'
	Execute (@SQL)
	Set @SQL=N'Use master;'
	--Execute (@SQL)
	Set @SQL=@SQL+N'GRANT VIEW SERVER STATE TO [TEAM'+@StrCount+'];'
	Execute (@SQL)

	Set @Count=@Count-1
End
