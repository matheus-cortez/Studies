/* Os comandos SQL estão difundidos em dois tipos:
DDL: Data Definition Language (Create; Alter; Drop)
DML: Data Manipulation Language (Insert; Update; Delete; Select) */

/* Todo banco de dados precisa de um servidor. No nosso caso,
o servidor roda o PostgreSQL, no qual podemos ter 
múltiplos databases associados. */

/* Dentro de cada banco de dados temos as tabelas (ou entidades)
que possuem informações como linhas e colunas (e seus tipos e restrições).
Também definimos as chaves primárias (PK) e estrangeiras (FK). */

/* No Postgres, sempre trabalhamos com algum esquema. Caso não
especifiquemos, iremos por default para o Schema 'public'. 
Os schemas nos ajudam a organizar de forma lógica nossas tabelas */

-- Uma boa prática é criar um scheme mais abreviado ('acd', por exemplo, ao inves de 'academico')
CREATE SCHEMA academico;

CREATE TABLE IF NOT EXISTS academico.aluno (
    id SERIAL PRIMARY KEY,
	-- O check nos permite impedir que seja inserido uma string vazia, nesse caso
	primeiro_nome VARCHAR(255) NOT NULL CHECK (primeiro_nome <> ''),
	ultimo_nome VARCHAR(255) NOT NULL,
	-- o Default nos permite dar um valor padrão caso não seja inserido
	data_nascimento DATE NOT NULL DEFAULT NOW()::DATE
	-- CHECK, UNIQUE, DEFAULT, PK, FK são column_constraints.
	-- Podemos aplicar uma mesma constraint para mais de uma coluna:
	-- UNIQUE ( primeiro_nome, ultimo_nome)
);


CREATE TABLE academico.categoria (
    id SERIAL PRIMARY KEY,
	nome VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE academico.curso (
    id SERIAL PRIMARY KEY,
	nome VARCHAR(255) NOT NULL,
	categoria_id INTEGER NOT NULL REFERENCES academico.categoria(id)
);

CREATE TABLE academico.aluno_curso (
	aluno_id INTEGER NOT NULL REFERENCES academico.aluno(id),
	curso_id INTEGER NOT NULL REFERENCES academico.curso(id),
	
	PRIMARY KEY (aluno_id, curso_id)
);

DROP TABLE academico.aluno_curso, academico.aluno, academico.curso;

/* Na prática, um analista de requisitos vai levantar um diagrama de
entidade relacionamento e nós implementaremos com base nesse diagrama. */

/* Quando você cria um banco de dados, você consegue definir varios parâmetros
incluindo o local no disco no qual será armazenado, o encoding, etc */

CREATE TEMPORARY TABLE a (
	coluna1 VARCHAR(255) NOT NULL CHECK(coluna1 <> ''),
	coluna2 VARCHAR(255) NOT NULL,
	UNIQUE (coluna1, coluna2)
);

INSERT INTO a VALUES ('a', 'b');
INSERT INTO a VALUES ('a', 'c');

-- Comando ALTER 

ALTER TABLE a RENAME TO teste;
SELECT * FROM teste;

ALTER TABLE teste RENAME coluna1 TO primeira_coluna;
ALTER TABLE teste RENAME coluna2 TO segunda_coluna;

INSERT INTO academico.aluno (primeiro_nome, ultimo_nome, data_nascimento) VALUES (
    'Vinicius', 'Dias', '1997-10-15'
), (
    'Patrícia', 'Freitas', '1996-10-25'
), (
    'Diogo', 'Oliveira', '1994-08-27'
), (
    'Maria', 'Rosa', '1985-01-01'
);

INSERT INTO academico.categoria (nome) VALUES ('Front-End'), ('Programação'), ('Banco de dados'), ('Data Science');

INSERT INTO academico.curso (nome, categoria_id) VALUES
    ('HTML',1),
    ('CSS',1),
    ('JS',1),
    ('PHP',2),
    ('Java',2),
    ('C++',2),
    ('PostgreSQL',3),
    ('MySQL',3),
    ('Oracle',3),
    ('SQL Server',3),
    ('SQLite',3),
    ('Pandas',4),
    ('Machine Learning',4),
    ('Power BI',4);
	
INSERT INTO academico.aluno_curso VALUES (1,4), (1,11), (2,1), (2,2), (3,4), (3,3),(4,4),(4,6),(4,5);

CREATE TEMPORARY TABLE cursos_programacao (
	id_curso INTEGER PRIMARY KEY,
	nome_curso VARCHAR(255) NOT NULL

);

-- O INSERT abaixo é idêntico à INSERT INTO cursos_programacao VALUES (4, 'PHP'), (5, 'Java'), (6, 'C++');
INSERT INTO cursos_programacao
	SELECT academico.curso.id,
			academico.curso.nome
		FROM academico.curso
		JOIN academico.categoria ON academico.categoria.id = academico.curso.categoria_id
	WHERE categoria_id = 2
	
SELECT * FROM cursos_programacao;


CREATE SCHEMA teste;

CREATE TABLE teste.cursos_programacao (
	id_curso INTEGER PRIMARY KEY,
	nome_curso VARCHAR(255) NOT NULL

);

INSERT INTO teste.cursos_programacao
	SELECT academico.curso.id,
			academico.curso.nome
		FROM academico.curso
		JOIN academico.categoria ON academico.categoria.id = academico.curso.categoria_id
	WHERE categoria_id = 2
	
SELECT * FROM teste.cursos_programacao;

/* Para inserir os valores de um arquivo .csv para a tabela teste.cursos_programacao,
você pode clicar no servidor>databases>alura>schemas>teste>tables.
Clica com o botão direito em cursos_programacao e clica em Import/Export Data. */
-- Também pode usar um comando COPY mas é mais fácil pela interface do pgAdmin.
-- O comando seria COPY teste.cursos_programacao FROM 'path/to/file.csv'

INSERT INTO teste.cursos_programacao (id_curso,nome_curso) VALUES
	(10, 'PHP Avançado'),
	(20, 'Java Avançado'),
	(30, 'C++ Avançado'),
	(40, 'C# Avançado');
	
SELECT * FROM academico.curso ORDER BY 1;

UPDATE academico.curso SET nome = 'PHP Básico' WHERE id = 4;
UPDATE academico.curso SET nome = 'Java Básico' WHERE id = 5;
UPDATE academico.curso SET nome = 'C++ Básico' WHERE id = 6;

-- Com essas atualizações, a tabela teste.cursos_programacao está desatualizada
-- em relação a academico.curso.

SELECT * FROM teste.cursos_programacao;


-- Com esse update, conseguimos atualizar a tablea teste.cursos_programacao com base na tabela academico.curso
UPDATE teste.cursos_programacao SET nome_curso = nome -- UPDATE TABELA 1 SET COLUNA_TABELA1 = COLUNA_TABELA2 ...
	FROM academico.curso WHERE teste.cursos_programacao.id_curso = academico.curso.id;
	

-- Podemos fazer "checkpoints" utilizando START TRANSACTION (ou BEGIN)
BEGIN;
DELETE FROM teste.cursos_programacao; -- delete todas as observações da tabela
SELECT * FROM teste.cursos_programacao;

-- caso tenhamos feito algum erro, podemos voltar atrás com o ROLLBACK
ROLLBACK;

BEGIN;
DELETE FROM teste.cursos_programacao WHERE id_curso = 60;

-- caso queiramos confirmar as alterações de uma transação (BEGIN)
COMMIT;

SELECT * FROM teste.cursos_programacao;

-- caso você tenha aberto uma transação e se desconecte do database, ele vai fazer um rollback automático

-- Também podemos usar savepoints após aberta uma transação
BEGIN;
SAVEPOINT meu_savepoint1;
SAVEPOINT meu_savepoint2;
-- podemos voltar para um savepoint quantas vezes quisermos
ROLLBACK TO meu_savepoint1;
COMMIT;



CREATE SEQUENCE eu_criei;

CREATE TEMPORARY TABLE auto (
	id SERIAL PRIMARY KEY,
	nome VARCHAR(30) NOT NULL
);

INSERT INTO auto (nome) VALUES ('Vinicius Dias');
INSERT INTO auto (id, nome) VALUES (2, 'Vinicius Dias');
-- retorna erro na primeira tentativa pois o SERIAL vai para 2, mas já tem um valor 2
INSERT INTO auto (nome) VALUES ('Outro nome'); 




DROP TABLE auto;

-- o SERIAL nada mais é do que uma SEQUENCE
CREATE SEQUENCE eu_criei;

-- retorna o valor atual da sequencia
-- esse tipo de função recebe o nome da sequencia como string
SELECT CURRVAL('eu_criei');

-- retorna o valor seguinte da sequencia E avança a sequencia
--SELECT NEXTVAL('eu_criei');

CREATE TEMPORARY TABLE auto (
	-- utilizando uma SEQUENCE ao invés do SERIAL
	id INTEGER PRIMARY KEY DEFAULT NEXTVAL('eu_criei'),
	nome VARCHAR(30) NOT NULL
);


INSERT INTO auto (nome) VALUES ('Vinicius Dias');
INSERT INTO auto (id, nome) VALUES (2, 'Vinicius Dias');
INSERT INTO auto (nome) VALUES ('Outro nome'); 


-- podemos criar um tipo customizado, dos mais variados tipos
CREATE TYPE CLASSIFICACAO AS ENUM ('LIVRE', '12_ANOS','14_ANOS','16_ANOS','18_ANOS');

CREATE TEMPORARY TABLE filme (
	id SERIAL PRIMARY KEY,
	nome VARCHAR(255) NOT NULL,
	--classificacao VARCHAR(255) CHECK(classificacao IN ('LIVRE', '12_ANOS','14_ANOS','16_ANOS','18_ANOS'))
	-- o comando acima é equivalente ao comando abaixo
	classificacao CLASSIFICACAO
);

INSERT INTO filme (nome, classificacao) VALUES ('Um filme qualquer', '18_ANOS');

SELECT * FROM filme;