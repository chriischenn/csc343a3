drop schema if exists wetworldschema cascade;
create schema wetworldschema;
set search_path to wetworldschema;

/*Domain of certification levels of divers*/
create domain OpenWaterCertification as varchar(4)
    check (value in ('NAUI', 'CMAS', 'PADI'));

/*Domain for types of dives*/
create domain DiveCategories as varchar(25)
    check (value in ('open water', 'cave dive', 'deep dive'));

/*Domain for pricing, will default to $0 if something is not offered*/
create domain Prices as integer
    default 0;

/*Table for dive sites*/
create table DiveSites (
    sID interger primary key,
    name varchar(25),
    location varchar(25),
    dayCap interger,
    nightCap interger
);

/*Table for dive categories offered at each dive location*/
create table AvailableCategories (
    sID interger references DiveSites(sID),
    type DiveCategories
);

/*Table for monitors*/
create table Monitors (
    mID integer primary key,
    name varchar(25) not null,
    openWaterLimit integer not null,
    caveDiveLimit integer not null,
    deepDiveLimit integer not null
);

/*Table for monitor affiliation*/
create table Affiliated (
    mID integer references Monitors(mID),
    sID integer references DiveSites(sID),
    unique(mID, sID)
);

/*Table for divers*/
create table Divers (
    dID integer primary key,
    fName varchar(25) not null,
    lName varchar(25) not null,
    birthday DATE not null,
    email varchar(55) not null,
    certification OpenWaterCertification not null
);

/*Table for monitor ratings*/
create table MonitorRatings (
    mID integer references Monitors(mID),
    rating integer not null,
    rater integer references Divers(dID),
    unique(mID, rating, rater)
);

/*Table for divesite ratings*/
create table DiveSiteRatings (
    sID integer references DiveSites(sID),
    rating integer not null,
    rater integer references Divers(dID),
    unique(sID, rating, rater)
);

/*Table for divesite pricing*/
/*Pricing will be $0 for extras that the divesite does not offer*/
create table DiveSitePricing (
    sID integer references DiveSites(sID),
    pricePerDiver Prices not null,
    primary key (sID),
    unique(sID, pricePerDiver)
);

/*Table for monitor pricing*/
/*Pricing will be 0 for dive sessions not offered*/
create table MonitorPricing (
    mID integer references Monitors(mID),
    dayOpenWater Prices not null,
    nightOpenWater Prices not null,
    dayCave Prices not null,
    nightCave Prices not null,
    dayDeep Prices not null,
    nightDeep Prices not null,
    primary key (mID),
    unique(mID, dayOpenWater,
      nightOpenWater, dayCave, nightCave, dayDeep, nightDeep)
);

/*Table for bookings*/
/*will have a divesite and monitor associated with each booking*/
