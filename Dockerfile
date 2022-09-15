FROM node:latest
ENV WEBAPP_URL=$WEBAPP_URL
WORKDIR /app
COPY . .
RUN npm install
EXPOSE $PORT
ENTRYPOINT ["node", "./bin/www"]