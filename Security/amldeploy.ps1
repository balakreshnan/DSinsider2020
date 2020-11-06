az login
az account set -s "c46a9435-c957-4e6c-a0f4-b9a597984773"
az group create -n insiderDS -l eastus2

$rg="insiderDS"

az network VNet create -g $rg -n hub --address-prefix 10.150.0.0/16 --subnet-name training --subnet-prefix 10.150.0.0/24
az network VNet subnet update -g $rg --vnet-name hub -n training --service-endpoints Microsoft.Storage Microsoft.KeyVault Microsoft.ContainerRegistry
az network VNet subnet create -g $rg --vnet-name hub -n scoring --address-prefixes 10.150.1.0/24
az network VNet subnet update -g $rg --vnet-name hub -n scoring --service-endpoints Microsoft.Storage Microsoft.KeyVault Microsoft.ContainerRegistry


az network nsg create -n insiderDSnsg -g $rg
az network vnet subnet update -g $rg --vnet-name hub -n training --network-security-group insiderDSnsg
az network vnet subnet update -g $rg --vnet-name hub -n scoring --network-security-group insiderDSnsg

az keyvault create -l eastus2 -n insiderDSkv -g $rg
az keyvault key create -n insiderDSkey --vault-name insiderDSkv

az deployment group create -n insiderDSaml -g $rg -f azuredeploy.json -p azuredeploy.parameters.json

$ws="insiderDSaml1"

## /subscriptions/c46a9435-c957-4e6c-a0f4-b9a597984773/resourceGroups/insiderDS/providers/Microsoft.KeyVault/vaults/insiderDSkv
## https://insiderdskv.vault.azure.net/

