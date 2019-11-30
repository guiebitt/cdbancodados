-- Consulta sem tipo de lock definido
SELECT * FROM ItemGuilherme;

-- Consulta sem lock (Leitura suja)
SELECT * FROM ItemGuilherme (NOLOCK);