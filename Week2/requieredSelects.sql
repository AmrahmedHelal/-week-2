--Retrieve all houses for a specific owner
select *
from Houses
where owner_id = 1;
--Retrieve all heaters in a specific house
select *
from Heater
where house_id = 1;

--Get daily usage records where working hours > 8
select *
from DailyUsages
where HoursWorked > 8;

--Get reports for a specific month
select *
from MonthlyReports
where ReportMonth = 1
  and ReportYear = 2026;

--Order houses by total monthly cost (descending)
select h.house_id,
       sum( d.HoursWorked* he.PowerKw* 2.5) as TotalCost
from Houses h
join DailyUsages d on h.house_id = d.house_id
join Heater  he on he.house_id=h.house_id
group by h.house_id
order by TotalCost desc;

--Order heaters by power value
select *
from Heater
order by PowerKw;
--Total working hours per house per month
select house_id,
       month(UsageDate) as MonthNumber,
       sum(HoursWorked) as TotalHours
from DailyUsages
group by house_id,
         month(UsageDate)
       
--Average daily working hours per heater
select 
    he.heater_id,
    he.ModelName,
    avg(d.HoursWorked) as AvgDailyHours
from Heater he
join Houses h 
    on he.house_id = h.house_id
join DailyUsages d 
    on h.house_id = d.house_id
group by 
    he.heater_id,
    he.ModelName

--Maximum heater value used per house
select 
    h.house_id,
    max(d.HeaterValue) as MaxHeaterValue
from Houses h
join DailyUsages d 
    on h.house_id = d.house_id
group by h.house_id

--Group daily usage by house
select 
    h.house_id,
    count(d.DailyUsage_id) as TotalRecords,
    sum(d.HoursWorked) as TotalHours,
    avg(d.HoursWorked) as AvgHours,
    max(d.HeaterValue) as MaxHeaterValue
from Houses h
join DailyUsages d 
    on h.house_id = d.house_id
group by h.house_id


--Group reports by owner
select 
    o.owner_id,
    o.FullName,
    count(m.report_id) as TotalReports,
    sum(m.TotalHours) as TotalOwnerHours
from Owner o
join Houses h 
    on o.owner_id = h.owner_id
join MonthlyReports m 
    on h.house_id = m.house_id
group by 
    o.owner_id, o.FullName


--joins 

--Owner + House
select o.FullName,
       h.house_id,
       h.OutsideTemp
from Owner o
join Houses h on o.owner_id = h.owner_id;
		
--House + Heater
select h.house_id,
       he.ModelName,
       he.PowerKw
from Houses h
join Heater he on h.house_id = he.house_id;

--Heater + DailyUsage
select 
    he.heater_id,
    he.ModelName,
    d.UsageDate,
    d.HoursWorked,
    d.HeaterValue
from Heater he
join Houses h 
    on he.house_id = h.house_id
join DailyUsages d 
    on h.house_id = d.house_id

--House + MonthlyReport
select h.house_id,
       m.ReportMonth,
       m.TotalHours
from Houses h
join MonthlyReports m on h.house_id = m.house_id;


exec sp_CalculateDailyHeaterUsageCost 1,'2026-1-1'
