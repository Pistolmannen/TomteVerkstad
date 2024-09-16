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
create table IkeMagiskaVerktyg(
	Namn varchar(20) not null,
	IdNr char(8) not null unique,
    Pris int not null,
	primary key(Namn, IdNr)
)engine=innodb;

/*   en horisonta split på vertyg/trasiga verktyg för att få ut beskrivning   */
create table VerktygBeskrivning(
	Namn varchar(20) not null,
	IdNr char(8) not null unique,
    Beskrivning varchar(60),
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

/*   en code variant på leksak    */
create table LeksakNamn(
	Namn varchar(20) not null,
	NamnKod char(8) not null unique,
    primary key(NamnKod)
)engine=innodb;

create table Leksak(
	NamnKod char(8) not null,
	IdNr char(8) not null unique,
    Vikt int not null,
    Pris int not null,
    primary key(IdNr),
    foreign key(NamnKod) references LeksakNamn(NamnKod) 
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

insert into Tomtenisse(Namn, IdNr, Nötter, Russin) value("Kevin", "555072-0318-3-934210345", 10, 20); 
insert into Tomtenisse(Namn, IdNr, Nötter, Russin, Skostorlek) value("David", "623072-1210-6-025610341", 15, 30, "medium"); 
insert into Tomtenisse(Namn, IdNr, Nötter, Russin) value("Robert", "890135-0822-2-819288236", 15, 15); 

insert into ChefAv(TNamn, TIdNr, CNamn, CIdNr) value("Kevin", "555072-0318-3-934210345", "David", "623072-1210-6-025610341"); 
insert into ChefAv(TNamn, TIdNr, CNamn, CIdNr) value("Robert", "890135-0822-2-819288236", "David", "623072-1210-6-025610341"); 

insert into Arbetslag(T1Namn, T1IdNr, T2Namn, T2IdNr, Lnummer) value("Robert", "890135-0822-2-819288236", "Kevin", "555072-0318-3-934210345", 556); 

insert into Byggare(TNamn, TIdNr, Klädfärg) value("Robert", "890135-0822-2-819288236", "blå"); 

insert into MagiskaVerktyg(Namn, IdNr, Pris, Magistatus) value("Hammare", 13, 120, 11);
insert into IkeMagiskaVerktyg(Namn, IdNr, Pris) values("Sax", 36, 5); 
insert into IkeMagiskaVerktyg(Namn, IdNr, Pris) values("Nål", 17, 10); 

insert into VerktygBeskrivning(Namn, IdNr, Beskrivning) value("Hammare", 13, "du kan slå väldigt hårt");
insert into VerktygBeskrivning(Namn, IdNr, Beskrivning) value("Sax", 36, "har gåt i två");
insert into VerktygBeskrivning(Namn, IdNr, Beskrivning) value("Nål", 17, "bra för dockor");

insert into AnvändsAv(TNamn, TIdNr, VNamn, VIdNr) value("Robert", "890135-0822-2-819288236", "Hammare", 13);

insert into LeksakNamn(Namn, NamnKod) value("T-rex", 245);

insert into Leksak(NamnKod, IdNr, vikt, Pris) value(245, 19234, 5, 120);
insert into Leksak(NamnKod, IdNr, vikt, Pris) value(245, 73204, 7, 160);
insert into Leksak(NamnKod, IdNr, vikt, Pris) value(245, 45104, 3, 100);

insert into Bygger(TNamn, TIdNr, LIdNr) value("Robert", "890135-0822-2-819288236", 19234);

insert into Behöver(VNamn, VIdNr, LIdNr) value("Hammare", 13, 19234);
insert into Behöver(VNamn, VIdNr, LIdNr) value("Sax", 36, 73204);
insert into Behöver(VNamn, VIdNr, LIdNr) value("Hammare", 13, 45104);
insert into Behöver(VNamn, VIdNr, LIdNr) value("Sax", 36, 45104);

/*  simplifikations vy för att kunna visa alla verktyg  */
create view allaVerktyg as 
select Namn, IdNr, Pris, Magistatus from MagiskaVerktyg union 
select Namn, IdNr, Pris, Null as "Magistatus" from IkeMagiskaVerktyg;

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
select * from IkeMagiskaVerktyg; 
select * from allaVerktyg; 		/* deta är en vy */
select * from VerktygBeskrivning; 
select * from AnvändsAv; 
select * from Leksak; 
select * from LeksakNamn; 
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

/*    proceduren använder en IN parameter för att hämta leksaker beroende på pris    */
delimiter //

create procedure getLeksakerPåPris(in checkPris int)
begin
	select * from Leksak where Leksak.Pris < checkPris;

end//

delimiter ;

call getLeksakerPåPris(140);

/*    proceduren använder en IN parameter för att hämta leksaker beroende på pris och priset får inte vara mindre en 0   */
delimiter //

create procedure görVerktygMagisk(in verktygNamn varchar(20), in verktygID char(8), in inMagistatus int)
begin
	if (inMagistatus < 0) then
		signal sqlstate '45000' set message_text = "Maginivån måste vara mer än 0";
	else
		insert into MagiskaVerktyg(Namn, IdNr, Pris, Magistatus) 
		select Namn, IdNr, Pris, Null as "Magistatus" from IkeMagiskaVerktyg where Namn = verktygNamn and IdNr = verktygID;
        
        update MagiskaVerktyg set Magistatus = inMagistatus where verktygNamn = Namn and verktygID = IdNr;
        
        delete from IkeMagiskaVerktyg where verktygNamn = Namn and verktygID = IdNr;
	end if;
end//

delimiter ;

call görVerktygMagisk("Nål", 17, 5);

select * from MagiskaVerktyg; 
select * from IkeMagiskaVerktyg; 

drop procedure getLeksakerPåPris;

/*    proceduren använder en IN parameter för att hämta leksaker beroende på pris och priset får inte vara mindre en 0   */
delimiter //

create procedure getLeksakerPåPris(in checkPris int)
begin
	if (checkPris < 0) then
		signal sqlstate '45000' set message_text = "priset måste vara 0 eller mer";
	else
		select * from Leksak where Leksak.Pris < checkPris;
	end if;
end//

delimiter ;

call getLeksakerPåPris(-10);