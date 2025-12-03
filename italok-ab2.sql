-- A készlet egy adott ital esetén kevésnek minősül, ha a készletből nincs legalább 48 egység.

-- Azokat az italokat nevezhetjük alkoholmentesnek, melyek alkoholtartalma nem éri el a 0,051% (5,1 ezrelék) alkohol szintet.

-- 1. feladat
-- 1. Készítsen egy nézet táblát nemsor néven, ami megjeleníti azokat a nem sör típusú italokat,
-- melyek ára 220 Ft és 440 Ft között van!
drop view if exists `nemsor`;
create view if not exists `nemsor` as select * from `italok` where `tipus` <> 'sör' and `ar` between 220 and 440;

-- 2. feladat
-- 2. Hozzon létre egy nézet táblát keszlethiany néven, ami megjeleníti azon dobozos kiszereléső
-- termékek nevét, melyekből kevés van a készleten.
drop view if exists `keszlethiany`;
create view if not exists `keszlethiany` as select `nev` from `italok` where `kiszereles` = 'dobozos' and `keszlet` < 48;

-- 3. feladat
-- 3. Készítsen egy alkohol_formaz(alkohol) függvényt, ami emberi szem számára olvashatóvá teszi az alkoholmennyiséget.
-- Például a Soproni Dobozos sör 0,5l 4,5% alkoholtartalma az adatázisban 0.04500. A függvény kimenete 4,5% (szöveg) legyen!
drop function if exists `alkohol_formaz`;
delimiter //
create function if not exists `alkohol_formaz` (`alkohol` double) returns varchar(10) DETERMINISTIC no sql
begin
    return replace(concat(round(alkohol * 100,1), '%'),'.',',');
end//
delimiter ;

-- 4. feladat
-- 4. Készítsen egy lekérdezést, ami megjeleníti minden ital nevét (nem a megnevezését!), típusát
--   és az alkohol tartalmát az alkohol_formaz() függvény segítségével megformázva.
select `nev`, `tipus`, alkohol_formaz(`alkohol`) from `italok`;

-- 5. feladat
-- 5. Hozzon létre egy eladas táblát, amiben lehet rögzíteni, hogy mi lett eladva ( id ), hány egység
--  lett eladva ( egyseg ), és az eladás pontos idejét. ( mikor ). Az oszlopnevek a zárójelben megadottak legyenek!
drop table if exists `eladas`;
create table if not exists `eladas` (
    `id` int not null,
    `egyseg` int not null,
    `mikor` datetime not null
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 6. feladat
-- 6. Készítsen egy triggert sor néven, ami garantálja, hogy ne lehessen olyan sört beszúrni, ami húsz
--  ezrelék (0,0020) feletti alkoholtartalommal rendelkezik. Amennyiben a felhasználó mégis ezzel
--  próbálkozna, úgy A sörben kevesebb alkohol lehet! figyelmeztetést adjon!
drop trigger if exists `sor`;
delimiter //
create trigger if not exists `sor` before insert on `italok`
for each row
begin
    if new.alkohol > 0.020 then
        SIGNAL SQLSTATE 'HY000'
        SET MESSAGE_TEXT= 'A sörben kevesebb alkohol lehet!';
    end if;
end//
delimiter ;

-- 7. feladat
-- 7. Készítsen egy triggert nincsennyi néven, módosítás esetén, ha egy termék készlete lecsökkenne
--  0 alá, akkor "Nincs ennyi" hibaüzenettel térjen vissza.
drop trigger if exists `nincsennyi`;
delimiter //
create trigger if not exists `nincsennyi` before update on `italok`
for each row
begin
    if new.keszlet < 0 then
        SIGNAL SQLSTATE 'HY000'
        SET MESSAGE_TEXT= 'Nincs ennyi';
    end if;
end//
delimiter ;

-- 8. feladat
-- 8. Hozzon létre egy tárolt eladas_rogzitese(mit,mennyit) eljárást, ami a paraméterként kapott
--  azonosítójú terméknek csökkenti a jelenlegi készletét a szintén paraméterként kapott mennyiséggel.
--  Ezek után rögzítse az eladás tényét az eladas táblába minden szükséges adattal.
--  Fontos, hogy a két lekérdezés csak akkor hajtódjon végre, ha mind a kettő sikeres. Ha nem,
--  akkor egyik se!
drop procedure if exists `eladas_rogzitese`;
delimiter //
create procedure if not exists `eladas_rogzitese` (mit int, mennyit int) modifies sql data
begin
    start transaction;
    update `italok` set `keszlet` = `keszlet` - mennyit where `id` = mit;
    insert into `eladas` (`id`, `egyseg`, `mikor`) values(mit, mennyit, now());
    commit;
end//
delimiter ;

-- 9. feladat
-- 9. Az eladas tábla felhasználásával állapítsa meg, hogy melyik termékből eddig mennyit adtak el
--  összesen! A lekérdezésben a termék nevét jelenítse meg, és az összesített eladott egységet.
select `nev`, sum(`egyseg`) from `italok` join `eladas` on `italok`.`id` = `eladas`.`id` group by `italok`.`id`;

-- 10. feladat
-- 10. Készítsen egy táblát statisztika néven, ami két mezőből áll: datum és liter.
--  A kulcs a dátum legyen! A liter pedig legyen alkalmas arra, hogy a napi össz eladást el tudja
--  tárolni.
drop table if exists `statisztika`;
create table if not exists `statisztika` (
    `datum` date primary key,
    `liter` float
);

-- 11. feladat
-- 11. Készítsen, egy minden nap hajnal 1-kor lefutó eseményt napi néven, ami összesíti az aznapi
--  eladott mennyiséget és a statisztika táblát tölti fel vele.
drop event if exists `napi`;
delimiter //
create event `napi` on schedule every 1 day starts '2025-11-26 01:00:00'
do 
begin
    select sum(`egyseg`*`mennyiseg`) into @sum from `eladas` `e` join `italok` `i` on `i`.`id` = `e`.`id`;
    insert into `statisztika` (`datum`, `liter`) values(date(now()), @sum);
end// 
delimiter ;