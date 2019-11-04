#!/bin/sh

PATH_ENV="scripts/env.sh"
if [ ! -f $PATH_ENV ]
then
	echo "Script not found: $PATH_ENV"
	exit 1
fi
source $PATH_ENV

echo "Building workspace in $PATH_WORKSPACE..."
echo "Clearing workspace, if exists..." && \
rm -rfv $PATH_WORKSPACE && \
mkdir -pv $PATH_WORKSPACE $PATH_WORKSPACE_WWW $PATH_WORKSPACE_LOGS $PATH_WORKSPACE_NGINX_CONF && \
cp -v $PATH_NGINX_CONF/nginx.conf $PATH_WORKSPACE_NGINX_CONF/nginx.conf && \
cp -rv "$PATH_ASSETS/." $PATH_WORKSPACE_WWW && \
echo "Built workspace!" && \
exit 0

exit 1
