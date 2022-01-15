SELECT area_id,
       ROUND(AVG(compensation_from), 2)                         AS avg_from,
       ROUND(AVG(compensation_to), 2)                           AS avg_to,
       ROUND(AVG((compensation_to + compensation_from) / 2), 2) AS avg_from_to
FROM vacancy
GROUP BY area_id
ORDER BY area_id;
