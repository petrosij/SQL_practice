-- Лекция 4
-- Оператор SELECT

-- Самый простой вариант оператора SELECT
SELECT *
FROM Trainers;

-- Выбор перечня атрибутов, возвращаемых оператором SELECT
SELECT
    TrainerId,
    LastName,
    FirstName
FROM Trainers;

-- Изменение порядка следования атрибутов
SELECT
    TrainerId,
    FirstName,
    LastName
FROM Trainers;
 
-- Фильтрация результатов
SELECT
    TrainerId,
    LastName,
    FirstName
FROM Trainers
WHERE TrainerId = 4;    

-- Сортировка результатов
SELECT
    TrainerId,
    LastName,
    FirstName
FROM Trainers
ORDER BY LastName;

-- Сортировка результатов по нескольким атрибутам
SELECT
    TrainerId,
    LastName,
    FirstName
FROM Trainers
ORDER BY LastName, FirstName;

-- Группировка результатов

-- Подготовительный запрос
SELECT
    GenderId,
    Salary
FROM Trainers
ORDER BY GenderId;

-- Собственно группировка
SELECT
    GenderId,
    AVG(Salary),
    SUM(Salary)
FROM Trainers
GROUP BY GenderId;
    

/* Функции агрегирования SQLite
  AVG -- среднее значение
  COUNT -- общее количество значений (NOT NULL) в столбце
  COUNT(*) -- общее количество строк в группе
  MAX -- максимальное значение в группе
  MIN -- минимальное значение в группе
  SUM -- сумма всех значений в группе
  TOTAL -- сумма всез значение в группе. Если есть только NULL-значения,
  то для таких групп возвращаемым значением будет 0

SELECT
    GenderId,
    AVG(Salary),
    COUNT(Salary),
    COUNT(*),
    MAX(Salary),
    MIN(Salary),
    SUM(Salary),
    TOTAL(Salary)
FROM Trainers
GROUP BY GenderId;

-- Использование псевдонимов
SELECT
    GenderId,
    AVG(Salary) AS AverageSalary,
    COUNT(Salary) AS PeopleQuantity,
    COUNT(*) AS QuantityWithNulls,
    MAX(Salary) AS MaxSalary,
    MIN(Salary) AS MinSalary,
    SUM(Salary) AS TotalSalary,
    TOTAL(Salary) AS SalaryWithNulls
FROM Trainers
GROUP BY GenderId;


-- Объединение таблиц
SELECT * FROM Students;

-- Внутреннее объединение таблиц (INNER JOIN)
SELECT
    LastName,
    FirstName,
    Genders.Title
FROM Students INNER JOIN Genders
ON Students.GenderId = Genders.GenderId;


-- Ещё один пример: выбор преподавателей и их занятий
SELECT
    Trainers.LastName,
    Trainers.FirstName,
    Trainers.MiddleName,
    Trainings.SportId
FROM Trainers INNER JOIN Trainings
ON Trainers.TrainerId = Trainings.TrainerId
ORDER BY
    Trainers.LastName ASC,
    Trainers.FirstName ASC;

-- Левое внешнее объединение таблиц (LEFT OUTER JOIN)
-- Выбор всех преподавателей (у которых есть занятия, и у которых занятий нет)
SELECT
    Trainers.LastName,
    Trainers.FirstName,
    Trainers.MiddleName,
    Trainings.SportId
FROM Trainers LEFT OUTER JOIN Trainings
ON Trainers.TrainerId = Trainings.TrainerId
ORDER BY
    Trainers.LastName ASC,
    Trainers.FirstName ASC;

-- Выбор только тех преподавателей, у которых есть занятия...
SELECT
    Trainers.LastName,
    Trainers.FirstName,
    Trainers.MiddleName,
    Trainings.SportId
FROM Trainers LEFT OUTER JOIN Trainings
ON Trainers.TrainerId = Trainings.TrainerId
WHERE Trainings.SportId IS NOT NULL
ORDER BY
    Trainers.LastName ASC,
    Trainers.FirstName ASC;

-- ... и тех преподавателей, у которых занятий пока нет
SELECT
    Trainers.LastName,
    Trainers.FirstName,
    Trainers.MiddleName,
    Trainings.SportId
FROM Trainers LEFT OUTER JOIN Trainings
ON Trainers.TrainerId = Trainings.TrainerId
WHERE Trainings.SportId IS NULL
ORDER BY
    Trainers.LastName ASC,
    Trainers.FirstName ASC;

-- Использование оператора UNION
SELECT
    Students.LastName,
    Students.FirstName,
    Students.MiddleName,
    'Student' AS Status
FROM Students
UNION
SELECT
    Adults.LastName,
    Adults.FirstName,
    Adults.MiddleName,
    'Adult' AS Status
FROM Adults;

-- Моделирование правого внешнего объединения таблиц (RIGHT OUTER JOIN)
SELECT
    Trainers.LastName,
    Trainers.FirstName,
    Trainers.MiddleName,
    Trainings.SportId,
    Sports.Title
FROM Sports LEFT OUTER JOIN Trainings
ON Sports.SportId = Trainings.SportId
    LEFT OUTER JOIN Trainers
    ON Trainings.TrainerId = Trainers.TrainerId;

-- Моделирование полного внешнего объединения таблиц
SELECT
    Trainers.LastName,
    Trainers.FirstName,
    Trainers.MiddleName,
    Trainings.SportId,
    Sports.Title
FROM Trainers LEFT OUTER JOIN Trainings
ON Trainers.TrainerId = Trainings.TrainerId
    LEFT OUTER JOIN Sports
    ON Trainings.SportId = Sports.SportId
UNION
SELECT
    Trainers.LastName,
    Trainers.FirstName,
    Trainers.MiddleName,
    Trainings.SportId,
    Sports.Title
FROM Sports LEFT OUTER JOIN Trainings
ON Sports.SportId = Trainings.SportId
    LEFT OUTER JOIN Trainers
    ON Trainings.TrainerId = Trainers.TrainerId;