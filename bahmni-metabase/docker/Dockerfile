FROM metabase/metabase:v0.44.6
RUN apk update && apk add curl jq
COPY scripts /app/scripts
RUN chmod +x /app/scripts/*.sh
ENTRYPOINT ["/bin/bash", "/app/scripts/metabase_startup.sh"]