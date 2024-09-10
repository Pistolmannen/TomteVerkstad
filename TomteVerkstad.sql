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

create table Verktyg(
	Namn varchar(20) not null,
	IdNr char(8) not null unique,
    Pris int not null,
    Magistatus int not null,
	primary key(Namn, IdNr)
)engine=innodb;

  /*     en vertikal split på verktyg    */
create table TrasigaVerktyg(
	Namn varchar(20) not null,
	IdNr char(8) not null unique,
    Pris int not null,
    Magistatus int not null,
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
    foreign key(TNamn, TIdNr) references Byggare(TNamn, TIdNr),
    foreign key(VNamn, VIdNr) references Verktyg(Namn, IdNr)
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
    foreign key(VNamn, VIdNr) references Verktyg(Namn, IdNr),
    foreign key(LIdNr) references Leksak(IdNr)
)engine=innodb;

insert into Tomtenisse(Namn, IdNr, Nötter, Russin) value("Kevin", "555072-0318-3-934210345", 10, 20); 
insert into Tomtenisse(Namn, IdNr, Nötter, Russin, Skostorlek) value("David", "623072-1210-6-025610341", 15, 30, "medium"); 
insert into Tomtenisse(Namn, IdNr, Nötter, Russin) value("Robert", "890135-0822-2-819288236", 15, 15); 

insert into ChefAv(TNamn, TIdNr, CNamn, CIdNr) value("Kevin", "555072-0318-3-934210345", "David", "623072-1210-6-025610341"); 
insert into ChefAv(TNamn, TIdNr, CNamn, CIdNr) value("Robert", "890135-0822-2-819288236", "David", "623072-1210-6-025610341"); 

insert into Arbetslag(T1Namn, T1IdNr, T2Namn, T2IdNr, Lnummer) value("Robert", "890135-0822-2-819288236", "Kevin", "555072-0318-3-934210345", 556); 

insert into Byggare(TNamn, TIdNr, Klädfärg) value("Robert", "890135-0822-2-819288236", "blå"); 

insert into Verktyg(Namn, IdNr, Pris, Magistatus) value("Hammare", 13, 120, 13);
insert into TrasigaVerktyg(Namn, IdNr, Pris, Magistatus) values("sax", 36, 5, 0); 

insert into VerktygBeskrivning(Namn, IdNr, Beskrivning) value("Hammare", 13, "du kan slå väldigt hårt");
insert into VerktygBeskrivning(Namn, IdNr, Beskrivning) value("sax", 36, "har gåt i två");

insert into AnvändsAv(TNamn, TIdNr, VNamn, VIdNr) value("Robert", "890135-0822-2-819288236", "Hammare", 13);

insert into LeksakNamn(Namn, NamnKod) value("T-rex", 245);

insert into Leksak(NamnKod, IdNr, vikt, Pris) value(245, 09234, 5, 120);

insert into Bygger(TNamn, TIdNr, LIdNr) value("Robert", "890135-0822-2-819288236", 09234);

insert into Behöver(VNamn, VIdNr, LIdNr) value("Hammare", 13, 09234);

select * from Tomtenisse; 
select * from ChefAv; 
select * from Arbetslag; 
select * from Byggare; 
select * from Verktyg; 
select * from TrasigaVerktyg; 
select * from VerktygBeskrivning; 
select * from AnvändsAv; 
select * from Leksak; 
select * from LeksakNamn; 
select * from Bygger;
select * from Behöver;
