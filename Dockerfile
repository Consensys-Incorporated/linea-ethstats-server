FROM node:24.22.1-alpine AS builder
ARG GRUNT_TASK=default
WORKDIR /ethstats-server
COPY ["package.json", "package-lock.json*", "./"]
RUN npm ci --only=production && npm install -g grunt-cli
COPY --chown=node:node . .
RUN grunt $GRUNT_TASK

FROM node:24.22.1-alpine
RUN apk add dumb-init
WORKDIR /ethstats-server
COPY --chown=node:node --from=builder /ethstats-server .
USER node
EXPOSE  3000
CMD ["dumb-init", "node", "./bin/www"]
