#!/usr/bin/env bash

PROJECT_DIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

docker run -it --rm \
  --env AWS_VAULT=$AWS_VAULT \
  --env AWS_REGION=$AWS_REGION \
  --env AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION \
  --env AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
  --env AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
  --env AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN \
  --env AWS_CREDENTIAL_EXPIRATION=$AWS_CREDENTIAL_EXPIRATION \
  --volume $PROJECT_DIR:/workdir \
  --volume ~/.aws/:/root/.aws/:ro \
  --workdir /workdir \
  terraform bash
