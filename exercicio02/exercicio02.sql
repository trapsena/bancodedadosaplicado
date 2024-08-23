create database barbeiro

create table usuario (
    numero int primary key,
    nome varchar(255)
);

create table barbeador (
    numero int primary key,
    nome varchar(255),
    especialidade varchar(255)
);

create table agenda (
    usuario_numero int,
    barbeador_numero int,
    dia date unique not null,
    primary key (usuario_numero, barbeador_numero),
    foreign key (usuario_numero) references usuario(numero),
    foreign key (barbeador_numero) references barbeador(numero)
);

insert into usuario (numero, nome) values (1, 'João Silva');
insert into usuario (numero, nome) values (2, 'Maria Oliveira');
insert into usuario (numero, nome) values (3, 'Pedro Souza');
insert into usuario (numero, nome) values (4, 'Ana Costa');
insert into usuario (numero, nome) values (5, 'Carlos Lima');

insert into barbeador (numero, nome, especialidade) values (1, 'Barbeador A', 'Corte de cabelo');
insert into barbeador (numero, nome, especialidade) values (2, 'Barbeador B', 'Barba');
insert into barbeador (numero, nome, especialidade) values (3, 'Barbeador C', 'Corte e barba');
insert into barbeador (numero, nome, especialidade) values (4, 'Barbeador D', 'Corte de cabelo');
insert into barbeador (numero, nome, especialidade) values (5, 'Barbeador E', 'Barba e bigode');

insert into agenda (usuario_numero, barbeador_numero, dia) values (1, 2, '2024-08-01');
insert into agenda (usuario_numero, barbeador_numero, dia) values (2, 3, '2024-08-02');
insert into agenda (usuario_numero, barbeador_numero, dia) values (3, 1, '2024-08-03');
insert into agenda (usuario_numero, barbeador_numero, dia) values (4, 5, '2024-08-04');
insert into agenda (usuario_numero, barbeador_numero, dia) values (5, 4, '2024-08-05');

--6.1
select * from usuario 

select * from barbeador 

select * from agenda

--6.2
select
    u.numero as usuario_numero,
    u.nome as usuario_nome,
    b.numero as barbeador_numero,
    b.nome as barbeador_nome,
    b.especialidade as barbeador_especialidade,
    a.dia as data_agenda
from
    agenda a
inner join
    usuario u on a.usuario_numero = u.numero
inner join
    barbeador b on a.barbeador_numero = b.numero;

--6.3
select a.dia, u.nome as nome_usuario, b.nome as nome_barbeador, b.especialidade 
from agenda a 
left join usuario u on a.usuario_numero = u.numero 
left join barbeador b on a.barbeador_numero = b.numero;

--6.4
select b.nome as nome_barbeador, b.especialidade, a.dia 
from agenda a 
right join barbeador b on a.barbeador_numero = b.numero;

--6.5
select u.numero as usuario_numero, u.nome as usuario_nome, a.barbeador_numero, a.dia as data_agenda
from usuario u
right join agenda a on u.numero = a.usuario_numero;

--6.6
select u.numero as usuario_numero, u.nome as usuario_nome, b.numero as barbeador_numero, b.nome as barbeador_nome, b.especialidade as barbeador_especialidade, a.dia as data_agenda
from usuario u
full outer join agenda a on u.numero = a.usuario_numero
full outer join barbeador b on a.barbeador_numero = b.numero;

--7.1
select u.numero as usuario_numero, u.nome as usuario_nome, b.numero as barbeador_numero, b.nome as barbeador_nome, b.especialidade as barbeador_especialidade, a.dia as data_agenda
from agenda a
inner join usuario u on a.usuario_numero = u.numero
inner join barbeador b on a.barbeador_numero = b.numero
where a.dia between '2024-08-01' and '2024-08-05';

--8.1
select max(numero) AS numero 
from usuario u;
--8.2
select min(numero) AS numero 
from usuario u;
--8.3
select avg(numero) AS numero 
from usuario u;
--8.4
select sum(numero) AS numero 
from usuario u;
--8.5
select count(numero) AS numero 
from usuario u;

--9
select b.nome AS barbeador, count(a.usuario_numero) AS total_agendamentos
from barbeador b
left join agenda a ON b.numero = a.barbeador_numero
group by b.nome;





