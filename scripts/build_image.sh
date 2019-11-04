#!/bin/sh

PATH_ENV="scripts/env.sh"
if [ ! -f $PATH_ENV ]
then
	echo "Script not found: $PATH_ENV"
	exit 1
fi
source $PATH_ENV

echo "Building docker image $IMAGE_NAME from file $PATH_NGINX_DOCKERFILE"
docker build -t "$IMAGE_NAME:latest" - < $PATH_NGINX_DOCKERFILE &&
exit 0

exit 1
