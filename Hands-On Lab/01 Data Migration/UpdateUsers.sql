 USE [TEAM02_TenantDataDb]
 exec sp_addrolemember 'db_owner', 'TEAM02'
 EXEC dbo.sp_changedbowner 'sa'
 use [TEAM02_LocalMasterDataDB]
  exec sp_addrolemember 'db_owner', 'TEAM02'
  EXEC dbo.sp_changedbowner 'sa'
use [TEAM02_SharedMasterDataDB]
 exec sp_addrolemember 'db_owner', 'TEAM02'
 EXEC dbo.sp_changedbowner 'sa'
------------------------------------------------------


alter database [TEAM02_LocalMasterDataDB] set trustworthy on
go
alter database [TEAM02_SharedMasterDataDB] set trustworthy on
go
alter database [TEAM02_TenantDataDb] set trustworthy on
go
EXEC sp_configure 'clr enabled', 1;  
RECONFIGURE;  

 
 
 
 use [TEAM01_TenantDataDb]
  --drop user TEAM1
  drop user TEAM01
    create user [TEAM01] from login [TEAM01]
  exec sp_addrolemember 'db_owner', 'TEAM01'
    use [TEAM01_LocalMasterDataDB]
  drop user TEAM1
  drop user TEAM01
    create user [TEAM01] from login [TEAM01]
  exec sp_addrolemember 'db_owner', 'TEAM01'
    use [TEAM01_SharedMasterDataDB]
  drop user TEAM1
  drop user TEAM01
   create user [TEAM01] from login [TEAM01]
  exec sp_addrolemember 'db_owner', 'TEAM01'
   
 use [TEAM02_TenantDataDb]
  drop user TEAM2
  drop user TEAM02
    create user [TEAM02] from login [TEAM02]
  exec sp_addrolemember 'db_owner', 'TEAM02'
    use [TEAM02_LocalMasterDataDB]
  drop user TEAM2
  drop user TEAM02
    create user [TEAM02] from login [TEAM02]
  exec sp_addrolemember 'db_owner', 'TEAM02'
    use [TEAM02_SharedMasterDataDB]
  drop user TEAM2
  drop user TEAM02
   create user [TEAM02] from login [TEAM02]
  exec sp_addrolemember 'db_owner', 'TEAM02'
   
 use [TEAM03_TenantDataDb]
  drop user TEAM3
  drop user TEAM03
    create user [TEAM03] from login [TEAM03]
  exec sp_addrolemember 'db_owner', 'TEAM03'
    use [TEAM03_LocalMasterDataDB]
  drop user TEAM3
  drop user TEAM03
    create user [TEAM03] from login [TEAM03]
  exec sp_addrolemember 'db_owner', 'TEAM03'
    use [TEAM03_SharedMasterDataDB]
  drop user TEAM3
  drop user TEAM03
   create user [TEAM03] from login [TEAM03]
  exec sp_addrolemember 'db_owner', 'TEAM03'
   
 use [TEAM04_TenantDataDb]
  drop user TEAM4
  drop user TEAM04
    create user [TEAM04] from login [TEAM04]
  exec sp_addrolemember 'db_owner', 'TEAM04'
    use [TEAM04_LocalMasterDataDB]
  drop user TEAM4
  drop user TEAM04
    create user [TEAM04] from login [TEAM04]
  exec sp_addrolemember 'db_owner', 'TEAM04'
    use [TEAM04_SharedMasterDataDB]
  drop user TEAM4
  drop user TEAM04
   create user [TEAM04] from login [TEAM04]
  exec sp_addrolemember 'db_owner', 'TEAM04'
   
 use [TEAM05_TenantDataDb]
  drop user TEAM5
  drop user TEAM05
    create user [TEAM05] from login [TEAM05]
  exec sp_addrolemember 'db_owner', 'TEAM05'
    use [TEAM05_LocalMasterDataDB]
  drop user TEAM5
  drop user TEAM05
    create user [TEAM05] from login [TEAM05]
  exec sp_addrolemember 'db_owner', 'TEAM05'
    use [TEAM05_SharedMasterDataDB]
  drop user TEAM5
  drop user TEAM05
   create user [TEAM05] from login [TEAM05]
  exec sp_addrolemember 'db_owner', 'TEAM05'
   
 use [TEAM06_TenantDataDb]
  drop user TEAM6
  drop user TEAM06
    create user [TEAM06] from login [TEAM06]
  exec sp_addrolemember 'db_owner', 'TEAM06'
    use [TEAM06_LocalMasterDataDB]
  drop user TEAM6
  drop user TEAM06
    create user [TEAM06] from login [TEAM06]
  exec sp_addrolemember 'db_owner', 'TEAM06'
    use [TEAM06_SharedMasterDataDB]
  drop user TEAM6
  drop user TEAM06
   create user [TEAM06] from login [TEAM06]
  exec sp_addrolemember 'db_owner', 'TEAM06'
   
 use [TEAM07_TenantDataDb]
  drop user TEAM7
  drop user TEAM07
    create user [TEAM07] from login [TEAM07]
  exec sp_addrolemember 'db_owner', 'TEAM07'
    use [TEAM07_LocalMasterDataDB]
  drop user TEAM7
  drop user TEAM07
    create user [TEAM07] from login [TEAM07]
  exec sp_addrolemember 'db_owner', 'TEAM07'
    use [TEAM07_SharedMasterDataDB]
  drop user TEAM7
  drop user TEAM07
   create user [TEAM07] from login [TEAM07]
  exec sp_addrolemember 'db_owner', 'TEAM07'
   
 use [TEAM08_TenantDataDb]
  drop user TEAM8
  drop user TEAM08
    create user [TEAM08] from login [TEAM08]
  exec sp_addrolemember 'db_owner', 'TEAM08'
    use [TEAM08_LocalMasterDataDB]
  drop user TEAM8
  drop user TEAM08
    create user [TEAM08] from login [TEAM08]
  exec sp_addrolemember 'db_owner', 'TEAM08'
    use [TEAM08_SharedMasterDataDB]
  drop user TEAM8
  drop user TEAM08
   create user [TEAM08] from login [TEAM08]
  exec sp_addrolemember 'db_owner', 'TEAM08'
   
 use [TEAM09_TenantDataDb]
  drop user TEAM9
  drop user TEAM09
    create user [TEAM09] from login [TEAM09]
  exec sp_addrolemember 'db_owner', 'TEAM09'
    use [TEAM09_LocalMasterDataDB]
  drop user TEAM9
  drop user TEAM09
    create user [TEAM09] from login [TEAM09]
  exec sp_addrolemember 'db_owner', 'TEAM09'
    use [TEAM09_SharedMasterDataDB]
  drop user TEAM9
  drop user TEAM09
   create user [TEAM09] from login [TEAM09]
  exec sp_addrolemember 'db_owner', 'TEAM09'
   
 use [TEAM10_TenantDataDb]
  drop user TEAM10
  drop user TEAM10
    create user [TEAM10] from login [TEAM10]
  exec sp_addrolemember 'db_owner', 'TEAM10'
    use [TEAM10_LocalMasterDataDB]
  drop user TEAM10
  drop user TEAM10
    create user [TEAM10] from login [TEAM10]
  exec sp_addrolemember 'db_owner', 'TEAM10'
    use [TEAM10_SharedMasterDataDB]
  drop user TEAM10
  drop user TEAM10
   create user [TEAM10] from login [TEAM10]
  exec sp_addrolemember 'db_owner', 'TEAM10'
   
 use [TEAM11_TenantDataDb]
  drop user TEAM11
  drop user TEAM11
    create user [TEAM11] from login [TEAM11]
  exec sp_addrolemember 'db_owner', 'TEAM11'
    use [TEAM11_LocalMasterDataDB]
  drop user TEAM11
  drop user TEAM11
    create user [TEAM11] from login [TEAM11]
  exec sp_addrolemember 'db_owner', 'TEAM11'
    use [TEAM11_SharedMasterDataDB]
  drop user TEAM11
  drop user TEAM11
   create user [TEAM11] from login [TEAM11]
  exec sp_addrolemember 'db_owner', 'TEAM11'
   
 use [TEAM12_TenantDataDb]
  drop user TEAM12
  drop user TEAM12
    create user [TEAM12] from login [TEAM12]
  exec sp_addrolemember 'db_owner', 'TEAM12'
    use [TEAM12_LocalMasterDataDB]
  drop user TEAM12
  drop user TEAM12
    create user [TEAM12] from login [TEAM12]
  exec sp_addrolemember 'db_owner', 'TEAM12'
    use [TEAM12_SharedMasterDataDB]
  drop user TEAM12
  drop user TEAM12
   create user [TEAM12] from login [TEAM12]
  exec sp_addrolemember 'db_owner', 'TEAM12'
   
 use [TEAM13_TenantDataDb]
  drop user TEAM13
  drop user TEAM13
    create user [TEAM13] from login [TEAM13]
  exec sp_addrolemember 'db_owner', 'TEAM13'
    use [TEAM13_LocalMasterDataDB]
  drop user TEAM13
  drop user TEAM13
    create user [TEAM13] from login [TEAM13]
  exec sp_addrolemember 'db_owner', 'TEAM13'
    use [TEAM13_SharedMasterDataDB]
  drop user TEAM13
  drop user TEAM13
   create user [TEAM13] from login [TEAM13]
  exec sp_addrolemember 'db_owner', 'TEAM13'
   
 use [TEAM14_TenantDataDb]
  drop user TEAM14
  drop user TEAM14
    create user [TEAM14] from login [TEAM14]
  exec sp_addrolemember 'db_owner', 'TEAM14'
    use [TEAM14_LocalMasterDataDB]
  drop user TEAM14
  drop user TEAM14
    create user [TEAM14] from login [TEAM14]
  exec sp_addrolemember 'db_owner', 'TEAM14'
    use [TEAM14_SharedMasterDataDB]
  drop user TEAM14
  drop user TEAM14
   create user [TEAM14] from login [TEAM14]
  exec sp_addrolemember 'db_owner', 'TEAM14'
   
 use [TEAM15_TenantDataDb]
  drop user TEAM15
  drop user TEAM15
    create user [TEAM15] from login [TEAM15]
  exec sp_addrolemember 'db_owner', 'TEAM15'
    use [TEAM15_LocalMasterDataDB]
  drop user TEAM15
  drop user TEAM15
    create user [TEAM15] from login [TEAM15]
  exec sp_addrolemember 'db_owner', 'TEAM15'
    use [TEAM15_SharedMasterDataDB]
  drop user TEAM15
  drop user TEAM15
   create user [TEAM15] from login [TEAM15]
  exec sp_addrolemember 'db_owner', 'TEAM15';   
  







use msdb

create user [TEAM01] from login [TEAM01];
create user [TEAM02] from login [TEAM02];
create user [TEAM03] from login [TEAM03];
create user [TEAM04] from login [TEAM04];
create user [TEAM05] from login [TEAM05];
create user [TEAM06] from login [TEAM06];
create user [TEAM07] from login [TEAM07];
create user [TEAM08] from login [TEAM08];
create user [TEAM09] from login [TEAM09];
create user [TEAM10] from login [TEAM10];
create user [TEAM11] from login [TEAM11];
create user [TEAM12] from login [TEAM12];
create user [TEAM13] from login [TEAM13];
create user [TEAM14] from login [TEAM14];
create user [TEAM15] from login [TEAM15];

GRANT SELECT TO [TEAM01];
GRANT SELECT TO [TEAM02];
GRANT SELECT TO [TEAM03];
GRANT SELECT TO [TEAM04];
GRANT SELECT TO [TEAM05];
GRANT SELECT TO [TEAM06];
GRANT SELECT TO [TEAM07];
GRANT SELECT TO [TEAM08];
GRANT SELECT TO [TEAM09];
GRANT SELECT TO [TEAM10];
GRANT SELECT TO [TEAM11];
GRANT SELECT TO [TEAM12];
GRANT SELECT TO [TEAM13];
GRANT SELECT TO [TEAM14];
GRANT SELECT TO [TEAM15];

USE MASTER
GRANT VIEW SERVER STATE TO [TEAM01];
GRANT VIEW SERVER STATE TO [TEAM02];
GRANT VIEW SERVER STATE TO [TEAM03];
GRANT VIEW SERVER STATE TO [TEAM04];
GRANT VIEW SERVER STATE TO [TEAM05];
GRANT VIEW SERVER STATE TO [TEAM06];
GRANT VIEW SERVER STATE TO [TEAM07];
GRANT VIEW SERVER STATE TO [TEAM08];
GRANT VIEW SERVER STATE TO [TEAM09];
GRANT VIEW SERVER STATE TO [TEAM10];
GRANT VIEW SERVER STATE TO [TEAM11];
GRANT VIEW SERVER STATE TO [TEAM12];
GRANT VIEW SERVER STATE TO [TEAM13];
GRANT VIEW SERVER STATE TO [TEAM14];
GRANT VIEW SERVER STATE TO [TEAM15];
