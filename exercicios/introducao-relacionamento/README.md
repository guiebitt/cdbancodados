# Introdução

## Modelo Conceitual x Modelo Lógico

![Modelo Conceitual x Modelo Lógico](./modelo_conceitual_logico.png)

## SQL

```sql
-- Cria a tabela de Pedido
CREATE TABLE PedidoGuilherme (
    PedidoCodigo INT CONSTRAINT PK_PedidoGuilherme PRIMARY KEY,
    PedidoValor MONEY,
    PedidoData DATE
);

-- Insere um registro na tabela de Pedido
INSERT PedidoGuilherme (PedidoCodigo, PedidoData, PedidoValor)
VALUES (1, '2019-11-30', 100.00);

-- Busca todos os Pedidos
SELECT * FROM PedidoGuilherme;

-- Cria a tabela Item
CREATE TABLE ItemGuilherme (
    ItemCodigo INT IDENTITY(1,1) CONSTRAINT PK_ItemGuilherme PRIMARY KEY,
    ItemNome CHAR(50)
);

-- Insere um registro na tabela Item
INSERT ItemGuilherme (ItemNome)
VALUES ('MC Donalds');

-- Busca todos os Itens
SELECT * FROM ItemGuilherme;

-- Altera o valor de um registro na tabela Item
UPDATE ItemGuilherme SET ItemNome = 'Mc Donalds' WHERE ItemCodigo = 1;

-- Cria a tabela Possui
CREATE TABLE PossuiGuilherme (
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
```