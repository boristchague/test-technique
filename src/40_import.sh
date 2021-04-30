#!/bin/bash

FILE_NAME=$(mktemp)

curl http://foobar.wtf/trucs.csv >> $FILE_NAME

chgrp mysql "$FILE_NAME"
chmod g+r "$FILE_NAME"

mysql foobar -e "LOAD DATA INFILE '$FILE_NAME' INTO TABLE foobar.trucs FIELDS TERMINATED BY ';' LINES TERMINATED BY '\n' IGNORE 1 LINES"

rm "$FILE_NAME"
