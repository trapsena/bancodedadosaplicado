create database DW;
drop table Dim_Tempo cascade;
drop table dim_quarto  cascade;
drop table dim_centro cascade;
drop table Fato_Reserva cascade;


   CREATE TABLE Dim_Cliente (
    cliente_sk SERIAL PRIMARY KEY,
    cliente_id INT,
    nome VARCHAR(100),
    endereco VARCHAR(200),
    categoria_fidelidade VARCHAR(50),
    data_inicio DATE,
    data_fim DATE,
    ativo BOOLEAN
);

   -- Criação da tabela Dim_Quarto
CREATE TABLE Dim_Quarto (
    quarto_sk SERIAL PRIMARY KEY,  -- Chave surrogate
    quarto_id INT NOT NULL,        -- Chave natural
    hotel_sk INT NOT NULL,         -- Chave estrangeira para Dim_Hotel
    tipo_quarto VARCHAR(255),
    status_manutencao VARCHAR(255),
    data_ultima_reforma DATE,
    FOREIGN KEY (hotel_sk) REFERENCES Dim_Hotel(hotel_sk)
);


-- Criação da tabela Dim_Hotel
CREATE TABLE Dim_Hotel (
    hotel_sk SERIAL PRIMARY KEY,  -- Chave surrogate
    hotel_id INT NOT NULL,        -- Chave natural
    nome_hotel VARCHAR(255),
    cidade VARCHAR(255),
    pais VARCHAR(255),
    data_inauguracao DATE
);

CREATE TABLE Dim_Tempo (
    tempo_sk SERIAL PRIMARY KEY,  -- Chave surrogate
    data DATE NOT NULL,           -- Chave natural
    dia INT,
    mes INT,
    ano INT,
    trimestre INT
);



   -- Tabela Fato_Reserva
CREATE TABLE Fato_Reserva (
    reserva_sk SERIAL PRIMARY KEY,  -- Chave surrogate para o fato
    cliente_sk INT NOT NULL,        -- Chave estrangeira para Dim_Cliente
    hotel_sk INT NOT NULL,          -- Chave estrangeira para Dim_Hotel
    quarto_sk INT NOT NULL,         -- Chave estrangeira para Dim_Quarto
    tempo_sk INT NOT NULL,          -- Chave estrangeira para Dim_Tempo
    valor_total DECIMAL(10, 2),
    FOREIGN KEY (cliente_sk) REFERENCES Dim_Cliente(cliente_sk),
    FOREIGN KEY (hotel_sk) REFERENCES Dim_Hotel(hotel_sk),
    FOREIGN KEY (quarto_sk) REFERENCES Dim_Quarto(quarto_sk),
    FOREIGN KEY (tempo_sk) REFERENCES Dim_Tempo(tempo_sk)
);

   -- Inserindo dados na tabela Dim_Cliente (SCD Tipo 2)
-- Cliente 1 (início de fidelidade 'Bronze')
INSERT INTO Dim_Cliente (cliente_id, nome, endereco, categoria_fidelidade, data_inicio, data_fim, ativo)
VALUES
(1, 'João Silva', 'Rua A, 100', 'Bronze', '2023-01-01', NULL, TRUE);

-- Cliente 1 (mudança para 'Prata')
INSERT INTO Dim_Cliente (cliente_id, nome, endereco, categoria_fidelidade, data_inicio, data_fim, ativo)
VALUES
(1, 'João Silva', 'Rua A, 100', 'Prata', '2024-06-01', NULL, TRUE);

-- Cliente 2
INSERT INTO Dim_Cliente (cliente_id, nome, endereco, categoria_fidelidade, data_inicio, data_fim, ativo)
VALUES
(2, 'Maria Oliveira', 'Rua B, 200', 'Ouro', '2023-01-01', NULL, TRUE);

-- Inserção de dados na tabela Dim_Quarto
INSERT INTO Dim_Quarto (quarto_id, hotel_sk, tipo_quarto, status_manutencao, data_ultima_reforma)
VALUES
(1, 1, 'Standard', 'Disponível', '2022-08-10'),
(2, 2, 'Luxo', 'Em manutenção', '2023-01-15'),
(3, 3, 'Suíte', 'Disponível', '2021-05-20');

-- Inserindo dados na tabela Dim_Hotel
INSERT INTO Dim_Hotel (hotel_id, nome_hotel, cidade, pais, data_inauguracao)
VALUES
(1, 'Hotel Central', 'São Paulo', 'Brasil', '2000-05-15'),
(2, 'Hotel Riviera', 'Rio de Janeiro', 'Brasil', '2005-10-10');

-- Inserindo dados na tabela Dim_Tempo
INSERT INTO Dim_Tempo (data, dia, mes, ano, trimestre)
VALUES
('2023-01-01', 1, 1, 2023, 1),
('2023-06-01', 1, 6, 2023, 2),
('2024-01-01', 1, 1, 2024, 1),
('2024-06-01', 1, 6, 2024, 2);

INSERT INTO Dim_Hotel (hotel_id, nome_hotel, cidade, pais, data_inauguracao)
VALUES
(1, 'Hotel Central', 'São Paulo', 'Brasil', '2000-05-15'),
(2, 'Hotel Riviera', 'Rio de Janeiro', 'Brasil', '2005-10-10'),
(3, 'Hotel Plaza', 'Buenos Aires', 'Argentina', '2010-03-20');

INSERT INTO Dim_Tempo (data, dia, mes, ano, trimestre)
VALUES
('2023-01-01', 1, 1, 2023, 1),
('2023-06-01', 1, 6, 2023, 2),
('2023-12-01', 1, 12, 2023, 4),
('2024-01-01', 1, 1, 2024, 1),
('2024-06-01', 1, 6, 2024, 2),
('2024-12-01', 1, 12, 2024, 4);

-- Inserção de dados na tabela Fato_Reserva
INSERT INTO Fato_Reserva (cliente_sk, hotel_sk, quarto_sk, tempo_sk, valor_total)
VALUES
(1, 1, 1, 1, 500.00),
(2, 2, 2, 2, 350.00),
(3, 3, 3, 3, 800.00),
(1, 2, 2, 3, 450.00),
(2, 1, 1, 2, 600.00);

--Receita Média por Cliente e Categoria de Fidelidade
SELECT c.categoria_fidelidade, AVG(fr.valor_total) AS receita_media
FROM Fato_Reserva fr
JOIN Dim_Cliente c ON fr.cliente_sk = c.cliente_sk
GROUP BY c.categoria_fidelidade;

--Taxa de Ocupação por Hotel e Período
SELECT h.nome_hotel, t.ano, t.mes, 
    COUNT(fr.reserva_sk) / COUNT(q.quarto_sk) AS taxa_ocupacao
FROM Fato_Reserva fr
JOIN Dim_Hotel h ON fr.hotel_sk = h.hotel_sk
JOIN Dim_Quarto q ON fr.quarto_sk = q.quarto_sk
JOIN Dim_Tempo t ON fr.tempo_sk = t.tempo_sk
GROUP BY h.nome_hotel, t.ano, t.mes;

--Perfil de Clientes com Maior Gasto em Reservas
SELECT c.nome, SUM(fr.valor_total) AS total_gasto
FROM Fato_Reserva fr
JOIN Dim_Cliente c ON fr.cliente_sk = c.cliente_sk
GROUP BY c.nome
ORDER BY total_gasto DESC
LIMIT 10;


