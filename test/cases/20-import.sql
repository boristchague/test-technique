CREATE TEMPORARY TABLE tests.expected (
	id_truc int,
	type varchar(255),
	msg varchar(255)
) ENGINE=InnoDB;

INSERT INTO tests.expected ( id_truc, type, msg ) VALUES 
( 1, 'truc', 'rien' ),
( 2, 'truc', NULL ),
( 3, 'machin', 'quelque chose' );

INSERT INTO tests.results ( pass, msg )
SELECT
( ch.id_truc IS NOT NULL ) as pass,
CONCAT(
	IF(ch.id_truc IS NULL, 'NO', 'FOUND'),
	' import with type ',
	IFNULL(ex.type, 'NULL'),
	' and msg ',
	IFNULL(ex.msg, 'NULL')
) as message
FROM tests.expected ex
LEFT JOIN `foobar`.trucs ch 
	ON ch.id_truc <=> ex.id_truc
	AND ch.type <=> ex.type
	AND ch.msg <=> ex.msg;