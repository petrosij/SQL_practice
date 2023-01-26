insert into sports (title)
values ('биатлон');

insert into sports (sportid,title)
values (12,'теннис'), (13,'настольный теннис');

insert into halls (hallnumber, title)
values ('004', 'лекционная аудитория');

insert into trainers (trainerid, genderid, lastname, firstname, middlename, salary, socialsecuritynumber)
values (9,'4','аганин','Владимир','Николаевич','30000','123-456-789 00 '), (10,'4','Романычев','александр','Иванович','40000','123-456-789 01');

insert into trainings (trainerid,sportid,hallid,weekday,begintime,endtime)
values ('9','11','4','четверг','11:45','13:45'),('10','13','4','Пятница','13:30','14:45');

update sports
set title = 'Синхронное плавание'
where sportid = 7;

update adults 
set firstname = 'Руслан'
where firstname like 'Арт_м';

update trainers 
set salary = 35000
where salary <= 30000;

delete from sports 
where sportid = 11;

-- Задание 10

delete from Trainers 
where LastName = 'Фамилия' and FirstName = 'Имя' and MiddleName = 'Отчество';

-- Задание 11

delete from MaleMiddleNames
where MaleMiddleNameId in (6,7);

--Задание 12 

delete from MaleMiddleNames
where MaleMiddleNameID between 8 and 10;

--Задание 12а
insert into MaleMiddleNames (maleMiddleNameID,value)
values (6,'Викторович'),(7,'Генадьевич'),(8,'Георгиевич'),(9,'Петрович'),(10,'Никитич');

--Задание 13
insert into sports (title)
values 
    ('Пляжный футбол'),('Пляжный волейбол');
    
delete from sports
where title like 'Пляжный %';

--Задание 14
select * from students;

--Задание 15
select 
    studentid,
    lastname,
    firstname,
    middlename
from students;

--Задание 16
select 
    studentid,
    firstname,
    lastname,
    middlename
from students;


--Задание 17
select
    studentid,
    lastname,
    firstname,
    middlename
from students
    order by lastname asc, firstname desc;
    
--Задание 18

select *
from students
where genderID = 2
order by lastname asc;

select *
from students
where genderID = 4
order by lastname asc;

--Задание 19
select 
    studentID,
    lastname as surname,
    firstname as name
from students
order by lastname asc;

--задание 20

select * from adults
where birthdate like '1985-02-%';

--Задание 21

select
    firstname,
    count(studentid) as quantity
from students
group by firstname
order by quantity desc;


--Задание 22
select
    genderid,
    avg(salary) as AvarageSalary
from trainers
group by genderid;

--Задание 23
select 
    genderid,
    min(salary) as minSalary,
    max(salary) as maxSalary,
    avg(salary) as avgSalary,
    count(*) as quantity
from trainers
group by genderid
having genderid = 4;

--Задание 24 
select 
    Students.LastName,
    Students.FirstName,
    Students.MiddleName,
    Genders.Title
from students inner join genders
    on students.GenderId = genders.GenderId
order by 
    students.lastname asc;
    
--Задание 25
select 
    students.LastName,
    students.FirstName,
    sports.Title
from students inner join studententries
on students.studentId = studententries.StudentId
    inner join trainings 
    on studententries.TrainingId = trainings.TrainingId
        inner join sports
        on trainings.SportId = sports.SportId
order by lastName asc;

--Задание 26 

select 
    trainers.LastName,
    trainers.FirstName,
    trainings.WeekDay,
    trainings.BeginTime,
    trainings.EndTime
from students inner join studententries
on students.studentId = studententries.StudentId
    inner join trainings 
    on studententries.TrainingId = trainings.TrainingId
        inner join trainers
        on trainings.TrainerId = trainers.TrainerId
where
    students.FirstName = 'Анастасия' and
    students.LastName = 'Боренко'and
    students.MiddleName = 'Денисовна';
    
        