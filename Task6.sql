-- Предположим, что для работодателей актуален поиск резюме
-- по территориальной принадлежности и конкретным специализациям.
-- Для ускорения поиска создадим индекс по полям summary_id, specialty_id
CREATE INDEX summary_specialty_index ON summary_specialty (summary_id, specialty_id);

-- Аналогично для соискателей актуален поиска вакансий
-- по территориальной принадлежности и интересующим специализациям.
-- Для ускорения поиска создадим индекс по полям vacancy_id, specialty_id.
CREATE INDEX vacancy_specialty_index ON vacancy_specialty (vacancy_id, specialty_id);

-- Для соискателя может быть актуален поиск по откликам работодателей на их резюме.
-- Для ускорения поиска создадим индекс по полям vacancy_id, summary_id.
CREATE INDEX vacancy_summary_index ON vacancy_summary (vacancy_id, summary_id);
