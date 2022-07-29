--Deaths table query
SELECT *
FROM deaths
ORDER BY 3, 4

--Vaccinations table query
SELECT *
FROM vaccinations
ORDER BY 3, 4

--Calculating death rate
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_rate
FROM deaths
WHERE location LIKE 'egypt'
ORDER BY 1, 2

--Calculating total cases rate to the population
SELECT location, date, total_cases, population, (total_cases/population)*100 AS infiction_rate
FROM deaths
WHERE location LIKE 'egypt'
ORDER BY 1, 2

--Infiction rate by location
SELECT location, population, MAX((total_cases/population))*100 AS infiction_rate
FROM deaths
GROUP BY location, population
ORDER BY 3 DESC

--Death rate by location
SELECT location, population, MAX((total_deaths/population))*100 AS death_rate
FROM deaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY 3 DESC

--Global numbers broken down by dates
SELECT date, SUM(new_cases) AS global_cases, SUM(CAST(new_deaths AS bigint)) AS global_deaths, (SUM(CAST(new_deaths AS bigint))/(SUM(new_cases)+.001))*100 AS death_rate
FROM deaths
GROUP BY date
HAVING SUM(new_cases) IS NOT NULL
ORDER BY 1

--Global numbers summary
SELECT SUM(new_cases) AS global_cases, SUM(CAST(new_deaths AS bigint)) AS global_deaths, (SUM(CAST(new_deaths AS bigint))/(SUM(new_cases)+.001))*100 AS death_rate
FROM deaths
HAVING SUM(new_cases) IS NOT NULL
ORDER BY 1

SELECT deaths.date, deaths.location, deaths.population, vaccinations.new_vaccinations, 
SUM(CAST(vaccinations.new_vaccinations AS bigint)) OVER (PARTITION BY deaths.location ORDER BY deaths.location, deaths.date) AS rolling_vaccination_sum
FROM deaths
JOIN vaccinations
ON deaths.date = vaccinations.date AND deaths.location = vaccinations.location
ORDER BY location, date
