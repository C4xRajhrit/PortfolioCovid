select * 
from Portfolio..Covid_Deaths$
ORDER BY 3,4

--select * 
--from Portfolio..Covid_Vaccinations$
--ORDER BY 3,4--

select location, date,  total_cases, new_cases, total_deaths, population
from Portfolio..Covid_Deaths$
order by 1,2

--Total Cases vs Total Deaths
select location, date,  total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
from Portfolio..Covid_Deaths$
where location = 'India'
order by 1,2

--Total Cases vs Population
select location, date,  total_cases, population, (total_cases/population)*100 as Infection_Rate
from Portfolio..Covid_Deaths$
where location = 'India'
order by 1,2

--Countries with Highest Infection Rates
select location,  MAX( total_cases) as HighestInfectionCount, population, MAX	((total_cases/population))*100 as Infection_Rate
from Portfolio..Covid_Deaths$
group by location,population
order by Infection_Rate desc

--Countries with Highest Death Counts per population

select location, max(cast( Total_deaths as bigint)) as Total_DeathCount
from Portfolio..Covid_Deaths$
where continent is not null
group by location 
order by Total_DeathCount DESC

-- By continent
select continent, max(cast( Total_deaths as bigint)) as Total_DeathCount
from Portfolio..Covid_Deaths$
where continent is not null
group by continent
order by Total_DeathCount DESC

-- GLOBAL NUMBERS

select   SUM(new_cases) as total_cases, Sum(cast(new_deaths as bigint)) as total_deaths, sum(cast(new_deaths as bigint))/sum(new_cases)*100 as Death_Percentage
from Portfolio..Covid_Deaths$
where continent is not null
order by 1,2

-- Total Population vs Vaccination


DROP table if exists #PercentagePoulationVaccinated
Create table #PercentagePoulationVaccinated
(
 continent nvarchar(255),
 location nvarchar(255),
 date datetime,
 population numeric,
 new_vaccinations numeric,
 RollingPeopleVaccinated numeric
 )
 insert into  #PercentagePoulationVaccinated
 
select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations, SUM(cast( vac.new_vaccinations as bigint))  over (partition by dea.location order by dea.location , dea.date) as RollingPeopleVaccinated
from Portfolio..Covid_Deaths$ dea
join Portfolio..Covid_Vaccinations$ vac
     on dea.location= vac.location
	 and dea.date= vac.date
	 where dea.continent is not null
	 
	 select *, (RollingPeopleVaccinated/population) * 100 as PercentagePoulationVaccinated
	 from #PercentagePoulationVaccinated
	 
	 
	 



	 Create view 
	 PercentPopulationVaccinated as
	 select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations, SUM(cast( vac.new_vaccinations as bigint))  over (partition by dea.location order by dea.location , dea.date) as RollingPeopleVaccinated
from Portfolio..Covid_Deaths$ dea
join Portfolio..Covid_Vaccinations$ vac
     on dea.location= vac.location
	 and dea.date= vac.date
	 where dea.continent is not null

	 
	 
