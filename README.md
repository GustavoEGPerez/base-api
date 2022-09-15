# Serviço de API Exemplo #
Servico de REST APIs desenvolvido em NodeJS/ExpressJS com o propósito de demonstrar sua publicação em um ambiente de aplicativo de contêiner do Azure

### az_setup.sh ###
Script responsável em criar no Azure todo o ambiente que irá sustentar o aplicativo de contêiner:
- Criação de Grupo de Recursos
- Criação de um Workspace de Log Analytics
- Criação de um ambiente de aplicativo de contêiner

Esse script não publica o container como aplicativo, apenas prepara o ambiente. Para publicar deve-se utilizar o `az_publishnew.sh` ou o `az_publishupdate.sh`

### az_publishnew.sh ###
Script responsável em publicar um novo aplicativo de contêiner do servico de apis.

### az_publishupdate.sh ###
Script responsável em publicar em cima de um aplicativo de contêiner existente do servico de apis.

### Dockerfile ###
Utilizado pelo comando docker tanto para fazer build da imagem que irá ser publicada no Docker.io e entao executada como aplicativo de conteiner, quanto para subir em um docker manualmente.

### docker-compose.yaml ###
Utilizado pelo comando docker-compose para publicar em um container docker local ou em um servidor que nao seja aplicativo de conteiner do azure,