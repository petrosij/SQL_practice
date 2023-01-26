
-- Получение информации об объектах базы данных
-- все объекты
SELECT * FROM sqlite_master;

-- типы объектов
SELECT DISTINCT type -- distinct для отмены повторений
FROM sqlite_master
ORDER BY type;

-- таблицы
SELECT * FROM sqlite_master
WHERE type = "table";

-- внутренняя таблица, использующаяся для реализации AUTOINCREMENT
SELECT * FROM sqlite_sequence;

SELECT * FROM UnacceptedStudentEntries;

SELECT * FROM Operations
ORDER BY OperationId DESC;

SELECT * FROM Adults
ORDER BY AdultId DESC
LIMIT 10;


-- представления
SELECT * FROM sqlite_master
WHERE type = "view";

-- триггеры
SELECT * FROM sqlite_master
WHERE type = "trigger";

-- индексы
SELECT * FROM sqlite_master
WHERE type = "index";

-- Подготовительный этап
-- Заполнение таблицы MaleLastNames
DELETE FROM MaleLastNames;

INSERT INTO MaleLastNames (MaleLastNameId, Value)
VALUES
    (1, 'Иванов'), (2, 'Смирнов'),
    (3, 'Кузнецов'), (4, 'Попов'),
    (5, 'Васильев'), (6, 'Петров'),
    (7, 'Соколов'), (8, 'Михайлов'),
    (9, 'Новиков'), (10, 'Федоров');

SELECT * FROM MaleLastNames;

-- Заполнение таблицы MaleFirstNames
DELETE FROM MaleFirstNames;

INSERT INTO MaleFirstNames (MaleFirstNameId, Value)
VALUES
    (1, 'Артём'), (2, 'Александр'),
    (3, 'Максим'), (4, 'Даниил'),
    (5, 'Дмитрий'), (6, 'Иван'),
    (7, 'Кирилл'), (8, 'Никита'),
    (9, 'Михаил'), (10, 'Егор');
    
SELECT * FROM MaleFirstNames;

-- Заполнение таблицы MaleMiddleNames
DELETE FROM MaleMiddleNames;

INSERT INTO MaleMiddleNames (MaleMiddleNameId, Value)
VALUES
    (1, 'Александрович'), (2, 'Алексеевич'),
    (3, 'Анатольевич'), (4, 'Борисович'),
    (5, 'Васильевич'), (6, 'Викторович'),
    (7, 'Георгиевич'), (8, 'Игоревич'),
    (9, 'Иванович'), (10, 'Константинович');
    
SELECT * FROM MaleMiddleNames;

-- Заполнение таблицы BirthDates
DELETE FROM BirthDates;

INSERT INTO BirthDates (BirthDateId, Value)
VALUES
    ( 1, '1985-01-01'),  (2, '1985-02-01'),
    ( 3, '1985-03-01'),  (4, '1985-04-01'),
    ( 5, '1985-05-01'),  (6, '1985-06-01'),
    ( 7, '1985-07-01'),  (8, '1985-08-01'),
    ( 9, '1985-09-01'), (10, '1985-10-01'),
    (11, '1985-11-01'), (12, '1985-12-01');

SELECT * FROM BirthDates;

-- Перекрестное объединение таблиц (простой пример)
SELECT
    MaleLastNames.Value AS LastName,
    MaleFirstNames.Value AS FirstName
FROM MaleLastNames CROSS JOIN MaleFirstNames
ORDER BY
    MaleLastNames.Value,
    MaleFirstNames.Value;

-- Перекрестное объединение таблиц (пример посложнее)
SELECT
    MaleLastNames.Value AS LastName,
    MaleFirstNames.Value AS FirstName,
    MaleMiddleNames.Value AS MiddleName,
    BirthDates.Value AS BirthDate
FROM MaleLastNames CROSS JOIN MaleFirstNames
    CROSS JOIN MaleMiddleNames
    CROSS JOIN BirthDates
ORDER BY
    MaleLastNames.Value,
    MaleFirstNames.Value,
    MaleMiddleNames.Value,
    BirthDates.Value;
    
-- Использование ключевого слова LIMIT
SELECT
    MaleLastNames.Value AS LastName,
    MaleFirstNames.Value AS FirstName,
    MaleMiddleNames.Value AS MiddleName,
    BirthDates.Value AS BirthDate
FROM MaleLastNames CROSS JOIN MaleFirstNames
    CROSS JOIN MaleMiddleNames
    CROSS JOIN BirthDates
ORDER BY
    MaleLastNames.Value,
    MaleFirstNames.Value,
    MaleMiddleNames.Value,
    BirthDates.Value
LIMIT 30;

-- Использование ключевых слов LIMIT и OFFSET
-- Использование ключевого слова LIMIT
SELECT
    MaleLastNames.Value AS LastName,
    MaleFirstNames.Value AS FirstName,
    MaleMiddleNames.Value AS MiddleName,
    BirthDates.Value AS BirthDate,
    (SELECT GenderId FROM Genders
    WHERE Title = 'мужской') AS GenderId
FROM MaleLastNames CROSS JOIN MaleFirstNames
    CROSS JOIN MaleMiddleNames
    CROSS JOIN BirthDates
ORDER BY
    MaleLastNames.Value,
    MaleFirstNames.Value,
    MaleMiddleNames.Value,
    BirthDates.Value
LIMIT 50 OFFSET 11900;

SELECT * FROM Adults;

DELETE FROM Adults;

INSERT INTO Adults (LastName, FirstName,
    MiddleName, BirthDate, GenderId)

    SELECT
    MaleLastNames.Value AS LastName,
    MaleFirstNames.Value AS FirstName,
    MaleMiddleNames.Value AS MiddleName,
    BirthDates.Value AS BirthDate,
        (SELECT GenderId FROM Genders
        WHERE Title = 'мужской') AS GenderId
    FROM MaleLastNames CROSS JOIN MaleFirstNames
    CROSS JOIN MaleMiddleNames
    CROSS JOIN BirthDates;

SELECT * FROM Adults
LIMIT 25;


DROP TABLE IF EXISTS Times;
CREATE TEMP TABLE IF NOT EXISTS Times
    (TimeId INTEGER PRIMARY KEY AUTOINCREMENT,
    TimeType NVARCHAR(20),
    TimeStamp TEXT);
    
SELECT * FROM Times;
    
-- Добавляем временную метку перед выполнением оператора
INSERT INTO Times (TimeType, TimeStamp)
VALUES ('BeginTime', strftime('%f', 'now'));    

SELECT * FROM Adults
WHERE (LastName = 'Смирнов' AND FirstName = 'Кирилл');

SELECT * FROM Adults
WHERE (LastName = 'Новиков' AND FirstName = 'Михаил');

SELECT * FROM Adults
WHERE (LastName = 'Михайлов' AND FirstName = 'Егор');

INSERT INTO Times (TimeType, TimeStamp)
VALUES ('EndTime', strftime('%f', 'now'));

SELECT * FROM Times;

SELECT
    (SELECT TimeStamp FROM Times
    WHERE TimeType = 'EndTime'
    ORDER BY TimeId DESC LIMIT 1)
- 
    (SELECT TimeStamp FROM Times
    WHERE TimeType = 'BeginTime'
    ORDER BY TimeId DESC LIMIT 1)
AS Duration;    

--DROP TABLE IF EXISTS Times;

CREATE INDEX IF NOT EXISTS SportsCenter.AdultsLastName
ON Adults (LastName);

-- DROP INDEX IF EXISTS SportsCenter.AdultsLastName;
-- CREATE INDEX IF NOT EXISTS SportsCenter.AdultsLastNameAndFirstName
-- ON Adults (LastName, FirstName);

-- Определение времени выполнения запроса
-- после создания индекса для поля "LastName"
INSERT INTO Times (TimeType, TimeStamp)
VALUES ('BeginTime', strftime('%f', 'now'));    

SELECT * FROM Adults
WHERE (LastName = 'Смирнов' AND FirstName = 'Кирилл');

SELECT * FROM Adults
WHERE (LastName = 'Новиков' AND FirstName = 'Михаил');

SELECT * FROM Adults
WHERE (LastName = 'Михайлов' AND FirstName = 'Егор');

INSERT INTO Times (TimeType, TimeStamp)
VALUES ('EndTime', strftime('%f', 'now'));

SELECT * FROM Times;

SELECT
    (SELECT TimeStamp FROM Times
    WHERE TimeType = 'EndTime'
    ORDER BY TimeId DESC LIMIT 1)
- 
    (SELECT TimeStamp FROM Times
    WHERE TimeType = 'BeginTime'
    ORDER BY TimeId DESC LIMIT 1)
AS Duration;

-- Влияние триггеров на добавление данных
INSERT INTO Times (TimeType, TimeStamp)
VALUES ('BeginTime', strftime('%f', 'now'));

INSERT INTO Adults (LastName, FirstName,
    MiddleName, BirthDate, GenderId)

    SELECT
    MaleLastNames.Value AS LastName,
    MaleFirstNames.Value AS FirstName,
    MaleMiddleNames.Value AS MiddleName,
    BirthDates.Value AS BirthDate,
        (SELECT GenderId FROM Genders
        WHERE Title = 'мужской') AS GenderId
    FROM MaleLastNames CROSS JOIN MaleFirstNames
    CROSS JOIN MaleMiddleNames
    CROSS JOIN BirthDates;
    
INSERT INTO Times (TimeType, TimeStamp)
VALUES ('EndTime', strftime('%f', 'now'));

SELECT
    (SELECT TimeStamp FROM Times
    WHERE TimeType = 'EndTime'
    ORDER BY TimeId DESC LIMIT 1)
- 
    (SELECT TimeStamp FROM Times
    WHERE TimeType = 'BeginTime'
    ORDER BY TimeId DESC LIMIT 1)
AS Duration;


-- Самосоединения таблиц
-- Подготовительный этап. Псевдоним для таблицы
SELECT
    S1.LastName,
    S1.FirstName
FROM Students AS S1;


-- Все возможные варианты
SELECT
    S1.StudentId, S1.LastName, S1.FirstName,
    S2.StudentId, S2.LastName, S2.FirstName
FROM Students AS S1 CROSS JOIN Students AS S2;

-- Исключение элементов, находящихся на главной диагонали
SELECT
    S1.StudentId, S1.LastName, S1.FirstName,
    S2.StudentId, S2.LastName, S2.FirstName
FROM Students AS S1 CROSS JOIN Students AS S2
WHERE S1.StudentId != S2.StudentId;

-- Выбор только уникальных пар
SELECT
    S1.StudentId, S1.LastName, S1.FirstName,
    S2.StudentId, S2.LastName, S2.FirstName
FROM Students AS S1 CROSS JOIN Students AS S2
WHERE S1.StudentId < S2.StudentId;

-- Выбор только уникальных пар с учетом пола
SELECT
    S1.StudentId, S1.LastName, S1.FirstName,
    S2.StudentId, S2.LastName, S2.FirstName
FROM Students AS S1 CROSS JOIN Students AS S2
WHERE S1.StudentId < S2.StudentId
AND S1.GenderId != S2.GenderId;


-- Транзакции
/* ACID <--> АСИД
** A (Atomicity) <--> А (Атомарность)
** С (Consistency) <--> С (Согласованность)
** I (Isolation) <--> И (Изолированность)
** D (Durability) <--> Д (Долговечность)

-- Пример (пока без транзакции)
SELECT * FROM Students

INSERT INTO Students (StudentId, GenderId, LastName, FirstName, MiddleName)
VALUES (18, 4, 'Михайлов', 'Алексей', 'Викторович');

INSERT INTO Students (StudentId, GenderId, LastName, FirstName, MiddleName)
VALUES (19, 6, 'Васильева', 'Варвара', 'Семёновна');

SELECT * FROM Students;

-- Пример (с транзакцией)
BEGIN TRANSACTION;

    INSERT INTO Students (StudentId, GenderId, LastName, FirstName, MiddleName)
    VALUES (21, 4, 'Александров', 'Сергей', 'Васильевич');
    
    SELECT * FROM Students;
    
    INSERT INTO Students (StudentId, GenderId, LastName, FirstName, MiddleName)
    VALUES (22, 6, 'Васильева', 'Варвара', 'Семёновна');

ROLLBACK TRANSACTION;

SELECT * FROM Students;