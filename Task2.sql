-- Заполнение таблиц данными

INSERT INTO company_type (company_type_title)
VALUES ('Other'),
       ('ПАО'),
       ('ЗАО'),
       ('ООО'),
       ('ИП');

INSERT INTO working_experience (working_experience_title)
VALUES ('Не требуется'),
       ('От 1 до 3 лет'),
       ('От 3 до 6 лет');

-- Заполняем таблицу работодателей случайными данными.
INSERT INTO employer (company_type_id, employer_title, employer_address)
SELECT (random() * (SELECT count(company_type_id) - 1 from company_type))::integer + 1,
       md5((random() * 10000000)::text),
       md5((random() * 10000000)::text)
FROM generate_series(1, 1000);

-- Заполняем таблицу территорий случайными данными.
INSERT INTO area (area_title)
SELECT md5((random() * 10000000)::text)
FROM generate_series(1, 200);

-- Заполняем таблицу должностей (профессий) случаными данными.
INSERT INTO profession (profession_title)
SELECT md5((random() * 10000000)::text)
FROM generate_series(1, 200);

-- Заполняем таблицу вакансий случайными данными.
INSERT INTO vacancy (vacancy_title, employer_id, profession_id, compensation_from, compensation_to,
                     working_experience_id, description,
                     requirements, responsibilities, working_conditions, skills, area_id, creation_date)
SELECT md5((random() * 10000000)::text),
       (random() * (SELECT count(e.employer_id) - 1 from employer e))::integer + 1,
       (random() * (SELECT count(p.profession_id) - 1 from profession p))::integer + 1,
       90000 + ((random() * 200)::integer) * 1000,
       0,
       (random() * (SELECT count(we.working_experience_id) - 1 from working_experience we))::integer + 1,
       md5((random() * 10000000)::text),
       md5((random() * 10000000)::text),
       md5((random() * 10000000)::text),
       md5((random() * 10000000)::text),
       md5((random() * 10000000)::text),
       (random() * (SELECT count(a.area_id) - 1 from area a))::integer + 1,
       timestamp '2016-01-01' + interval '1 day' * round(random() * 365 * 2)
FROM generate_series(1, 10000);

-- Дополняем таблицу вакансий данными о максимальном вознаграждении.
UPDATE vacancy
SET compensation_to = compensation_from + ((random() * 200):: integer) * 1000
WHERE true;

-- Заполняем таблицу соискателей.
INSERT INTO job_seeker (contacts, working_experience_description, education, knowledge_languages, citizenship)
SELECT md5((random() * 10000000)::text),
       md5((random() * 10000000)::text),
       md5((random() * 10000000)::text),
       md5((random() * 10000000)::text),
       md5((random() * 10000000)::text)
FROM generate_series(1, 30000);


INSERT INTO employment (employment_title)
VALUES ('Полный рабочий день'),
       ('Не полный рабочий день'),
       ('Частичная занятость'),
       ('Вахтовый метод'),
       ('Удалённо');

INSERT INTO visibility (visibility_title)
VALUES ('Не видно никому'),
       ('Видно только по прямой ссылке'),
       ('Скрыто от выбранных компаний, видно остальным'),
       ('Видно выбранным компаниям'),
       ('Видно компаниям-клиентам HeadHunter');

-- Заполняем таблицу резюме случайными данными.
INSERT INTO summary (summary_title, area_id, job_seeker_id, profession_id, employment_id, skills, creation_date)
SELECT md5((random() * 10000000)::text),
       (random() * (SELECT count(a.area_id) - 1 FROM area AS a))::integer + 1,
       (random() * (SELECT count(js.job_seeker_id) - 1 FROM job_seeker AS js))::integer + 1,
       (random() * (SELECT count(p.profession_id) - 1 FROM profession AS p))::integer + 1,
       (random() * (SELECT count(e.employment_id) - 1 FROM employment AS e))::integer + 1,
       md5((random() * 10000000)::text),
       timestamp '2016-01-01' + interval '1 day' * round(random() * 365 * 2)
FROM generate_series(1, 100000);

-- Заполняем таблицу специализаций случайными данными.
INSERT INTO specialty (specialty_title)
SELECT md5((random() * 10000000)::text)
FROM generate_series(1, 200);

-- Заполняем таблицу соттветствия специализаций для каждой вакансии случайными данными.
-- Максимум 5 специализаций.
INSERT INTO vacancy_specialty (vacancy_id, specialty_id)
SELECT v.vacId,
       temp.specId
FROM (SELECT vacancy_id AS vacId, random() AS r FROM vacancy) AS v
         CROSS JOIN LATERAL (
    SELECT specialty_id AS specId
    FROM specialty
    ORDER BY random()
    LIMIT v.r * 4 + 1
    ) AS temp
ORDER BY 1;

-- Заполняем таблицу соттветствия специализаций для каждого резюме случайными данными.
-- Максимум 5 специализаций.
INSERT INTO summary_specialty (summary_id, specialty_id)
SELECT s.sumId,
       temp.specId
FROM (SELECT summary_id AS sumId, random() AS r FROM summary) AS s
         CROSS JOIN LATERAL (
    SELECT specialty_id AS specId
    FROM specialty
    ORDER BY random()
    LIMIT s.r * 4 + 1
    ) AS temp
ORDER BY 1;

-- Заполняем таблицу откликов на вакансии случаными данными вакансий и резюме и дат создания отклика.
-- Максимум 15 откликов на одно резюме.
INSERT INTO summary_vacancy (summary_id, vacancy_id, creation_date)
SELECT s.sumId,
       v.vacId,
       case
           when (v.date >= s.date)
               then v.date + interval '1 day' * round(random() * 56)
           else s.date + interval '1 day' * round(random() * 56)
           end
FROM (SELECT summary_id AS sumId, creation_date AS date, random() AS r FROM summary) AS s
         CROSS JOIN LATERAL (
    SELECT vacancy_id AS vacId, creation_date AS date
    FROM vacancy
    ORDER BY random()
    LIMIT s.r * 14 + 1
    ) AS v
ORDER BY 1;

