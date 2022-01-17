SELECT year_month_vacancy AS month_max_count_vacancy,
       year_month_summary AS month_min_count_summary
FROM (
         SELECT to_char(creation_date, 'YYYY-MM') AS year_month_vacancy,
                count(*) AS count
         FROM vacancy
         GROUP BY year_month_vacancy
         ORDER BY count DESC
             LIMIT 1
     ) AS max_count_vacancy
         INNER JOIN (
    SELECT to_char(creation_date, 'YYYY-MM') AS year_month_summary,
           count(*) AS count
    FROM summary
    GROUP BY year_month_summary
    ORDER BY count
        LIMIT 1
) as min_count_summary ON true;