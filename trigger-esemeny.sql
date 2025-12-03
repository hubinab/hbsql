-- 0. feladat
create table if not exists `Person`(
    ID int PRIMARY KEY AUTO_INCREMENT,
    FirstName varchar(100) not null,
    LastName varchar(100) not null,
    FullName varchar(201),
    BirthDate date not null
);

create table if not exists `Person_Archive`(
    FirstName varchar(100) not null,
    LastName varchar(100) not null,
    BirthDate date not null,
	ArchiveDate date not null	
);

create table if not exists `log` (
    ID int PRIMARY KEY AUTO_INCREMENT,
	`DateTime` datetime,
    Messag Text 
);

-- 1. feladat
delimiter //
drop trigger if exists Fullname_I_B//
create trigger Fullname_I_B
before insert on Person
for each row
begin
    set NEW.FullName = concat(NEW.FirstName, ' ', NEW.LastName);
end//
delimiter ;

-- insert into Person (FirstName, LastName, BirthDate) values("Balazs", "Hubina", "1976-12-18");

-- 2. feladat
delimiter //
drop trigger exists Fullname_U_B//
create trigger Fullname_U_B
before update on Person
for each row
begin
    set NEW.FullName = concat(NEW.FirstName, ' ', NEW.LastName);
end//
delimiter ;

-- update Person set FirstName = "Bela" where ID = 1;

-- 3. feladat
delimiter //
drop trigger exists Archive_D_A//
create trigger Archive_D_A
after delete on Person
for each row
begin 
    insert into Person_Archive (FirstName, LastName, BirthDate, ArchiveTime)
    values (OLD.FirstName, OLD.LastName, OLD.BirthDate, now());
end//
delimiter ;
-- delete from Person where ID = 1;
-- select * from Person_Archive;

-- 4. feladat
delimiter //
drop trigger if exists Archive_D//
create trigger Archive_D
before delete on Person_Archive
for each row
begin
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Törlés nem engedélyezett ezen a táblán.';
end//
delimiter ;
-- delete from Person_Archive where ID = 1;

-- 5. feladat
alter table `Person`
    add column `IsDeleted` tinyint default 0;

-- 6. feladat
drop trigger if exists `Archive_D_A`;
delimiter //
create trigger if not exists `Archive_D_A` after delete on `Person` for each ROW
begin
if old.`IsDeleted` = 0 then
        insert into `Person_Archive` (`ArchiveDate`, `BirthDate`, `FirstName`, `LastName`) 
            VALUES(date(now()), old.`BirthDate`, old.`FirstName`, old.`LastName`);
    end if;
end//
delimiter ;

-- 7. feladat
create event if not exists `csakegyszer` on schedule at now() + interval 1 minute 
	do insert into `log` (`DateTime`, `Messag`) values('1900-01-01', 'beszúrva');

-- 8. feladat
drop event if exists `otpercmost`;
create event if not exists `otpercmost` 
	on schedule every 5 minute starts now() ends now() + interval 2 hour
    do insert into log (`DateTime`) values(now());

-- 9. feladat
-- Ez ugyan az, mint a 8-as!!!!

-- 10. feladat
select *from `logs`;

-- 11. feladat
create trigger if not exists `torleslog` 
	after delete on `Person` for each row
    	insert into log (`DateTime`, `Messag`) values(now(), old.FullName);



