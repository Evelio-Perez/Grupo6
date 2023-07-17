$myScaleSet = "Evelio1"            #NOMBRE DEL SCALE SET
$PublicIP = "20.172.252.176"                #DIRECCIN IP PUBLICA
$frontendPort = "50002"            #PUERTO DE CONEXION

#CONECTARSE A SU INSTANCIA
ssh evelioscale@$PublicIP -p $frontendPort