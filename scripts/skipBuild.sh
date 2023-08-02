#!/bin/bash
SR_LOGFILE=sr-logs.txt
SR_ERROR_LOGFILE=sr-error-logs.txt
node /opt/semantic/node_modules/semantic-release/bin/semantic-release.js -d --no-ci > $SR_LOGFILE 2> $SR_ERROR_LOGFILE

check(){
   BUILD=`grep "$1" $SR_LOGFILE | wc -l | xargs`
   if [ "$BUILD" -eq "1" ]; then
      echo "0";
      exit;
   fi
}

NO_RELEVANT=`grep "There are no relevant changes" $SR_LOGFILE | wc -l | xargs`
if [ "$NO_RELEVANT" -eq "1" ]; then
   echo "1";
   exit;
fi

check "### 🧑‍💻  Teste"
check "### 🏗️  Build"
check "### 🐛  Correção"
check "### 💡  Novidade"
check "### ⚡  Desempenho"
check "### 🎨  Estilização"
check "### 🚧  Refatoração"
check "### 📦  Dependências"

echo "1"
exit