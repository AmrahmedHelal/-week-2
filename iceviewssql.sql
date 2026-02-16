create view vw_househeatersummary
as
select
    h.house_id as houseid,
    he.heater_id as heaterid,
    he.heatertype as heatertype,
    he.powervalue as powervalue
from houses h
join heater he
    on h.house_id = he.house_id;


create view vw_monthlycostsummary
as
select
    h.house_id as houseid,
    m.reportmonth as reportmonth,
    sum(d.hoursworked) as totalworkinghours,
    avg(d.hoursworked * he.powervalue) as monthlyaveragecost
from houses h
join monthlyreports m
    on h.house_id = m.house_id
join dailyusages d
    on h.house_id = d.house_id
join heater he
    on h.house_id = he.house_id
group by
    h.house_id,
    m.reportmonth;


