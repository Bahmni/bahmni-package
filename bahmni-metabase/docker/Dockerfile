FROM metabase/metabase:v0.44.6
RUN apk update && apk add curl jq
COPY scripts /app/scripts
RUN chmod +x /app/scripts/metabase/*.sh
RUN chmod +x /app/scripts/user/*.sh
RUN chmod +x /app/scripts/database/*.sh
RUN chmod +x /app/scripts/reports/*.sh
ENTRYPOINT ["/bin/bash", "/app/scripts/metabase/metabase_startup.sh"]