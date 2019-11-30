--PIVOT
SELECT AgenciaCodigo, SUM(ContaSaldo) FROM dbo.Contas

WITH T1 AS
(SELECT 'ContaSaldo' AS SaldoPorAgencia, 
[1], [2], [3],[4],[5],[6],[7],[8]
FROM
(SELECT AgenciaCodigo, ContaSaldo 
    FROM Contas) AS SourceTable
PIVOT
(
SUM(ContaSaldo)
FOR AgenciaCodigo IN ([1], [2], [3],[4],[5],[6],[7],[8])
) AS PivotTable)

SELECT * 
INTO #TEMP
FROM T1

SELECT * FROM #TEMP

SELECT AgenciaCodigo, ContaSaldo 
FROM 
   (SELECT SaldoPorAgencia, [1], [2], [3], [4], [5], [6], [7], [8]    
   FROM #TEMP) P
UNPIVOT
   (ContaSaldo FOR AgenciaCodigo IN 
      ( [1], [2], [3], [4], [5], [6], [7], [8] )
)AS unpvt;
GO

SELECT * FROM dbo.Contas

UPDATE dbo.Contas SET ContaSaldo = NULL
WHERE AgenciaCodigo IN (1,3)

--ROLLUP
--Mostra um totalizador ao final da consulta
SELECT AgenciaCodigo,SUM(ContaSaldo) AS Total FROM Contas
GROUP BY AgenciaCodigo WITH ROLLUP

--GROUPING
--Faz o total, porém você especifica os grupos totalizadores
--ou seja, agrupa por ano 
SELECT 
YEAR(ContaAbertura) AS ANO, AgenciaCodigo,
GROUPING(AgenciaCodigo) AS 'AgrupouAgencia',
GROUPING(ContaAbertura) AS 'AgrupouAno',
SUM(ContaSaldo) FROM Contas
GROUP BY AgenciaCodigo,ContaAbertura WITH ROLLUP


--CUBE
--Monta as conbinações possíveis de agrupamento por mês e por ano nesse caso
SELECT 
YEAR(ContaAbertura) AS ANO,
MONTH(ContaAbertura) AS MES,
SUM(ContaSaldo) 
FROM Contas
GROUP BY YEAR(ContaAbertura),
MONTH(ContaAbertura) WITH CUBE


--WHILE
DECLARE @CONTADOR INT
DECLARE @CLIENTES INT

SET @CONTADOR = 1
SET @CLIENTES = (SELECT COUNT(*) FROM dbo.Clientes)

WHILE (@CONTADOR <= @CLIENTES)
	BEGIN
		SELECT dbo.Clientes.ClienteNome FROM dbo.Clientes
			WHERE ClienteCodigo = @CONTADOR
	
	SET @CONTADOR=@CONTADOR+1
	END
	
--LIKE e NOT LIKE
SELECT ClienteNome,
CASE WHEN ClienteNome LIKE '%a' THEN 'F' ELSE 'M' END AS 'Sexo'
FROM dbo.Clientes


SELECT ClienteNome,
CASE WHEN ClienteNome LIKE '%a' THEN 'F' ELSE 'M' END AS 'Sexo'
FROM dbo.Clientes
WHERE 
ClienteNome LIKE 'Julian[ao]';


SELECT ClienteNome,
CASE WHEN ClienteNome LIKE '%a' THEN 'F' ELSE 'M' END AS 'Sexo'
FROM dbo.Clientes
WHERE ClienteNome LIKE 'A[n]a';

--Regular Expressions
--http://technet.microsoft.com/en-us/library/ms174214(v=sql.110).aspx
--http://msdn.microsoft.com/en-us/library/ms179859.aspx

--Views

CREATE VIEW vContas
as
SELECT ContaNumero, CASE WHEN dbo.Contas.ContaSaldo > 700 THEN 'Especial'
ELSE 'Normal' END AS 'Classificação' FROM CONTAS

SELECT * FROM vContas

--Procedures
	--Declare
	--If

CREATE PROCEDURE proc_converte_saldo
(
@conta varchar(10),
@moeda char(2)
)
AS
BEGIN
DECLARE @total MONEY
DECLARE @SALDO MONEY

SELECT @SALDO = dbo.Contas.ContaSaldo FROM dbo.Contas WHERE ContaNumero = @CONTA

IF @MOEDA = 'DO'
	BEGIN
		SET @TOTAL = @SALDO / 2.5
	END
	ELSE 
	IF @MOEDA = 'EU'
	BEGIN
		SET @TOTAL = @SALDO / 3.2
	END
		ELSE 
		BEGIN
		SET @TOTAL = @SALDO / 3.3
		END

SELECT @TOTAL

END

EXECUTE proc_converte_saldo 'C-401','EU'
 

--Triggers



--Functions

CREATE FUNCTION TRIM(@ST VARCHAR(1000))
RETURNS VARCHAR(1000)
BEGIN
   RETURN(LTRIM(RTRIM(@ST)))
END

http://www.devmedia.com.br/construindo-funcoes-para-sql-server/20934
--Performance
--Cursor

sp_help Clientes
sp_helpindex Clientes

SELECT ClienteCodigo FROM dbo.Clientes
WHERE  ClienteCodigo = 5
--ORDER BY ClienteCidade DESC

CREATE INDEX IX_CIDADE ON dbo.Clientes
(ClienteCidade DESC)

UPDATE STATISTICS dbo.Clientes

SELECT
  [AgenciaCodigo]
  ,ContaSaldo
  ,MONTH([ContaAbertura]) AS Mes
  ,ROW_NUMBER() OVER(ORDER BY MONTH([ContaAbertura]) DESC) AS RowNumber
  ,RANK() OVER(ORDER BY MONTH([ContaAbertura]) DESC) AS BasicRank
  --,DENSE_RANK() OVER(ORDER BY MONTH([ContaAbertura]) DESC) AS DenseRank
  --,NTILE(3) OVER(ORDER BY MONTH([ContaAbertura]) DESC) AS NTileRank
FROM
  dbo.Contas;


  SELECT TOP 25
dm_mid.database_id AS DatabaseID,
dm_migs.avg_user_impact*(dm_migs.user_seeks+dm_migs.user_scans) Avg_Estimated_Impact,
dm_migs.last_user_seek AS Last_User_Seek,
OBJECT_NAME(dm_mid.OBJECT_ID,dm_mid.database_id) AS [TableName],
'CREATE INDEX [IX_' + OBJECT_NAME(dm_mid.OBJECT_ID,dm_mid.database_id) + '_'
+ REPLACE(REPLACE(REPLACE(ISNULL(dm_mid.equality_columns,''),', ','_'),'[',''),']','') +
CASE
WHEN dm_mid.equality_columns IS NOT NULL AND dm_mid.inequality_columns IS NOT NULL THEN '_'
ELSE ''
END
+ REPLACE(REPLACE(REPLACE(ISNULL(dm_mid.inequality_columns,''),', ','_'),'[',''),']','')
+ ']'
+ ' ON ' + dm_mid.statement
+ ' (' + ISNULL (dm_mid.equality_columns,'')
+ CASE WHEN dm_mid.equality_columns IS NOT NULL AND dm_mid.inequality_columns IS NOT NULL THEN ',' ELSE
'' END
+ ISNULL (dm_mid.inequality_columns, '')
+ ')'
+ ISNULL (' INCLUDE (' + dm_mid.included_columns + ')', '') AS Create_Statement
FROM sys.dm_db_missing_index_groups dm_mig
INNER JOIN sys.dm_db_missing_index_group_stats dm_migs
ON dm_migs.group_handle = dm_mig.index_group_handle
INNER JOIN sys.dm_db_missing_index_details dm_mid
ON dm_mig.index_handle = dm_mid.index_handle
WHERE dm_mid.database_ID = DB_ID()
ORDER BY Avg_Estimated_Impact DESC
GO

SELECT OBJECT_NAME(ind.OBJECT_ID) AS TableName,
ind.name AS IndexName, indexstats.index_type_desc AS IndexType,
indexstats.avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, NULL) indexstats
INNER JOIN sys.indexes ind 
ON ind.object_id = indexstats.object_id
AND ind.index_id = indexstats.index_id
WHERE indexstats.avg_fragmentation_in_percent > 30--You can specify the percent as you want
ORDER BY indexstats.avg_fragmentation_in_percent DESC