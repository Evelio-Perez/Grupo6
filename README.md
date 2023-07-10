# Informe final del proyecto
 En este proyecto se abordara el escalado de maquinas virtuales 
 * las infraestructura  de maquinas virtuales (VMs) permiten crear y gestionar multiples sistemas operativos en un solo servidor fisico.

para la creacion del scale set: se creo un conjunto de escalado llamado myScaleSet utilizando Azure CLI.Este conjunto se configuro para tener 3 VMs.Al crear un conjunto de escalado, Azure se encarga de distribuir automáticamente las VMs entre los nodos disponibles para lograr un equilibrio de carga efectivo.

*Política de Escalado Personalizado: Se utilizó una política de escalado personalizado con la siguiente configuración:

 Para habilitar el escalado automático en un conjunto de escalado, primero debe definir un perfil de escalado automático. Este perfil define la capacidad predeterminada, mínima y máxima del conjunto de escalado. Estos límites le permiten controlar el costo al no crear continuamente instancias de máquina virtual, y equilibrar un rendimiento aceptable con un número mínimo de instancias que permanecen en un evento de reducción horizontal.

Número mínimo de instancias: 1
Número máximo de instancias: 5
Escalado hacia arriba (Scale out): Cuando el consumo de CPU alcanza el 70% durante al menos 10 minutos, se incrementa una instancia adicional.
Escalado hacia abajo (Scale in): Cuando el consumo de CPU desciende por debajo del 30%, se reduce una instancia.
Scrip para la creacion de los recursos en azure:

$myResourceGroup = "Evelio" 
$location = "eastus" 
$myScaleSet = "Evelio1"
$SKUimage = "UbuntuLTS"
$instancias = "1"
$scaleUser = "evelioscale"
$autoscalename = "EvelioAutoScale"
$min = "1"
$max = "5"
$porcentajeout = "70"
$timeout = "10m"
$aumenta = "1"
$disminuye = "1"
$porcentajein = "30"
$timein = "5m"

Aqui se hara la declaran las variables para la creacion del scale set

DECLARACION DE VARIABLES DE LOS GRUPOS ESCALONADOS:
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

    #Creacion del codigo en PowerShell.
#CREACION DE GRUPO DE RECURSOS:
az group create --name $myResourceGroup --location $location 

#CREACION DE UN CONJUNTO DE ESCALADO :
az vmss create --resource-group $myResourceGroup --name $myScaleSet --image $SKUimage --authentication-type ssh --orchestration-mode "Flexible" --instance-count $instancias --admin-username $scaleUser --generate-ssh-keys

#DEFINICION DE UN PERFIL DE ESCALADO:
az monitor autoscale create --resource-group $myResourceGroup --resource $myScaleSet --resource-type Microsoft.Compute/virtualMachineScaleSets --name $autoscalename --min-count $min --max-count $max --count $instancias

#CRECION DE UNA REGLA DE ESCALADO AUTOMATICO HORIZONTAL DE AUMENTO:
az monitor autoscale rule create --resource-group $myResourceGroup --autoscale-name $autoscalename --condition "Percentage CPU > $porcentajeout avg $timeout" --scale out $aumenta

az monitor autoscale rule create --resource-group $myResourceGroup --autoscale-name $autoscalename --condition "Percentage CPU < $porcentajein avg $timein" --scale in $disminuye
#CRECION DE UNA REGLA DE ESCALADO AUTOMATICO HORIZONTAL DE REDUCCION:
az monitor autoscale rule create --resource-group $myResourceGroup --autoscale-name $autoscalename --condition "Percentage CPU < $porcentajein avg $timein" --scale in $disminuye

#Eliminacion de recursos.
En este  apartado se muestran  los  comandos necesarios para la eliminacion de los recursos escalonados este script primero elimina las instancias creadas y el conjunto escalonado correspondiente , el seguiente comando se encarga de  eliminar el grupo de recusos  

#VARIABLES
$myResourceGroup = "Evelio"        #NOMBRE DEL GRUPO DE SCRIPT
$myScaleSet = "Evelio1"            #NOMBRE DEL SCALE SET

#Eliminar el conjunto de escalado y sus recursos asociados
az vmss delete --name $myscaleset --resource-group $myresourcegroup

#Eliminar grupo de recursos.
az group delete --name $myResourceGroup --no-wait --yes