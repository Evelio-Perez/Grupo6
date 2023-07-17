
$myResourceGroup = "Evelio"        #NOMBRE DEL GRUPO DE RECURSOS
$nameVm = "Evelio1_f97130b7"              #NOMBRE DE MAQUINA VIRTUAL
$Nicinfo = "eveli4166Nic-cbd0a451"

az vm nic show --resource-group $myResourceGroup --vm-name $nameVm --nic $Nicinfo 