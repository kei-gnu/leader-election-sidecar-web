FROM node:10

WORKDIR /usr/src/app
EXPOSE 8080
COPY server.js .
CMD [ "node", "server.js" ]