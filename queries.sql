/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name LIKE '%_mon';

SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';

SELECT name FROM animals WHERE (neutered = true) AND (escape_attempts<'3');

SELECT date_of_birth FROM animals WHERE (name = 'Agumon') OR (name = 'Pikachu');

SELECT name, escape_attempts FROM animals WHERE weight_kg > '10.5';

SELECT * FROM animals WHERE neutered = true;

SELECT * FROM animals WHERE name <> 'Gabumon';

SELECT * FROM animals WHERE (weight_kg >= '10.4') AND (weight_kg <= '17.3');

-- update queries with transaction

BEGIN;

UPDATE animals SET species = 'unspecified';

ROLLBACK;

BEGIN;

UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';

UPDATE animals SET species = 'pokemon' WHERE species IS NULL;

COMMIT;

BEGIN;

DELETE FROM animals;

ROLLBACK;

BEGIN;

DELETE FROM animals WHERE date_of_birth > '2022-01-01';

SAVEPOINT DOB;

UPDATE animals SET weight_kg = weight_kg *-1;

ROLLBACK TO SAVEPOINT DOB;

UPDATE animals SET weight_kg = weight_kg*-1 WHERE weight_kg <0;

COMMIT;

-- aggregate functions

SELECT COUNT(*) FROM animals;

SELECT COUNT(*) FROM animals WHERE escape_attempts = '0';

SELECT AVG(weight_kg) FROM animals;

SELECT neutered, MAX(escape_attempts) FROM animals GROUP BY neutered ORDER BY neutered DESC LIMIT 1;

SELECT species, MIN(weight_kg), MAX(weight_kg) FROM animals GROUP BY species;

SELECT species, AVG(escape_attempts) FROM animals GROUP BY species;

SELECT species, AVG(escape_attempts) FROM animals WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31' GROUP BY species;

-- JOIN queries

SELECT * FROM animals A JOIN owners O ON O.id = A.owner_id WHERE O.full_name = 'Melody Pond';

SELECT * FROM animals A JOIN species S ON S.id = A.species_id WHERE S.name = 'pokemon';

SELECT name AS animal, full_name AS owner FROM animals A JOIN owners O ON O.id = A.owner_id;

SELECT S.name AS species, COUNT(S.name) FROM animals A JOIN species S ON S.id = A.species_id GROUP BY S.name;

SELECT A.name AS animal, S.name AS species, O.full_name
FROM animals A 
JOIN species S ON S.id = A.species_id
JOIN owners O ON O.id = A.owner_id
WHERE O.full_name = 'Jennifer Orwell' AND S.name = 'digimon';

SELECT A.name AS animal, O.full_name AS owner, A.escape_attempts
FROM animals A JOIN owners O ON O.id = A.owner_id
WHERE O.full_name = 'Dean Winchester' AND A.escape_attempts = 0;

SELECT O.full_name AS owner, COUNT(A.name)
FROM animals A JOIN owners O ON O.id = A.owner_id
GROUP BY O.full_name
ORDER BY COUNT(A.name) DESC LIMIT 1;

SELECT A.name AS animal, V.name as vet, Vi.date_of_visit as visit_date
FROM visits Vi
JOIN animals A ON A.id = Vi.animal_id
JOIN vets V ON Vi.vet_id = V.id
WHERE V.name = 'William Tatcher'
ORDER BY Vi.date_of_visit DESC LIMIT 1;

-- two different queries to have animals visit by 'Stephanie Mendez'

SELECT A.name AS animal, V.name AS vet, vi.date_of_visit AS visit_date
FROM visits Vi
JOIN vets V ON V.id = Vi.vet_id
JOIN animals A ON A.id = Vi.animal_id
WHERE V.name = 'Stephanie Mendez'
GROUP BY A.name, V.name, Vi.date_of_visit;

SELECT V.name AS vet, COUNT(A.name)
FROM visits Vi
JOIN vets V ON V.id = Vi.vet_id
JOIN animals A ON A.id = Vi.animal_id
WHERE V.name = 'Stephanie Mendez'
GROUP BY V.name;

-- end of two alternative subqueries

SELECT V.name AS vet,
       CASE
           WHEN S.name IS NULL THEN 'no speciality'
           ELSE S.name
       END AS speciality
FROM vets V
LEFT JOIN specializations AS Sp ON V.id = Sp.vet_id
LEFT JOIN species AS S ON S.id = Sp.species_id;

SELECT A.name as animal, V.name as vet, Vi.date_of_visit as visit_date
FROM visits Vi
JOIN vets V ON v.id = Vi.vet_id
JOIN animals A ON A.id = Vi.animal_id
WHERE V.name = 'Stephanie Mendez' AND Vi.date_of_visit BETWEEN '2020-04-01' AND '2020-08-30';

SELECT A.name AS animal, COUNT(A.name) AS visits FROM visits Vi
JOIN vets V ON v.id = Vi.vet_id
JOIN animals A ON A.id = Vi.animal_id
GROUP BY A.name ORDER BY COUNT(A.name) DESC LIMIT 1;

SELECT A.name AS animal, V.name as vet, Vi.date_of_visit AS visit_date
FROM visits Vi
JOIN vets V ON v.id = Vi.vet_id
JOIN animals A ON A.id = Vi.animal_id
WHERE V.name = 'Maisy Smith'
ORDER BY Vi.date_of_visit LIMIT 1;

SELECT A.name AS animal, A.date_of_birth, A.escape_attempts, A.neutered, A.weight_kg, V.name AS vet, V.age, V.date_of_graduation, Vi.date_of_visit
FROM visits Vi
JOIN vets V ON v.id = Vi.vet_id
JOIN animals A ON A.id = Vi.animal_id
ORDER BY Vi.date_of_visit DESC LIMIT 1;

-- three different queries to achieve the following
-- "How many visits were with a vet that did not specialize in that animal's species?"
-- first
SELECT V.name, COUNT(V.name) FROM visits Vi
FULL JOIN vets V ON v.id = Vi.vet_id
FULL JOIN specializations SP ON SP.vet_id = v.id
WHERE SP.vet_id IS NULL
GROUP BY V.name;
-- second
SELECT vet_name,
       COUNT(*) AS num_visits
FROM visits vi
JOIN vets v ON v.id = vi.vet_id
JOIN specializations sp ON sp.vet_id = v.id
WHERE sp.vet_id IS NULL
GROUP BY v.name;
-- third
SELECT vet_name,
       COUNT(vet_name) AS num_visits
FROM (
    SELECT v.name AS vet_name
    FROM visits vi
    FULL JOIN vets v ON v.id = vi.vet_id
    FULL JOIN specializations sp ON sp.vet_id = v.id
    WHERE sp.vet_id IS NULL
) AS t
GROUP BY vet_name;

SELECT V.name AS vet, COUNT(A.species_id),
CASE
    WHEN A.species_id = 2 THEN 'pokemon'
    ELSE 'digimon'
    END AS preferred_speciality
FROM visits Vi
FULL JOIN vets V ON v.id = Vi.vet_id
FULL JOIN specializations SP ON SP.vet_id = v.id
FULL JOIN animals A on A.id = Vi.animal_id
WHERE SP.vet_id IS NULL
GROUP BY A.species_id, V.name
ORDER BY COUNT(A.species_id) DESC LIMIT 1;
