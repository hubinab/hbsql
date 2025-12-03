create database if not exists `banki_utalas` default character set utf8mb4 collate utf8mb4_hu_0900_ai_ci;

select p.Name, a.Balance from Person p 
join Account a on p.ID = a.Person_Id;

select p.Name from Person p
left join Account a on p.ID = a.Person_Id 
where a.Balance is null;

set autocommit = 0;
start transaction;
update Account a join Person p on p.ID = a.Person_Id set a.Balance = a.Balance-1500 
where p.Name = 'Reaper';
update Account a join Person p on p.ID = a.Person_Id set a.Balance = a.Balance+1500 
where p.Name = 'Lúcio';
commit;

set autocommit = 0;
start transaction;
update Account a join Person p on p.ID = a.Person_Id set a.Balance = a.Balance-1500 
where p.Name = 'Hanzo';
update Account a join Person p on p.ID = a.Person_Id set a.Balance = a.Balance+1500 
where p.Name = 'Mei';
commit;

set autocommit = 0;
start transaction;
select a.ID into @acc_from from Account a right join Person p on p.ID = a.Person_Id
where p.Name = 'Reaper';
select a.ID into @acc_to from Account a right join Person p on p.ID = a.Person_Id
where p.Name = 'Lúcio';
update Account a join Person p on p.ID = a.Person_Id set a.Balance = a.Balance-1500 
where p.Name = 'Reaper';
update Account a join Person p on p.ID = a.Person_Id set a.Balance = a.Balance+1500 
where p.Name = 'Lúcio';
set @sql = (select if(@acc_from is null or @acc_to is null, "ROLLBACK;", "COMMIT;"));
prepare stmt from @sql;
execute stmt;

set autocommit = 0;
start transaction;
select a.ID into @acc_from from Account a right join Person p on p.ID = a.Person_Id
where p.Name = 'Hanzo';
select a.ID into @acc_to from Account a right join Person p on p.ID = a.Person_Id
where p.Name = 'Mei';
update Account a join Person p on p.ID = a.Person_Id set a.Balance = a.Balance-1500 
where p.Name = 'Hanzo';
update Account a join Person p on p.ID = a.Person_Id set a.Balance = a.Balance+1500 
where p.Name = 'Mei';
set @sql = (select if(@acc_from is null or @acc_to is null, "ROLLBACK;", "COMMIT;"));
prepare stmt from @sql;
execute stmt;

set autocommit = 0;
start transaction;
update Account a join Person p on p.ID = a.Person_Id set a.Balance = a.Balance-150 
where p.Name = 'Mei';
update Account a join Person p on p.ID = a.Person_Id set a.Balance = a.Balance+150 
where p.Name = 'Torbjörn';
commit;

create table if not exists `transactions`(
	`ID` int NOT NULL AUTO_INCREMENT,
	`From_Account` int not null,
	`To_Account` int not null,
	`State` varchar(20) not null,
    `Date` date not null,
    primary key(`ID`),
    foreign key (`From_Account`) references `Account`(`ID`),
    foreign key (`To_Account`) references `Account`(`ID`)
);

set autocommit = 0;
start transaction;
select a.ID into @acc_from from Account a right join Person p on p.ID = a.Person_Id
where p.Name = 'Reaper';
select a.ID into @acc_to from Account a right join Person p on p.ID = a.Person_Id
where p.Name = 'Lúcio';
update Account a join Person p on p.ID = a.Person_Id set a.Balance = a.Balance-1500 
where p.Name = 'Reaper';
update Account a join Person p on p.ID = a.Person_Id set a.Balance = a.Balance+1500 
where p.Name = 'Lúcio';
insert into transactions (`From_Account`, `To_Account`, `State`, `Date`)
                     values(@acc_from, @acc_to, 'Sikeres', CURDATE()); 
set @sql = (select if(@acc_from is null or @acc_to is null, "ROLLBACK;","COMMIT;"));
prepare stmt from @sql;
execute stmt;

set autocommit = 0;
start transaction;
select a.ID into @acc_from from Account a right join Person p on p.ID = a.Person_Id
where p.Name = 'Hanzo';
select a.ID into @acc_to from Account a right join Person p on p.ID = a.Person_Id
where p.Name = 'Mei';
update Account a join Person p on p.ID = a.Person_Id set a.Balance = a.Balance-1500 
where p.Name = 'Hanzo';
update Account a join Person p on p.ID = a.Person_Id set a.Balance = a.Balance+1500 
where p.Name = 'Mei';
insert into transactions (`From_Account`, `To_Account`, `State`, `Date`)
                     values(@acc_from, @acc_to, 'Sikeres', CURDATE()); 
set @sql = (select if(@acc_from is null or @acc_to is null, "ROLLBACK;","COMMIT;"));
prepare stmt from @sql;
execute stmt;
