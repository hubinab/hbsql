--3. feladat:
create view programozok as select concat(FIRST_NAME, ' ', LAST_NAME) FULL_NAME from employees order by FULL_NAME;

--4. feladat:
select * from programozok;

--5. feladat:
create view munkakorletszam as select JOB_TITLE, count(*) as db from jobs j join employees e on e.job_id = j.job_id group by job_title having count(*) >= 20;

--6. feladat:
select * from munkakorletszam;

--7. feladat:
create view orszagfo as select COUNTRY_NAME, count(*) as fo from countries c join locations l on l.country_id = c.country_id join departments d on d.location_id = l.location_id join employees e
on e.department_id = d.department_id group by country_name;

--8. feladat:
select *from orszagfo;

--9. feladat:
create view reszlegvezeto as select DEPARTMENT_NAME, concat(first_name, ' ', last_name) FULL_NAME from departments d join employees e on e.employee_id = d.manager_id;

--10. feladat:
select * from reszlegvezeto where FULL_NAME like 'Den%';

--11. feladat:
create view kiholdolgozik as select d.DEPARTMENT_NAME, d.DEPARTMENT_ID, FIRST_NAME, LAST_NAME, e.EMPLOYEE_ID from employees e join departments d on d.department_id = e.department_id;

--12. feladat:
select avg(salary) from employees e where e.department_id in (select department_id from kiholdolgozik k where k.first_name = 'David' and k.last_name = 'Austin');

--13. feladat:
create view belepo as select concat(first_name, ' ', last_name) FULL_NAME, HIRE_DATE from employees;

--14. feladat:
select * from belepo;

--15. feladat:
create view regiovezetok as select concat(e.first_name, ' ', e.last_name) FULL_NAME, e.HIRE_DATE, r.REGION_NAME from employees e join departments d on d.department_id = e.department_id and e.employee_id=d.manager_id join locations l on d.location_id = l.location_id join countries c on c.country_id = l.country_id join regions r on r.region_id = c.region_id;

--16. feladat:
select * from regiovezetok;
