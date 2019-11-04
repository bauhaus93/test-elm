#!/bin/sh

PATH_ENV="scripts/env.sh"
if [ ! -f $PATH_ENV ]
then
	echo "Script not found: $PATH_ENV"
	exit 1
fi
source $PATH_ENV

echo "Running container image $IMAGE_NAME"
echo "Mapping $PATH_WORKSPACE_WWW -> /var/www"
echo "Mapping $PATH_WORKSPACE_LOGS -> /var/logs/nginx"
echo "Mapping $PATH_WORKSPACE_NGINX_CONF -> /etc/nginx"

docker run \
	-it --rm \
	-v "$PATH_WORKSPACE_WWW:/var/www" \
	-v "$PATH_WORKSPACE_LOGS:/var/log/nginx" \
	-v "$PATH_WORKSPACE_NGINX_CONF:/etc/nginx" \
	-p 80:80 \
	$IMAGE_NAME
