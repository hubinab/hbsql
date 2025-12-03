SET @jobid = "IT_PROG";
SET @city = "Roma";
SET @region = "Americas";
SET @department = "IT";
SET @country = "Canada";
SET @tol = 9000;
SET @ig = 30000;
SET @tabla = "employees";
SET @oszlop = "FIRST_NAME";

-- 1. feladat
select * from employees where job_id = @jobid;

-- 2. feladat
SELECT * from employees where job_id = @jobid
and TIMESTAMPDIFF(YEAR, hire_date, CURDATE()) > 50;

-- 3. feladat
SELECT 
  e.*
FROM employees e
JOIN departments d ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
JOIN locations l ON d.LOCATION_ID = l.LOCATION_ID
JOIN countries c ON l.COUNTRY_ID = c.COUNTRY_ID
JOIN regions r ON c.REGION_ID = r.REGION_ID
WHERE e.JOB_ID = @jobid
  AND r.REGION_NAME = @region;

-- 4. feladat
SELECT AVG(e.SALARY) from employees e
JOIN departments d ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
JOIN locations l ON d.LOCATION_ID = l.LOCATION_ID
WHERE d.DEPARTMENT_NAME = @department
  and l.CITY = @city;

-- 5. feladat
SELECT l.CITY, count(e.EMPLOYEE_ID) from locations l
LEFT JOIN departments d ON d.LOCATION_ID = l.LOCATION_ID
LEFT JOIN employees e ON d.DEPARTMENT_ID = e.DEPARTMENT_ID and e.JOB_ID = @jobid
GROUP by l.city;

-- 6. feladat
SELECT 
  d.DEPARTMENT_NAME, avg(e.SALARY)
FROM departments d
JOIN employees e ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
JOIN locations l ON d.LOCATION_ID = l.LOCATION_ID
JOIN countries c ON l.COUNTRY_ID = c.COUNTRY_ID
where c.COUNTRY_NAME = @country
GROUP by d.DEPARTMENT_NAME;

-- 7. feladat
SELECT 
  c.COUNTRY_NAME, e.*
FROM employees e
JOIN departments d ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
JOIN locations l ON d.LOCATION_ID = l.LOCATION_ID
JOIN countries c ON l.COUNTRY_ID = c.COUNTRY_ID
WHERE c.COUNTRY_NAME = @country
  AND d.DEPARTMENT_NAME = @department
  and e.SALARY BETWEEN @tol and @ig;