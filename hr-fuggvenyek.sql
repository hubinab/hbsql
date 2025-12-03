-- 1. feladat
delimiter //
drop function if exists orszagkod//
create function orszagkod(_country_name varchar(40))
returns varchar(2)
reads sql data
begin
    set @country_id = "";
    select country_id
    into @country_id
    from countries
    where country_name = _country_name;
    return @country_id;
end//
delimiter ;
-- select orszagkod("Egypt") from dual;

-- 2. feladat
delimiter //
drop function if exists atlag//
create function atlag(_department_name varchar(30))
returns float
reads sql data
begin
    select avg(salary)
    into @atlag
    from employees e 
    join departments d on e.department_id = d.department_id
    where department_name = _department_name;
    return @atlag;
end//
delimiter ;

-- select atlag("IT") from dual;
-- select avg(salary) from employees where department_id = 60;

-- 3. feladat
delimiter //
drop function if exists fonokatlag//
create function fonokatlag()
returns float
reads sql data
begin 
    select round(avg(salary), 2) "atlagfizetes"
    into @foniatlag
    from employees e 
    join departments d on d.department_id = e.department_id 
    and (e.employee_id = d.manager_id or e.manager_id = 0);
    return @foniatlag;
end//
delimiter ;

-- select fonokatlag() from dual;

-- 4. feladat
delimiter //
drop function if exists email//
-- itt lehet inkabb employee_id-t kene beolvasni
create function email(_first_name varchar(20), _last_name varchar(25))
returns varchar(20)
reads sql data
begin 
    select concat(lower(substr(last_name,1,2)), lower(substr(first_name, -2)), employee_id, '@example.com') 
    into @email
    from employees
    where first_name = _first_name
    and last_name = _last_name;
    return @email;
end//
delimiter ;

-- select email(first_name, last_name) from employees;

-- 5. feladat
select first_name, last_name, employee_id, email(first_name, last_name) from employees;
update employees set `email` = email(FIRST_NAME, LAST_NAME);
