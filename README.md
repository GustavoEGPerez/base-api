# Auditty - Serviço de REST APIs #
Servico de REST APIs, desenvolvido em NodeJS/ExpressJS, responsável pelo processamento e disposição de informações a serem utilizados por outros servicoes e aplicações, como o aplicativo web da Auditty. As informações processadas por esse servico são obtidas através da comunicação com origens de dados da solução Auditty e retornadas em formato JSON através de comunicação HTTPS, previamente credenciadas através do mecanismo de autenticação JWT.

## Pré-requisitos
###Desenvolvimento
- Microsoft Visual Studio Code 1.70.1 ou superior
- Node JS v16.14.0
- npm v8.3.1
  
###Testes e produção
- Node JS v16.14.0
- npm v8.3.1
- Docker v20.10.17 ou superior
- Acesso a servicos HTTPS do docker.io e ambiente Azure da Microsoft

## Configuração inicial ambiente de desenvolvimento ##
Siga as seguintes etapas para configurar o ambiente de desenvolvimento:
- Clone o repositório a partir de sua origem
- Execute o comando `npm install` para configurar o projeto e instalar suas dependências
- Verifique se as variáveis de ambiente configuradas no arquivo `.env` do projeto estão de acordo com seu ambiente:
### Desenvolvimento
|Variável|Descrição|Obrigatório|Valor Padrão|
|-|-|-|-|
WEBAPP_URL|Url do aplicativo web, IMPORTANTE para liberar o CORS com o frontend||http://localhost:3000
PORT|Porta TCP para comunicação com o serviço||5000
### Testes e Produção
Durante o processo de deploy em ambientes intermediários e ambiente de produção, é necessário revisar as seguintes variáveis de ambientes no arquivo .env do projeto, necessárias para o procedimento de publicação:
|Variável|Descrição|Obrigatório|Valor Padrão|
|-|-|-|-|
WEBAPP_URL|Url do aplicativo web, IMPORTANTE para liberar o CORS com o frontend||_Url base do aplicativo web da Auditty no ambiente atual_
PORT|Porta TCP para comunicação com o serviço||5000
APP_NAME|Nome da aplicação de container no Azure||auditty-api
RESOURCE_GROUP|Nome do grupo de recursos do Azure||DHS_Auditty
DOCKERUSER|Login de acesso ao repositório de imagens do Docker.io||
DOCKERPWD|Chave de acesso ao repositório de imagens do Docker.io||
LOCATION|Região geográfica dos serviços do Azure - formato de nome definido pela documentação do Azure||eastus
LOG_ANALYTICS_WORKSPACE|Nome do Log Analytics Workspace do Azure a ser utilizado pelo serviço||auditty-logs
CONTAINERAPPS_ENVIRONMENT|Nome do ambiente deste aplicativo de conteiner||auditty-env
SUBSCRIPTION_NAME|ID da subscrição do Azure, onde esse serviço será hospedado||_ID da subscrição Azure onde o ambiente atual está hospedado_
## Publicação ##
Para o processo de publicação, o projeto possui scripts que automatizam as ações necessárias para que o serviço seja devidamente publicadas no ambiente final. São elas:
### az_setup.sh ###
Script responsável em criar no Azure todo o ambiente que irá sustentar o aplicativo de contêiner:
- Criação de Grupo de Recursos
- Criação de um Workspace de Log Analytics
- Criação de um ambiente de aplicativo de contêiner

Esse script não publica o container como aplicativo, apenas prepara o ambiente. Para publicar deve-se utilizar o `az_publishnew.sh` ou o `az_publishupdate.sh`

##### Argumentos
###### --group ou --nogroup
* `--group` - Em cenários onde o grupo de recursos do Azure chamado `DHS-Auditty` ainda não existe
* `--nogroup` - Em cenários onde o Azure chamado `DHS-Auditty` já exista

###### --log ou --nolog
* `--logs` - Em cenários onde o workspace log analytics do Azure chamado `dhs-auditty-logs` ainda não existe
* `--nologs` - Em cenários onde o workspace log analytics do Azure chamado `dhs-auditty-logs` já exista

### az_publishnew.sh ###
Script responsável em publicar um novo aplicativo de contêiner do servico de apis chamado `dhs-auditty-api`, utilizando a última imagem de contêiner do projeto.

### az_publishupdate.sh ###
Script responsável em republicar um aplicativo de contêiner do servico de apis chamado `dhs-auditty-api`, utilizando a última imagem de contêiner do projeto.

### Dockerfile ### 
Utilizado pelo comando docker da máquina em execução, tanto para fazer build da imagem que irá ser publicada no Docker.io e entao executada como aplicativo de conteiner, quanto para subir em um docker local ou em outro servidor com docker instalado.

### docker-compose.yaml ###
Utilizado pelo comando docker-compose para publicar em um container docker local ou em um servidor que nao seja aplicativo de conteiner do azure.

_(em breve, descrição dos endpoints disponiveis - documentação swagger)_