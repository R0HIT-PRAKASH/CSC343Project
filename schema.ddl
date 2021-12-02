-- Made a change to the DiseaseCausedDeaths table 
-- by adding data that included the death rate per country
-- rather than just comparing over the total global population
-- for a given year. This gives more useful information 
-- (while retaining the same information as before) 
-- and adds more depth to our answers for our questions. 
-- Removed a foreign key from HealthCareFunding because
-- we were restricting the data for no reason.
-- We could look at data without directly comparing to 
-- TB related values. 

drop schema if exists projectschema cascade;
create schema projectschema;
set search_path to projectschema;

create domain ageranges as varchar(20)
    not null
    check (value in ('0-4', '5-14', '15plus', 'all'));

create domain Sex as varchar(20)
    not null
    check (value in ('m', 'f', 'a'));

create domain HealthSector as varchar(20)
    not null
    check (value in ('DrugSusp', 'Lab', 
    'Research','BudgetLine', 'Patient', 'DrugRes'));

-- Contains the number of TB cases and deaths
-- in a given country and year
-- Country - The country the row is describing
-- Year - The year the row is describing
-- fatalityRate - The number of TB caused deaths that occured
-- incidenceRate - The number of TB cases that occured
DROP TABLE IF EXISTS TB_Rates CASCADE;
CREATE TABLE TB_Rates (
    country VARCHAR(100) NOT NULL,
    year INT NOT NULL,
    fatalityRate INT NOT NULL,
    incidenceRate INT NOT NULL,
    primary key(country, year)
);

-- Contains the number of TB cases based on
-- different population demographics in a given 
-- country and year
-- Country - The country the row is describing
-- Year - The year the row is describing
-- sex - The sex of the people with TB
-- ageRange - The ages of the people with TB
-- tbRate - The number of TB cases that occured
DROP TABLE IF EXISTS TB_By_Demographic CASCADE;
CREATE TABLE TB_By_Demographic (
    country VARCHAR(100) NOT NULL,
    year INT NOT NULL,
    sex Sex,
    ageRange ageranges,
    tbRate FLOAT NOT NULL,
    primary key(country, year, ageRange, sex),
    foreign key (country, year) references TB_Rates
);

-- The GDP of a country in a given year
-- Country - the country the row is describing
-- year - The year the row is describing
-- GDP - The GDP of the country in the year
DROP TABLE IF EXISTS CountryGDP CASCADE;
CREATE TABLE CountryGDP (
    country VARCHAR(100) NOT NULL,
    year INT NOT NULL,
    GDP FLOAT NOT NULL,
    primary key(country, year),
    foreign key (country, year) references TB_Rates(country, year)
);

-- The GDP per capita of a country in a given year
-- Country - the country the row is describing
-- year - The year the row is describing
-- GDPPerCap - The GDP per capita of the country in the year
DROP TABLE IF EXISTS CountryGDPPC CASCADE;
CREATE TABLE CountryGDPPC (
    country VARCHAR(100) NOT NULL,
    year INT NOT NULL,
    GDPPerCap FLOAT NOT NULL,
    primary key(country, year),
    foreign key (country, year) references TB_Rates(country, year)
);


-- The number of TB cases whose patients had 
-- complicating illnesses
-- Country - the country the row is describing
-- year - The year the row is describing
-- cName - The name of the comorbidity
-- comorbidityRate - The number of TB cases that occured 
-- in people with cName comorbidity
DROP TABLE IF EXISTS TBComorbidity CASCADE;
CREATE TABLE TBComorbidity (
    country VARCHAR(100) NOT NULL,
    year INT NOT NULL,
    cName VARCHAR(250) NOT NULL,
    comorbidityRate FLOAT NOT NULL,
    primary key(country, year, cName),
    foreign key (country, year) references TB_Rates(country, year)
);

-- Number of deaths caused by illnesses in a given year
-- Year - the year this row is describing
-- diseaseName - The name of the disease 
-- totalDeaths - The number of deaths per 100,000 people
-- by diseaseName
DROP TABLE IF EXISTS DiseaseCausedDeaths CASCADE;
CREATE TABLE DiseaseCausedDeaths (
    country VARCHAR(100) NOT NULL,
    year INT NOT NULL,
    diseaseName VARCHAR(250) NOT NULL,
    deathPer100k FLOAT NOT NULL,
    primary key(country, year, diseaseName),
    foreign key (country, year) references TB_Rates(country, year)
);

-- The total funds allocated to different healthcare sectors
-- in a given country and year
-- country - The country the row is describing
-- year - the year the row is describing
-- healthcareSector - the name of the healthcareSector 
-- amount - The total dollar amount allocated to 
-- healthcareSector
DROP TABLE IF EXISTS HealthCareFunding CASCADE;
CREATE TABLE HealthCareFunding (
    country VARCHAR(100) NOT NULL,
    year INT NOT NULL,
    healthcareSector HealthSector,
    amount FLOAT NOT NULL,
    primary key(country, year, healthcareSector),
);
