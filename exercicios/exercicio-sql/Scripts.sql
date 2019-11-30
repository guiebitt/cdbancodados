--GETDATE()
--YEAR()
--ORDER BY
--TOP
--ALIAS

SELECT * FROM Clientes;

SELECT GETDATE();

SELECT ClienteNascimento, GETDATE() AS DataAtual,
   DATEDIFF(YYYY, ClienteNascimento, GETDATE()) AS IdadeUsandoDATEDIFF,
   (YEAR(GETDATE())-YEAR(dbo.Clientes.ClienteNascimento)) AS Idade,
   CONVERT([float], DATEDIFF(dd, ClienteNascimento, GETDATE())) / 365 AS IdadeComCasasDecimais,
   FORMAT(EOMONTH(ClienteNascimento), 'dd/MM/yyyy') AS UltimoDiaMes,
   CONVERT([VARCHAR], ClienteNascimento, 103) AS DataFormatada
   FROM Clientes;

SET DATEFORMAT dmy;

SELECT Clientes.ClienteNome AS [Nome do Cliente],
(YEAR(GETDATE())-YEAR(dbo.Clientes.ClienteNascimento)) AS 'Idade'
FROM dbo.Clientes (NOLOCK)

SELECT TOP 1 
Clientes.ClienteNome AS [Nome do Cliente],
(YEAR(GETDATE())-YEAR(dbo.Clientes.ClienteNascimento)) AS 'Idade'
FROM dbo.Clientes (NOLOCK)
ORDER BY 2

SELECT TOP 1 
Clientes.ClienteNome AS [Nome do Cliente],
(YEAR(GETDATE())-YEAR(dbo.Clientes.ClienteNascimento)) AS 'Idade'
FROM dbo.Clientes (NOLOCK)
ORDER BY 2 DESC

--COALESCE
SELECT  ClienteNome + ' - ' + COALESCE(ClienteRua,'') 
+ ' - ' + ClienteCidade
FROM dbo.Clientes
WHERE ClienteCodigo = 1 OR ClienteCodigo = 5

--ISNULL
SELECT ClienteNome, 
ISNULL(ClienteRua,'NN') AS ClienteRua
FROM dbo.Clientes

--CAST
SELECT 'R$ ' + CAST(ContaNumero AS VARCHAR(8)) AS SALDO
FROM dbo.Contas

--CONVERT
SELECT 'R$ ' + CONVERT(VARCHAR(8),ContaNumero) AS SALDO
FROM dbo.Contas

--LEN()
SELECT LEN(Contas.ContaNumero) AS 'TAMANHO DO CONTE�DO'
FROM dbo.Contas

--DATALENGTH
SELECT DATALENGTH(Contas.ContaNumero) AS 'TAMANHO DO CAMPO'
FROM dbo.Contas

--PATINDEX
SELECT
PATINDEX('%-%', ContaNumero) AS 'POSI��O DO TRA�O '
FROM dbo.Contas
GO

--SUBSTRING
SELECT SUBSTRING(Contas.ContaNumero,3,5) 
AS 'NUMERO DA CONTA'
FROM dbo.Contas


--LEN(), DATALENGHT, PATINDEX
SELECT
SUBSTRING(ContaNumero,3,5)
FROM dbo.Contas
GO

SELECT
SUBSTRING(Clientes.ClienteRua, PATINDEX('%[^0]%', 
Clientes.ClienteRua 
+ ' '), LEN(Clientes.ClienteRua))
FROM dbo.Clientes
GO

--CASE
SELECT ContaNumero, 
CASE 
WHEN ContaNumero < 200 THEN 'Cliente C'
WHEN ContaNumero < 500 THEN 'Cliente B'
ELSE 'Cliente A' END AS 'Curva Cliente'
FROM dbo.Contas

--JOINS


--PIVOT
SELECT AgenciaCodigo, SUM(ContaNumero) FROM dbo.Contas

WITH T1 AS
(SELECT 'ContaNumero' AS SaldoPorAgencia, 
[1], [2], [3],[4],[5],[6],[7],[8]
FROM
(SELECT AgenciaCodigo, ContaNumero 
    FROM Contas) AS SourceTable
PIVOT
(
SUM(ContaNumero)
FOR AgenciaCodigo IN ([1], [2], [3],[4],[5],[6],[7],[8])
) AS PivotTable)

SELECT * 
INTO #TEMP
FROM T1

SELECT * FROM #TEMP

SELECT AgenciaCodigo, ContaNumero 
FROM 
   (SELECT SaldoPorAgencia, [1], [2], [3], [4], [5], [6], [7], [8]    
   FROM #TEMP) P
UNPIVOT
   (ContaNumero FOR AgenciaCodigo IN 
      ( [1], [2], [3], [4], [5], [6], [7], [8] )
)AS unpvt;
GO

SELECT * FROM dbo.Contas

UPDATE dbo.Contas SET ContaNumero = NULL
WHERE AgenciaCodigo IN (1,3)

--ROLLUP
SELECT AgenciaCodigo,SUM(ContaNumero) FROM Contas
GROUP BY AgenciaCodigo WITH ROLLUP

--GROUPING
SELECT 
YEAR(ContaAbertura) AS ANO,
AgenciaCodigo,
GROUPING(AgenciaCodigo) AS 'AgrupouAgencia',
GROUPING(ContaAbertura) AS 'AgrupouAno',
SUM(ContaNumero) FROM Contas
GROUP BY AgenciaCodigo,ContaAbertura WITH ROLLUP


--CUBE
SELECT 
YEAR(ContaAbertura) AS ANO,
MONTH(ContaAbertura) AS MES,
SUM(ContaNumero) FROM Contas
GROUP BY CUBE (YEAR(ContaAbertura),MONTH(ContaAbertura))






