drop database TomteVerkstad;
create database TomteVerkstad;
use TomteVerkstad;

create table Tomtenisse(
	Namn varchar(20),
	IdNr int,
    Nötter int,
    Russin int,
    Skostorlek varchar(20),
    primary key(Namn, IdNr)
)engine=innodb;

create table Byggare(
	TNamn varchar(20),
	TIdNr int,
    Klädfärg varchar(20),
    primary key(TNamn, TIdNr),
    foreign key(TNamn, TIdNr) references Tomtenisse(Namn, IdNr)
)engine=innodb;

create table ChefAv(
	TNamn varchar(20),
	TIdNr int,
    CNamn varchar(20),
	CIdNr int,
    primary key(TNamn, TIdNr),
    foreign key(TNamn, TIdNr) references Tomtenisse(Namn, IdNr),
    foreign key(CNamn, CIdNr) references Tomtenisse(Namn, IdNr)
)engine=innodb;

create table Arbetslag(
	T1Namn varchar(20),
	T1IdNr int,
    T2Namn varchar(20),
	T2IdNr int,
    Lnummer int,
    primary key(T1Namn, T1IdNr, T2Namn, T2IdNr),
    foreign key(T1Namn, T1IdNr) references Tomtenisse(Namn, IdNr),
    foreign key(T2Namn, T2IdNr) references Tomtenisse(Namn, IdNr)
)engine=innodb;

create table Adress(
	Barack varchar(30),
    Sängnr int,
    TNamn varchar(20),
	TIdNr int,
    primary key(Barack, Sängnr),
    foreign key(TNamn, TIdNr) references Tomtenisse(Namn, IdNr)
)engine=innodb;

create table Verktyg(
	Namn varchar(20),
	IdNr int,
    Beskrivning varchar(60),
    Pris int,
    Magistatus varchar(20),
	primary key(Namn, IdNr)
)engine=innodb;

create table AnvändsAv(
	TNamn varchar(20),
	TIdNr int,
    VNamn varchar(20),
	VIdNr int,
    primary key(TNamn, TIdNr, VNamn, VIdNr),
    foreign key(TNamn, TIdNr) references Byggare(TNamn, TIdNr),
    foreign key(VNamn, VIdNr) references Verktyg(Namn, IdNr)
)engine=innodb;

create table Leksak(
	Namn varchar(20),
	IdNr int,
    Vikt int,
    Pris int,
    primary key(IdNr)
)engine=innodb;

create table Bygger(
	TNamn varchar(20),
	TIdNr int,
	LIdNr int,
    primary key(TNamn, TIdNr, LIdNr),
    foreign key(TNamn, TIdNr) references Byggare(TNamn, TIdNr),
    foreign key(LIdNr) references Leksak(IdNr)
)engine=innodb;

create table Behöver(
	VNamn varchar(20),
	VIdNr int,
	LIdNr int,
    primary key(VNamn, VIdNr, LIdNr),
    foreign key(VNamn, VIdNr) references Verktyg(Namn, IdNr),
    foreign key(LIdNr) references Leksak(IdNr)
)engine=innodb;