FROM node:8.14.0-alpine as basis

WORKDIR /opt/iot-agent

RUN apk add git python make bash gcc g++ zeromq-dev musl-dev zlib-dev krb5-dev --no-cache

COPY package.json .
COPY package-lock.json .

RUN npm install
COPY . .

FROM node:8.14.0-alpine
RUN apk add --no-cache tini
ENTRYPOINT ["/sbin/tini", "--"]

COPY --from=basis  /opt/iot-agent /opt/iot-agent
WORKDIR /opt/iot-agent
COPY . .


EXPOSE 1883
CMD ["node", "index.js"]
