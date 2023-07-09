#DECLARACION DE VARIABLES:
$myResourceGroup = "Evelio"        #NOMBRE DEL GRUPO DE RECURSOS
$location = "eastus"               #LOCALIZACION
$myScaleSet = "Evelio1"            #NOMBRE DEL SCALE SET
$SKUimage = "UbuntuLTS"            #IMAGEN A UTILIZAR
$instancias = "3"                  #NUMERO DE INSTANCIAS
$scaleUser = "evelioscale"         #NOMBRE DE USUARIO PARA EL ESCALADO
$autoscalename = "EvelioAutoScale" #NOMBRE DE USUARIO PARA EL AUTOESCALADO
$min = "1"                         #ESTABLECER MINIMO
$max = "5"                         #ESTABLECER MAXIMO
$porcentajeout = "70"              #PORCENTAJE PARA EL SACALEOUT
$aumenta = "1"                     #NUMERO DE AUMENTOS
$timeout = "10m"                   #ESTABLECER TIEMPO DEL AUMENTO               
$porcentajein = "30"               #PORCENTAJE PARA EL SACALEIN
$disminuye = "1"                   #NUMERO DE DISMINUCION 
$timein = "5m"                     #ESTABLECER TIEMPO DE LA DISMINUCION 


#CREACION DE GRUPO DE RECURSOS:
az group create --name $myResourceGroup --location $location 

#CREACION DE UN CONJUNTO DE ESCALADO :
az vmss create --resource-group $myResourceGroup --name $myScaleSet --image $SKUimage --authentication-type ssh --orchestration-mode "Flexible" --instance-count $instancias --admin-username $scaleUser --generate-ssh-keys

#DEFINICION DE UN PERFIL DE ESCALADO:
az monitor autoscale create --resource-group $myResourceGroup --resource $myScaleSet --resource-type Microsoft.Compute/virtualMachineScaleSets --name $autoscalename --min-count $min --max-count $max --count $instancias

#CRECION DE UNA REGLA DE ESCALADO AUTOMATICO HORIZONTAL DE AUMENTO:
az monitor autoscale rule create --resource-group $myResourceGroup --autoscale-name $autoscalename --condition "Percentage CPU > $porcentajeout avg $timeout" --scale out $aumenta

#CRECION DE UNA REGLA DE ESCALADO AUTOMATICO HORIZONTAL DE REDUCCION:
az monitor autoscale rule create --resource-group $myResourceGroup --autoscale-name $autoscalename --condition "Percentage CPU < $porcentajein avg $timein" --scale in $disminuye
