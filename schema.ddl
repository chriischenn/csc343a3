drop schema if exists wetworldschema cascade;
create schema wetworldschema;
set search_path to wetworldschema;

/*Domain of certification levels of divers*/
create domain OpenWaterCertification as varchar(4)
    check (value in ('NAUI', 'CMAS', 'PADI'));

/*Domain for types of dives*/
create domain DiveCategories as varchar(25)
    check (value in ('open water', 'cave dive', 'beyond 30 meters'));

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

/*Table for divers*/
