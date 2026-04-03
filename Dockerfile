FROM docker.n8n.io/n8nio/n8n:stable

USER root
WORKDIR /home/node/packages/cli
ENTRYPOINT []
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
CMD ["/entrypoint.sh"]