#!/bin/bash

if [ ! -f .releaserc.json ]
then
  echo "#### Copping default .releaserc.json"
  cp -f /opt/semantic/.releaserc.json .
else
  echo "#### Merging .releaserc.json"
  node /opt/semantic/merge.js
fi

git rev-parse --git-dir

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