-- three different queries to achieve the following
-- "How many visits were with a vet that did not specialize in that animal's species?"
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
-- end of alternative queries

-- alternative query to have animals visit by 'Stephanie Mendez'

SELECT V.name AS vet, COUNT(A.name)
FROM visits Vi
JOIN vets V ON V.id = Vi.vet_id
JOIN animals A ON A.id = Vi.animal_id
WHERE V.name = 'Stephanie Mendez'
GROUP BY V.name;

-- end of two alternative subqueries