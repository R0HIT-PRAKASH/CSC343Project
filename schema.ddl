drop schema if exists projectschema cascade;
create schema projectschema;
set search_path to projectschema;

create domain ageranges as varchar(20)
    not null
    check (value in ('0-4', '5-14', '15plus', all));

create domain Sex as varchar(20)
    not null
    check (value in ('m', 'f', 'a'));

create domain HealthSector as varchar(20)
    not null
    check (value in ('research', 'laboratory equipments', 
    'patient support','budget line items', 'treatment types'));



DROP TABLE IF EXISTS TB_Rates CASCADE;
CREATE TABLE TB_Rates (
    country VARCHAR(100) NOT NULL,
    year INT NOT NULL,
    fatalityRate INT NOT NULL,
    incidenceRate INT NOT NULL,
    primary key(country, year)
);


DROP TABLE IF EXISTS TB_By_Demographic CASCADE;
CREATE TABLE TB_By_Demographic (
    country VARCHAR(100) NOT NULL,
    year INT NOT NULL,
    ageRange ageranges,
    sex Sex,
    tbRate FLOAT NOT NULL,
    primary key(country, year, ageRange, sex),
    foreign key (country, year) references TB_Rates
);


DROP TABLE IF EXISTS CountryGDP CASCADE;
CREATE TABLE CountryGDP (
    country VARCHAR(100) NOT NULL,
    year INT NOT NULL,
    GDP FLOAT NOT NULL,
    primary key(country, year),
    foreign key (country, year) references TB_Rates(country, year)
);

DROP TABLE IF EXISTS CountryGDPPC CASCADE;
CREATE TABLE CountryGDPPC (
    country VARCHAR(100) NOT NULL,
    year INT NOT NULL,
    GDPPerCap FLOAT NOT NULL,
    primary key(country, year),
    foreign key (country, year) references TB_Rates(country, year)
);

DROP TABLE IF EXISTS TBComorbidity CASCADE;
CREATE TABLE TBComorbidity (
    country VARCHAR(100) NOT NULL,
    year INT NOT NULL,
    cName VARCHAR(250) NOT NULL,
    comorbidityRate FLOAT NOT NULL,
    primary key(country, year, cName),
    foreign key (country, year) references TB_Rates(country, year)
);

DROP TABLE IF EXISTS DiseaseCausedDeaths CASCADE;
CREATE TABLE DiseaseCausedDeaths (
    year INT NOT NULL,
    diseaseName VARCHAR(250) NOT NULL,
    totalDeaths INT NOT NULL,
    primary key(year, diseaseName)
);

DROP TABLE IF EXISTS HealthCareFunding CASCADE;
CREATE TABLE HealthCareFunding (
    country VARCHAR(100) NOT NULL,
    year INT NOT NULL,
    healthcareSector HealthSector,
    amount FLOAT NOT NULL,
    primary key(country, year, healthcareSector),
    foreign key (country, year) references TB_Rates(country, year)
);