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
    sID integer not null,
    name varchar(25) not null,
    location varchar(25) not null,
    dayCap integer not null,
    nightCap integer not null,
    primary key (sID)
);

/*Table for dive categories offered at each dive location*/
create table AvailableCategories (
    sID integer references DiveSites(sID) not null,
    type DiveCategories not null,
    unique(sID, type)
);

/*Table for monitors*/
create table Monitors (
    mID integer not null,
    name varchar(25) not null,
    openWaterLimit integer not null,
    caveDiveLimit integer not null,
    deepDiveLimit integer not null,
    primary key (mID)
);

/*Table for monitor affiliation*/
create table Affiliated (
    mID integer references Monitors(mID) not null,
    sID integer references DiveSites(sID) not null,
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
    mID integer references Monitors(mID) not null,
    rating integer not null,
    rater integer references Divers(dID) not null,
    unique(mID, rating, rater)
);

/*Table for divesite ratings*/
create table DiveSiteRatings (
    sID integer references DiveSites(sID) not null,
    rating integer not null,
    rater integer references Divers(dID) not null,
    unique(sID, rating, rater)
);

/*Table for divesite pricing*/
/*Pricing will be $0 for extras that the divesite does not offer*/
create table DiveSitePricing (
    sID integer references DiveSites(sID) not null,
    pricePerDiver Prices not null,
    masks Prices not null,
    regulators Prices not null,
    fins Prices not null,
    diveComputers Prices not null,
    primary key (sID),
    unique(sID, pricePerDiver, masks, regulators, fins, diveComputers)
);

/*Table for monitor pricing*/
/*Pricing will be 0 for dive sessions not offered, set in domain Prices*/
create table MonitorPricing (
    mID integer references Monitors(mID) not null,
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
create table Bookings (
    bID integer primary key not null,
    leadDiver integer references Divers(dID) not null,
    mID integer references Monitors(mID) not null,
    sID integer references DiveSites(sID) not null,
    bookingDate DATE not null,
    bookingTime TIME not null,
    /*numDivers includes the leadDiver in its count, total divers for booking*/
    numDivers integer not null,
    /*Add constraint to check if monitor has more than 2 bookings in 24 period*/

    /*unique added here to implement constraint that each diver can only
    one booking at a specific time and date*/
    unique(bID, leadDiver, bookingDate, bookingTime)
);
