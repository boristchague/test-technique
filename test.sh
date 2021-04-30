#!/bin/bash

DIR=$( dirname "${BASH_SOURCE[0]}" )
DIR=$( realpath $DIR )

function Cleanup {
	if ! [ -z $MARIADB_CONTAINER ]; then
		if docker ps --no-trunc | grep -q $MARIADB_CONTAINER;  then
			docker stop $MARIADB_CONTAINER
		fi
	fi
}

trap Cleanup EXIT

APACHE_CONTAINER=$(docker run --rm -d \
		--mount "type=bind,src=$DIR/test/remote/,dst=/usr/local/apache2/htdocs/" \
		httpd:2.4)
		
REMOTE_IP=$(docker inspect "$APACHE_CONTAINER" | jq -r '.[0].NetworkSettings.IPAddress')

docker build --file $DIR/test/dockerfile --tag mini-project .

MARIADB_CONTAINER=$(docker run \
	-d \
 	--rm \
	-e MYSQL_ROOT_PASSWORD=foobar \
	-e MYSQL_INITDB_SKIP_TZINFO=true \
	--cap-add=ALL \
	--mount type=bind,src=$DIR,dst=/src \
	--mount type=bind,src=$DIR/test/docker-entrypoint,dst=/docker-entrypoint-initdb.d \
	mini-project)

docker exec -ti $MARIADB_CONTAINER /src/test/run.sh "$REMOTE_IP"

