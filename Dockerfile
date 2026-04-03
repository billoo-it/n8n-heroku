FROM n8nio/n8n:stable

USER root
WORKDIR /home/node
COPY ./entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh