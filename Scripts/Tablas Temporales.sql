-- CREACION DE TABLAS TEMPORALES 

-- Persistencia de movie_dataset formateando crew
DROP TABLE IF EXISTS movie_dataset_cleaned ;
CREATE TABLE movie_dataset_cleaned  AS
SELECT 
	`index`, budget, genres, homepage, id, keywords, original_language, original_title, overview, popularity, 
	 production_companies, production_countries, release_date, revenue, runtime, spoken_languages, `status`, 
	 tagline, title, vote_average, vote_count, cast, director,  
	CONVERT(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Crew,
	 		"""", "'"), 
	 		"', '", """, """), 
	 		"': '", """: """), 
	 		"': ", """: "), 
	 		", '", ", """), 
	 		"{'", "{""") 
	 	using utf8mb4) AS Crew
		FROM movie_dataset ;
ALTER TABLE movie_dataset_cleaned  ADD Primary Key (id) ;
		
        
-- Borrar si existe una versión anterior (re-crear el procedimiento)
DROP PROCEDURE IF EXISTS Json2Relational_production_companies ;
DELIMITER //
CREATE PROCEDURE Json2Relational_production_companies()
BEGIN
	DECLARE a INT Default 0 ;
	
	-- crear tabla temporal para almacenar datos de pdocuction_companies que están en JSON
	DROP TABLE IF EXISTS tmp_production_companies ;
	CREATE TABlE tmp_production_companies (id_movie INT, id_production_company INT, name_production_company VARCHAR (100) );
	
	-- ciclo repetitivo para ir cargando datos desde el arreglo JSON hacia la tabla temporal
  simple_loop: LOOP

    -- cargando datos del objeto JSON en la tabla temporal 
		INSERT INTO tmp_production_companies (id_movie, id_production_company, name_production_company)  
		SELECT id as id_Movie, 
			JSON_EXTRACT(CONVERT(production_companies using utf8mb4), CONCAT("$[",a,"].id")) AS id_production_company,
			JSON_EXTRACT(CONVERT(production_companies using utf8mb4), CONCAT("$[",a,"].name")) AS id_production_company
		FROM movie_dataset m ; 
			SET a=a+1;	
     	IF a=10 THEN
            LEAVE simple_loop;
      END IF;
   END LOOP simple_loop;
   -- limpieza de registros nulos
   -- 43820 tuplas en tmp_production_companies
   DELETE FROM tmp_production_companies WHERE id_production_company IS NULL ;
   -- 12156 tuplas en tmp_production_companies
END //
DELIMITER ;


-- Borrar si existe una versión anterior (re-crear el procedimiento)
DROP PROCEDURE IF EXISTS Json2Relational_production_countries ;
DELIMITER //
CREATE PROCEDURE Json2Relational_production_countries()
BEGIN
	DECLARE a INT Default 0 ;
	
	-- crear tabla temporal para almacenar datos de pdocuction_companies que están en JSON
	DROP TABLE IF EXISTS tmp_production_countries ;
	CREATE TABlE tmp_production_countries (id_movie INT, iso_3166_1 VARCHAR (5), country VARCHAR (100) );
	
	-- [{"iso_3166_1": "US", "name": "United States of America"}]
	
	-- ciclo repetitivo para ir cargando datos desde el arreglo JSON hacia la tabla temporal
  simple_loop: LOOP

    -- cargando datos del objeto JSON en la tabla temporal 
		INSERT INTO tmp_production_countries (id_movie, iso_3166_1, country)  
		SELECT id as id_Movie, 
			JSON_EXTRACT(CONVERT(production_countries using utf8mb4), CONCAT("$[",a,"].iso_3166_1")) AS iso_3166_1,
			JSON_EXTRACT(CONVERT(production_countries using utf8mb4), CONCAT("$[",a,"].name")) AS country
		FROM movie_dataset m ; 
			SET a=a+1;	
     	IF a=10 THEN
            LEAVE simple_loop;
      END IF;
   END LOOP simple_loop;
   -- limpieza de registros nulos
   -- xyz tuplas en tmp_production_countries
   DELETE FROM tmp_production_countries WHERE iso_3166_1 IS NULL ;
   -- 5783 tuplas en tmp_production_countries
END //
DELIMITER ;


-- Borrar si existe una versión anterior (re-crear el procedimiento)
DROP PROCEDURE IF EXISTS Json2Relational_spoken_languages ;
DELIMITER //
CREATE PROCEDURE Json2Relational_spoken_languages()
BEGIN
	DECLARE a INT Default 0 ;
	
	-- crear tabla temporal para almacenar datos de pdocuction_companies que están en JSON
	DROP TABLE IF EXISTS tmp_spoken_languages ;
	CREATE TABlE tmp_spoken_languages (id_movie INT, iso_639_1 VARCHAR (5), `language` VARCHAR (100) );
	
	-- [{"iso_639_1": "en", "name": "English"}]
	
	-- ciclo repetitivo para ir cargando datos desde el arreglo JSON hacia la tabla temporal
  simple_loop: LOOP

    -- cargando datos del objeto JSON en la tabla temporal 
		INSERT INTO tmp_spoken_languages (id_movie, iso_639_1, `language`)  
		SELECT id as id_Movie, 
			JSON_EXTRACT(CONVERT(spoken_languages using utf8mb4), CONCAT("$[",a,"].iso_639_1")) AS iso_639_1,
			JSON_EXTRACT(CONVERT(spoken_languages using utf8mb4), CONCAT("$[",a,"].name")) AS language
		FROM movie_dataset m ; 
			SET a=a+1;	
     	IF a=10 THEN
            LEAVE simple_loop;
      END IF;
   END LOOP simple_loop;
   -- limpieza de registros nulos
   -- xyz tuplas en tmp_spoken_languages
   DELETE FROM tmp_spoken_languages WHERE iso_639_1 IS NULL ;
   -- 6103 tuplas en tmp_spoken_languages
END //
DELIMITER ;

-- Borrar si existe una versión anterior (re-crear el procedimiento)
DROP PROCEDURE IF EXISTS Json2Relational_crew ;
DELIMITER //
CREATE PROCEDURE Json2Relational_crew()
BEGIN
	DECLARE a INT Default 0 ;
	-- crear tabla temporal para almacenar datos de pdocuction_companies que están en JSON
	DROP TABLE IF EXISTS tmp_crew;
	CREATE TABlE tmp_crew 
	  (id_movie INT, id_crew INT, job VARCHAR (200), name VARCHAR (400), gender INT, credit_id VARCHAR (50), department VARCHAR (50) );

   simple_loop: LOOP

    -- cargando datos del objeto JSON en la tabla temporal 
		INSERT INTO tmp_crew (id_movie, id_crew, job, name, gender, credit_id, department)  
		SELECT id as id_Movie, 
			JSON_EXTRACT(CONVERT(crew using utf8mb4), CONCAT("$[",a,"].id")) AS id_crew,
			JSON_EXTRACT(CONVERT(crew using utf8mb4), CONCAT("$[",a,"].job")) AS job,
			JSON_EXTRACT(CONVERT(crew using utf8mb4), CONCAT("$[",a,"].name")) AS name,
			JSON_EXTRACT(CONVERT(crew using utf8mb4), CONCAT("$[",a,"].gender")) AS gender,
			JSON_EXTRACT(CONVERT(crew using utf8mb4), CONCAT("$[",a,"].credit_id")) AS credit_id,
			JSON_EXTRACT(CONVERT(crew using utf8mb4), CONCAT("$[",a,"].department")) AS department
		FROM movie_dataset_cleaned m 
		WHERE id IN (SELECT id FROM movie_dataset_cleaned WHERE a <= JSON_LENGTH (crew) ); 
		
		SET a=a+1;	
     	IF a=436 THEN
            LEAVE simple_loop;
      END IF;
   END LOOP simple_loop;
   -- limpieza de registros nulos
   -- xyz tuplas en tmp_crew
   DELETE FROM tmp_crew WHERE id_crew IS NULL ;
   --  tuplas en tmp_crew
END //
DELIMITER ;

Call Json2Relational_production_countries(); 
Call Json2Relational_spoken_languages();
Call Json2Relational_crew();


DROP TABLE IF EXISTS tmp_MOVIES ;
CREATE TABLE tmp_MOVIES AS 
SELECT DISTINCT `index`, budget, genres, homepage, id, keywords, original_language, original_title, overview, popularity, 
	 production_companies, production_countries, release_date, revenue, runtime, spoken_languages, `status`, 
	 tagline, title, vote_average, vote_count, cast, director  
FROM movie_dataset_cleaned ;
ALTER TABLE tmp_MOVIES ADD PRIMARY KEY (id);

ALTER TABLE tmp_crew ADD PRIMARY KEY (id_movie, credit_id) ;

DROP TABLE IF EXISTS tmp_CREDITS ;
CREATE TABLE tmp_CREDITS AS 
SELECT DISTINCT credit_id, id_crew, job, name, gender, department 
FROM tmp_crew ;
ALTER TABLE tmp_CREDITS 
ADD PRIMARY KEY (credit_id) ;

DROP TABLE IF EXISTS MOVIES_CREW ;
CREATE TABLE MOVIES_CREW AS 
SELECT DISTINCT id_movie, credit_id
FROM tmp_crew ;
ALTER TABLE MOVIES_CREW ADD PRIMARY KEY (id_movie, credit_id) ;

DROP TABLE IF EXISTS CREDITS ;
CREATE TABLE CREDITS AS 
SELECT DISTINCT credit_id, id_crew, job, department
FROM tmp_crew ;
ALTER TABLE CREDITS ADD PRIMARY KEY (credit_id) ;


UPDATE tmp_crew 
SET name = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(name, '\\\\u00e9', 'é'), '\\\\u00e1', 'á'), '\\\\u00f1', 'ñ'), '\\\\u00c9', 'É'), """'", """"), "'""", """")  
WHERE id_crew IN (223, 492, 2424, 4710, 6057, 7475, 7998, 8928, 8965, 10054, 10907, 11218, 11425, 11711, 14192, 14351, 16337, 16734, 17002, 17829, 20296, 20719, 23867, 24530, 24840, 24890, 25460, 30711, 34512, 37299, 39923, 40766, 51897, 52576, 54387, 59528, 69987, 79790, 91854, 92237, 119178, 571434, 582915, 935493, 958087, 960435, 1002096, 1037310, 1042814, 1160347, 1177771, 1177850, 1187337, 1275131, 1293479, 1308742, 1309482, 1316104, 1323112, 1325887, 1331893, 1331979, 1334494, 1367821, 1380004, 1384359, 1384365, 1384396, 1384399, 1387252, 1391751, 1392113, 1393324, 1394130, 1394756, 1394775, 1398092, 1398930, 1398935, 1399305, 1402017, 1406584, 1406844, 1408839, 1409724, 1411340, 1411357, 1413224, 1418485, 1420154, 1421652, 1421662, 1425500, 1425503, 1428842, 1431015, 1434221, 1436493, 1442151, 1447119, 1458084, 1459935, 1461401, 1462845, 1464445, 1537245, 1548959, 1550774, 1560107, 1561353, 1564469, 1564484, 1571046, 1574642, 1574652, 1595472, 1613316, 1618901, 1693479, 1708290, 1764736, 1831266) ;
-- IN ( SELECT id_crew FROM (SELECT DISTINCT id_crew, name, gender FROM tmp_crew ) t GROUP BY id_crew  HAVING COUNT(*) > 1 ) ;


DROP TABLE IF EXISTS CREW ;
CREATE TABLE CREW AS 
SELECT DISTINCT id_crew, name, gender
FROM tmp_crew ;
ALTER TABLE CREW ADD PRIMARY KEY (id_crew) ;
-- Borrar tabla temporal 
DROP TABLE IF EXISTS tmp_CREDITS ;


DROP TABLE IF EXISTS tmp_NF2 ;
CREATE TABLE tmp_NF2 AS 
SELECT tmp_MOVIES.*, 
	t.id_production_company, t.name_production_company 
FROM tmp_MOVIES,  tmp_production_companies t
WHERE tmp_MOVIES.id = t.id_movie ;

-- PK: id_production_company 
DROP TABLE IF EXISTS PRODUCTION_COMPANIES ;
CREATE TABLE PRODUCTION_COMPANIES AS
SELECT DISTINCT id_production_company, name_production_company
FROM tmp_NF2;

-- PK: id,  id_production_company
DROP TABLE IF EXISTS MOVIES_PRODUCTION_COMPANIES ;
CREATE TABLE MOVIES_PRODUCTION_COMPANIES AS 
SELECT id,  id_production_company
FROM tmp_NF2;

-- tmp_NF3 join PRODUCTION_COUNTRIES
DROP TABLE IF EXISTS tmp_NF3 ;
CREATE TABLE tmp_NF3 AS 
SELECT tmp_NF2.*, 
	t.iso_3166_1, t.country 
FROM tmp_NF2,  tmp_production_countries t
WHERE tmp_NF2.id = t.id_movie ;

-- Borrar si existe una versión anterior (re-crear el procedimiento)
DROP PROCEDURE IF EXISTS Json2Relational_genres ;
DELIMITER //
CREATE PROCEDURE Json2Relational_genres()
BEGIN
	DECLARE a INT Default 0 ;
	
	-- crear tabla temporal para almacenar datos de pdocuction_companies que están en JSON
	DROP TABLE IF EXISTS tmp_genres ;
	CREATE TABlE tmp_genres (id_movie INT, genre VARCHAR (100) );
	
	-- ["Action", "Thriller", "Science", "Fiction", "Adventure"]
	
	-- ciclo repetitivo para ir cargando datos desde el arreglo JSON hacia la tabla temporal
  simple_loop: LOOP

    -- cargando datos del objeto JSON en la tabla temporal 
		INSERT INTO tmp_genres (id_movie, genre)  
		SELECT id as id_Movie, 
			JSON_EXTRACT(CONCAT('["', REPLACE(REPLACE (genres, ' ', '","'), 'Science","Fiction', 'Science Fiction'), '"]'), CONCAT("$[",a,"]")) AS genre
		FROM movie_dataset_cleaned m ; 
			SET a=a+1;	
     	IF a=6 THEN
            LEAVE simple_loop;
      END IF;
   END LOOP simple_loop;
   -- limpieza de registros nulos
   -- xyz tuplas en tmp_spoken_languages
   DELETE FROM tmp_genres WHERE genre IS NULL ;
   -- xyz tuplas en tmp_spoken_languages
END //
DELIMITER ;
Call Json2Relational_genres();

-- Borrar si existe una versión anterior (re-crear el procedimiento)
DROP PROCEDURE IF EXISTS Json2Relational_genres ;
DELIMITER //
CREATE PROCEDURE Json2Relational_genres()
BEGIN
	DECLARE a INT Default 0 ;
	
	-- crear tabla temporal para almacenar datos de pdocuction_companies que están en JSON
	DROP TABLE IF EXISTS tmp_genres ;
	CREATE TABlE tmp_genres (id_movie INT, genre VARCHAR (100) );
	
	-- ciclo repetitivo para ir cargando datos desde el arreglo JSON hacia la tabla temporal
  simple_loop: LOOP

    -- cargando datos del objeto JSON en la tabla temporal 
		INSERT INTO tmp_genres (id_movie, genre)  
		SELECT id as id_Movie, 
			JSON_EXTRACT(CONCAT('["', REPLACE(REPLACE(genres, ' ', '","'), 'Science","Fiction', 'Science Fiction'), '"]'), CONCAT("$[",a,"]")) AS genre
		FROM tmp_MOVIES m ; 
			SET a=a+1;	
     	IF a=10 THEN
            LEAVE simple_loop;
      END IF;
   END LOOP simple_loop;
   -- limpieza de registros nulos
   --  tuplas en Json2Relational_genres
   DELETE FROM tmp_genres WHERE genre IS NULL ;
   --  tuplas en Json2Relational_genres
END //
DELIMITER ;

Call Json2Relational_genres();

-- Creación de tabla que relaciona películas con directores
DROP TABLE IF EXISTS MOVIES_DIRECTORS;
CREATE TABLE MOVIES_DIRECTORS AS

SELECT m.id, m.director Movie_id, c.*
FROM (SELECT id, REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(director, '\\u00e9', 'é'), '\\u00e1', 'á'), '\\u00f1', 'ñ'), '\\u00c9', 'É'), """'", """"), "'""", """") AS director 
       FROM movie_dataset) m 
     LEFT JOIN 
     (SELECT id_crew, REPLACE(name, '"', '') as name, gender FROM crew ) c 
	ON m.director = c.name ;

