-- Copies a database to the same server
-- Copying the database is based on backing up the original database and restoring with a different name
Use Master
GO
DECLARE @sourceDb nvarchar(50);    
DECLARE @destDb nvarchar(50);
DECLARE @backupTempDir nvarchar(200)
DECLARE @SQL nvarchar(1000);
Declare @Count smallint;
Set @Count=20
SET @sourceDb =  N'TEAM01_AdventureWorks'    

SET @backupTempDir = N'C:\_SQLHACK_\LABS\01-Data_Migration\Backups'       -- The name of the temporary directory in which the temporary backup file will be saved

While @Count>1 
Begin
	SET @destDb =    N'TEAM'+Format(@Count,'0#')+N'_AdventureWorks'
/*
	Set @SQL=N'DROP DATABASE IF EXISTS TEAM'+Format(@Count,'0#')+'_TenantDataDb;'
	Execute (@SQL)
	Set @SQL=N'DROP DATABASE IF EXISTS TEAM'+Format(@Count,'0#')+'_LocalMasterDataDB;'
	Execute (@SQL)
	Set @SQL=N'DROP DATABASE IF EXISTS TEAM'+Format(@Count,'0#')+'_SharedMasterDataDB;'
	Execute(@SQL)
*/


	DECLARE @sourceDb_ROWS nvarchar(50);  
	DECLARE @sourceDb_LOG nvarchar(50);
	DECLARE @backupPath nvarchar(400); 
	DECLARE @destMdf nvarchar(100);
	DECLARE @destLdf nvarchar(100);
	DECLARE @sqlServerDbFolder nvarchar(100);

	Declare @Ret as int = -1
	Declare @RetDescription nvarchar(200) = ''

	-- Temporary backup file name
	SET @backupPath = @backupTempDir+ '\TempDb_' + @sourceDb + '.bak'    

	-- Finds the physical location of the files on the disk
	set @sqlServerDbFolder = (SELECT top(1) physical_name as dir
							   FROM sys.master_files where DB_NAME(database_id) = @sourceDb  );

	-- Clears the file name and leaves the directory name
	set @sqlServerDbFolder = REVERSE(SUBSTRING(REVERSE(@sqlServerDbFolder), CHARINDEX('\', REVERSE(@sqlServerDbFolder)) + 1, LEN(@sqlServerDbFolder))) + '\'

	-- Finds the logical name for the .mdf file
	set @sourceDb_ROWS = (SELECT f.name LogicalName FROM sys.master_files f INNER JOIN sys.databases d ON d.database_id = f.database_id
						  where d.name = @sourceDb  and   f.type_desc = 'ROWS' )

	-- Finds the logical name for the .ldf file
	set @sourceDb_LOG = (SELECT f.name LogicalName FROM sys.master_files f INNER JOIN sys.databases d ON d.database_id = f.database_id
						  where d.name = @sourceDb  and   f.type_desc = 'LOG' )

	-- Composes the names of the physical files for the new database  
	SET @destMdf = @sqlServerDbFolder + @destDb + N'.mdf'
	SET @destLdf = @sqlServerDbFolder + @destDb + N'_log' + N'.ldf'

	-- If the source name is the same as the target name does not perform the operation
	if @sourceDb <> @destDb      
		begin 

		-- Checks if the target database already exists
		IF Not EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = @destDb)
		begin 
			-- Checks if the source database exists
			IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = @sourceDb) and (@sqlServerDbFolder is not null)
			begin 

				-- Opens the permission to run xp_cmdshell
				EXEC master.dbo.sp_configure 'show advanced options', 1
				RECONFIGURE WITH OVERRIDE
				EXEC master.dbo.sp_configure 'xp_cmdshell', 1
				RECONFIGURE WITH OVERRIDE
         
				-- If the temporary backup directory does not exist it creates it
				declare @md as nvarchar(100) = N'if not exist ' + @backupTempDir + N' md ' +@backupTempDir  
				exec xp_cmdshell  @md,  no_output

				-- Creates a backup to the source database to the temporary file
				BACKUP DATABASE @sourceDb TO DISK = @backupPath 

				-- Restores the database with a new name
				RESTORE DATABASE @destDb FROM DISK = @backupPath
				WITH REPLACE, 
				MOVE @sourceDb_ROWS TO @destMdf, 
				MOVE @sourceDb_LOG TO  @destLdf

				-- Deletes the temporary backup file
				declare @del as varchar(100) = 'if exist ' + @backupPath +' del ' +@backupPath 
				exec xp_cmdshell  @del ,  no_output

				-- Close the permission to run xp_cmdshell
				EXEC master.dbo.sp_configure 'xp_cmdshell', 0
				RECONFIGURE WITH OVERRIDE
				EXEC master.dbo.sp_configure 'show advanced options', 0
				RECONFIGURE WITH OVERRIDE
         
				set @ret = 1
				set @RetDescription = 'The ' +@sourceDb + ' database was successfully copied to ' + @destDb 
        
			end
			else
			begin
			  set @RetDescription = 'The source database '''+ @sourceDb + ''' is not exists.'
			  set @ret = -3
			end

		end
		else
		begin
		  set @RetDescription = 'The target database '''+ @destDb + ''' already exists.'
		  set @ret = -4
		end
	end
	else
	begin
	  set @RetDescription = 'The target database ''' +@destDb + ''' and the source database '''+ @sourceDb + ''' have the same name.'
	  set @ret = -5
	end

	select @ret as Ret, @RetDescription as RetDescription
	Set @Count=@Count-1
End