FROM node:18

WORKDIR /opt/semantic
ADD . .
RUN yarn

WORKDIR /opt/app
ENTRYPOINT ["/opt/semantic/scripts/entrypoint.sh"]