
CREATE OR REPLACE TEMPORARY TABLE `foobar`.`foo_tmp` (
	id_line int unsigned auto_increment,
	id_foo int,
	type varchar(255),
	color varchar(255),
	PRIMARY KEY ( id_line )
) ENGINE=InnoDB;

INSERT INTO foobar.foo_tmp ( id_foo, type, color )
SELECT
a.id_foo,
TRIM(REGEXP_SUBSTR(a.header, '^[^\\[]+')) as type,
TRIM(SUBSTR(REGEXP_SUBSTR(a.header, '\\[[^\]]+'), 2)) as color
FROM (
	SELECT
	id_foo,
	TRIM(REGEXP_SUBSTR(label, '^[^:]+')) as header
	FROM prod.foo_log
) a;

INSERT INTO foobar.foo_tmp ( id_foo, type, color )
SELECT
a.id_foo,
TRIM(REGEXP_SUBSTR(a.header, '^[^\\[]+')) as type,
TRIM(SUBSTR(REGEXP_SUBSTR(a.header, '\\[[^\]]+'), 2)) as color
FROM (
	SELECT
	id_foo,
	TRIM(REGEXP_SUBSTR(label, '^[^:]+')) as header
	FROM prod.foo
) a;

INSERT INTO `foobar`.`foo`
SELECT
s.id_foo,
s.type,
s.color
FROM (
	SELECT MAX(id_line) as id_line FROM `foobar`.`foo_tmp` GROUP BY id_foo
) m
JOIN `foobar`.`foo_tmp` s ON s.id_line = m.id_line;

