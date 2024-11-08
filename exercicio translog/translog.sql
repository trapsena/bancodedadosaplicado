create database DW;
drop table Dim_Tempo cascade;
drop table Dim_Cliente cascade;
drop table dim_centro cascade;
drop table Fato_entregas cascade;

-- criação da tabela de clientes
create table clientes (
    cliente_id int primary key,
    nome varchar(100) not null,
    endereco varchar(255),
    cidade varchar(100),
    estado char(2)
);

-- criação da tabela de centros de distribuição
create table centros (
    centro_id int primary key,
    nome varchar(100) not null,
    endereco varchar(255),
    cidade varchar(100),
    estado char(2)
);

-- criação da tabela de pedidos
create table pedidos (
    pedido_id int primary key,
    data_pedido date not null,
    cliente_id int,
    centro_saida_id int,
    centro_destino_id int,
    quantidade int check (quantidade > 0),
    valor_total decimal(10, 2) check (valor_total > 0),
    foreign key (cliente_id) references clientes(cliente_id),
    foreign key (centro_saida_id) references centros(centro_id),
    foreign key (centro_destino_id) references centros(centro_id)
);

-- criação da tabela de entregas
create table entregas (
    entrega_id int primary key,
    pedido_id int,
    data_saida date,
    data_chegada date,
    quilometragem decimal(10, 2) check (quilometragem > 0),
    foreign key (pedido_id) references pedidos(pedido_id)
);

-- Criação das Tabelas de Dimensão

-- Dimensão Cliente (com SCD do tipo 2)
CREATE TABLE Dim_Cliente (
    cliente_sk SERIAL PRIMARY KEY,
    cliente_id INT,
    nome VARCHAR(100),
    endereco VARCHAR(200),
    cidade VARCHAR(100),
    estado VARCHAR(2),
    data_inicio DATE,
    data_fim DATE,
    ativo BOOLEAN
);

-- Dimensão Centro de Distribuição (com SCD do tipo 2)
CREATE TABLE Dim_Centro (
    centro_sk SERIAL PRIMARY KEY ,
    centro_id INT,
    nome VARCHAR(100),
    endereco VARCHAR(200),
    cidade VARCHAR(100),
    estado VARCHAR(2),
    data_inicio DATE,
    data_fim DATE,
    ativo BOOLEAN
);

-- Dimensão Tempo
CREATE TABLE Dim_Tempo (
    tempo_sk SERIAL PRIMARY KEY ,
    data DATE,
    ano INT,
    mes INT,
    dia INT,
    trimestre INT,
    semestre INT
);

-- Tabela de Fato de Entregas
CREATE TABLE Fato_Entregas (
    entrega_sk SERIAL PRIMARY KEY ,
    cliente_sk INT,
    centro_saida_sk INT,
    centro_destino_sk INT,
    tempo_sk_saida INT,
    tempo_sk_chegada INT,
    quantidade INT,
    quilometragem DECIMAL(10, 2),
    valor_total DECIMAL(10, 2),
    tempo_total INT,
    FOREIGN KEY (cliente_sk) REFERENCES Dim_Cliente(cliente_sk),
    FOREIGN KEY (centro_saida_sk) REFERENCES Dim_Centro(centro_sk),
    FOREIGN KEY (centro_destino_sk) REFERENCES Dim_Centro(centro_sk),
    FOREIGN KEY (tempo_sk_saida) REFERENCES Dim_Tempo(tempo_sk),
    FOREIGN KEY (tempo_sk_chegada) REFERENCES Dim_Tempo(tempo_sk)
);


INSERT INTO Dim_Cliente (cliente_id, nome, endereco, cidade, estado, data_inicio, data_fim, ativo)
VALUES 
(1, 'Cliente A', 'Rua A, 100', 'São Paulo', 'SP', '2023-01-01', '2023-06-30', FALSE),
(1, 'Cliente A', 'Rua B, 200', 'São Paulo', 'SP', '2023-07-01', NULL, TRUE),
(2, 'Cliente B', 'Av. Central, 300', 'Rio de Janeiro', 'RJ', '2023-01-01', NULL, TRUE);

-- Inserindo dados em Dim_Centro (considerando histórico)
INSERT INTO Dim_Centro (centro_id, nome, endereco, cidade, estado, data_inicio, data_fim, ativo)
VALUES 
(1, 'Centro Sul', 'Rua das Flores, 123', 'Curitiba', 'PR', '2023-01-01', '2023-08-01', FALSE),
(1, 'Centro Sul', 'Av. Brasil, 400', 'Curitiba', 'PR', '2023-08-02', NULL, TRUE),
(2, 'Centro Norte', 'Rua A, 555', 'Manaus', 'AM', '2023-01-01', NULL, TRUE);

-- Inserindo dados em Dim_Tempo
INSERT INTO Dim_Tempo (data, ano, mes, dia, trimestre, semestre)
VALUES 
('2023-05-01', 2023, 5, 1, 2, 1),
('2023-05-10', 2023, 5, 10, 2, 1),
('2023-05-20', 2023, 5, 20, 2, 1);

-- Inserindo dados na Tabela de Fato (Fato_Entregas)
INSERT INTO Fato_Entregas (cliente_sk, centro_saida_sk, centro_destino_sk, tempo_sk_saida, tempo_sk_chegada, quantidade, quilometragem, valor_total, tempo_total)
VALUES 
(1, 1, 2, 1, 2, 50, 1500.5, 750.00, 9),
(2, 2, 1, 2, 3, 75, 300.0, 500.00, 5),
(1, 1, 2, 1, 3, 30, 1200.0, 600.00, 8);

SELECT pedido_id, quantidade
FROM Pedidos
WHERE quantidade > 0;
--quantidade de produtos e tempo total
SELECT 
    SUM(quantidade) AS total_produtos_transportados,
    SUM(tempo_total) AS tempo_total_entrega
FROM 
    Fato_Entregas;
   --tempo medio
  SELECT 
    AVG(tempo_total) AS tempo_medio_entrega
FROM 
    Fato_Entregas;
--media por KM
   SELECT 
    AVG(valor_total / NULLIF(quilometragem, 0)) AS custo_medio_por_km
FROM 
    Fato_Entregas;

