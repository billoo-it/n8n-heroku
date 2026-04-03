FROM n8nio/n8n:stable

USER root
WORKDIR /home/node
ENTRYPOINT []
COPY --chmod=755 entrypoint.sh /entrypoint.sh
CMD ["/bin/sh", "/entrypoint.sh"]