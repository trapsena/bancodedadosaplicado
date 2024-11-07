create database views

-- Tabela de alunos
CREATE TABLE ALUNO (
    matricula INT PRIMARY KEY,
    nome VARCHAR(100),
    sexo VARCHAR(10)
);

-- Tabela de disciplinas
CREATE TABLE DISCIPLINA (
    codigo INT PRIMARY KEY,
    nome VARCHAR(100),
    creditos INT
);

-- Tabela de cursos (relacionamento entre aluno e disciplina)
CREATE TABLE CURSA (
    matricula INT,
    codigo INT,
    semestreAno VARCHAR(10),
    nota DECIMAL(3, 1),
    falta INT,
    PRIMARY KEY (matricula, codigo, semestreAno),
    FOREIGN KEY (matricula) REFERENCES ALUNO(matricula),
    FOREIGN KEY (codigo) REFERENCES DISCIPLINA(codigo)
);

INSERT INTO ALUNO (matricula, nome, sexo) VALUES
(1, 'João Silva', 'Masculino'),
(2, 'Maria Santos', 'Feminino'),
(3, 'Carlos Lima', 'Masculino'),
(4, 'Ana Oliveira', 'Feminino'),
(5, 'Pedro Souza', 'Masculino'),
(6, 'Sofia Alves', 'Feminino'),
(7, 'Rafael Pereira', 'Masculino'),
(8, 'Luana Fernandes', 'Feminino'),
(9, 'Lucas Rodrigues', 'Masculino'),
(10, 'Beatriz Costa', 'Feminino');

INSERT INTO DISCIPLINA (codigo, nome, creditos) VALUES
(1, 'Estrutura de Dados', 4),
(2, 'Projeto Integrador', 6),
(3, 'Orientação a Objetos', 4),
(4, 'Requisitos de Software', 4),
(5, 'Sistema de Banco de Dados', 4);

INSERT INTO CURSA (matricula, codigo, semestreAno, nota, falta) VALUES
(1, 1, '1/2021', 8.5, 0),
(2, 1, '1/2021', 4.0, 3),
(3, 2, '1/2021', 9.0, 1),
(4, 3, '1/2021', 7.8, 2),
(5, 4, '2/2021', 6.5, 5),
(6, 4, '2/2021', 8.3, 4),
(7, 5, '1/2022', 7.0, 1),
(8, 5, '1/2022', 9.1, 0),
(9, 3, '2/2022', 8.0, 2),
(10, 2, '2/2022', 6.7, 3);

--Quantidade de alunos
SELECT d.codigo, d.nome, COUNT(c.matricula) AS num_alunos
FROM DISCIPLINA d
JOIN CURSA c ON d.codigo = c.codigo
GROUP BY d.codigo, d.nome;
-- Media das notas
SELECT d.codigo, d.nome, AVG(c.nota) AS media_notas
FROM DISCIPLINA d
JOIN CURSA c ON d.codigo = c.codigo
GROUP BY d.codigo, d.nome;
--Media das faltas
SELECT d.codigo, d.nome, AVG(c.falta) AS media_faltas
FROM DISCIPLINA d
JOIN CURSA c ON d.codigo = c.codigo
GROUP BY d.codigo, d.nome;
