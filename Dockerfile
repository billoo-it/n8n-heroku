FROM node:22-alpine

RUN apk add --no-cache git openssh tini tzdata ca-certificates
RUN npm install -g n8n

COPY entrypoint.sh /heroku-entrypoint.sh
RUN chmod +x /heroku-entrypoint.sh

ENTRYPOINT []
CMD ["sh", "/heroku-entrypoint.sh"]