create database prova; 

create or replace procedure faz_algo(x integer,out y real)
as $$
declare
	subtotal alias for $1;
begin
	y:= subtotal + subtotal*0.05;
end;
$$ language plpgsql;

call faz_algo(5,2)

CREATE TABLE Empregado (
    id SERIAL PRIMARY KEY,     -- Identificador único para cada empregado
    nome VARCHAR(50),          -- Nome do empregado
    cargo VARCHAR(50),         -- Cargo do empregado
    salario NUMERIC(10, 2)     -- Salário do empregado (com 2 casas decimais)
);

INSERT INTO Empregado (nome, cargo, salario)
VALUES
    ('João Silva', 'Analista', 3000.00),
    ('Maria Souza', 'Gerente', 6000.00),
    ('Carlos Pereira', 'Desenvolvedor', 4500.00),
    ('Ana Costa', 'Designer', 3200.00),
    ('Fernanda Oliveira', 'Gerente de Projetos', 7500.00),
    ('Pedro Gomes', 'Estagiário', 1500.00);
    
CREATE OR REPLACE FUNCTION nome_funcao(x numeric) 
RETURNS SETOF varchar(20) AS $$
DECLARE
    registro record;  -- Variável para armazenar os registros da tabela
BEGIN
    FOR registro IN 
        SELECT nome FROM Empregado WHERE salario >= x  -- Seleciona o nome com base no salário
    LOOP
        RETURN NEXT registro.nome;  -- Retorna o nome de cada registro que satisfaz a condição
    END LOOP;
    RETURN;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM nome_funcao(4000);