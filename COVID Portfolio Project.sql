/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/

select *
from PortfolioProject..CovidDeaths
where continent is not NULL
order by 3,4


--Select data that we are going to be startimg with

select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
where continent is not NULl
order by 1,2

-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not NULL
Where location like 'Pakistan'
order by 1,2

-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

select location, date, total_cases, population, (total_cases/population)*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
Where location like 'Pakistan'
where continent is not NULL
order by 1,2


-- Countries with highest infection rate compared to population

select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
--Where location like 'Pakistan'
group by location, population
order by PercentPopulationInfected desc


-- Countries with the Highest Death Count per Population

select location,  Max(cast(total_deaths as int)) as totalDeathCount
from PortfolioProject..CovidDeaths
--Where location like 'Pakistan'
where continent is not NULL
group by location 
order by totalDeathCount desc

-- BREAKING THINGS DOWN BY CONTINET

--Showing the continents with the highest death count per population

select continent,  Max(cast(total_deaths as int)) as totalDeathCount
from PortfolioProject..CovidDeaths
--Where location like 'Pakistan'
where continent is not NULL
group by continent 
order by totalDeathCount desc


-- GLOBAL NUMBERS

select  date, SUM(new_cases)as Total_Cases, SUM(cast(new_deaths as int)) as Total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases) * 100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not NULL
--Where location like 'Pakistan'
--group by date
order by 1,2

	
-- Total population vs vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(convert(int, vac.new_vaccinations)) over  (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated--, (RollingPeopleVaccinated/population) *100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date 
where dea.continent is not NULL
order by 2,3

--Using CTE to perform Calculation on Partition By in previous query

with PopvsVac (Continent, location, date,population, new_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(convert(int, vac.new_vaccinations)) over  (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated--, (RollingPeopleVaccinated/population) *100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date 
where dea.continent is not NULL
--order by 2,3
)
select *, (RollingPeopleVaccinated/population)*100
from PopvsVac


	
-- Using Temp Table to perform Calculation on Partition By in previous query
	

drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)


insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(convert(int, vac.new_vaccinations)) over  (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated--, (RollingPeopleVaccinated/population) *100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date 
where dea.continent is not NULL
--order by 2,3

select *, (RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated



--Creating view to store data for later visualisation

create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(convert(int, vac.new_vaccinations)) over  (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated--, (RollingPeopleVaccinated/population) *100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date 
where dea.continent is not NULL
--order by 2,3

select *
from PercentPopulationVaccinated
