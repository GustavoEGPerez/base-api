# PROCEDIMENTO PARA PUBLICAR UMA NOVA VERSAO DO APP NO AZURE CONTAINER APPS

export APP_NAME=sample-api
export RESOURCE_GROUP=dev-labs
export DOCKERUSER=gustavoperezyssy
export DOCKERPWD=dckr_pat_Zo2ipzZcWb94lXfkVBqcC0oQZmE
export LOCATION=centralus
export LOG_ANALYTICS_WORKSPACE=sample-logs            
export CONTAINERAPPS_ENVIRONMENT=sample-env
CONTAINER_REGISTRY_NAME=`echo "$APP_NAME" | sed "s/[^[:alnum:]]//g"`

export $(cat .env | xargs)

echo "Azure login..."
az login --use-device-code

echo "Cleaning previous docker image locally..."
docker rmi --force "$(docker images -q '$DOCKERUSER/$APP_NAME')"

echo "Build container image locally..."
docker build --no-cache -t $DOCKERUSER/$APP_NAME:latest -f Dockerfile .

echo "Push container image to docker.io ..."
docker login -u $DOCKERUSER -p "$DOCKERPWD" docker.io
docker push $DOCKERUSER/$APP_NAME:latest

echo "Updating container application..."
az containerapp update --name $APP_NAME --resource-group $RESOURCE_GROUP --image docker.io/$DOCKERUSER/$APP_NAME:latest --set-env-vars "WEBAPP_URL=https://sample-web.delightfulisland-a394343a.centralus.azurecontainerapps.io"

echo "DONE!"