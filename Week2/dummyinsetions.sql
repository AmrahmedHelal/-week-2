create table Houses (house_id int primary key identity (1,1) , OutsideTemp int , CreatedAt date)
create table Heater(heater_id int primary key identity(1,1),ModelName varchar(15), PowerKw int ,Efficiency varchar(15)
,house_id int references Houses(house_id))

create table DailyUsages(DailyUsage_id int primary key identity(1,1), house_id int references Houses(house_id),UsageDate date
,HoursWorked int , HeaterValue int )

create table Owner (owner_id int primary key identity(1,1),FullName varchar(50),PhoneNumber int , Email varchar(50))
alter table Houses 
add owner_id int references Owner(owner_id)
-----------------------------------------------------------
create table MonthlyReports (
    report_id int primary key identity(1,1),
    house_id int references Houses(house_id),
    ReportMonth int,
    ReportYear int,
    TotalHours int
)


insert into Owner (FullName, PhoneNumber, Email) values
('Ahmed Ali', 1011111111, 'ahmed@email.com'),
('Mohamed Samy', 1022222222, 'mohamed@email.com'),
('Omar Hassan', 1033333333, 'omar@email.com');


insert into Houses (OutsideTemp, CreatedAt, owner_id) values
(25, '2026-01-01', 1),
(30, '2026-01-02', 1),

(20, '2026-01-03', 2),
(18, '2026-01-04', 2),

(15, '2026-01-05', 3),
(10, '2026-01-06', 3);
select * from MonthlyReports
insert into Heater (ModelName, PowerKw, Efficiency, house_id) values
('H100', 5, 'High', 1),
('H101', 4, 'Medium', 1),

('H102', 6, 'High', 2),
('H103', 5, 'Low', 2),

('H104', 4, 'High', 3),
('H105', 3, 'Medium', 3),

('H106', 5, 'High', 4),
('H107', 4, 'Low', 4),

('H108', 6, 'High', 5),
('H109', 5, 'Medium', 5),

('H110', 4, 'High', 6),
('H111', 3, 'Low', 6);

-- House 1
INSERT INTO DailyUsages (house_id, UsageDate, HoursWorked, HeaterValue)
VALUES 
(1, '2026-01-01', 5, 120),
(1, '2026-01-02', 6, 125);

-- House 2
INSERT INTO DailyUsages (house_id, UsageDate, HoursWorked, HeaterValue)
VALUES 
(2, '2026-01-01', 4, 110),
(2, '2026-01-02', 7, 115);

-- House 3
INSERT INTO DailyUsages (house_id, UsageDate, HoursWorked, HeaterValue)
VALUES 
(3, '2026-01-01', 6, 130),
(3, '2026-01-02', 5, 128);

-- House 4
INSERT INTO DailyUsages (house_id, UsageDate, HoursWorked, HeaterValue)
VALUES 
(4, '2026-01-01', 5, 118),
(4, '2026-01-02', 6, 122);

-- House 5
INSERT INTO DailyUsages (house_id, UsageDate, HoursWorked, HeaterValue)
VALUES 
(5, '2026-01-01', 4, 115),
(5, '2026-01-02', 5, 119);

-- House 6
INSERT INTO DailyUsages (house_id, UsageDate, HoursWorked, HeaterValue)
VALUES 
(6, '2026-01-01', 7, 125),
(6, '2026-01-02', 6, 128);


insert into MonthlyReports (house_id, ReportMonth, ReportYear, TotalHours)
select 
    house_id,
    1,
    2026,
    sum(HoursWorked)
from DailyUsages
group by house_id;



select * from MonthlyReports

exec sp_CalculateDailyHeaterUsageCost 1,'2026-1-1'

