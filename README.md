# nelsonA
proyecto final de practicas de especializacion.
 En este proyecto se abordara el escalado de maquinas virtuales
Para habilitar el escalado automático en un conjunto de escalado, primero debe definir un perfil de escalado automático. Este perfil define la capacidad predeterminada, mínima y máxima del conjunto de escalado. Estos límites le permiten controlar el costo al no crear continuamente instancias de máquina virtual, y equilibrar un rendimiento aceptable con un número mínimo de instancias que permanecen en un evento de reducción horizontal.

Las infraestructura  de maquinas virtuales (VMs) permiten crear y gestionar multiples sistemas operativos en un solo servidor fisico. 

para la creacion del scale set: se creo un conjunto de escalado llamado myScaleSet utilizando Azure CLI.Este conjunto se configuro para tener 3 VMs.Al crear un conjunto de escalado, Azure se encarga de distribuir automáticamente las VMs entre los nodos disponibles para lograr un equilibrio de carga efectivo.

Política de Escalado Personalizado: Se utilizó una política de escalado personalizado con la siguiente configuración:

Número mínimo de instancias: 1
Número máximo de instancias: 5
Escalado hacia arriba (Scale out): Cuando el consumo de CPU alcanza el 70% durante al menos 10 minutos, se incrementa una instancia adicional.
Escalado hacia abajo (Scale in): Cuando el consumo de CPU desciende por debajo del 30%, se reduce una instancia.
Scrip para la creacion de los recursos:

azurecli
Copy code
# Variables de configuración
$rgName = "myResourceGroup" # Nombre del grupo de recursos
$location = "eastus" # Ubicación del recurso
$vmssName = "myScaleSet" # Nombre del conjunto de escalado
$vmSize = "Standard_DS2_v2" # Tamaño de la máquina virtual
$instanceCount = 3 # Número inicial de instancias
$minInstances = 1 # Número mínimo de instancias
$maxInstances = 5 # Número máximo de instancias
$cpuThresholdScaleOut = 70 # Umbral de consumo de CPU para escalar hacia arriba (%)
$cpuThresholdScaleIn = 30 # Umbral de consumo de CPU para escalar hacia abajo (%)
$scaleOutCooldown = 10 # Duración del período de escala hacia arriba (minutos)

# Crear el grupo de recursos
az group create --name $rgName --location $location

# Crear el conjunto de escalado
az vmss create `
    --resource-group $rgName `
    --name $vmssName `
    --image UbuntuLTS `
    --upgrade-policy-mode automatic `
    --admin-username azureuser `
    --generate-ssh-keys `
    --instance-count $instanceCount `
    --vm-sku $vmSize

# Configurar la política de escalado
az vmss update `
    --resource-group $rgName `
    --name $vmssName `
    --set virtualMachineProfile.extensionProfile.extensions[0].settings.AutoUpgradeMinorVersion=true

az monitor autoscale create `
    --resource-group $rgName `
    --resource-id (az vmss show --resource-group $rgName --name $vmssName --query id --output tsv) `
    --name "scaleOutRule" `
    --min-count $minInstances `
    --max-count $maxInstances `
    --count $instanceCount `
    --metrics "Percentage CPU" `
    --time-grain "PT1M" `
    --time-window "PT5M" `
    --operator "GreaterThan" `
    --threshold $cpuThresholdScaleOut `
    --direction "Increase" `
    --cooldown $scaleOutCooldown

az monitor autoscale rule create `
    --resource-group $rgName `
    --autoscale-name "scaleOutRule" `
    --scale out `
    --condition "AverageLoad > $cpuThresholdScaleOut" `
    --scale out by 1

az monitor autoscale rule create `
    --resource-group $rgName `
    --autoscale-name "scaleOutRule" `
    --scale in `
    --condition "AverageLoad < $cpuThresholdScaleIn" `
    --scale in by 1
Script para Destruir los Recursos:
azurecli
Copy code
# Variables de configuración
$rgName = "myResourceGroup" # Nombre del grupo de recursos
$vmssName = "myScaleSet" # Nombre del conjunto de escalado

# Eliminar el conjunto de escalado
az vmss delete --resource-group $rgName --name $vmssName --yes

# Eliminar el grupo de recursos y todos los recursos relacionados
az group delete --name $rgName --yes
Conclusiones
Azure VM Scale Sets es una solución eficiente para crear y administrar grupos de máquinas virtuales con equilibrio de carga. Permite aumentar o disminuir automáticamente la cantidad de instancias de VM según la demanda, lo que garantiza alta disponibilidad y eficiencia en la administración de las VMs.

En este informe, se ha presentado el proceso de creación de una infraestructura de VMs utilizando Azure Scale Sets. Se ha utilizado una política de escalado personalizado para controlar la cantidad de instancias en función del consumo de CPU. Los scripts proporcionados permiten crear y destruir los recursos de manera sencilla y automatizada.

