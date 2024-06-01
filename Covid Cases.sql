select location , date, total_cases, new_cases, total_deaths
from Project1..coviddeaths

Order by 1,2



-- Looking at total Cases vs Total Deaths

Select Location, date, total_cases,total_deaths,(cast(total_deaths as float)/cast(total_cases as float))*100 as DeathPercentage
From Project1..CovidDeaths
Where location like 'india'

order by 1,2


-- Looking at total Cases vs Population

Select Location, date, total_cases, population ,(cast(total_cases as float)/population)*100 as InfectionPercentage
From Project1..CovidDeaths
Where location like 'india'
and total_cases is not null

order by 1,2


-- Looking at Countries with Highest Death Count

Select Location, Max(cast (Total_deaths as int)) as TotalDeathCount
From Project1..CovidDeaths
where continent is not null
Group by Location 

order by TotalDeathCount desc


-- Total Deaths in Continents

Select Continent, Max(cast (Total_deaths as int)) as TotalDeathCount,  SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From Project1..CovidDeaths
where continent is not null
Group by Continent 

order by TotalDeathCount desc


-- Global Numbers

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From Project1..CovidDeaths



-- Total Vaccinated people in different Countries

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(float,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From project1..CovidDeaths dea
Join project1..CovidVacinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where vac.new_vaccinations is not null 
	and dea.continent is not null
order by 2,3


-- Using CTE for getting Percentage of Vaccinated people

With VacPercentage (Continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
as 
(
	Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
	, SUM(CONVERT(float,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
	From project1..CovidDeaths dea
	Join project1..CovidVacinations vac
		On dea.location = vac.location
		and dea.date = vac.date
	where dea.continent is not null
)

Select *, (RollingPeopleVaccinated/Population)*100
	From VacPercentage