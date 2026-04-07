FROM n8nio/n8n:stable

USER root
WORKDIR /home/node
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["tini", "--"]
CMD ["/entrypoint.sh"]