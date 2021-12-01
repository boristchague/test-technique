# Test Technique

## 0. Introduction

Bonjour, merci à vous de prendre le temps de participer à ce test technique.

Ce test a pour but d'évaluer votre capacité à répondre aux exigences suivantes :
- Être capable de comprendre l'existant
- Etre capable de travailler en autonomie, et donc de comprendre un besoin utilisateur pour proposer une solution adaptée à celui-ci.
- Être capable d'écrire des tests afin d'assurer l'exactitude des résultats.

Ce test ne cherche pas spécifiquement à évaluer votre compétence avec un langage donné. Il n'est donc pas spécialement limité dans le temps, de plus vous pouvez utiliser toute documentation à votre disposition ( ce qui inclut Google ). De plus, bien que le projet lié à ce test puisse normalement être exécuté dans un environnement Linux, l'exécuter ne devrait pas être nécessaire pour répondre aux différentes questions.

Finalement, si vous avez davantage de facilités à répondre en anglais, les réponses en anglais seront acceptées.

## 1. Comprendre l'existant

Comme vous l'avez sans doute constaté, ce fichier est inclus dans un projet. 

- Pourriez vous expliquer le fonctionnement général de ce projet ?
- Dans quel environnement de production ce projet sera-t-il déployé ?
- Quel est le point d'entrée du projet ?
- Comment sont sélectionnés les fichiers à exécuter ?
- Quels sont les fichiers procédant à des écritures de données ?
- Quelles sont les données écrites ?
- Des données pré-existantes sont-elles modifiées ? Si oui, lesquels ?
- Ce projet a-t-il des sources de données extérieures ? Si oui, lesquels ?

Vous êtes également invité à communiquer toutes remarques supplémentaires que vous auriez à faire sur ce projet.

## 2. Travailler à partir d'un besoin utilisateur

Veuillez considérer les trois tables suivantes :

```sql
CREATE OR REPLACE TABLE passeport (
	id int unsigned,
	PRIMARY KEY(id)
) ENGINE=InnoDB;

-- +----+
-- | id |
-- +----+
-- |  1 |
-- |  2 |
-- +----+

CREATE OR REPLACE TABLE pays (
	id int unsigned,
	name varchar(255) default null,
	PRIMARY KEY(id)
) ENGINE=InnoDB;

-- +----+-----------+
-- | id | name      |
-- +----+-----------+
-- |  1 | france    |
-- |  2 | allemagne |
-- |  3 | uk        |
-- +----+-----------+

CREATE OR REPLACE TABLE tampons (
	id int unsigned AUTO_INCREMENT,
	id_passeport int unsigned,
	id_pays int unsigned,
	_creation_date datetime,
	PRIMARY KEY(id),
	CONSTRAINT `fk_tampons_passeport` FOREIGN KEY (id_passeport) REFERENCES passeport (id),
	CONSTRAINT `fk_tampons_pays` FOREIGN KEY (id_pays) REFERENCES pays (id)
) ENGINE=InnoDB;

-- +----+-------------+---------+---------------------+
-- | id | id_passeport | id_pays | _creation_date      |
-- +----+-------------+---------+---------------------+
-- |  1 |           1 |       1 | 2020-01-01 00:00:00 |
-- |  2 |           1 |       2 | 2020-02-01 00:00:00 |
-- |  3 |           1 |       1 | 2020-03-01 00:00:00 |
-- |  4 |           1 |       3 | 2020-04-01 00:00:00 |
-- |  5 |           2 |       1 | 2020-01-01 00:00:00 |
-- |  6 |           2 |       3 | 2020-02-01 00:00:00 |
-- +----+-------------+---------+---------------------+
```

Votre clients vous demande de rendre ces données plus faciles à analyser, notamment pour en extraire les analyses suivantes :
- temps moyen entre deux premières entrées dans deux pays. (ex: en moyenne une personne entrée pour la première fois au Royaume-Unis rentre pour la première fois en France 652 jours après. )
- % des personnes entrées au moins une fois dans un pays entrant ultérieurement dans un autre pays. (ex: 3% des personnes entrées en France sont par la suite entrées en Allemagne, 10% au Royaume-Uni, 1% en Allemagne ET au Royaume-Uni. )
- % des passeports étant déjà entrés au moins une fois dans une liste de pays. ( ex : combien sont déjà allés en France et Allemagne sans aller au Royaume-Uni )

Quel format de données proposeriez vous à votre client ? Écrire du code n'est pas nécessaire, vous pouvez juste proposer un schéma de table.

## 3. Ecriture de tests

Si vous deviez écrire les tests unitaires pour le code SQL suivant, quels tests écririez-vous ? Vous n'avez pas besoin d'écrire du code, juste de lister les différents cas et résultats que vous comptez tester.

```sql
INSERT INTO books (
	id,
	id_author,
	type,
	title
)
SELECT
b.id,
COALESCE(da.id_author, a.id_author),
'hardcover',
b.title
FROM _books b
LEFT JOIN _dead_author da ON b.author = da.name
LEFT JOIN _author a 
	ON da.id_author IS NULL
	AND b.author = a.name
WHERE b._creation_date <= '1950-01-01 00:00:00';

INSERT INTO books (
	id,
	id_author,
	type,
	title
)
SELECT
b.id,
COALESCE(a.id_author, da.id_author),
b.type,
b.title
FROM _books b
LEFT JOIN _author a ON b.author = a.name
LEFT JOIN _dead_author da 
	ON a.id_author IS NULL
	AND b.author = da.name
WHERE b._creation_date > '1950-01-01 00:00:00';
```

Des données d'exemple :

```sql
CREATE OR REPLACE TABLE _books (
	id int unsigned,
	author varchar(255),
	type varchar(255) default null,
	title varchar(255) default null,
	_creation_date datetime,
	PRIMARY KEY(id)
) ENGINE=InnoDB;

CREATE OR REPLACE TABLE _dead_author (
	id_author int unsigned,
	name varchar(255) default null,
	PRIMARY KEY(id_author)
) ENGINE=InnoDB;

CREATE OR REPLACE TABLE _author (
	id_author int unsigned,
	name varchar(255) default null,
	PRIMARY KEY(id_author)
) ENGINE=InnoDB;

CREATE OR REPLACE TABLE books (
	id int unsigned,
	id_author int unsigned,
	type varchar(255),
	title varchar(255),
	PRIMARY KEY(id)
) ENGINE=InnoDB;


INSERT INTO _author VALUES (1, 'foobar'), (2, 'voltair');
INSERT INTO _dead_author VALUES (10, 'voltair'), (11, 'platon');
INSERT INTO _books VALUES (1, 'foobar', 'virtual', 'something awful', '2020-01-01 00:00:00');
INSERT INTO _books VALUES (2, 'foobar', 'virtual', 'something else', '1920-01-01 00:00:00');
INSERT INTO _books VALUES (3, 'voltair', 'virtual', 'really awful', '2020-01-01 00:00:00');
INSERT INTO _books VALUES (4, 'voltair', 'virtual', 'really awesome', '1920-01-01 00:00:00');
INSERT INTO _books VALUES (5, 'platon', 'virtual', '2020', '2020-01-01 00:00:00');
INSERT INTO _books VALUES (6, 'platon', 'virtual', '1920', '1920-01-01 00:00:00');

-- Nos deux requêtes

SELECT * FROM books;
-- +----+-----------+-----------+-----------------+
-- | id | id_author | type      | title           |
-- +----+-----------+-----------+-----------------+
-- |  1 |         1 | virtual   | something awful |
-- |  2 |         1 | hardcover | something else  |
-- |  3 |         2 | virtual   | really awful    |
-- |  4 |        10 | hardcover | really awesome  |
-- |  5 |        11 | virtual   | 2020            |
-- |  6 |        11 | hardcover | 1920            |
-- +----+-----------+-----------+-----------------+
```

## 4. Ecriture de code

Sauriez vous générer 10 millions d'entrées de test pour la table suivante ?
- Point bonus si vous les répartisez sur 6 types differents.
- Point bonus si vous les répartisez de façon déterministe.

```sql
CREATE OR REPLACE TABLE `foobar`.`trucs` (
	id_truc int,
	type varchar(255),
	msg varchar(255),
	PRIMARY KEY ( id_truc )
) ENGINE=InnoDB;
```

