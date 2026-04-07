FROM n8nio/n8n:stable

USER root
WORKDIR /home/node
COPY ./entrypoint.sh /entrypoint.sh
RUN tr -d '\r' < /entrypoint.sh > /tmp/ep.sh && mv /tmp/ep.sh /entrypoint.sh && chmod +x /entrypoint.sh
ENTRYPOINT ["tini", "--"]
CMD ["/entrypoint.sh"]