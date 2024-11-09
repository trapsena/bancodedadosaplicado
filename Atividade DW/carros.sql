CREATE DATABASE carro;

-- Tabelas de Dimensão

CREATE TABLE Dim_Carro (
    id_carro CHAR(30) PRIMARY KEY NOT NULL,
    cgc CHAR(12),
    nome CHAR(30),
    modelo CHAR(10),
    preco INT
);

CREATE TABLE Dim_Cliente (
    id_cliente CHAR(12) PRIMARY KEY NOT NULL,
    endereco CHAR(100),
    cidade CHAR(30),
    estado CHAR(2),
    pais CHAR(20),
    renda int
);

CREATE TABLE Dim_Loja (
    id_loja CHAR(12) PRIMARY KEY NOT NULL,
    endereco CHAR(100),
    nome CHAR(30)
);

CREATE TABLE Dim_Tempo (
    tempoid NUMERIC PRIMARY KEY,
    ano NUMERIC,
    mes NUMERIC
);

-- Tabela de Fato

CREATE TABLE Fato_Vendas (
    id_carro CHAR(30),
    id_cliente CHAR(12),
    id_loja CHAR(12),
    tempoid NUMERIC,
    quantidade_vendida INT,
    valor_total int,

    FOREIGN KEY(id_carro) REFERENCES Dim_Carro(id_carro),
    FOREIGN KEY(id_cliente) REFERENCES Dim_Cliente(id_cliente),
    FOREIGN KEY(id_loja) REFERENCES Dim_Loja(id_loja),
    FOREIGN KEY(tempoid) REFERENCES Dim_Tempo(tempoid)
);



-- Populando a tabela Dim_Carro
INSERT INTO Dim_Carro (id_carro, cgc, nome, modelo, preco) VALUES
('C1', '123456789012', 'Carro A', 'Sedan', 30000),
('C2', '123456789013', 'Carro B', 'SUV', 40000),
('C3', '123456789014', 'Carro C', 'Hatch', 25000);

-- Populando a tabela Dim_Cliente
INSERT INTO Dim_Cliente (id_cliente, endereco, cidade, estado, pais, renda) VALUES
('CL1', 'Rua A, 100', 'São Paulo', 'SP', 'Brasil', 50000),
('CL2', 'Rua B, 200', 'Rio de Janeiro', 'RJ', 'Brasil', 30000),
('CL3', 'Rua C, 300', 'Curitiba', 'PR', 'Brasil', 70000);

-- Populando a tabela Dim_Loja
INSERT INTO Dim_Loja (id_loja, endereco, nome) VALUES
('L1', 'Avenida Central, 100', 'Loja A'),
('L2', 'Avenida Sul, 200', 'Loja B'),
('L3', 'Avenida Norte, 300', 'Loja C');

-- Populando a tabela Dim_Tempo
INSERT INTO Dim_Tempo (tempoid, ano, mes) VALUES
(1, 2023, 1),
(2, 2023, 2),
(3, 2023, 3);

-- Populando a tabela Fato_Vendas
INSERT INTO Fato_V--create database carros;

CREATE TABLE dim_cliente (
    id_cliente INT UNIQUE NOT NULL,
    nome_cliente TEXT NOT NULL,
    cliente_cidade TEXT,
    cliente_pais TEXT,
    PRIMARY KEY(id_cliente)
);

CREATE TABLE dim_veiculo (
    id_veiculo INT NOT NULL UNIQUE,
    modelo_veiculo TEXT NOT NULL,
    quantidade_venda INT,
    preco_carro int,
    PRIMARY KEY(id_veiculo)
);

CREATE TABLE dim_loja (
    id_loja INT UNIQUE NOT NULL,
    endereco TEXT,
    PRIMARY KEY(id_loja)
);

CREATE TABLE dim_tempo (
    id_data DATE PRIMARY KEY,
    ano INT,
    mes INT
);

CREATE TABLE fat_venda (
    id_fato_venda SERIAL PRIMARY KEY,          
    id_loja INT NOT NULL,                      
    id_cliente INT NOT NULL,                   
    id_veiculo INT NOT NULL,                   
    id_data DATE NOT NULL,                     
    
     

    FOREIGN KEY (id_loja) REFERENCES dim_loja(id_loja),
    FOREIGN KEY (id_cliente) REFERENCES dim_cliente(id_cliente),
    FOREIGN KEY (id_veiculo) REFERENCES dim_veiculo(id_veiculo),
    FOREIGN KEY (id_data) REFERENCES dim_tempo(id_data)
);


INSERT INTO dim_cliente (id_cliente, nome_cliente, cliente_cidade, cliente_pais)
VALUES
(1, 'João Silva', 'São Paulo', 'Brasil'),
(2, 'Maria Oliveira', 'Rio de Janeiro', 'Brasil'),
(3, 'Carlos Pereira', 'Lisboa', 'Portugal');

-- Inserir dados na tabela dim_veiculo
INSERT INTO dim_veiculo (id_veiculo, modelo_veiculo, quantidade_venda, preco_carro)
VALUES
(1, 'Fiat Uno', 100, 25000),
(2, 'Volkswagen Gol', 150, 35000),
(3, 'Chevrolet Onix', 200, 50000);

-- Inserir dados na tabela dim_loja
INSERT INTO dim_loja (id_loja, endereco)
VALUES
(1, 'Avenida Paulista, 1000, São Paulo, SP'),
(2, 'Rua das Flores, 300, Rio de Janeiro, RJ'),
(3, 'Alameda Santos, 500, São Paulo, SP');

-- Inserir dados na tabela dim_tempo
INSERT INTO dim_tempo (id_data, ano, mes)
VALUES
('2024-01-01', 2024, 1),
('2024-02-01', 2024, 2),
('2024-03-01', 2024, 3);

-- Inserir dados na tabela fat_venda
INSERT INTO fat_venda (id_loja, id_cliente, id_veiculo, id_data)
VALUES
(1, 1, 1, '2024-01-01'),
(2, 2, 2, '2024-02-01'),
(3, 3, 3, '2024-03-01');


SELECT 
    l.id_loja,
    l.endereco,
    SUM(v.preco_carro * fv.id_veiculo) AS total_vendas
FROM 
    fat_venda fv
JOIN 
    dim_veiculo v ON fv.id_veiculo = v.id_veiculo
JOIN 
    dim_loja l ON fv.id_loja = l.id_loja
WHERE 
    fv.id_data BETWEEN '2024-01-01' AND '2024-03-31'  
GROUP BY 
    l.id_loja, l.endereco;
   
 
   
 --mais
  SELECT 
    l.id_loja,
    l.endereco,
    SUM(v.preco_carro * fv.id_veiculo) AS total_vendas
FROM 
    fat_venda fv
JOIN 
    dim_veiculo v ON fv.id_veiculo = v.id_veiculo
JOIN 
    dim_loja l ON fv.id_loja = l.id_loja
WHERE 
    fv.id_data BETWEEN '2024-01-01' AND '2024-03-31'  -- Período de exemplo
GROUP BY 
    l.id_loja, l.endereco
ORDER BY 
    total_vendas DESC
 
   --menos
SELECT 
    l.id_loja,
    l.endereco,
    SUM(v.preco_carro * fv.id_veiculo) AS total_vendas
FROM 
    fat_venda fv
JOIN 
    dim_veiculo v ON fv.id_veiculo = v.id_veiculo
JOIN 
    dim_loja l ON fv.id_loja = l.id_loja
WHERE 
    fv.id_data BETWEEN '2024-01-01' AND '2024-03-31'  -- Período de exemplo
GROUP BY 
    l.id_loja, l.endereco
ORDER BY 
    total_vendas asc
    
    
 
Aqui estão as consultas SQL que atendem aos requisitos mencionados:

1. Total das vendas de uma determinada loja, num determinado período:
Essa consulta soma o preço dos veículos vendidos em uma loja específica dentro de um determinado período. Para calcular o total, vamos juntar a tabela fat_venda com as tabelas dim_veiculo e dim_loja, considerando o preço do carro e o período de tempo desejado.

sql
Copiar código
SELECT 
    l.id_loja,
    l.endereco,
    SUM(v.preco_carro * fv.id_veiculo) AS total_vendas
FROM 
    fat_venda fv
JOIN 
    dim_veiculo v ON fv.id_veiculo = v.id_veiculo
JOIN 
    dim_loja l ON fv.id_loja = l.id_loja
WHERE 
    fv.id_data BETWEEN '2024-01-01' AND '2024-03-31'  -- Período de exemplo
GROUP BY 
    l.id_loja, l.endereco;
2. Lojas que mais venderam num determinado período de tempo:
Essa consulta retorna as lojas que mais venderam em um determinado período. A soma será feita com base no preço dos veículos vendidos.

sql
Copiar código
SELECT 
    l.id_loja,
    l.endereco,
    SUM(v.preco_carro * fv.id_veiculo) AS total_vendas
FROM 
    fat_venda fv
JOIN 
    dim_veiculo v ON fv.id_veiculo = v.id_veiculo
JOIN 
    dim_loja l ON fv.id_loja = l.id_loja
WHERE 
    fv.id_data BETWEEN '2024-01-01' AND '2024-03-31'  -- Período de exemplo
GROUP BY 
    l.id_loja, l.endereco
ORDER BY 
    total_vendas DESC
LIMIT 5;  -- Lojas com as maiores vendas
3. Lojas que menos venderam num determinado período de tempo:
Semelhante à consulta anterior, mas agora ordenando pela menor venda.

sql
Copiar código
SELECT 
    l.id_loja,
    l.endereco,
    SUM(v.preco_carro * fv.id_veiculo) AS total_vendas
FROM 
    fat_venda fv
JOIN 
    dim_veiculo v ON fv.id_veiculo = v.id_veiculo
JOIN 
    dim_loja l ON fv.id_loja = l.id_loja
WHERE 
    fv.id_data BETWEEN '2024-01-01' AND '2024-03-31'  -- Período de exemplo
GROUP BY 
    l.id_loja, l.endereco
ORDER BY 
    total_vendas ASC
LIMIT 5;  -- Lojas com as menores vendas
4. Perfil de clientes que devem-se investir:
Para identificar o perfil de clientes que devem ser priorizados, podemos observar aqueles com maior valor de compras e/ou frequência de compra. Podemos realizar uma consulta agrupando por id_cliente e somando as vendas.


SELECT 
    c.id_cliente,
    c.nome_cliente,
    c.cliente_cidade,
    c.cliente_pais,
    SUM(v.preco_carro * fv.id_veiculo) AS total_gasto
FROM 
    fat_venda fv
JOIN 
    dim_veiculo v ON fv.id_veiculo = v.id_veiculo
JOIN 
    dim_cliente c ON fv.id_cliente = c.id_cliente
GROUP BY 
    c.id_cliente, c.nome_cliente, c.cliente_cidade, c.cliente_pais
ORDER BY 
    total_gasto DESC

    
 SELECT 
    v.id_veiculo,
    v.modelo_veiculo,
    SUM(fv.id_veiculo) AS total_vendas
FROM 
    fat_venda fv
JOIN 
    dim_veiculo v ON fv.id_veiculo = v.id_veiculo
JOIN 
    dim_cliente c ON fv.id_cliente = c.id_cliente
WHERE 
    c.cliente_cidade = 'São Paulo'  
GROUP BY 
    v.id_veiculo, v.modelo_veiculo
ORDER BY 
    total_vendas DESCendas (id_carro, id_cliente, id_loja, tempoid, quantidade_vendida, valor_total) VALUES
('C1', 'CL1', 'L1', 1, 2, 60000),
('C2', 'CL2', 'L1', 2, 1, 40000),
('C1', 'CL3', 'L2', 1, 1, 30000),
('C3', 'CL1', 'L3', 2, 3, 75000),
('C2', 'CL2', 'L2', 3, 2, 80000),
('C1', 'CL3', 'L1', 3, 1, 30000);
