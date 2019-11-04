#!/bin/sh

PATH_ENV="scripts/env.sh"
if [ ! -f $PATH_ENV ]
then
	echo "Script not found: $PATH_ENV"
	exit 1
fi
source $PATH_ENV

elm make src/Main.elm --output="$PATH_ASSETS/main.js" && \
exit 0

exit 1
