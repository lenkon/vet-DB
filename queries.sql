/*Queries that provide answers to the questions from all projects.*/

SELECT * 
FROM animals 
WHERE name LIKE '%_mon';

SELECT name 
FROM animals 
WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';

SELECT name 
FROM animals 
WHERE (neutered = true) AND (escape_attempts<'3');

SELECT date_of_birth
FROM animals
WHERE (name = 'Agumon') OR (name = 'Pikachu');

SELECT name, escape_attempts
FROM animals
WHERE weight_kg > '10.5';

SELECT *
FROM animals
WHERE neutered = true;

SELECT *
FROM animals
WHERE name <> 'Gabumon';

SELECT *
FROM animals
WHERE (weight_kg >= '10.4') AND (weight_kg <= '17.3');

BEGIN;

UPDATE animals
SET species = 'unspecified';

ROLLBACK;

BEGIN;

UPDATE animals
SET species = 'digimon'
WHERE name LIKE '%mon';

UPDATE animals
SET species = 'pokemon'
WHERE species IS NULL;

COMMIT;

BEGIN;

DELETE FROM animals;

ROLLBACK;

BEGIN;

DELETE FROMv animals
WHERE date_of_birth > '2022-01-01';

SAVEPOINT DOB;

UPDATE animals
SET weight_kg = weight_kg * '-1';

ROLLBACK TO SAVEPOINT DOB;

COMMIT;

SELECT COUNT(name)
FROM animals;

SELECT COUNT(name)
FROM animals
WHERE escape_attempts = '0';

SELECT AVG(weight_kg)
FROM animals;

SELECT MAX(escape_attempts)
FROM animals;

