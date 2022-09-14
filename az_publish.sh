# PROCEDIMENTO PARA PUBLICAR UMA NOVA VERSAO DO APP NO AZURE CONTAINER APPS

export APP_NAME=sample-api
export APP_NAME=sample-api
export RESOURCE_GROUP=dev-labs
export DOCKERUSER=gustavoperezyssy
export DOCKERPWD=dckr_pat_Zo2ipzZcWb94lXfkVBqcC0oQZmE
export LOCATION=centralus
export LOG_ANALYTICS_WORKSPACE=sample-api-logs            
export CONTAINERAPPS_ENVIRONMENT=sample-api-env
CONTAINER_REGISTRY_NAME=`echo "$APP_NAME" | sed "s/[^[:alnum:]]//g"`

docker build --no-cache -t $DOCKERUSER/$APP_NAME:latest -f Dockerfile .
docker login -u $DOCKERUSER -p "$DOCKERPWD" docker.io
docker push $DOCKERUSER/$APP_NAME:latest

echo "Azure login..."
az login --use-device-code

echo "Updating container application..."
az containerapp update --name $APP_NAME --resource-group $RESOURCE_GROUP --image docker.io/$DOCKERUSER/$APP_NAME --query configuration.ingress.fqdn

echo "DONE!"