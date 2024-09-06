drop database TomteVerkstad;
create database TomteVerkstad;
use TomteVerkstad;

create table Tomtenisse(
	Namn varchar(20) not null,
	IdNr char(23) not null unique,
    Nötter int not null,
    Russin int not null,
    Skostorlek varchar(20),
    check (IdNr rlike '[0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]-[0-9]-[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    primary key(Namn, IdNr)
)engine=innodb;

create table Byggare(
	TNamn varchar(20) not null,
	TIdNr char(23) not null unique,
    Klädfärg varchar(20) not null,
    check (klädfärg not rlike "röd|burgundy"),
    primary key(TNamn, TIdNr),
    foreign key(TNamn, TIdNr) references Tomtenisse(Namn, IdNr)
)engine=innodb;

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
	IdNr int not null unique,
    Beskrivning varchar(60),
    Pris int not null,
    Magistatus int not null,
    check (Magistatus rlike '[0-11]'),
	primary key(Namn, IdNr)
)engine=innodb;

create table AnvändsAv(
	TNamn varchar(20) not null,
	TIdNr char(23) not null,
    VNamn varchar(20) not null,
	VIdNr int not null,
    primary key(TNamn, TIdNr, VNamn, VIdNr),
    foreign key(TNamn, TIdNr) references Byggare(TNamn, TIdNr),
    foreign key(VNamn, VIdNr) references Verktyg(Namn, IdNr)
)engine=innodb;

create table Leksak(
	Namn varchar(20) not null unique,
	IdNr int not null unique,
    Vikt int not null,
    Pris int not null,
    primary key(IdNr)
)engine=innodb;

create table Bygger(
	TNamn varchar(20) not null,
	TIdNr char(23) not null,
	LIdNr int not null,
    primary key(TNamn, TIdNr, LIdNr),
    foreign key(TNamn, TIdNr) references Byggare(TNamn, TIdNr),
    foreign key(LIdNr) references Leksak(IdNr)
)engine=innodb;

create table Behöver(
	VNamn varchar(20) not null,
	VIdNr int not null,
	LIdNr int not null,
    primary key(VNamn, VIdNr, LIdNr),
    foreign key(VNamn, VIdNr) references Verktyg(Namn, IdNr),
    foreign key(LIdNr) references Leksak(IdNr)
)engine=innodb;

insert into Tomtenisse(Namn, IdNr, Nötter, Russin) value("Kevin", "555072-0318-3-934210345", 10, 20); 
insert into Tomtenisse(Namn, IdNr, Nötter, Russin, Skostorlek) value("David", "623072-1210-6-025610341", 15, 30, "Mellan"); 
insert into Tomtenisse(Namn, IdNr, Nötter, Russin) value("Robert", "890135-0822-2-819288236", 15, 15); 

insert into ChefAv(TNamn, TIdNr, CNamn, CIdNr) value("Kevin", "555072-0318-3-934210345", "David", "623072-1210-6-025610341"); 
insert into ChefAv(TNamn, TIdNr, CNamn, CIdNr) value("Robert", "890135-0822-2-819288236", "David", "623072-1210-6-025610341"); 

insert into Arbetslag(T1Namn, T1IdNr, T2Namn, T2IdNr, Lnummer) value("Robert", "890135-0822-2-819288236", "Kevin", "555072-0318-3-934210345", 556); 

insert into Verktyg(Namn, IdNr, Beskrivning, Pris, Magistatus) value("Hammare", 13, "du kan så väldigt hårt", 120, 13);


select * from Tomtenisse; 
select * from ChefAv; 
select * from Arbetslag; 
select * from Verktyg; 