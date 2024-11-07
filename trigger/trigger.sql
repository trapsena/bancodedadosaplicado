create database trabalho;

CREATE TABLE Produtos (
    cod_prod SERIAL PRIMARY KEY,
    descricao VARCHAR(255),
    qtd_disponivel INTEGER
);

CREATE TABLE ItensVenda (
    cod_venda SERIAL PRIMARY KEY,
    id_produto INTEGER REFERENCES Produtos(cod_prod),
    qtd_vendida INTEGER
);

CREATE OR REPLACE FUNCTION atualiza_estoque()
RETURNS trigger
AS $$
BEGIN
    -- Atualiza a quantidade disponível do produto subtraindo a quantidade vendida
    UPDATE Produtos
    SET qtd_disponivel = qtd_disponivel - NEW.qtd_vendida
    WHERE cod_prod = NEW.id_produto;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para atualizar o estoque após uma inserção em ItensVenda
CREATE TRIGGER trigger_atualiza_estoque
AFTER INSERT ON ItensVenda
FOR EACH ROW
EXECUTE FUNCTION atualiza_estoque();

CREATE TABLE tb_usuarios (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100),
    senha VARCHAR(100)
);

CREATE TABLE tb_bkp_usuarios (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100),
    senha VARCHAR(100)
);

CREATE OR REPLACE FUNCTION backup_usuario_excluido()
RETURNS trigger
AS $$
BEGIN
    -- Insere o usuário excluído na tabela de backup
    INSERT INTO tb_bkp_usuarios (id, nome, senha)
    VALUES (OLD.id, OLD.nome, OLD.senha);
    
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- Trigger para armazenar o usuário excluído na tabela de backup
CREATE TRIGGER trigger_backup_usuario
AFTER DELETE ON tb_usuarios
FOR EACH ROW
EXECUTE FUNCTION backup_usuario_excluido();

INSERT INTO Produtos (descricao, qtd_disponivel)
VALUES ('Produto A', 100);

INSERT INTO ItensVenda (id_produto, qtd_vendida)
VALUES (1, 5);  -- Exemplo: vendendo 5 unidades do Produto A

SELECT * FROM Produtos WHERE cod_prod = 1;

INSERT INTO tb_usuarios (nome, senha)
VALUES ('Usuario1', 'senha123');

DELETE FROM tb_usuarios WHERE id = 1;

SELECT * FROM tb_bkp_usuarios;
