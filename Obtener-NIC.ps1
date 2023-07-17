$myResourceGroup = "Evelio"    #NOMBRE DEL GRUPO DE RECURSOS
$nameVm = "Evelio1_ad8321ad"              #NOMBRE DE MAQUINA VIRTUAL

#OBTENCION DE INFORMACION NIC
az vm nic list --resource-group Evelio --vm-name $nameVm