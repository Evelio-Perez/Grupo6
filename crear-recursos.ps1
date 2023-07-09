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



az group create --name $myResourceGroup --location $location 

az vmss create --resource-group $myResourceGroup --name $myScaleSet --image $SKUimage --authentication-type ssh --orchestration-mode "Flexible" --instance-count $instancias --admin-username $scaleUser --generate-ssh-keys

az monitor autoscale create --resource-group $myResourceGroup --resource $myScaleSet --resource-type Microsoft.Compute/virtualMachineScaleSets --name $autoscalename --min-count $min --max-count $max --count $instancias

az monitor autoscale rule create --resource-group $myResourceGroup --autoscale-name $autoscalename --condition "Percentage CPU > $porcentajeout avg $timeout" --scale out $aumenta

az monitor autoscale rule create --resource-group $myResourceGroup --autoscale-name $autoscalename --condition "Percentage CPU < $porcentajein avg $timein" --scale in $disminuye