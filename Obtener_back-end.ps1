$myScaleSetLBBEPool = "Evelio1LBBEPool"   #NOMBRE BACKEND POOL
$myScaleSetLB       = "Evelio1LB"         #NOMBRE BACKEND
$direccionIp = "10.0.0.6"             #DIRECCION DE LA MAQUINA VIRTUAL
$myResourceGroup = "Evelio"        #NOMBRE DE GRUPO DE RECURSOS


#OBTENCION DE LOS DETALLES DEL GRUPO DEL BACK-END
az network lb list-mapping --backend-pool-name $myScaleSetLBBEPool --resource-group Evelio --name $myScaleSetLB --request ip=$direccionIp

#OBTENCION DE IP PUBLICA
az network public-ip list --resource-group $myResourceGroup