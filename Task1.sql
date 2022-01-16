-- Создание таблиц

-- Перед созданием таблиц удаляем все сущеуствующие.
-- Удаляем в порядке от верхнего уровня к нижнему, в противном случае будет ошибка удаления связанных таблиц.
DROP TABLE IF EXISTS summary_specialty;
DROP TABLE IF EXISTS summary_vacancy;
DROP TABLE IF EXISTS vacancy_specialty;
DROP TABLE IF EXISTS vacancy;
DROP TABLE IF EXISTS summary;
DROP TABLE IF EXISTS area;
DROP TABLE IF EXISTS working_experience;
DROP TABLE IF EXISTS employer;
DROP TABLE IF EXISTS company_type;
DROP TABLE IF EXISTS job_seeker;
DROP TABLE IF EXISTS employment;
DROP TABLE IF EXISTS visibility;
DROP TABLE IF EXISTS profession;
DROP TABLE IF EXISTS specialty;

-- Создание таблицы company_type для хранения допустимых видов организаций работодателей, таких как ООО, ЗАО, ПАО, ИП и т.д.
-- При заполнении видов организаций в качестве первого значения укажем 'Other', id которого будет
-- применяться по умолчанию для поля в таблице работодателей, если для работодателя не будет подходящего типа.
CREATE TABLE company_type
(
    company_type_id    SERIAL PRIMARY KEY,
    company_type_title TEXT NOT NULL
);

-- Создание таблицы employer для хранения организаций работодателей.
CREATE TABLE employer
(
    employer_id      SERIAL PRIMARY KEY,
    company_type_id  INTEGER NOT NULL DEFAULT 1,
    employer_title   TEXT    NOT NULL,
    employer_address TEXT    NOT NULL,
    FOREIGN KEY (company_type_id) REFERENCES company_type (company_type_id) ON DELETE SET DEFAULT
);

-- Создание таблицы working_experience для хранения допустимых видов опыта работы, таких как ('Не требуется', 'От 1 до 3 лет' и т.д.)
-- При заполнении вакансий в качестве первого значения укажем 'Не требуется', id которого будет
-- применяться по умолчанию для поля в таблице вакансий.
CREATE TABLE working_experience
(
    working_experience_id    SERIAL PRIMARY KEY,
    working_experience_title TEXT NOT NULL
);

-- Создание таблицы area для хранения территории.
CREATE TABLE area
(
    area_id    SERIAL PRIMARY KEY,
    area_title TEXT NOT NULL
);

-- Создание таблицы profession для хранения территории.
CREATE TABLE profession
(
    profession_id    SERIAL PRIMARY KEY,
    profession_title TEXT NOT NULL
);

-- Создание таблицы vacancy для хранения вакансий.
CREATE TABLE vacancy
(
    vacancy_id            SERIAL PRIMARY KEY,
    vacancy_title         TEXT      NOT NULL,
    employer_id           INTEGER   NOT NULL,
    profession_id         INTEGER   NOT NULL,
    compensation_from     INTEGER,
    compensation_to       INTEGER,
    working_experience_id INTEGER DEFAULT 1,
    description           TEXT      NOT NULL,
    requirements          TEXT      NOT NULL,
    responsibilities      TEXT      NOT NULL,
    working_conditions    TEXT      NOT NULL,
    skills                TEXT,
    area_id               INTEGER   NOT NULL,
    creation_date         TIMESTAMP NOT NULL,
    FOREIGN KEY (employer_id) REFERENCES employer (employer_id) ON DELETE CASCADE,
    FOREIGN KEY (profession_id) REFERENCES profession (profession_id) ON DELETE CASCADE,
    FOREIGN KEY (working_experience_id) REFERENCES working_experience (working_experience_id) ON DELETE SET DEFAULT,
    FOREIGN KEY (area_id) REFERENCES area (area_id) ON DELETE CASCADE
);

-- Создание таблицы job_seeker для хранения соискателей.
CREATE TABLE job_seeker
(
    job_seeker_id                  SERIAL PRIMARY KEY,
    contacts                       TEXT NOT NULL,
    working_experience_description TEXT,
    education                      TEXT,
    knowledge_languages            TEXT,
    citizenship                    TEXT NOT NULL
);

-- Создание таблицы employment для хранения соискателей.
CREATE TABLE employment
(
    employment_id    SERIAL PRIMARY KEY,
    employment_title TEXT NOT NULL
);

-- Создание таблицы visibility для хранения видов видимости резюме, таких как 'Не видно никому', 'Видно только по прямой ссылке'.
-- При заполнении видов видимости в качестве первого значения укажем 'Не видно никому', id которого будет
-- применяться по умолчанию для поля в таблице резюме, если для резюме не будет подходящего типа.
CREATE TABLE visibility
(
    visibility_id    SERIAL PRIMARY KEY,
    visibility_title TEXT NOT NULL
);

-- Создание таблицы summary для хранения резюме.
CREATE TABLE summary
(
    summary_id    SERIAL PRIMARY KEY,
    summary_title TEXT      NOT NULL,
    area_id       INTEGER   NOT NULL,
    job_seeker_id INTEGER   NOT NULL,
    profession_id INTEGER   NOT NULL,
    employment_id INTEGER,
    skills        TEXT,
    visibility_id INTEGER   NOT NULL DEFAULT 1,
    creation_date TIMESTAMP NOT NULL,
    FOREIGN KEY (area_id) REFERENCES area (area_id) ON DELETE SET NULL,
    FOREIGN KEY (profession_id) REFERENCES profession (profession_id) ON DELETE CASCADE,
    FOREIGN KEY (visibility_id) REFERENCES visibility (visibility_id) ON DELETE SET DEFAULT,
    FOREIGN KEY (employment_id) REFERENCES employment (employment_id) ON DELETE SET NULL,
    FOREIGN KEY (job_seeker_id) REFERENCES job_seeker (job_seeker_id) ON DELETE CASCADE
);

-- Создание таблицы specialty, для хранения различных специализаций.
CREATE TABLE specialty
(
    specialty_id    SERIAL PRIMARY KEY,
    specialty_title TEXT NOT NULL
);

-- Создание таблицы для хранения взаимосвязей между вакансиями и специализациями.
CREATE TABLE vacancy_specialty
(
    vacancy_specialty_id SERIAL PRIMARY KEY,
    vacancy_id           INTEGER NOT NULL,
    specialty_id         INTEGER NOT NULL,
    FOREIGN KEY (vacancy_id) REFERENCES vacancy (vacancy_id) ON DELETE CASCADE,
    FOREIGN KEY (specialty_id) REFERENCES specialty (specialty_id) ON DELETE CASCADE
);

-- Создание таблицы для хранения взаимосвязей между резюме и специализациями.
CREATE TABLE summary_specialty
(
    summary_specialty_id SERIAL PRIMARY KEY,
    summary_id           INTEGER NOT NULL,
    specialty_id         INTEGER NOT NULL,
    FOREIGN KEY (summary_id) REFERENCES summary (summary_id) ON DELETE CASCADE,
    FOREIGN KEY (specialty_id) REFERENCES specialty (specialty_id) ON DELETE CASCADE
);

-- Создание таблицы для хранения откликов резюме на вакансии.
CREATE TABLE summary_vacancy
(
    summary_vacancy_id SERIAL PRIMARY KEY,
    summary_id         INTEGER   NOT NULL,
    vacancy_id         INTEGER   NOT NULL,
    creation_date      TIMESTAMP NOT NULL,
    FOREIGN KEY (summary_id) REFERENCES summary (summary_id) ON DELETE CASCADE,
    FOREIGN KEY (vacancy_id) REFERENCES vacancy (vacancy_id) ON DELETE CASCADE
);



