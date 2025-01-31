#!/usr/bin/env bash

PROJECT_DIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

docker run -it --rm \
  --volume $PROJECT_DIR:/workdir \
  --volume ~/.aws/:/root/.aws/:ro \
  --workdir /workdir \
  terraform bash
