

-- 2. feladat
CREATE DATABASE IF NOT EXISTS `urhajozas` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

-- 3. feladat
use urhajozas;

-- 5. feladat
select nev, nem, szulev from urhajos;

-- 6. feladat
select megnevezes, DATEDIFF(veg, kezdet) nap from kuldetes;

-- 7. feladat
select nev, year(now())-szulev kor from urhajos order by kor desc;

-- 8. feladat
select nev, year(now())-szulev kor from urhajos order by kor desc;

-- 9. feladat
select megnevezes, nev from kuldetes k join repules r on k.id = r.kuldetes_id join urhajos u on u.id = r.urhajos_id order by k.kezdet, u.nev desc;

-- 10. feladat
select nev from urhajos order by length(nev) desc limit 1;

-- 11. feladat
select megnevezes, count(*) from kuldetes k join repules r on k.id = r.kuldetes_id join urhajos u on u.id = r.urhajos_id group by megnevezes;

-- 12. feladat
select nev, count(*) from kuldetes k join repules r on k.id = r.kuldetes_id join urhajos u on u.id = r.urhajos_id group by nev having count(*) >= 6;

-- 13. feladat
select round(avg(datediff(veg, kezdet)),2) 'Gemini kldetsek tlagos hosszsga' from kuldetes where megnevezes like '%Gemini%';

-- 14. feladat
select orszag from urhajos u join repules r on r.urhajos_id = u.id join kuldetes k on k.id = r.kuldetes_id and year(kezdet) between 1991 and 2000 group by orszag order by count(*) desc limit 3;

-- 15. feladat
select count(*) 'Robik szama' from urhajos where nev like '%Robert%';

-- 16. feladat
select nev, orszag, szulev from urhajos where szulev in (select szulev from urhajos where nev = 'Barbara Morgan');

-- 17. feladat by AI
SELECT k.megnevezes, k.kezdet, k.veg
FROM kuldetes k
JOIN repules r ON k.id = r.kuldetes_id
JOIN urhajos u ON r.urhajos_id = u.id
GROUP BY k.id, k.megnevezes, k.kezdet, k.veg
HAVING SUM(u.nem = 'F') = 0 AND SUM(u.nem = 'N') > 0;

-- 18. feladat
delete FROM `urhajos` WHERE nev = 'Serbán Lajos';

-- 19. feladat
insert into urhajos values(561, 'Alexander Poleshchuk', 'RUS', 'F', 1953, 'T179:00:43');

-- 20. feladat
alter table kuldetes add COLUMN honapok int;

-- 21. feladat
update kuldetes set honapok = timestampdiff(month, kezdet, veg);
