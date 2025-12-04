-- 1. feladat

-- 2. feladat
drop database if exists jatekok;
create database if not exists jatekok character set utf8mb4 collate utf8mb4_hungarian_ci;

-- 3. feladat


-- 4. feladat
drop view if exists `kimit`;
create view if not exists `kimit` as select `jatekos`.`nev`, `jatek`.`cim` from `jatekos` 
join `allapot` on `allapot`.`jatekos_id` = `jatekos`.`id`
join `jatek` on `allapot`.`jatek_id` = `jatek`.`id`;

-- 5. feladat
drop view if exists `felig`;
create view if not exists `felig` as select distinct `jatekos`.`nev` from `jatekos` 
join `allapot` on `allapot`.`jatekos_id` = `jatekos`.`id` where `allapot`.`kijatszva` >= 0.5;

-- 6. feladat
drop function if exists `szazalek`;
create function if not exists `szazalek`(ertek double) returns varchar(20) DETERMINISTIC NO SQL
return concat(ertek*100, ' %');

-- 7. feladat
select `jatekos`.`kor`, `szazalek`(round(avg(`allapot`.`kijatszva`), 2)) from `jatekos`
join `allapot` on `allapot`.`jatekos_id` = `jatekos`.`id`
group by `jatekos`.`kor`;

-- 8. feladat
select count(`jatekos`.`id`) from `jatekos` 
join `allapot` on `allapot`.`jatekos_id` = `jatekos`.`id` where `allapot`.`kijatszva` >= 0.9;

-- 9. feladat
select `jatekos`.`nev` from `jatekos` 
join `allapot` on `allapot`.`jatekos_id` = `jatekos`.`id` 
group by `jatekos`.`nev`
ORDER BY SUM(`allapot`.`vetelar`) DESC LIMIT 1;

-- 10. feladat
select `jatek`.`cim` from `jatek` 
join `allapot` on `allapot`.`jatek_id` = `jatek`.`id` 
ORDER BY `allapot`.`vetelar` LIMIT 1;

-- 11. feladat
drop procedure if exists `mennyijatek`;
delimiter //
create procedure if not exists `mennyijatek` (in platform varchar(15), in kiado varchar(20), out valasz int)
BEGIN
	SELECT count(*) into valasz FROM `jatek` 
	JOIN `allapot` on `allapot`.`jatek_id` = `jatek`.`id`
	where `jatek`.`platform` = platform
	and `jatek`.`kiado` = kiado
	GROUP by `jatek`.`platform`, `jatek`.`kiado`;
END //
delimiter ;

-- 12. feladat
drop trigger if exists `maxszazalek100`;
DELIMITER //
create trigger if not exists `maxszazalek100` before insert on `allapot` for each row 
BEGIN
	if new.`kijatszva` > 1 then 
    	signal sqlstate 'HY000' 
    	set MESSAGE_TEXT = 'A kijátszva értéke nem lehet több, mint 100 %!';
    end if;
end //
DELIMITER ;

-- 13. feladat
drop event if exists `delia_ebbitt_1`;
DELIMITER //
create event if not exists `delia_ebbitt_1` on SCHEDULE every 1 day STARTS '2025-11-30 02:00:00'
DO
BEGIN
update `allapot` join `jatekos` on `jatekos`.`id` = `allapot`.`jatekos_id`
set `kijatszva` = `kijatszva`+0.01 where `jatekos`.`nev` = 'Delia Ebbitt';
END//
DELIMITER ;
-- 14. feladat
create user 'statisztika'@'localhost' identified by 'kutya';
GRANT SELECT on `jatekok`.`koratlag` to 'statisztika'@'localhost';
