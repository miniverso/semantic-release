#!/bin/bash

if [ ! -f .releaserc ]
then
  cp -f /opt/semantic/.releaserc .
fi

case $1 in
run)
  node /opt/semantic/node_modules/semantic-release/bin/semantic-release.js ;;
deploy)
  /opt/semantic/scripts/skipDeploy.sh ;;
build)
  /opt/semantic/scripts/skipBuild.sh ;;
*)
  node /opt/semantic/node_modules/semantic-release/bin/semantic-release.js -d --no-ci ;;
esac