FROM node:20.19.5-alpine3.21 AS build
WORKDIR /opt/server
COPY package.json .
COPY *.js .
RUN npm install

FROM node:20.19.5-alpine3.22
WORKDIR /opt/server
RUN apk update && \
apk upgrade 
RUN addgroup -S roboshop && adduser -S roboshop -G roboshop
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