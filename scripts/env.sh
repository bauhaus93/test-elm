#!/bin/sh

IMAGE_NAME="nginx-elm"
PATH_NGINX_CONF="$PWD/nginx/"
PATH_NGINX_DOCKERFILE="$PWD/nginx/Dockerfile"
PATH_ASSETS="$PWD/assets"
PATH_WORKSPACE="$PWD/workspace-frontend"

PATH_WORKSPACE_WWW="$PATH_WORKSPACE/www"
PATH_WORKSPACE_LOGS="$PATH_WORKSPACE/logs"
PATH_WORKSPACE_NGINX_CONF="$PATH_WORKSPACE/conf"

if [ ! -f $PATH_NGINX_DOCKERFILE ]
then
	echo "Dockerfile not existing: $PATH_NGINX_DOCKERFILE"
	exit 1
fi

if [ ! -d $PATH_ASSETS ]
then
	echo "Assets not existing: $PATH_ASSETS"
	exit 1
fi

if [ ! -d $PATH_NGINX_CONF ]
then
	echo "Nginx.conf not existing: $PATH_NGINX_CONF"
	exit 1
fi
