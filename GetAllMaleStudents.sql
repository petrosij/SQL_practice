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