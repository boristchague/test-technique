#!/bin/bash

echo " __  __ _       _                        _           _   "
echo "|  \/  (_)     (_)                      (_)         | |  "
echo "| \  / |_ _ __  _ ______ _ __  _ __ ___  _  ___  ___| |_ "
echo "| |\/| | | '_ \| |______| '_ \| '__/ _ \| |/ _ \/ __| __|"
echo "| |  | | | | | | |      | |_) | | | (_) | |  __/ (__| |_ "
echo "|_|  |_|_|_| |_|_|      | .__/|_|  \___/| |\___|\___|\__|"
echo "                        | |            _/ |              "
echo "                        |_|           |__/              "


DIR=$( realpath $( dirname "${BASH_SOURCE[0]}" ) )

function Log {
	echo $@
}

function Inject {
	local filename="$1"
	
	printf "Injecting %s\n" $filename
	
	mysql -e "source $filename;" foobar
}

function Execute {
	local filename="$1"
	
	printf "Executing %s\n" $filename
	
	$filename
}

for filename in $( ls --color=no $DIR/run | sort)
do
	extension="${filename##*.}"
	
	case $extension in
		sql) Inject "$DIR/run/$filename";;
		sh) Execute "$DIR/run/$filename";;
		*) Log "Unsupported extension: $DIR/run/$filename -- Skipping";;
	esac
done
