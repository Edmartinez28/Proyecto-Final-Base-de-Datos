-- Realizamos el traspaso de las tablas temporales a las tablas finales

-- Paso de la tabla movie
INSERT INTO movie
SELECT m.id AS id,
m.budget AS budget,
m.homepage AS homepage,
m.original_language AS originalLanguage,
m.original_title AS originalTitle,
m.overview AS overview,
m.popularity AS popularity,
m.cast AS cast,
m.director AS director,
m.status AS estado
FROM tmp_movies m;

-- Paso de la tabla indice
INSERT INTO indice 
SELECT t.`index` as indice,
t.id as id
FROM tmp_movies t;

-- Paso de la tabla gender
INSERT INTO gender
SELECT DISTINCT g.genre AS "genderName"
FROM tmp_genres g
WHERE g.genre IS NOT NULL;

-- Paso a la tabla MovieGenders
INSERT INTO moviegenders 
SELECT g.id_movie AS "id",
g.genre AS "genderName"
FROM tmp_genres g;

-- Paso a la tabla SpokenLanguages
INSERT INTO spokenlanguages
SELECT DISTINCT l.iso_639_1 as iso639,
l.`language` as `name`
FROM tmp_spoken_languages l;

-- Paso a la tabla Company
INSERT INTO company
SELECT DISTINCT c.id_production_company AS idCompany,
c.name_production_company AS nombre
FROM tmp_production_companies c
WHERE c.id_production_company IS NOT NULL;

-- Paso a la tabla ProductionCountries
INSERT INTO productioncountries
SELECT DISTINCT c.iso_3166_1  AS iso3166,
c.country AS `name`
FROM tmp_production_countries c
WHERE c.iso_3166_1 IS NOT NULL;

-- Paso a la tabla Employee
INSERT INTO employee
SELECT c.id_crew as idEmployee,
c.name as `name`,
c.gender as gender,
c.credit_id as creditId
FROM tmp_crew c;

-- Paso a la tabla OtherTitle
INSERT INTO OtherTitle
SELECT m.id as id,
m.original_title as originalTitle,
m.title as title
FROM movie_dataset_cleaned m;

-- Paso a la tabla Identifiers
INSERT INTO identifiers
SELECT m.id as id,
m.overview as overview,
m.tagline as tagline,
m.keywords as keywords
FROM movie_dataset_cleaned m;

-- Paso a la tabla Posproduction
INSERT INTO posproduction
SELECT m.id AS id,
m.`status` as estado,
m.release_date as relaseDate,
m.revenue as revenue,
m.runtime as runtime,
m.vote_average as voteAverange,
m.vote_count as voteCount
FROM tmp_movies m;

-- Paso a la tabla WorkCrew
INSERT INTO workcrew
SELECT c.credit_id as creditId,
c.department as department,
c.job as job
FROM tmp_crew c;

-- Paso a la tabla MovieLanguages
INSERT INTO movielanguages
SELECT s.id_movie as id,
s.iso_639_1 as iso639
FROM tmp_spoken_languages s;

-- Paso a la tabla MovieFrom
INSERT INTO moviefrom
SELECT mc.id_movie as id,
mc.iso_3166_1 as iso3166
FROM tmp_production_countries mc;

-- Paso a la tabla MovieProducedBy
INSERT INTO movieproducedby
SELECT mc.id as id,
m.id_production_company as idCompany
FROM movies_production_companies mc;

-- Paso a la tabla
INSERT INTO moviecrew
SELECT	mc.id_movie as id,
mc.credit_id as idEmployee
FROM movies_crew mc;


-- ELIMINACION DE LAS TABLAS TEMPORALES
-- DESPUES DEL TRASPASO DE DATOS

DROP TABLE IF EXISTS credits ;
DROP TABLE IF EXISTS crew;
DROP TABLE IF EXISTS movie_dataset;
DROP TABLE IF EXISTS movie_dataset_cleaned;
DROP TABLE IF EXISTS movies_crew;
DROP TABLE IF EXISTS movies_directors;
DROP TABLE IF EXISTS movies_production_companies;
DROP TABLE IF EXISTS mpc_raw;
DROP TABLE IF EXISTS production_companies;
DROP TABLE IF EXISTS tmp_credits;
DROP TABLE IF EXISTS tmp_crew;
DROP TABLE IF EXISTS tmp_genres;
DROP TABLE IF EXISTS tmp_movies;
DROP TABLE IF EXISTS tmp_nf2;
DROP TABLE IF EXISTS tmp_production_companies;
DROP TABLE IF EXISTS tmp_production_countries;
DROP TABLE IF EXISTS tmp_spoken_languages;


