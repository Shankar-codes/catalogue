FROM node:20.20.2-alpine3.22 AS build
WORKDIR /opt/server
COPY package.json .
COPY *.js .
RUN npm install

FROM node:20.20.2-alpine3.22
RUN addgroup -S roboshop && adduser -S roboshop -G roboshop
WORKDIR /opt/server
RUN apk update && \
    apk upgrade --no-cache
COPY --from=build /opt/server /opt/server/
EXPOSE 8080
LABEL created by="Shankar Thimmappa" \
      project="RoboShop ecommerce" \
      component="Catalogue"
ENV MONGO="true" \
    MONGO_URL="mongodb://mongodb:27017/catalogue"
RUN chown -R roboshop:roboshop /opt/server
USER roboshop
CMD ["server.js"]
ENTRYPOINT ["node"]