/** Quantidade de motoristas certificados */
SELECT COUNT(driverid) as Quantidade, certified FROM drivers GROUP BY certified

/** Ranking dos 5 motoristas que mais dirigiram em horas */
SELECT TOP 5 name AS Nome, SUM(CONVERT(int, [hours-logged])) AS Horas FROM timesheet
    INNER JOIN drivers
	ON drivers.driverId = timesheet.driverId
	GROUP BY name
	ORDER BY Horas desc

/** Ranking dos 5 motoristas que mais dirigiram em milhas */
SELECT TOP 5 name AS Nome, SUM(CONVERT(int, [miles-logged])) AS Milhas FROM timesheet
    INNER JOIN drivers
	ON drivers.driverId = timesheet.driverId
	GROUP BY name
	ORDER BY Milhas desc

/** Média geral dos motoristas */
DECLARE @TOTAL_HORAS_GERAL FLOAT
SET @TOTAL_HORAS_GERAL = (SELECT SUM(CONVERT(int, [hours-logged])) FROM timesheet)
SELECT @TOTAL_HORAS_GERAL AS TotalHoras

DECLARE @QUANTIDADE_MOTORISTAS INT
SET @QUANTIDADE_MOTORISTAS = (SELECT COUNT(DISTINCT driverId) FROM timesheet)
SELECT @QUANTIDADE_MOTORISTAS AS QuantidadeMotoristas

DECLARE @MEDIA FLOAT
SET @MEDIA = @TOTAL_HORAS_GERAL/@QUANTIDADE_MOTORISTAS
SELECT @MEDIA AS Media

SELECT name AS Nome, SUM(CONVERT(int, [hours-logged])) AS Horas FROM timesheet
    INNER JOIN drivers
	ON drivers.driverId = timesheet.driverId
	GROUP BY name
    HAVING SUM(CONVERT(int, [hours-logged])) > @MEDIA
	ORDER BY Horas DESC

SELECT name AS Nome, SUM(CONVERT(int, [hours-logged])) AS Horas FROM timesheet
    INNER JOIN drivers
	ON drivers.driverId = timesheet.driverId
	GROUP BY name
    HAVING SUM(CONVERT(int, [hours-logged])) > ((SELECT SUM(CONVERT(int, [hours-logged])) FROM timesheet) / (SELECT COUNT(DISTINCT driverId) FROM timesheet))
	ORDER BY Horas DESC

/** Ranking dos motoristas mais ágeis por semana */
SELECT name AS Nome, CONVERT(int, week) AS Semana,  (CONVERT(float, [miles-logged]) / CONVERT(float, [hours-logged])) AS MilhasPorHora FROM timesheet
    INNER JOIN drivers
	ON drivers.driverId = timesheet.driverId
	WHERE [miles-logged] > 0
	ORDER BY Semana DESC, MilhasPorHora DESC