FROM node:20.12.1

WORKDIR /opt/semantic
ADD . .
RUN yarn && git config --global --add safe.directory /opt/app
WORKDIR /opt/app
ENTRYPOINT ["/opt/semantic/scripts/entrypoint.sh"]