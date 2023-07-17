#DECLARACION DE VARIABLES:
$myResourceGroup = "Evelio"    #NOMBRE DEL GRUPO DE RECURSOS
$myScaleSet = "Evelio1"        #NOMBRE DEL SCALE SET

#LISTA DE VMS
az vmss list-instances --resource-group $myResourceGroup --name $myScaleSet --output table