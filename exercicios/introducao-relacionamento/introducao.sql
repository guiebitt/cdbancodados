-- Cria a tabela de Pedido
CREATE TABLE PedidoGuilherme
(
    PedidoCodigo INT CONSTRAINT PK_PedidoGuilherme PRIMARY KEY,
    PedidoValor MONEY,
    PedidoData DATE
);

-- Cria a tabela Item
CREATE TABLE ItemGuilherme
(
    ItemCodigo INT IDENTITY(1,1) CONSTRAINT PK_ItemGuilherme PRIMARY KEY,
    ItemNome CHAR(50)
);

-- Cria a tabela Possui
CREATE TABLE PossuiGuilherme
(
    Quantidade INT,
    ItemCodigo INT,
    PedidoCodigo INT,
    CONSTRAINT PK_PossuiGuilherme PRIMARY KEY (ItemCodigo, PedidoCodigo)
);

-- Altera a tabela Possui para incluir uma chave estrangeira referenciando a tabela Item
ALTER TABLE PossuiGuilherme ADD CONSTRAINT FK_PossuiItemGuilherme
    FOREIGN KEY(ItemCodigo) REFERENCES ItemGuilherme (ItemCodigo);

-- Altera a tabela Possui para incluir uma chave estrangeira referenciando a tabela Pedido
ALTER TABLE PossuiGuilherme ADD CONSTRAINT FK_PossuiPedidoGuilherme
    FOREIGN KEY(PedidoCodigo) REFERENCES PedidoGuilherme (PedidoCodigo);

-- Altera a tabela de Item para incluir um novo campo
ALTER TABLE ItemGuilherme ADD Unidade CHAR(10);

-- Altera a tabela de Item para alterar o campo de Unidade
ALTER TABLE ItemGuilherme ALTER COLUMN Unidade CHAR(15);

-- Insere um registro na tabela de Pedido
INSERT PedidoGuilherme
    (PedidoCodigo, PedidoData, PedidoValor)
VALUES
    (1, '2019-11-30', 100.00);

-- Insere um registro na tabela Item
INSERT ItemGuilherme
    (ItemNome)
VALUES
    ('MC Donalds');

-- Altera o valor de um registro na tabela Item
UPDATE ItemGuilherme SET ItemNome = 'Mc Donalds' WHERE ItemCodigo = 1;

-- Insere um registro na tabela Item
INSERT ItemGuilherme
    (ItemNome)
VALUES
    ('Batata frita');

-- Insere um registro na tabela Possui (Deve dar erro, pois não existe o item 3)
INSERT PossuiGuilherme
    (Quantidade, ItemCodigo, PedidoCodigo)
VALUES
    (100, 3, 1);

-- Insere um registro na tabela Possui
INSERT PossuiGuilherme
    (Quantidade, ItemCodigo, PedidoCodigo)
VALUES
    (100, 2, 1);

-- Alterando o Item para conter valor para Unidade
UPDATE ItemGuilherme SET Unidade = 'KG'
 WHERE ItemCodigo = 1;

-- Alterando o Item para conter valor para Unidade
UPDATE ItemGuilherme SET Unidade = 'Grama'
 WHERE ItemCodigo = 2;

-- Alterando o Item para conter valor para Unidade com condição utilizando relacionamento
UPDATE ItemGuilherme SET Unidade = 'Grama'
  FROM ItemGuilherme
 INNER JOIN PossuiGuilherme
    ON ItemGuilherme.ItemCodigo = PossuiGuilherme.ItemCodigo
 WHERE ItemGuilherme.ItemCodigo = 2
   AND PossuiGuilherme.Quantidade > 0;

-- Deletando o Item com condição utilizando relacionamento
SELECT *
--DELETE ItemGuilherme
  FROM ItemGuilherme
 INNER JOIN PossuiGuilherme
    ON ItemGuilherme.ItemCodigo = PossuiGuilherme.ItemCodigo
 WHERE ItemGuilherme.ItemCodigo = 2
   AND PossuiGuilherme.Quantidade > 0;

-- Busca todos os Pedidos
SELECT *
FROM PedidoGuilherme;

-- Busca todos os Itens
SELECT *
FROM ItemGuilherme;

-- Busca todos os Possui
SELECT *
FROM PossuiGuilherme;

-- Busca todos os Pedidos (Definindo os campos)
SELECT PedidoCodigo, PedidoData
FROM PedidoGuilherme;

-- Busca todos os Pedidos que possuem Item
SELECT PedidoGuilherme.PedidoCodigo AS Pedido,
    PedidoGuilherme.PedidoData As Data,
    PossuiGuilherme.Quantidade,
    ItemGuilherme.ItemNome AS Item
FROM PedidoGuilherme
    INNER JOIN PossuiGuilherme ON (PedidoGuilherme.PedidoCodigo = PossuiGuilherme.PedidoCodigo)
    INNER JOIN ItemGuilherme ON (ItemGuilherme.ItemCodigo = PossuiGuilherme.ItemCodigo);

-- Busca todos os Pedidos que possuem Item e os itens que não estão relacionados a pedidos
SELECT ISNULL(PedidoGuilherme.PedidoCodigo, 0) AS Pedido,
    ISNULL(PedidoGuilherme.PedidoData, '') As Data,
    ISNULL(PossuiGuilherme.Quantidade, 0) AS Quantidade,
    ItemGuilherme.ItemNome AS Item,
    CASE WHEN PossuiGuilherme.Quantidade IS NULL
        THEN 'Nunca Vendeu' 
        WHEN PossuiGuilherme.Quantidade > 50 THEN 'Vende Bastante'
        ELSE 'Vende Mais ou Menos' END AS Vendas
FROM PedidoGuilherme
    INNER JOIN PossuiGuilherme ON (PedidoGuilherme.PedidoCodigo = PossuiGuilherme.PedidoCodigo)
    RIGHT JOIN ItemGuilherme ON (ItemGuilherme.ItemCodigo = PossuiGuilherme.ItemCodigo);