drop database TomteVerkstad;
create database TomteVerkstad;
use TomteVerkstad;

/*  merga in mellannisse i tometenisse  */
create table Tomtenisse(
	Namn varchar(20) not null,
	IdNr char(23) not null unique,
    Nötter int not null,
    Russin int not null,
    Skostorlek varchar(20),
    check (Skostorlek rlike 'mini|medium|maxi|ultra|mega'),
    check (IdNr rlike '[0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]-[0-9]-[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    primary key(Namn, IdNr)
)engine=innodb;

/*   index skapad för att kunna hitta Mellanissar enklare   */
create index TomtenisseSkostorlek on Tomtenisse(Skostorlek ASC) using BTREE;

show indexes from Tomtenisse;

create table Byggare(
	TNamn varchar(20) not null,
	TIdNr char(23) not null unique,
    Klädfärg varchar(20) not null,
    check (klädfärg not rlike "röd|burgundy"),
    primary key(TNamn, TIdNr),
    foreign key(TNamn, TIdNr) references Tomtenisse(Namn, IdNr)
)engine=innodb;

/*   index skapad för att kunna hitta specialister enklare   */
create index ByggareKlädfärg on Byggare(Klädfärg ASC) using BTREE;

show indexes from Byggare;

create table ChefAv(
	TNamn varchar(20) not null,
	TIdNr char(23) not null unique,
    CNamn varchar(20) not null,
	CIdNr char(23) not null,
    primary key(TNamn, TIdNr),
    foreign key(TNamn, TIdNr) references Tomtenisse(Namn, IdNr),
    foreign key(CNamn, CIdNr) references Tomtenisse(Namn, IdNr)
)engine=innodb;

create table Arbetslag(
	T1Namn varchar(20) not null,
	T1IdNr char(23) not null,
    T2Namn varchar(20) not null,
	T2IdNr char(23) not null,
    Lnummer int not null unique,
    primary key(T1Namn, T1IdNr, T2Namn, T2IdNr),
    foreign key(T1Namn, T1IdNr) references Tomtenisse(Namn, IdNr),
    foreign key(T2Namn, T2IdNr) references Tomtenisse(Namn, IdNr)
)engine=innodb;

create table Adress(
	Barack varchar(30) not null,
    Sängnr int not null,
    TNamn varchar(20) not null,
	TIdNr char(23) not null unique,
    primary key(Barack, Sängnr),
    foreign key(TNamn, TIdNr) references Tomtenisse(Namn, IdNr)
)engine=innodb;

create table MagiskaVerktyg(
	Namn varchar(20) not null,
	IdNr char(8) not null unique,
    Pris int not null,
    Magistatus int,
	primary key(Namn, IdNr)
)engine=innodb;

  /*     en vertikal split på verktyg    */
create table IckeMagiskaVerktyg(
	Namn varchar(20) not null,
	IdNr char(8) not null unique,
    Pris int not null,
	primary key(Namn, IdNr)
)engine=innodb;

create table VerktygLog(
	Händelse varchar(20) not null,
	Namn varchar(20) not null,
	IdNr char(8) not null unique,
    Pris int not null,
    Magistatus int,
    Tid datetime not null,
	primary key(Namn, IdNr, Tid)
)engine=innodb;

/*   en horisonta split på vertyg/trasiga verktyg för att få ut beskrivning   */
create table VerktygBeskrivning(
	Namn varchar(20) not null,
	IdNr char(8) not null unique,
    Beskrivning varchar(60) not null,
    primary key(Namn, IdNr)
)engine=innodb;

create table AnvändsAv(
	TNamn varchar(20) not null,
	TIdNr char(23) not null,
    VNamn varchar(20) not null,
	VIdNr char(8) not null,
    primary key(TNamn, TIdNr, VNamn, VIdNr),
    foreign key(TNamn, TIdNr) references Byggare(TNamn, TIdNr)
)engine=innodb;

create table AnvändsAvLog(
	Händelse varchar(32) not null,
	TNamn varchar(20) not null,
	TIdNr char(23) not null,
    VNamn varchar(20) not null,
	VIdNr char(8) not null,
    Tid datetime not null,
    primary key(TNamn, TIdNr, VNamn, VIdNr, Tid),
    foreign key(TNamn, TIdNr) references Byggare(TNamn, TIdNr)
)engine=innodb;

/*   en code variant på leksak    */
create table LeksakNamn(
	Namn varchar(20) not null,
	NamnKod char(8) not null unique,
    primary key(NamnKod)
)engine=innodb;

create table LeksakNamnLog(
	Händelse varchar(20) not null,
	Namn varchar(20) not null,
	NamnKod char(8) not null unique,
    Tid datetime not null, 
    primary key(NamnKod, Tid)
)engine=innodb;

create table Leksak(
	NamnKod char(8) not null,
	IdNr char(8) not null unique,
    Vikt int not null,
    Pris int not null,
    primary key(IdNr)
)engine=innodb;

create table Bygger(
	TNamn varchar(20) not null,
	TIdNr char(23) not null,
	LIdNr char(8) not null,
    primary key(TNamn, TIdNr, LIdNr),
    foreign key(TNamn, TIdNr) references Byggare(TNamn, TIdNr),
    foreign key(LIdNr) references Leksak(IdNr)
)engine=innodb;

create table Behöver(
	VNamn varchar(20) not null,
	VIdNr char(8) not null,
	LIdNr char(8) not null,
    primary key(VNamn, VIdNr, LIdNr),
    foreign key(LIdNr) references Leksak(IdNr)
)engine=innodb;

delimiter //
/*  trigger för att loga när verktyg slutar användas */
create trigger SlutaAnvända after delete on AnvändsAv
for each row begin
	insert into AnvändsAvLog(Händelse, TNamn, TIdNr, VNamn, VIdNr, Tid) 
    value("Sluta använda", OLD.TNamn, OLD.TIdNr, OLD.VNamn, OLD.VIdNr, now());
end//

delimiter ;

delimiter //
/*  trigger för att loga när verktyg börjar användas */
create trigger BörjaAnvända after insert on AnvändsAv
for each row begin
	insert into AnvändsAvLog(Händelse, TNamn, TIdNr, VNamn, VIdNr, Tid) 
    value("Börja använda", NEW.TNamn, NEW.TIdNr, NEW.VNamn, NEW.VIdNr, now());
end//

delimiter ;

delimiter //
/*  trigger för att loga när nya leksaks namn lägs till och fixa namnkoder i leksaker */
create trigger LäggTillNamnKod after insert on LeksakNamn
for each row begin
	insert into LeksakNamnLog(Händelse, Namn, NamnKod, Tid) 
    value("Lagt till", new.Namn, new.NamnKod, now());
	update Leksak set NamnKod = new.NamnKod where NamnKod = new.Namn;
end//

delimiter ;

delimiter //
/*  trigger för att kolla om verktyg kan tas bort och logar om det går */
create trigger SäljMagiskaVerktyg after delete on MagiskaVerktyg 
for each row begin
    if ((select count(*) from AnvändsAv where VNamn = old.Namn and VIdNr = old.IdNr) > 0) then
		signal sqlstate '45000' set message_text = "Deta verktyg används av någon";
	else
		insert into VerktygLog(Händelse, Namn, IdNr, Pris, Magistatus, Tid) 
		value("såldes", old.Namn, old.IdNr, old.pris, old.magistatus, now());
		delete from VerktygBeskrivning where Namn = old.Namn and IdNr = old.IdNr;
		delete from Behöver where VNamn = old.Namn and VIdNr = old.IdNr;
	end if;
end//

delimiter //
/*  trigger för att kolla om verktyg kan tas bort och logar om det går */
create trigger SäljIckeMagiskaVerktyg after delete on IckeMagiskaVerktyg 
for each row begin
    if ((select count(*) from AnvändsAv where VNamn = old.Namn and VIdNr = old.IdNr) > 0) then
		signal sqlstate '45000' set message_text = "Deta verktyg används av någon";
	else
		insert into VerktygLog(Händelse, Namn, IdNr, Pris, Magistatus, Tid) 
		value("såldes", old.Namn, old.IdNr, old.pris, null, now());
		delete from VerktygBeskrivning where Namn = old.Namn and IdNr = old.IdNr;
		delete from Behöver where VNamn = old.Namn and VIdNr = old.IdNr;
	end if;
end//


delimiter ;


insert into Tomtenisse(Namn, IdNr, Nötter, Russin) value("Kevin", "555072-0318-3-934210345", 10, 20); 
insert into Tomtenisse(Namn, IdNr, Nötter, Russin, Skostorlek) value("David", "623072-1210-6-025610341", 15, 30, "medium"); 
insert into Tomtenisse(Namn, IdNr, Nötter, Russin) value("Robert", "890135-0822-2-819288236", 15, 15); 

insert into ChefAv(TNamn, TIdNr, CNamn, CIdNr) value("Kevin", "555072-0318-3-934210345", "David", "623072-1210-6-025610341"); 
insert into ChefAv(TNamn, TIdNr, CNamn, CIdNr) value("Robert", "890135-0822-2-819288236", "David", "623072-1210-6-025610341"); 

insert into Arbetslag(T1Namn, T1IdNr, T2Namn, T2IdNr, Lnummer) value("Robert", "890135-0822-2-819288236", "Kevin", "555072-0318-3-934210345", 556); 

insert into Byggare(TNamn, TIdNr, Klädfärg) value("Robert", "890135-0822-2-819288236", "blå"); 

insert into MagiskaVerktyg(Namn, IdNr, Pris, Magistatus) value("Hammare", 13, 120, 11);
insert into MagiskaVerktyg(Namn, IdNr, Pris, Magistatus) value("Såg", 29, 200, 6);
insert into IckeMagiskaVerktyg(Namn, IdNr, Pris) values("Sax", 36, 5); 
insert into IckeMagiskaVerktyg(Namn, IdNr, Pris) values("Nål", 17, 10); 
insert into IckeMagiskaVerktyg(Namn, IdNr, Pris) values("Hammare", 5, 100); 

insert into VerktygBeskrivning(Namn, IdNr, Beskrivning) value("Hammare", 13, "du kan slå väldigt hårt");
insert into VerktygBeskrivning(Namn, IdNr, Beskrivning) value("Såg", 29, "sågar alltid rakt");
insert into VerktygBeskrivning(Namn, IdNr, Beskrivning) value("Sax", 36, "har gåt i två");
insert into VerktygBeskrivning(Namn, IdNr, Beskrivning) value("Nål", 17, "bra för dockor");

insert into AnvändsAv(TNamn, TIdNr, VNamn, VIdNr) value("Robert", "890135-0822-2-819288236", "Hammare", 13);
/*  insert into AnvändsAv(TNamn, TIdNr, VNamn, VIdNr) value("Robert", "890135-0822-2-819288236", "Såg", 29); 
	Används för att testa verktyg trigger */  

insert into LeksakNamn(Namn, NamnKod) value("T-rex", 245);

insert into Leksak(NamnKod, IdNr, vikt, Pris) value(245, 19234, 5, 120);
insert into Leksak(NamnKod, IdNr, vikt, Pris) value(245, 73204, 7, 160);
insert into Leksak(NamnKod, IdNr, vikt, Pris) value(245, 45104, 3, 100);
insert into Leksak(NamnKod, IdNr, vikt, Pris) value("Björn", 98201, 3, 100);

insert into Bygger(TNamn, TIdNr, LIdNr) value("Robert", "890135-0822-2-819288236", 19234);

insert into Behöver(VNamn, VIdNr, LIdNr) value("Hammare", 13, 19234);
insert into Behöver(VNamn, VIdNr, LIdNr) value("Såg", 29, 19234);
insert into Behöver(VNamn, VIdNr, LIdNr) value("Sax", 36, 73204);
insert into Behöver(VNamn, VIdNr, LIdNr) value("Hammare", 13, 45104);
insert into Behöver(VNamn, VIdNr, LIdNr) value("Sax", 36, 45104);

/*  simplifikations vy för att kunna visa alla verktyg  */
create view allaVerktyg as 
select Namn, IdNr, Pris, Magistatus from MagiskaVerktyg union 
select Namn, IdNr, Pris, Null as "Magistatus" from IckeMagiskaVerktyg;

/*  simplifikations vy för att kunna se vilka som är mellan nissar  */
create view Mellanisse as
select * from Tomtenisse where Skostorlek is not NULL;

/*  specialist vy för att kunna hitta vilka leksaker som kräver magi för att skapas  */
create view KräverMagi as
select  Leksak.NamnKod, Leksak.IdNr from Leksak, Behöver, allaVerktyg 
where Leksak.IdNr = Behöver.LIdNr and allaVerktyg.Namn = Behöver.VNamn and allaVerktyg.IdNr = Behöver.VIdNr and allaVerktyg.Magistatus is not null;

select * from Tomtenisse; 
select * from Mellanisse;		/* deta är en vy */
select * from ChefAv; 
select * from Arbetslag; 
select * from Byggare; 
select * from MagiskaVerktyg; 

delete from MagiskaVerktyg where Namn = "Såg" and IdNr = "29";
delete from IckeMagiskaVerktyg where Namn = "Hammare" and IdNr = "5";
select * from IckeMagiskaVerktyg; 
select * from allaVerktyg; 		/* deta är en vy */
select * from VerktygBeskrivning; 
select * from VerktygLog;
select * from AnvändsAv; 

delete from AnvändsAv where TNamn = "Robert" and TIdNr = "890135-0822-2-819288236" and VNamn = "Hammare" and VIdNr = 13;
select * from AnvändsAvLog;
select * from LeksakNamn; 

insert into LeksakNamn(Namn, NamnKod) value("Björn", 193);
select * from LeksakNamnLog; 
select * from Leksak; 
select * from Bygger;
select * from Behöver;
select * from KräverMagi;		/* deta är en vy */

/*    en procedur som bara hämtar alla nissar     */
delimiter //

create procedure getNissar()
begin
	select * from Tomtenisse;

end//

delimiter ;

call getNissar();

/*    en procedur som hämtar namnet av en leksak     */
delimiter //

create procedure getNamnPåLeksak(in LeksakID int)
begin
	select LeksakNamn.Namn, Leksak.IdNr, Leksak.Vikt, Leksak.Pris from Leksak, LeksakNamn where Leksak.IdNr = LeksakID and Leksak.NamnKod = LeksakNamn.NamnKod;

end//

delimiter ;

call getNamnPåLeksak(45104);

/*    proceduren använder en IN parameter för att hämta leksaker beroende på pris    */
delimiter //

create procedure getLeksakerPåPris(in checkPris int)
begin
	select * from Leksak where Leksak.Pris <= checkPris;

end//

delimiter ;

call getLeksakerPåPris(140);

/*    proceduren används för att flyta tuplar från ikemagiska till magiska verktyg   */
delimiter //

create procedure görVerktygMagisk(in verktygNamn varchar(20), in verktygID char(8), in inMagistatus int)
begin
	if (inMagistatus <= 0 or inMagistatus >= 12) then
		signal sqlstate '45000' set message_text = "Maginivån måste vara mellan 1 och 11";
	else
		insert into MagiskaVerktyg(Namn, IdNr, Pris, Magistatus) 
		select Namn, IdNr, Pris, inMagistatus from IckeMagiskaVerktyg where Namn = verktygNamn and IdNr = verktygID;
        
        delete from IckeMagiskaVerktyg where verktygNamn = Namn and verktygID = IdNr;
	end if;
end//

delimiter ;

call görVerktygMagisk("Nål", 17, 5);

select * from MagiskaVerktyg; 
select * from IckeMagiskaVerktyg; 

drop procedure getLeksakerPåPris;

/*    proceduren använder en IN parameter för att hämta leksaker beroende på pris och priset får inte vara mindre en 0   */
delimiter //

create procedure getLeksakerPåPris(in checkPris int)
begin
	if (checkPris < 0) then
		signal sqlstate '45000' set message_text = "priset måste vara 0 eller mer";
	else
		select * from Leksak where Leksak.Pris <= checkPris;
	end if;
end//

delimiter ;

call getLeksakerPåPris(-10);

/*  create user "a23eriguByggarNisse"@"%" identified by "ByggaBil";  */ /*   skapade användaren */

/*   koden för alla rättigheter */
/* grant select, delete, insert on TomteVerkstad.AnvändsAv to "a23eriguByggarNisse"@"%"; 
grant select, delete, insert on TomteVerkstad.Bygger to "a23eriguByggarNisse"@"%";
grant select on TomteVerkstad.AnvändsAvLog to "a23eriguByggarNisse"@"%";
grant select on TomteVerkstad.MagiskaVerktyg to "a23eriguByggarNisse"@"%";
grant select on TomteVerkstad.IckeMagiskaVerktyg to "a23eriguByggarNisse"@"%";
grant select on TomteVerkstad.allaVerktyg to "a23eriguByggarNisse"@"%"; 
grant select on TomteVerkstad.VerktygLog to "a23eriguByggarNisse"@"%";
grant select on TomteVerkstad.Behöver to "a23eriguByggarNisse"@"%";
grant select on TomteVerkstad.KräverMagi to "a23eriguByggarNisse"@"%";
grant select on TomteVerkstad.Leksak to "a23eriguByggarNisse"@"%";
grant select on TomteVerkstad.LeksakNamn to "a23eriguByggarNisse"@"%";
grant select on TomteVerkstad.LeksakNamnLog to "a23eriguByggarNisse"@"%"; 
grant execute on procedure TomteVerkstad.getLeksakerPåPris to "a23eriguByggarNisse"@"%"; 
grant execute on procedure TomteVerkstad.getNamnPåLeksak to "a23eriguByggarNisse"@"%"; 
grant execute on procedure TomteVerkstad.getNissar to "a23eriguByggarNisse"@"%"; */

/*
use TomteVerkstad;			 koden som användes för att testa användare

show tables;
select * from allaVerktyg;

show procedure status;
call getLeksakerPåPris(160);
*/