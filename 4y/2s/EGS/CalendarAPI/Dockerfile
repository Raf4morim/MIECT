# Utilizar a imagem oficial do Node como base
FROM node:14

RUN apt-get update 

# Definir o diretório de trabalho no container
WORKDIR /usr/src/app

# Copiar os arquivos de definição de pacotes para o diretório de trabalho
COPY package*.json ./

# Instalar as dependências do projeto
RUN npm install

# Copiar os arquivos do projeto para o diretório de trabalho no container
COPY . .

# Expor a porta que o servidor utiliza
EXPOSE 3000

# Comando para rodar a aplicação
CMD [ "node", "index.js" ]
