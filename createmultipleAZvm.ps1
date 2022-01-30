#This PowerShell scripts automates the creation of any number of Virtual Machines in a Azure resource group specified by the administrator.
#Run the script in PowerShell by typing ./createmultipleAzVM.ps1 "AzureExercises" "Demo" 3 "CentOS"

#Capture the input parameter for the Azure resource group, name of VM, number of VMs, & image type in a variable.
param([string]$resourceGroup, [string]$name, [int]$numberofVM, [string]$image )

#Import thr Azure PowerShell module.
Import-Module -Name Az

#Connect to an Azure Account.
Connect-AzAccount

#Prompt for a username and password for the virtual machhine's admin account, and capture the result in a variable.
$adminCredential = Get-Credential -Message "Enter a username and password for the VM Administrator."

#Loop that executes up to the numer of VMs to be created.
For ($i = 1; $i -le $numberofVM; $i++)
{
    $vmName = $name + $i
    Write-Host "Creating VM: " $vmName

    #Create each virtual machine
    New-AzVm -ResourceGroupName $resourceGroup -Name $vmName -Credential $adminCredential -Image $image
}
