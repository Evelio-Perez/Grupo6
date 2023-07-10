
#VARIABLES
$myResourceGroup = "Evelio"        #NOMBRE DEL GRUPO DE RECURSOS
$myScaleSet = "Evelio1"            #NOMBRE DEL SCALE SET

#Eliminar el conjunto de escalado y sus recursos asociados
az vmss delete --name $myscaleset --resource-group $myresourcegroup

#Eliminar grupo de recursos.
az group delete --name $myResourceGroup --no-wait --yes