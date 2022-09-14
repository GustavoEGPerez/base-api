# PROCEDIMENTO PARA CONFIGURAR E PUBLICAR UMA NOVA VERSAO DO APP NO AZURE CONTAINER APPS

export APP_NAME=sample-api
export APP_NAME=sample-api
export RESOURCE_GROUP=dev-labs
export DOCKERUSER=gustavoperezyssy
export DOCKERPWD=dckr_pat_Zo2ipzZcWb94lXfkVBqcC0oQZmE
export LOCATION=centralus
export LOG_ANALYTICS_WORKSPACE=sample-api-logs            
export CONTAINERAPPS_ENVIRONMENT=sample-api-env
CONTAINER_REGISTRY_NAME=`echo "$APP_NAME" | sed "s/[^[:alnum:]]//g"`

docker build -t $DOCKERUSER/$APP_NAME:latest -f Dockerfile .
docker login -u $DOCKERUSER -p "$DOCKERPWD" docker.io
docker push $DOCKERUSER/$APP_NAME:latest

echo "Azure login..."
az login --use-device-code

echo "Creating resource group ..."
az group create -l $LOCATION -n $RESOURCE_GROUP

#echo "Creating container registry ..."
#az acr create --resource-group $RESOURCE_GROUP --name $CONTAINER_REGISTRY_NAME --sku Basic

echo "Creating log analytics workspace ..."
az monitor log-analytics workspace create --resource-group $RESOURCE_GROUP --workspace-name $LOG_ANALYTICS_WORKSPACE

echo "Getting ClientID and Secred from log analytics workspace ..."
LOG_ANALYTICS_WORKSPACE_CLIENT_ID=`az monitor log-analytics workspace show --query customerId -g $RESOURCE_GROUP -n $LOG_ANALYTICS_WORKSPACE --out tsv`
LOG_ANALYTICS_WORKSPACE_CLIENT_SECRET=`az monitor log-analytics workspace get-shared-keys --query primarySharedKey -g $RESOURCE_GROUP -n $LOG_ANALYTICS_WORKSPACE --out tsv`

echo "Creating container application environment..."
az containerapp env create --name $CONTAINERAPPS_ENVIRONMENT --resource-group $RESOURCE_GROUP --logs-workspace-id $LOG_ANALYTICS_WORKSPACE_CLIENT_ID --logs-workspace-key $LOG_ANALYTICS_WORKSPACE_CLIENT_SECRET --location "$LOCATION"

echo "Creating container application..."
az containerapp create --name $APP_NAME --resource-group $RESOURCE_GROUP --environment $CONTAINERAPPS_ENVIRONMENT --image docker.io/$DOCKERUSER/$APP_NAME --target-port 3000 --ingress 'external' --query configuration.ingress.fqdn

echo "DONE!"