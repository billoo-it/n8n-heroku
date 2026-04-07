FROM n8nio/n8n:stable

USER root
COPY entrypoint.sh /heroku-entrypoint.sh
RUN chmod +x /heroku-entrypoint.sh
ENTRYPOINT []
CMD ["sh", "/heroku-entrypoint.sh"]