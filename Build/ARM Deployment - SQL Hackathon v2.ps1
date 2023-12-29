﻿<# 
#POWERSHELL ENVIRONMENTALS:
#=========================

#1. SET PS SCRIPT SECURITY:
#1.1 Set PS execution policy to Unrestricted so script can be run:
Set-ExecutionPolicy -ExecutionPolicy Unrestricted

#1.1 Confirm Exectution Policy changed to Unrestricted:
Get-ExecutionPolicy -List

#2. CONNECT PS SESSION TO TARGET AZURE SUBSCRIPTION:
#2.1 Run this to connect into Azure:
Connect-AzAccount

#2.2 Run this to get a list of Subscriptions you have access to:
Get-AzSubscription -TenantId 345ff19a-728a-4c30-b146-d7bc44087fc4

#2.3 Replace <Tenant ID> and <Subscription ID> placeholders below then run: 
Select-AzSubscription -Tenant '345ff19a-728a-4c30-b146-d7bc44087fc4' -SubscriptionId '1479657d-52da-420f-8add-add930152216'

#NOW RUN THE ENTIRE PS SCRIPT COMPLETING REQUESTED PARAMTERS AS PROMPTED.
# DemoUser
# Demo@pass1234567
#>
Select-AzSubscription -Tenant '345ff19a-728a-4c30-b146-d7bc44087fc4' -SubscriptionId '1479657d-52da-420f-8add-add930152216'
Write-Host -BackgroundColor Black -ForegroundColor Yellow "#################################################################################"
Write-Host -BackgroundColor Black -ForegroundColor Yellow "SQL Server Migration Hack Build Script"
Write-Host -BackgroundColor Black -ForegroundColor Yellow "This script will build the enviroment for the SQL Server Hack and Labs"
Write-Host -BackgroundColor Black -ForegroundColor Yellow "#################################################################################"

Write-Host -BackgroundColor Black -ForegroundColor Yellow "Checking and Installing Az and SQL modules......................................."

Set-ExecutionPolicy RemoteSigned -Force
If(-not(Get-InstalledModule Az -ErrorAction silentlycontinue)){
    Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force
}

Write-Host -BackgroundColor Black -ForegroundColor Yellow "Setting Enviroment Varibales....................................................."
$subscriptionID = (Get-AzContext).Subscription.id
$subscriptionName = (Get-AzContext).Subscription.Name

if(-not $subscriptionID) {   `
    $subscriptionMessage = "There is no selected Azure subscription. Please use Select-AzSubscription to select a default subscription";  `
    Write-Warning $subscriptionMessage ; return;}  `
else {   `
    $subscriptionMessage = ("Actually targeting Azure subscription: {0} - {1}." -f $subscriptionID, $subscriptionName)}
Write-Host -BackgroundColor Black -ForegroundColor Yellow $subscriptionMessage

if ((read-host "Please ensure this is the correct subscription. Press a to abort, any other key to continue.") -eq "a") {Return;}
Write-Host -BackgroundColor Black -ForegroundColor Yellow "Continuing to build.................................................."

###################################################################
# Setup Vaiables
###################################################################
$DefaultValue = 5
if (($TeamVMCount = Read-Host "Please enter the number of Team VM's required (1-20) (default value: $DefaultValue)") -eq '') {$TeamVMCount = $DefaultValue}
If ($TeamVMCount -gt 20)
{
    Write-Warning "Maximum number TEAM VM's is 20. Setting to 5 VM's"
    $TeamVMCount = 5

}

$DefaultValue = "northeurope"
if (($Location = Read-Host "Please enter the Location of the Resource Groups. (default value: $DefaultValue)") -eq '') {$Location = $DefaultValue}
If (“NorthEurope”,”WestEurope”,”UKSouth”, "UKWest", "WestUS", "EastUS" -NotContains $Location  ) {Write-Warning "Unrecognised location. Setting to Default $DefaultValue" ; $Location = "NorthEurope"}

Write-Host -BackgroundColor Black -ForegroundColor Yellow "##################### IMPORTANT: MAKE A NOTE OF THE FOLLOWING USERNAME and PASSWORD ########################"
Write-Host -BackgroundColor Black -ForegroundColor Yellow "The username and password specified next, will be used to credentials to SQL, Managed Instance and any VM's"
Write-Host -BackgroundColor Black -ForegroundColor Yellow "############################################################################################################"
$adminUsername = "DemoUser"
$x = 4
do
    {$x = $x - 1
    if ($x -lt 3){write-host "Not enough characters. Retries remaining: " $x};
    if ($x -le 0) {write-host "Existing build. Please check username and retry..."; Exit};
    $adminUsername = Read-Host "Please enter an Admin username (more than 6 characters) (default value: $adminUsername)"
    }
while ($adminUsername.length -le 6)


$x = 4
do
    {$x = $x - 1
    if ($x -lt 3){write-host "Not enough characters. Retries remaining: " $x};
    if ($x -le 0) {write-host "Existing build. Please check password and retry..."; Exit};
    $adminPassword = Read-Host "Please enter a 16 character Password. The password must be between 16 and 128 characters in length and must contain at least one number, one non-alphanumeric character, and one upper or lower case letter" -AsSecureString
    }
while ($adminPassword.length -le 15)

###################################################################
# Setup Hack Resource Groups
###################################################################

Write-Host -BackgroundColor Black -ForegroundColor Yellow "##################### IMPORTANT: MAKE A NOTE OF THE FOLLOWING RESOURCE GROUPS ########################"
Write-Host -BackgroundColor Black -ForegroundColor Yellow "The Resource groups will be used to store all the lab build"
Write-Host -BackgroundColor Black -ForegroundColor Yellow "############################################################################################################"

$DefaultValue = "SQLHACK-SHARED"
if (($SharedRG = Read-Host "Please enter a Shared resource group name. (default value: $DefaultValue)") -eq '') {$SharedRG = $DefaultValue}

$notPresent = Get-AzResourceGroup -name $SharedRG -ErrorVariable notPresent -ErrorAction SilentlyContinue
if (!($notPresent)) {New-AzResourceGroup -Name $SharedRG -Location $Location} 

$DefaultValue = "SQLHACK-TEAM_VMs"
if (($TeamRG = Read-Host "Please enter a VM resource group name. (default value: $DefaultValue)") -eq '') {$TeamRG = $DefaultValue}

$notPresent =Get-AzResourceGroup -name $TeamRG -ErrorVariable notPresent -ErrorAction SilentlyContinue
if (!($notPresent)) {New-AzResourceGroup -Name $TeamRG -Location $Location}

###################################################################
# Setup Network and Storage account
###################################################################
Write-Host -BackgroundColor Black -ForegroundColor Yellow "Creating Virtual Network................................................."
$TemplateUri = "https://raw.githubusercontent.com/valmirmeneses/SQL-Hackathon/master/Build/ARM%20Templates/ARM%20Template%20-%20SQL%20Hackathon%20-%20Network%20-%20v2.json"
#New-AzResourceGroupDeployment -ResourceGroupName $SharedRG -TemplateUri $TemplateUri -Name "NetworkBuild" 

# Check if Vnet has been created
Get-AzVirtualNetwork -Name "$SharedRG-vnet" -ResourceGroupName $SharedRG -ErrorVariable notPresent -ErrorAction SilentlyContinue
if ($notPresent) {Write-Warning "VNET Failed to build. Please check and retry";return;}

###################################################################
# Setup SASURI
###################################################################
#Create Blob Storage Container and SASURI Key.
$StorageAccount = (get-AzStorageAccount -ResourceGroupName $SharedRG).StorageAccountName  | Select-object -First 1
$StorageAccountKeys = Get-AzStorageAccountKey -ResourceGroupName $SharedRG -Name $StorageAccount
$Key0 = $StorageAccountKeys | Select-Object -First 1 -ExpandProperty Value
$Context = New-AzStorageContext -StorageAccountName $StorageAccount -StorageAccountKey $Key0

#New-AzStorageContainer -Context $Context -Name migration 
#New-AzStorageContainer -Context $Context -Name auditlogs

$storagePolicyName = “Migration-Policy”
$expiryTime = (Get-Date).AddYears(1)
#New-AzStorageContainerStoredAccessPolicy -Container migration -Policy $storagePolicyName -Permission rwld -ExpiryTime $expiryTime -Context $Context -StartTime(Get-Date) 
#$SASUri = (New-AzStorageContainerSASToken -Name "migration" -FullUri -Policy $storagePolicyName -Context $Context)

$JsonSASURI = $SASUri | ConvertTo-Json

###################################################################
# Setup SQL Legacy Server
###################################################################
Write-Host -BackgroundColor Black -ForegroundColor Yellow "Creating legacySQL Server................................................."

$TemplateUri = "https://raw.githubusercontent.com/valmirmeneses/SQL-Hackathon/master/Build/ARM%20Templates/ARM%20Template%20-%20SQL%20Hackathon%20-%20LegacySQL-%20v2.json"
#$TemplateUri = "C:\Users\vamenese\OneDrive - Microsoft\CSU\Hacks\SQL-Hackathon-master\SQL-Hackathon-master\Build\ARM Templates\ARM Template - SQL Hackathon - LegacySQL- v2.json"
#New-AzResourceGroupDeployment -ResourceGroupName $SharedRG -TemplateUri $TemplateUri -adminPassword $adminPassword -Name "LegacySQLBuild" -AsJob 

###################################################################
# Setup Managed Instance and ADF with SSIS IR
###################################################################
Write-Host -BackgroundColor Black -ForegroundColor Yellow "Creating sqlhack-mi Managed Instance................................................."

$TemplateUri = "https://raw.githubusercontent.com/valmirmeneses/SQL-Hackathon/master/Build/ARM%20Templates/ARM%20Template%20-%20SQL%20Hackathon%20-%20Free%20Managed%20Instance-template.json"
#$TemplateUri = "C:\Users\vamenese\OneDrive - Microsoft\CSU\Hacks\SQL-Hackathon-master\SQL-Hackathon-master\Build\ARM Templates\ARM Template - SQL Hackathon - Free Managed Instance-template.json"
New-AzResourceGroupDeployment -ResourceGroupName $SharedRG -TemplateUri $TemplateUri -location $location -adminPassword $adminPassword -Name "ManagedInstanceBuild" -AsJob

###################################################################
# Setup Data Migration Service, Gateway, Keyvault
###################################################################
Write-Host -BackgroundColor Black -ForegroundColor Yellow "Creating DMS, Datafactory, Keyvault, storage account shared resources.................................................."
$TemplateUri = "https://raw.githubusercontent.com/valmirmeneses/SQL-Hackathon/master/Build/ARM%20Templates/ARM%20Template%20-%20SQL%20Hackathon%20-%20Shared%20-%20v2.json"

#New-AzResourceGroupDeployment -ResourceGroupName $SharedRG -TemplateUri $TemplateUri -Name "SharedServicesBuild" -AsJob 

# Setup KeyVault
$Random = Get-Random -Maximum 99999
$Keyvault = "sqlhack-keyvault-$Random"
#New-AzKeyVault -Name $Keyvault  -ResourceGroupName $SharedRG -Location $Location

Get-AzKeyVault -Name $Keyvault -ResourceGroupName $SharedRG -ErrorVariable notPresent -ErrorAction SilentlyContinue
if ($notPresent) {Write-Warning "sqlhack-keyvault Failed to build. Please check and retry";return;}

###################################################################
# Setup Team VM's
###################################################################
Write-Host -BackgroundColor Black -ForegroundColor Yellow "Creating $TeamVMCount Team Server(s).................................................."
$TemplateUri = "https://raw.githubusercontent.com/valmirmeneses/SQL-Hackathon/master/Build/ARM%20Templates/ARM%20Template%20-%20SQL%20Hackathon%20-%20Jump%20Servers%20-%20v2.json"
#$TemplateUri = "C:\Users\vamenese\OneDrive - Microsoft\CSU\Hacks\SQL-Hackathon-master\SQL-Hackathon-master\Build\ARM Templates\ARM Template - SQL Hackathon - Jump Servers - v2.json"

#New-AzResourceGroupDeployment -ResourceGroupName $TeamRG -TemplateUri $TemplateUri -Name "TeamVMBuild" -vmCount $TeamVMCount -SharedResourceGroup $SharedRG -SASURIKey $JsonSASURI -StorageAccount $StorageAccount -adminPassword $adminpassword -adminUsername $adminUsername -AsJob 

###################################################################
# Setup Managed Instance and ADF with SSIS IR
###################################################################
#Write-Host -BackgroundColor Black -ForegroundColor Yellow "Creating sqlhack-mi Managed Instance................................................."

$TemplateUri = "https://raw.githubusercontent.com/valmirmeneses/SQL-Hackathon/master/Build/ARM%20Templates/ARM%20Template%20-%20SQL%20Hackathon%20-%20Free%20Managed%20Instance-template.json"
#$TemplateUri = "C:\Users\vamenese\OneDrive - Microsoft\CSU\Hacks\SQL-Hackathon-master\SQL-Hackathon-master\Build\ARM Templates\ARM Template - SQL Hackathon - Free Managed Instance-template.json"
#New-AzResourceGroupDeployment -ResourceGroupName $SharedRG -TemplateUri $TemplateUri -location $location -adminPassword $adminPassword -Name "ManagedInstanceBuild" -AsJob

Write-Host -BackgroundColor Black -ForegroundColor Yellow "Enviroment Build in progress. Please check RG deployments for errors."

Write-Warning "NOTE: THE FOLLOWING POST BUILD TASKS ARE REQUIRED."
Write-Warning "1. DataFactory Build Ok. You will need to start the SSIS integration runtime and enable AHUB"
Write-Warning "2. Restore the 4 databases for SSIS labs by running the C:\Install\SSIS Build Script.ps1 from a TEAMVM. Note: Only run once."
Write-Warning "3. All labs and documaention can be found on TEAMVM's in C:\_SQLHACK_\LABS"


