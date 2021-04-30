
CREATE TEMPORARY TABLE tests.expected (
	id_foo int,
	type varchar(255),
	color varchar(255)
) ENGINE=InnoDB;

INSERT INTO tests.expected ( id_foo, type, color ) VALUES 
( 1, 'foobar', '#000000' ),
( 2, 'bar', '#ff0000' ),
( 3, 'bob', '#00ff00' );

INSERT INTO tests.results ( pass, msg )
SELECT
( ch.id_foo IS NOT NULL ) as pass,
CONCAT(
	IF(ch.id_foo IS NULL, 'NO', 'FOUND'),
	' foo with type ',
	ex.type,
	' and color ',
	ex.color
) as message
FROM tests.expected ex
LEFT JOIN `foobar`.foo ch 
	ON ch.id_foo <=> ex.id_foo
	AND ch.type <=> ex.type
	AND ch.color <=> ex.color;


