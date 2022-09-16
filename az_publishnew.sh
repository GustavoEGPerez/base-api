# PROCEDIMENTO PARA PUBLICAR UMA NOVA VERSAO DO APP NO AZURE CONTAINER APPS
export $(cat .env | xargs)

echo "Azure login..."
az login --use-device-code

echo "Set to subscription..."
az account set --subscription $SUBSCRIPTION_NAME

echo "Cleaning previous docker image locally..."
docker rmi --force "$(docker images -q '$DOCKERUSER/$APP_NAME')"

echo "Build container image locally..."
docker build --no-cache -t $DOCKERUSER/$APP_NAME:latest -f Dockerfile .

echo "Push container image to docker.io ..."
docker login -u $DOCKERUSER -p "$DOCKERPWD" docker.io
docker push $DOCKERUSER/$APP_NAME:latest

echo "Creating container application..."
az containerapp create --name $APP_NAME --resource-group $RESOURCE_GROUP --environment $CONTAINERAPPS_ENVIRONMENT --image docker.io/$DOCKERUSER/$APP_NAME --target-port $PORT --ingress 'external' --query configuration.ingress.fqdn --env-vars "WEBAPP_URL=$WEBAPP_URL"

echo "DONE!"