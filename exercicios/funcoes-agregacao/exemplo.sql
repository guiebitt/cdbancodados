-- Funções de Agregação

-- SUM, MIN, MAX, AVG, COUNT
-- GROUP BY
-- HAVING

SELECT *
FROM Movimentos;
-- Quanto foi movimentado por Ano
-- Ordenar pelos maiores
-- Apenas os anos que movimentaram acima da média

SELECT YEAR(Movimentos.MovimentoData) AS ANO,
    SUM(Movimentos.MovimentoValor) AS VALOR,
    COUNT(Movimentos.MovimentoCodigo) AS MOVIMENTOS
FROM Movimentos
GROUP BY YEAR(Movimentos.MovimentoData)
-- HAVING SUM(Movimentos.MovimentoValor) > 
ORDER BY ANO DESC;