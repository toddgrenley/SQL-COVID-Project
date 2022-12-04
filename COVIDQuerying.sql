SELECT *
FROM [Portfolio Project]..CovidDeaths
WHERE continent is not null
ORDER BY 3,4

SELECT *
FROM [Portfolio Project]..CovidVaccinations
ORDER BY 3,4

-- Select the Data that we are going to be using

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM [Portfolio Project]..CovidDeaths
WHERE continent is not null
ORDER BY 1,2


-- Looking at Total Cases vs Total Deaths
-- Shows what percentage of cases resulted in death

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM [Portfolio Project]..CovidDeaths
WHERE location = 'United States'
ORDER BY 1,2


-- Looking at Total Cases vs Population
-- Shows what percentage of the population got Covid

SELECT location, date, population, total_cases, (total_cases/population)*100 AS CasePercentage
FROM [Portfolio Project]..CovidDeaths
WHERE location = 'United States'
ORDER BY 1,2


-- Looking at Countries with Highest Infection Rate

SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population)*100) AS CasePercentage
FROM [Portfolio Project]..CovidDeaths
--WHERE location = 'United States'
GROUP BY location, population
ORDER BY CasePercentage desc


-- Looking at Countries with Highest Death Count

SELECT location, population, MAX(total_deaths) AS TotalDeathCount, MAX((total_deaths/population)*100) AS PopulationDeathPercentage
FROM [Portfolio Project]..CovidDeaths
--WHERE location = 'United States'
GROUP BY location, population
ORDER BY TotalDeathCount desc

-- Simpler Version of Previous

SELECT location, MAX(cast(total_deaths AS int)) AS TotalDeathCount
FROM [Portfolio Project]..CovidDeaths
--WHERE location = 'United States'
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount desc


-- BREAKING THINGS DOWN BY CONTINENT

-- Looking at Continents with Highest Death Count

SELECT continent, MAX(cast(total_deaths AS int)) AS TotalDeathCount
FROM [Portfolio Project]..CovidDeaths
--WHERE location = 'United States'
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc

-- Gives correct numbers for continents for Above

SELECT location, MAX(cast(total_deaths AS int)) AS TotalDeathCount
FROM [Portfolio Project]..CovidDeaths
--WHERE location = 'United States'
WHERE continent is null
GROUP BY location
ORDER BY TotalDeathCount desc


-- GLOBAL NUMBERS

-- Looking at Total Global Numbers

SELECT date, SUM(new_cases) AS TotalCases, SUM(cast(new_deaths AS int)) AS TotalDeaths, SUM(cast(new_deaths AS int))/SUM(new_cases)*100 AS DeathPercentage
FROM [Portfolio Project]..CovidDeaths
--WHERE location = 'United States'
WHERE continent is not null
GROUP BY date
ORDER BY 1,2

-- Simpler Version of Previous

SELECT SUM(new_cases) AS TotalCases, SUM(cast(new_deaths AS int)) AS TotalDeaths, SUM(cast(new_deaths AS int))/SUM(new_cases)*100 AS DeathPercentage
FROM [Portfolio Project]..CovidDeaths
--WHERE location = 'United States'
WHERE continent is not null
--GROUP BY date
ORDER BY 1,2


-- JOINS

-- Looking at Total Population vs Vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated --, (RollingPeopleVaccinated/population)*100
FROM [Portfolio Project]..CovidDeaths dea
JOIN [Portfolio Project]..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3