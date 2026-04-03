FROM n8nio/n8n:stable

USER root
WORKDIR /home/node
ENTRYPOINT []
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
CMD ["/bin/sh", "/entrypoint.sh"]