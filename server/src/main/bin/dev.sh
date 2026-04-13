#!/bin/bash

set -e

ROOT_DIR=$(cd "$(dirname "$0")/../../../.." || exit 1; pwd)
SERVER_DIR="$ROOT_DIR/server"

if [ -n "$JAVA_HOME" ]; then
  export PATH="$JAVA_HOME/bin:$PATH"
fi

cd "$SERVER_DIR" || exit 1

mvn spring-boot:run \
  -Dspring-boot.run.addResources=true \
  -Dspring-boot.run.jvmArguments="-Dfile.encoding=UTF-8 -Dspring.config.location=$SERVER_DIR/src/main/config/application.properties"
