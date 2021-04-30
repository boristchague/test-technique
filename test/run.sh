#!/bin/bash

REMOTE_IP="$1"

function waitMainProcess {
	for i in `seq 1 30`; do
		local PROCESS=$(ps -p 1 -o cmd=)
		
		if [ "$PROCESS" = "mysqld" ]; then
			echo "MYSQLD as main process ( after $i s )"
			return 0
		else
			sleep 1
		fi
	done
	
	echo `date`" Main MYSQLD process didn't start after $i s, exiting"
	return 1
}

function waitDatabase {
	DEFAULT_FILE="$1"
	
	for i in `seq 1 180`; do	
		if mysql -e "SHOW DATABASES" foobar >/dev/null 2>/dev/null
		then
			echo "SHOW DATABASES ( after $i s )"
			return 0
		else
			sleep 1
		fi
	done
	
	echo `date`" No DATABASE foobar after $i s, exiting"
	return 1
}

# ######################################################

if ! waitMainProcess; then
	exit 1
fi

if ! waitDatabase; then
	exit 1
fi

printf "%s\t%s\n" "$REMOTE_IP" "foobar.wtf" >> /etc/hosts

# ######################################################

/src/run.sh

# ######################################################

mysql mysql -s <<< 'CREATE DATABASE IF NOT EXISTS tests;

CREATE TABLE IF NOT EXISTS tests.results (
	id int unsigned AUTO_INCREMENT,
	pass tinyint unsigned DEFAULT 0,
	msg varchar(255),
	PRIMARY KEY ( id )
) ENGINE=InnoDB;'


for filename in $( ls --color=no /src/test/cases | sort)
do
	printf "CASE: %s\n" $filename
	mysql mysql < "/src/test/cases/$filename"
done

# ######################################################

mysql tests -e "SELECT * FROM tests.results;"
FAILED=$(mysql tests -s -e "SELECT count(*) FROM tests.results WHERE pass = 0;")

if [ "$FAILED" -gt "0" ]
then
	printf "FAILED to pass.\n\n"
	exit 1
fi

exit 0