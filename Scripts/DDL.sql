DROP TABLE IF EXISTS Movie;
DROP TABLE IF EXISTS Gender;
DROP TABLE IF EXISTS SpokenLanguages;
DROP TABLE IF EXISTS ProductionCountries;
DROP TABLE IF EXISTS Company;
DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS MovieGenders;
DROP TABLE IF EXISTS MovieLanguages;
DROP TABLE IF EXISTS MovieFrom;
DROP TABLE IF EXISTS MovieProducedBy;
DROP TABLE IF EXISTS MovieCrew;

CREATE TABLE Movie(
	id INT NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE Gender(
	genderName VARCHAR(25) NOT NULL,
    PRIMARY KEY (genderName)
);

CREATE TABLE SpokenLanguages(
	iso639 VARCHAR(3) NOT NULL,
    name VARCHAR(15) DEFAULT NULL,
    PRIMARY KEY (iso639)
);

CREATE TABLE ProductionCountries(
	iso3166 VARCHAR(3) NOT NULL,
    name VARCHAR(25) DEFAULT NULL,
    PRIMARY KEY (iso3166)
);

CREATE TABLE Company(
	idComapny INT NOT NULL,
    name VARCHAR(50) DEFAULT NULL,
    PRIMARY KEY (idCompany)
);

CREATE TABLE Employee(
	idEmployee INT NOT NULL,
    name VARCHAR(25) DEFAULT NULL,
    gender INT DEFAULT NULL,
    department VARCHAR(25) DEFAULT NULL,
    job VARCHAR (25) DEFAULT NULL,
    creditId VARCHAR(25) DEFAULT NULL,
    PRIMARY KEY (idEmployee)
);

CREATE TABLE MovieGenders(
	id INT NOT NULL,
    genderName VARCHAR(25) NOT NULL,
    PRIMARY KEY (id ,genderName),
    FOREIGN KEY (id) REFERENCES Movie (id),
	FOREIGN KEY (genderName) REFERENCES Gender(genderName)
);

CREATE TABLE MovieLanguages(
	id INT NOT NULL,
    iso639 VARCHAR(3) NOT NULL,
    PRIMARY KEY (id ,iso639),
    FOREIGN KEY (id) REFERENCES Movie (id),
    FOREIGN KEY (iso639) REFERENCES SpokenLanguages(iso639)
);

CREATE TABLE MovieFrom(
	id INT NOT NULL,
    iso3166 VARCHAR(3) NOT NULL,
    PRIMARY KEY (id ,iso3166),
    FOREIGN KEY (id) REFERENCES Movie (id),
    FOREIGN KEY (iso3166) REFERENCES ProductionCountries(iso3166)
);

CREATE TABLE MovieProducedBy(
	id INT NOT NULL,
    idComapny INT NOT NULL,
    PRIMARY KEY (id ,idComapny),
    FOREIGN KEY (id) REFERENCES Movie (id),
    FOREIGN KEY (idComapny) REFERENCES Company(idComapny)
);

CREATE TABLE MovieCrew(
	id INT NOT NULL,
    idEmployee INT NOT NULL,
    PRIMARY KEY (id ,idEmployee),
    FOREIGN KEY (id) REFERENCES Movie (id),
    FOREIGN KEY (idEmployee) REFERENCES Employee(idEmployee)
);