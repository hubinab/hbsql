-- 1. feladat
DELIMITER //
drop procedure if exists hely_darab//
create procedure hely_darab (_orszagnev varchar(40))
reads sql data
begin
    select count(*) 
    from countries c 
    join locations l on l.country_id = c.country_id 
    where c.country_name = "Japan" 
    group by c.country_id;
end //
delimiter ;

-- 2. feladat
create or replace view dolgozodb 
as select j.JOB_TITLE as munkakor, count(*) as db
from employees e 
join jobs j on e.JOB_ID = j.JOB_ID
group by j.JOB_ID
order by j.JOB_TITLE;

-- 3. feladat
delimiter //
drop procedure if exists minmax//
create procedure minmax()
reads sql data
begin
    set @min = 0;
    set @max = 0;
    select munkakor 
    into @min
    from dolgozodb order by db limit 1;
    select munkakor 
    into @max
    from dolgozodb order by db desc limit 1;
    select @min legkevesebben, @max legtobben;
end//
delimiter ;

-- 4. feladat
delimiter //
drop procedure emel1000//
create procedure emel1000(_city varchar(30), _department_name varchar(30))
modifies sql data
begin
-- select l.city, d.department_name, concat(e.first_name, " ", e.last_name), e.salary 
-- from employees e 
-- join departments d on d.department_id = e.department_id 
-- join locations l on l.location_id = d.location_id 
-- where l.city = "Munich" 
-- and d.department_name = "Public Relations";
    update employees e  
    join departments d on d.department_id = e.department_id 
    join locations l on l.location_id = d.location_id 
    set e.salary=e.salary + 1000
    where l.city = _city
    and d.department_name = _department_name;
end//
delimiter ;
-- call emel1000("Munich", "Public Relations");

-- 5. feladat
delimiter //
drop procedure emeles//
create procedure emeles(_kor int, _department_id decimal(4, 0), _percent int)
modifies sql data
begin
    update employees e  
    join departments d on d.department_id = e.department_id 
    join locations l on l.location_id = d.location_id 
    set e.salary=e.salary * ((100+_percent)/100)
    where TIMESTAMPDIFF(YEAR, e.hire_date, CURDATE()) > _kor
    and d.department_id = _department_id;
end//
delimiter ;

-- select d.department_id, concat(e.first_name, " ", e.last_name) Nev, 
--     e.salary, TIMESTAMPDIFF(YEAR, e.hire_date, CURDATE()) as "Eve dolgozik"  
--     from employees e 
--     join departments d on d.department_id = e.department_id 
--     join locations l on l.location_id = d.location_id 
--     where l.city = "Munich" and d.department_name = "Public Relations";
-- +---------------+--------------+----------+--------------+
-- | department_id | Nev          | salary   | Eve dolgozik |
-- +---------------+--------------+----------+--------------+
-- |            70 | Hermann Baer | 11000.00 |           38 |
-- +---------------+--------------+----------+--------------+
-- call emeles(10, 70, 20);
-- +---------------+--------------+----------+--------------+
-- | department_id | Nev          | salary   | Eve dolgozik |
-- +---------------+--------------+----------+--------------+
-- |            70 | Hermann Baer | 13200.00 |           38 |
-- +---------------+--------------+----------+--------------+
-- 11000*1.2 = 13200

-- 6. feladat
delimiter //
drop procedure hely//
create procedure hely(_location_id decimal(4, 0), _street_address varchar(40), _postal_code varchar(12), 
                    _city varchar(30), _state_province varchar(25), _country_name varchar(40))
modifies sql data
begin
    set @_country_id = "";
    select country_id 
    into @_country_id
    from countries where country_name = _country_name;

    insert into locations 
    (location_id, street_address, postal_code, city, state_province, country_id)
    values(_location_id, _street_address, _postal_code, _city, _state_province, @_country_id);
end//
delimiter ;
-- call hely(3300, "Arany Janos utca 22", 11465, "New York", "New York", "United States of America");
