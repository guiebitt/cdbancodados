-- Transação
BEGIN TRANSACTION

UPDATE ItemGuilherme SET Unidade = 'Metro'
 WHERE ItemGuilherme.ItemCodigo = 1;

-- COMMIT
-- ROLLBACK