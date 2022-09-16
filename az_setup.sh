if [ "$1" == "" ] || [ $# -lt 2 ]
then
    echo "Favor informe um dos parametros abaixo: "
    echo "   --nogroup"
    echo "        Nao criar grupo de recursos"
    echo "   --group"
    echo "        Criar grupo de recursos"
    echo "   --nolog"
    echo "        Nao criar workspace de analise de logs"
    echo "   --log"
    echo "        Criar workspace de analise de logs"
    exit 1
fi

# CARREGA AS VARIAVEIS DE AMBIENTE DO ARQUIVO .env 
# LOCALIZADO NA MESMA PASTA DO SCRIPT
export $(cat .env | xargs) 

# PROCEDIMENTO PARA CONFIGURAR O AMBIENTE AZURE PARA IMPLANTACAO DO CONTAINER APP
#CONTAINER_REGISTRY_NAME=`echo "$APP_NAME" | sed "s/[^[:alnum:]]//g"`

echo "Azure login..."
az login --use-device-code

echo "Set to subscription..."
az account set --subscription $SUBSCRIPTION_NAME

if [ "$1" == "--group" ] || [ "$2" == "--group" ]
then
    echo "Creating resource group ..."
    az group create -l $LOCATION -n $RESOURCE_GROUP
fi

#echo "Creating container registry ..."
#az acr create --resource-group $RESOURCE_GROUP --name $CONTAINER_REGISTRY_NAME --sku Basic

if [ "$1" == "--log" ] || [ "$2" == "--log" ]
then
    echo "Creating log analytics workspace ..."
    az monitor log-analytics workspace create --resource-group $RESOURCE_GROUP --workspace-name $LOG_ANALYTICS_WORKSPACE
fi

az provider register -n Microsoft.App --wait

echo "Getting ClientID and Secred from log analytics workspace ..."
LOG_ANALYTICS_WORKSPACE_CLIENT_ID=`az monitor log-analytics workspace show --query customerId -g $RESOURCE_GROUP -n $LOG_ANALYTICS_WORKSPACE --out tsv`
LOG_ANALYTICS_WORKSPACE_CLIENT_SECRET=`az monitor log-analytics workspace get-shared-keys --query primarySharedKey -g $RESOURCE_GROUP -n $LOG_ANALYTICS_WORKSPACE --out tsv`

echo "Creating container application environment..."
az containerapp env create --name $CONTAINERAPPS_ENVIRONMENT --resource-group $RESOURCE_GROUP --logs-workspace-id $LOG_ANALYTICS_WORKSPACE_CLIENT_ID --logs-workspace-key $LOG_ANALYTICS_WORKSPACE_CLIENT_SECRET --location "$LOCATION"

echo "ENVIRONMENT SETUP DONE!"