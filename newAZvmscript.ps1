#Import thr Azure PowerShell module.
Import-Module -Name Az

#Connect to an Azure Account.
Connect-AzAccount

#Define Azure variables for a virtual machine.
$vmName = "VM-2"
$resourceGroup = "MyResourceGroup"

#Create Azure credentials.
$adminCredential = Get-Credential -Message "Enter a username and password for the VM Administrator."

#Create a virtual machine in Azure.
New-AzVM -ResourceGroupName $resourceGroup -Name $vmName -Credential $adminCredential -Image CentOS