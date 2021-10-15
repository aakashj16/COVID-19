create database covid_project;
use covid_project;
create table cases_deaths
(
	iso_code varchar (8),
    continent varchar (13),
    location varchar (32),
    recorded_date date,
    population bigint unsigned,
    population_density decimal (8,3),
    total_cases int unsigned,
    new_cases mediumint,
    new_cases_smoothed decimal (9,3),
    total_deaths mediumint unsigned,
    new_deaths smallint,
    new_deaths_smoothed decimal (8,3),
    total_case_per_million decimal (9,3),
    new_case_per_million decimal (7,3),
    new_cases_smoothed_per_million decimal (7,3),
    total_deaths_per_million decimal (7,3),
    new_deaths_per_million decimal (6,3),
    new_deaths_smoothed_per_million decimal (5,3)
);

create table infection_tests_hospitalization
(
	iso_code varchar (8),
    continent varchar (13),
    location varchar (32),
    recorded_date date,
    population bigint unsigned,
    population_density decimal (8,3),
    reproduction_rate decimal (3,2),
    icu_patients smallint unsigned,
    icu_patients_per_million decimal (6,3),
    hospitalized_patients mediumint unsigned,
    hospitalized_patients_per_million decimal (7,3),
    weekly_icu_admissions decimal (7,3),
    weekly_icu_admissions_per_million decimal (6,3),
    weekly_hospital_admissions decimal (9,3),
    weekly_hospital_admissions_per_million decimal (7,3),
    new_tests mediumint unsigned,
    total_tests int unsigned,
    total_tests_per_thousand decimal (8,3),
    new_tests_per_thousand decimal (6,3),
    new_tests_smoothed mediumint unsigned,
    new_tests_smoothed_per_thousand decimal (5,3),
    positive_rate decimal (4,3),
    tests_per_case decimal (6,1),
    test_units varchar (15)
);    

create table vaccinations
(
	iso_code varchar (8),
    continent varchar (13),
    location varchar (32),
    recorded_date date,
    population bigint unsigned,
    population_density decimal (8,3),
    total_vaccinations bigint unsigned,
	people_vaccinated int unsigned,
	people_fully_vaccinated int unsigned,
	total_boosters int unsigned,
	new_vaccinations int unsigned,
	new_vaccinations_smoothed int unsigned,
	total_vaccinations_per_hundred decimal (5,2),
	people_vaccinated_per_hundred decimal (5, 2),
	people_fully_vaccinated_per_hundred decimal (5,2),
	total_boosters_per_hundred decimal (4,2),
	new_vaccinations_smoothed_per_million mediumint unsigned
);

/* COVID-19 Exploratory Analysis For Countries*/

/* Total Cases */
select location, recorded_date, total_cases
from covid_project.cases_deaths
where continent is not null;

/* Creating View For Later Visualization */
create view total_cases as
select location, recorded_date, total_cases
from covid_project.cases_deaths
where continent is not null;

/* Total Cases Per Million */
select location, recorded_date, total_case_per_million
from covid_project.cases_deaths
where continent is not null;

/* Percentage Infected - Ratio of Total Cases to Population */
select location, recorded_date, (total_cases / population) * 100 as percentage_infected_population
from covid_project.cases_deaths
where continent is not null;

/* Creating View For Later Visualization */
create view percentage_infected as
select location, recorded_date, (total_cases / population) * 100 as percentage_infected_population
from covid_project.cases_deaths
where continent is not null;

/* Maximum Infected Percentage of Population */
select location, max((total_cases / population) * 100) as maximum_percentage_infected_population
from covid_project.cases_deaths
where continent is not null
group by location
order by maximum_percentage_infected_population desc;

/* Total Deaths*/
select location, recorded_date, total_deaths
from covid_project.cases_deaths
where continent is not null;

/* Creating View For Later Visualization */
create view total_deaths as
select location, recorded_date, total_deaths
from covid_project.cases_deaths
where continent is not null;

/* Total Deaths Per Million */
select location, recorded_date, total_deaths_per_million
from covid_project.cases_deaths
where continent is not null;

/* Case Fatality Rate - Ratio of Confirmed Daths to Confirmed Cases */
select location, recorded_date, (total_deaths / total_cases) * 100 as case_fatality_rate
from covid_project.cases_deaths
where continent is not null;

/* Creating View For Later Visualization */
create view case_fatality_rate as
select location, recorded_date, (total_deaths / total_cases) * 100 as case_fatality_rate
from covid_project.cases_deaths
where continent is not null;

/* Reproduction Rate */
select location, recorded_date, reproduction_rate
from covid_project.infection_tests_hospitalization
where continent is not null;

/* Relation Between Confirmed New Cases and Reproduction Rate - Theoretically, cases start increasing exponentially when reproduction rate (R) is more than 1 */
select covid_project.cases_deaths.location, covid_project.cases_deaths.recorded_date, new_cases, reproduction_rate
from covid_project.cases_deaths
	join covid_project.infection_tests_hospitalization
    on covid_project.cases_deaths.location = covid_project.infection_tests_hospitalization.location
    and covid_project.cases_deaths.recorded_date = covid_project.infection_tests_hospitalization.recorded_date
where covid_project.cases_deaths.continent is not null;

/* Creating View For Later Visualization */
create view relation_between_confirmed_new_cases_and_reproduction_rate as
select covid_project.cases_deaths.location, covid_project.cases_deaths.recorded_date, new_cases, reproduction_rate
from covid_project.cases_deaths
	join covid_project.infection_tests_hospitalization
    on covid_project.cases_deaths.location = covid_project.infection_tests_hospitalization.location
    and covid_project.cases_deaths.recorded_date = covid_project.infection_tests_hospitalization.recorded_date
where covid_project.cases_deaths.continent is not null;

/*Total Tests Conducted */
select location, recorded_date, total_tests
from covid_project.infection_tests_hospitalization
where continent is not null;

/* Tests Conducted Per 1000 People */
select location, recorded_date, total_tests_per_thousand
from covid_project.infection_tests_hospitalization
where continent is not null;

/* Total Tests Conducted Per Total Cases */
select covid_project.cases_deaths.location, covid_project.cases_deaths.recorded_date, total_cases, total_tests
from covid_project.cases_deaths
	join covid_project.infection_tests_hospitalization
    on covid_project.cases_deaths.location = covid_project.infection_tests_hospitalization.location
    and covid_project.cases_deaths.recorded_date = covid_project.infection_tests_hospitalization.recorded_date
where covid_project.cases_deaths.continent is not null;

/* Creating View For Later Visualization */
create view total_tests_conducted_per_total_cases as
select covid_project.cases_deaths.location, covid_project.cases_deaths.recorded_date, total_cases, total_tests
from covid_project.cases_deaths
	join covid_project.infection_tests_hospitalization
    on covid_project.cases_deaths.location = covid_project.infection_tests_hospitalization.location
    and covid_project.cases_deaths.recorded_date = covid_project.infection_tests_hospitalization.recorded_date
where covid_project.cases_deaths.continent is not null;

/* Percentage Positive Tests - Ratio of Confirmed Cases to Total Test Conducted */
select covid_project.cases_deaths.location, covid_project.cases_deaths.recorded_date, total_cases, total_tests, (total_cases / total_tests) * 100 as percentage_positive_cases
from covid_project.cases_deaths
	join covid_project.infection_tests_hospitalization
    on covid_project.cases_deaths.location = covid_project.infection_tests_hospitalization.location
    and covid_project.cases_deaths.recorded_date = covid_project.infection_tests_hospitalization.recorded_date
where covid_project.cases_deaths.continent is not null;

/* Creating View For Later Visualization */
create view percentage_positive_tests as 
select covid_project.cases_deaths.location, covid_project.cases_deaths.recorded_date, total_cases, total_tests, (total_cases / total_tests) * 100 as percentage_positive_cases
from covid_project.cases_deaths
	join covid_project.infection_tests_hospitalization
    on covid_project.cases_deaths.location = covid_project.infection_tests_hospitalization.location
    and covid_project.cases_deaths.recorded_date = covid_project.infection_tests_hospitalization.recorded_date
where covid_project.cases_deaths.continent is not null;

/* Total Vaccinations */
select location, recorded_date, total_vaccinations
from covid_project.vaccinations
where continent is not null;

/* Total Vaccinations per 100 People */
select location, recorded_date, total_vaccinations_per_hundred
from covid_project.vaccinations
where continent is not null;

/* Number of People Vaccinated */
select location, recorded_date, people_vaccinated
from covid_project.vaccinations
where continent is not null;

/* Percentage of People Vaccinated */
select location, recorded_date, (people_vaccinated / population) *100 as percentage_of_people_vaccinated
from covid_project.vaccinations
where continent is not null;

/* Maximum Percentage of People Vaccinated */
select location, max((people_vaccinated / population) *100) as percentage_of_people_vaccinated
from covid_project.vaccinations
where continent is not null
group by location
order by percentage_of_people_vaccinated desc;

/* Number of People Fully Vaccinated */
select location, recorded_date, people_fully_vaccinated
from covid_project.vaccinations
where continent is not null;

/* Percentage of People Fully Vaccinated */
select location, recorded_date, (people_fully_vaccinated / population) *100 as percentage_of_people_fully_vaccinated
from covid_project.vaccinations
where continent is not null;

/* Maximum Percentage of People Fully Vaccinated */
select location, max((people_fully_vaccinated / population) *100) as percentage_of_people_fully_vaccinated
from covid_project.vaccinations
where continent is not null
group by location
order by percentage_of_people_fully_vaccinated desc;

/* People Vaccinated & People Fully Vaccinated */
select location, recorded_date, people_vaccinated, people_fully_vaccinated
from covid_project.vaccinations
where continent is not null;

/* Creating View For Later Visualization */
create view People_Vaccinated_and_People_Fully_Vaccinated as
select location, recorded_date, people_vaccinated, people_fully_vaccinated
from covid_project.vaccinations
where continent is not null;

/* Percentage of People Vaccinated & People Fully Vaccinated */
select location, recorded_date, (people_vaccinated / population) *100 as percentage_of_people_vaccinated, (people_fully_vaccinated / population) *100 as percentage_of_people_fully_vaccinated
from covid_project.vaccinations
where continent is not null;

/* Creating View For Later Visualization */
create view Percentage_of_People_Vaccinated_and_People_Fully_Vaccinated as
select location, recorded_date, (people_vaccinated / population) *100 as percentage_of_people_vaccinated, (people_fully_vaccinated / population) *100 as percentage_of_people_fully_vaccinated
from covid_project.vaccinations
where continent is not null;

/* Booster Doses Administered */
select location, recorded_date, total_boosters
from covid_project.vaccinations
where continent is not null;

/* Booster Doses Administered per 100 People */
select location, recorded_date, total_boosters_per_hundred
from covid_project.vaccinations
where continent is not null;