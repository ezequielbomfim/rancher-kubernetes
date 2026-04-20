FROM node:18-alpine

LABEL maintainer="Jonathan Baraldi"

WORKDIR /tmp
COPY package*.json /tmp/
RUN npm install
RUN npm install mysql

WORKDIR /src
COPY . /src

EXPOSE 8080

CMD ["node", "/src/index.js"]
