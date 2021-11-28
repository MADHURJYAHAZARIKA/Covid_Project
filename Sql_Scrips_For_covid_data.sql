Select  Location,date,total_cases,new_cases,total_deaths,population from PortfolioProject.dbo.CovidDeaths Order by 1,2;
--Looking at Total cases vs total death
Select Location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as Death_Percentage 
from PortfolioProject.dbo.CovidDeaths where Location Like 'India' Order by 1,2
--Looking at Total cases vs Total population
Select Location,date,total_cases,total_deaths,Population,(total_cases/population)*100 as Infection_Percentage from 
PortfolioProject.dbo.CovidDeaths where Location Like 'India' Order by 1,2
--Looking at countries having highest infections
Select Location,Population,MAX(total_cases) as max_total_cases,max(total_cases/population)*100 as Infection_Percentage from  PortfolioProject.dbo.CovidDeaths group by Location,population order by Infection_Percentage desc
--Selecting country with highest no of death count per population
Select location,max(cast(total_deaths as int)) as TotalDeathcounts from [PortfolioProject].[dbo].[CovidDeaths] where continent is not null group by Location order by TotalDeathCounts  desc
--Breaking things by continet
--Showing continents with highest no of death
Select continent,max(cast(total_deaths as int)) as TotalDeathcounts 
from [PortfolioProject].[dbo].[CovidDeaths] where
continent is not null group by continent order by TotalDeathCounts  desc
--Global numbers
Select SUM(new_cases),SUM(cast(new_deaths as int)),SUM(cast(new_deaths as int))/Sum(new_cases)*100 as Death_Percentage from  [PortfolioProject].[dbo].[CovidDeaths]
 where continent is not null Order by 1,2

 --Total percentage people in the world got vaccinated 
 with popvsvac(location,continent,date,population,vaccinations,RollingPeopleVaccinated)
 as
 (
 Select dea.location,dea.continent,dea.date,dea.population,vac.new_vaccinations,Sum(cast(vac.new_vaccinations as bigint))
 over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
 from PortfolioProject.dbo.CovidDeaths dea  INNER JOIN PortfolioProject.dbo.CovidVaccination  vac on
 dea.location = vac.location and dea.date = vac.date where dea.continent is not null )
 Select*,(RollingPeopleVaccinated/population) *100 as Vaccinated_People_Percentage from popvsvac

 --Temp tables
 Drop table if exists #PercentageVaccinatedPeople
 create Table #PercentageVaccinatedPeople
 (Location varchar(255),
 Continent varchar(255),
 date datetime,
 population numeric,
 new_vacination numeric,
 RollingPeopleVaccinated numeric
  
 )

 insert into #PercentageVaccinatedPeople
 Select dea.location,dea.continent,dea.date,dea.population,vac.new_vaccinations,Sum(cast(vac.new_vaccinations as bigint))
 over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
 from PortfolioProject.dbo.CovidDeaths dea  INNER JOIN PortfolioProject.dbo.CovidVaccination  vac on
 dea.location = vac.location and dea.date = vac.date where dea.continent is not null
 Select*,(RollingPeopleVaccinated/population) *100  from #PercentageVaccinatedPeople

 --creating views for visualization
 create view PercentageVaccinatedPeople as
 Select dea.location,dea.continent,dea.date,dea.population,vac.new_vaccinations,Sum(cast(vac.new_vaccinations as bigint))
 over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
 from PortfolioProject.dbo.CovidDeaths dea  INNER JOIN PortfolioProject.dbo.CovidVaccination  vac on
 dea.location = vac.location and dea.date = vac.date where dea.continent is not null
