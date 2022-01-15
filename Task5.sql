SELECT v.vacancy_id,
       v.vacancy_title
FROM vacancy AS v
         INNER JOIN summary_vacancy AS sv ON v.vacancy_id = sv.vacancy_id
WHERE (date_part('year', age(sv.creation_date, v.creation_date))) = 0
  AND (date_part('month', age(sv.creation_date, v.creation_date))) = 0
  AND (date_part('day', age(sv.creation_date, v.creation_date))) <= 7
GROUP BY v.vacancy_id, v.vacancy_title
HAVING count(*) > 5;