CREATE DATABASE `iskola`
CHARACTER SET utf8mb4
COLLATE utf8mb4_hungarian_ci;

-- show databases;

use iskola;

create or replace view jegyeim as 
select * from jegyek
where diak = SUBSTRING_INDEX(USER(), '@', 1);

-- show tables;

insert into tantargyak values(1, "Matematika");
insert into tantargyak values(2, "Backend programozas");
insert into tantargyak values(3, "Tortnelem");
insert into tantargyak values(4, "Fizika");

insert into jegyek values(1, 1, 4, "Kati", SUBSTRING_INDEX(USER(), '@', 1), now());
insert into jegyek values(2, 2, 5, "Dani", SUBSTRING_INDEX(USER(), '@', 1), now());
insert into jegyek values(3, 4, 2, "Marci", SUBSTRING_INDEX(USER(), '@', 1), now());

update jegyek set jegy=3 where id=3;
