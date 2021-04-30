ALTER USER 'root'@'localhost' IDENTIFIED VIA mysql_native_password USING PASSWORD('foobar') OR unix_socket;

CREATE DATABASE IF NOT EXISTS foobar;
CREATE DATABASE IF NOT EXISTS prod;

CREATE OR REPLACE TABLE `prod`.`foo_log` (
	id_foo int,
	label varchar(255),
	PRIMARY KEY ( id_foo )
) ENGINE=InnoDB;

CREATE OR REPLACE TABLE `prod`.`foo` (
	id_foo int,
	label varchar(255),
	PRIMARY KEY ( id_foo )
) ENGINE=InnoDB;

INSERT INTO prod.foo_log ( id_foo, label ) VALUES ( 1, 'foobar [#000000]: nothing' );
INSERT INTO prod.foo_log ( id_foo, label ) VALUES ( 2, 'bar [#00ff00]: something awful' );

INSERT INTO prod.foo ( id_foo, label ) VALUES ( 2, 'bar [#ff0000]: something awful' );
INSERT INTO prod.foo ( id_foo, label ) VALUES ( 3, 'bob [#00ff00]: something else' );
