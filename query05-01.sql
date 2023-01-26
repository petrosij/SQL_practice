-- Лекция 5
-- Представления

-- Подготовительный запрос
SELECT
    Students.LastName,
    Students.FirstName,
    Genders.Title AS Gender
FROM Students INNER JOIN Genders
ON Students.GenderId = Genders.GenderId
WHERE Genders.Title = 'мужской'
ORDER BY
    Students.LastName ASC,
    Students.FirstName ASC;
    
/* Варианты сохранения сделанной работы
**   1. Сохранить запрос в отдельном(!) файле с расширением *.sql.
**   2. Создать представление (View), которое будет сохранено в БД. */     

/* Цитата: "A view is nothing more than a SQLite statement
** that is stored in the database with an associated name. */

-- Синтаксис создания представления
CREATE VIEW [Male students] AS
    SELECT Students.LastName,
           Students.FirstName,
           Genders.Title AS Gender
      FROM Students
           INNER JOIN
           Genders ON Students.GenderId = Genders.GenderId
     WHERE Genders.Title = 'мужской'
     ORDER BY Students.LastName ASC,
              Students.FirstName ASC;

/* Если имя объекта БД содержит пробелы, то имя необходимо поместить
** в квадратные скобки */

/* Назначение представлений:
**  1. Получение данных в виде, удобном для пользователя.
**  2. Ограничение доступа к таблицам.
**  3. Формирование отчетов на основе запросов к нескольким таблицам. */

/* К представлению можно обратиться по имени представления,
** как к обычной таблице. */
SELECT * FROM [Male students];


/* Ещё один пример. Создание представления для отображения
** всех преподавателей. */
SELECT
    LastName,
    FirstName,
    MiddleName
FROM Trainers
ORDER BY
    LastName ASC,
    FirstName ASC,
    MiddleName ASC;

-- Создание представления ...
CREATE VIEW [All trainers] AS
    SELECT LastName,
           FirstName,
           MiddleName
    FROM Trainers
    ORDER BY LastName ASC,
             FirstName ASC,
             MiddleName ASC;

-- ... и обращение к нему
SELECT * FROM [All trainers];

SELECT * FROM Trainers;

/* Цитата: "SQLite is read only. You cannot use INSERT, DELETE
** and UPDATE statements to update data in the base tables
** through the view */

-- Изменение наименований столбцов в представлении

-- Подготовительный запрос
SELECT
    Students.LastName,
    Students.FirstName,
    Genders.Title AS Gender
FROM Students INNER JOIN Genders
ON Students.GenderId = Genders.GenderId
WHERE Genders.Title = 'женский'
ORDER BY
    Students.LastName ASC,
    Students.FirstName ASC;
    
-- Создание представления ...
CREATE VIEW [Female students]
(FamilyName, ForeName, Civility) AS
    SELECT Students.LastName,
           Students.FirstName,
           Genders.Title AS Gender
      FROM Students
           INNER JOIN
           Genders ON Students.GenderId = Genders.GenderId
     WHERE Genders.Title = 'женский'
     ORDER BY Students.LastName ASC,
              Students.FirstName ASC;

-- ... и обращение к нему
SELECT * FROM [Female students];


-- Триггеры

/* Триггеры могут быть:
**  1. BEFORE - триггер выполняется перед запросом
**  2. AFTER - триггер выполняется после запроса
**  3. INSTEAD OF - триггер выполняется вместо запроса
** Также они могут быть:
**  1. INSERT - триггер запустится при попытке добавления данных
**  2. UPDATE - триггер запустится при попытке модификации данных
**  3. DELETE - триггер запустится при попытке удаления данных  


-- Простой пример триггера (триггер AFTER INSERT)
CREATE TRIGGER StudentsAfterInsert AFTER INSERT
ON Students
BEGIN
    INSERT INTO Operations (
        OperationType,
        TableName,
        ObjectId,
        OperationDateAndTime
    )
    VALUES (
        'Insert',
        'Students',
        NEW.StudentId,
        datetime('now')
    );
END;

-- Пример работы триггера
DELETE FROM Operations;
SELECT * FROM Operations;

INSERT INTO Students
    (StudentId, GenderId, LastName, FirstName, MiddleName)
VALUES
    (21, 4, 'Алексеев', 'Михаил', 'Михайлович');
    
INSERT INTO Students
    (StudentId, GenderId, LastName, FirstName, MiddleName)
VALUES
    (22, 4, 'Емельянов', 'Артем', 'Анатольевич');        
    
SELECT * FROM Students;
SELECT * FROM Operations;


-- Ещё один пример триггера (триггер AFTER DELETE)
CREATE TRIGGER StudentsAfterDelete AFTER DELETE
ON Students
BEGIN
    INSERT INTO Operations (
        OperationType,
        TableName,
        ObjectId,
        OperationDateAndTime
    )
    VALUES (
        'Delete',
        'Students',
        OLD.StudentId,
        datetime('now')
    );
END;

-- Пример работы триггера
DELETE FROM Students
WHERE StudentId IN (21, 22);

SELECT * FROM Students;
SELECT * FROM Operations;


-- Триггер с условием WHEN
DELETE FROM StudentEntries;

INSERT INTO StudentEntries (StudentEntryId, TrainingId, StudentId)
VALUES
    (1, 4, 1), (2, 4, 2), (3, 4, 3), (4, 4, 4), (5, 4, 5),
    (6, 4, 6), (7, 4, 7), (8, 4, 8), (9, 4, 9), (10, 4, 10);
    
CREATE TRIGGER StudentEntriesAfterInsert AFTER INSERT
ON StudentEntries WHEN (
    SELECT COUNT(*) FROM StudentEntries
    WHERE TrainingId = NEW.TrainingId) > 10
BEGIN
    INSERT INTO UnacceptedStudentEntries (TrainingId, StudentId)
    VALUES (NEW.TrainingId, NEW.StudentId);
    DELETE FROM StudentEntries
    WHERE TrainingId = NEW.TrainingId
        AND StudentId = NEW.StudentId;
END

DELETE FROM UnacceptedStudentEntries;

-- Пример работы триггера с условием WHEN
-- Сейчас триггер сработает ...
INSERT INTO StudentEntries (StudentEntryId, TrainingId, StudentId)
VALUES
    (11, 4, 11), (12, 4, 12);
    
DELETE FROM StudentEntries
WHERE StudentEntryId IN (9, 10);

-- ... а сейчас -- нет
INSERT INTO StudentEntries (StudentEntryId, TrainingId, StudentId)
VALUES
    (11, 4, 11), (12, 4, 12);
    