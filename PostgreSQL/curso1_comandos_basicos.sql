/* 
No bash: 
sudo -u postgres psql postgres # inicializa o postgresql
sudo service postgresql start # (ou restart) para inicializar o postgres e assim poder interagir no pgadmin.
\l # Lista os databases existentes
\c database_name # Se conecta a um determinado database
\dt # Lista as tabelas existentes em um determinado database

Tipos de coluna:
integer, real, serial, numeric

varchar, char, text

boolean

date, time, timestamp
*/


/* Cria uma tabela definindo suas colunas e o tipo relativo a cada coluna */
CREATE TABLE aluno(
	id SERIAL,
	nome VARCHAR(255),
	cpf CHAR(11),
	observacao TEXT,
	idade INTEGER,
	dinheiro NUMERIC(10,2),
	altura real,
	ativo BOOLEAN,
	data_nascimento DATE,
	hora_aula TIME,
	matriculado_em timestamp

);

/* Mostrando todas as colunas da tabela aluno */
SELECT * FROM aluno;

/* Inserindo uma linha na tabela aluno para as colunas especificadas. 
Se uma coluna não for especificada, o valor correspondente fica NULL */
INSERT INTO aluno(
	nome,
	cpf,
	observacao,
	idade,
	dinheiro,
	altura,
	ativo,
	data_nascimento,
	hora_aula,
	matriculado_em
) 
VALUES (
	'Diogo',
	'12345678901',
	'um texto aleatório e de tamanho indeterminado',
	35,
	100.50,
	1.81,
	TRUE,
	'1984-08-27',
	'17:30:00',
	'2020-02-08 12:32:33'
);

SELECT * 
	FROM aluno
	WHERE id = 1;

/* 'Seta' em todas as linhas da tabela aluno que possuem o id = 1 os valores especificados abaixo */
UPDATE aluno
	SET nome = 'Nico',
	cpf = '10987654321',
	observacao = 'Teste',
	idade = 38,
	dinheiro = 15.83,
	altura = 1.90,
	ativo = FALSE,
	data_nascimento = '1980-01-15',
	hora_aula = '13:00:00',
	matriculado_em = '2020-01-15 15:00:00'
WHERE id = 1;

SELECT * 
	FROM aluno
	WHERE nome = 'Nico';

/* Deleta todas as linhas da tabela aluno em que a coluna nome = 'Nico' */
DELETE
	FROM aluno
	WHERE nome = 'Nico';
	
SELECT * FROM aluno;

/* Mostra as colunas nome, idade e matriculado_em da tabela aluno
além disso, altera os nomes das colunas "nome" e "matriculado_em" para os nomes especificados. */
SELECT nome AS "Nome do aluno",
	idade,
	matriculado_em AS quando_se_matriculou
	FROM aluno;

/* Insere na tabela aluno os nomes especificados abaixo. */
INSERT INTO aluno (nome) VALUES ('Vinicius Dias');
INSERT INTO aluno (nome) VALUES ('Nico Steppat');
INSERT INTO aluno (nome) VALUES ('João Roberto');
INSERT INTO aluno (nome) VALUES ('Diego');


SELECT * 
	FROM aluno
	WHERE nome = 'Diego';

/* Diferente de (também pode ser usado '!=' ) */
SELECT * 
	FROM aluno
	WHERE nome <> 'Diego';

/* O underline significa "qualquer caractere pode substituir" */
SELECT * 
	FROM aluno
	WHERE nome LIKE 'Di_go';

/* Qualquer coisa antes de 'i', qualquer coisa entre 'i' e 'g', e qualquer coisa depois de 'g'. */
SELECT * 
	FROM aluno
	WHERE nome LIKE '%i%g%';
	
SELECT *
	FROM aluno
	WHERE idade <> 36;

/* Inclusivo para 10 e 40 */
SELECT * FROM aluno WHERE idade BETWEEN 10 AND 40;

/* Para se referir a NULL, usar IS ou IS NOT */
SELECT * 
	FROM aluno 
	WHERE nome LIKE 'D%' 
	AND cpf IS NOT NULL;

/* Também podemos utilizar AND e OR */
SELECT * 
	FROM aluno 
	WHERE nome LIKE 'Diogo' 
	OR nome LIKE 'Rodrigo'
	OR nome LIKE 'Nico%';
	

/* Cria a tabela 'curso', em que o id não pode ser nulo e é Primary Key
PRIMARY KEY: todos os valores nessa coluna devem ser UNIQUE e NOT NULL. 
FOREIGN KEY: é utilizado para evitar inconsistências no código. A tabela com uma foreign key é a filha, e a com a primary key é a parent. 
Só se pode inserir uma observação em uma tabela filha se o valor na coluna foreign key existir na tabela parent. */
CREATE TABLE curso (
	id INTEGER NOT NULL PRIMARY KEY,
	nome VARCHAR(255) NOT NULL
);

/* Exemplos de tentativas de insersão na tabela curso */
/* INSERT INTO curso (id, nome) VALUES (NULL, NULL); # Retorna erro porque nem id nem nome podem ser nulos */
INSERT INTO curso (id, nome) VALUES (1, 'HTML');
/* INSERT INTO curso (id, nome) VALUES (1, 'Javascript'); # Retorna erro porque já existe um id 1 na tabela curso */
INSERT INTO curso (id, nome) VALUES (2, 'Javascript');

SELECT * FROM curso;
SELECT * FROM aluno;

/* Deleta a tabela 'aluno' */
DROP TABLE aluno;

CREATE TABLE aluno (
	id SERIAL PRIMARY KEY,
	nome VARCHAR(255) NOT NULL
);

INSERT INTO aluno (nome) VALUES ('Diogo');
INSERT INTO aluno (nome) VALUES ('Vinícius');

SELECT * FROM aluno;

SELECT * FROM curso;

CREATE TABLE aluno_curso (
	aluno_id INTEGER,
	curso_id INTEGER,
	/* Aqui, não pode haver dois registros na tabela de um mesmo aluno fazendo um mesmo curso */
	PRIMARY KEY (aluno_id, curso_id),
	
	/* Só se pode inserir uma linha nessa tabela caso os valores 
	de aluno_id e curso_id existam em aluno.id e curso.id respectivamente
	Observação: aluno.id significa "tabela aluno, coluna id". */
	FOREIGN KEY (aluno_id)
	REFERENCES aluno (id),
	
	FOREIGN KEY (curso_id)
	REFERENCES curso (id)
);

/* Exemplos de tentativas de insersão na tabela aluno_curso */
INSERT INTO aluno_curso (aluno_id, curso_id) VALUES (1,1);
INSERT INTO aluno_curso (aluno_id, curso_id) VALUES (2,1);
INSERT INTO aluno_curso (aluno_id, curso_id) VALUES (2,2);
/* INSERT INTO aluno_curso (aluno_id, curso_id) VALUES (3,1); # Retorna erro porque o aluno_id = 3 não existe na tabela aluno */

SELECT * FROM aluno WHERE id = 1;
SELECT * FROM curso WHERE id = 1;

SELECT * FROM aluno WHERE id = 2;
SELECT * FROM curso WHERE id = 1;

SELECT * FROM aluno;
SELECT * FROM curso;
SELECT * FROM aluno_curso;

/* Juntando as tabelas aluno e curso */
SELECT *
	/* iniciando com os valores da tabela aluno */
	FROM aluno
	/* junte a tabela aluno_curso nas linhas em que aluno_curso.aluno_id é igual a aluno.id */
	JOIN aluno_curso ON aluno_curso.aluno_id = aluno.id
	/* também junte a tabela curso nas linhas em que curso.id é igual a aluno_curso.curso_id */
	JOIN curso ON curso.id = aluno_curso.curso_id;

/* Visualizando apenas duas colunas do join acima */
SELECT aluno.nome as aluno_nome, 
	   curso.nome as curso
	FROM aluno
	JOIN aluno_curso ON aluno_curso.aluno_id = aluno.id
	JOIN curso ON curso.id = aluno_curso.curso_id;

INSERT INTO aluno (nome) VALUES ('Nico'); /* Esse aluno não está matriculado em nenhum curso */

INSERT INTO curso (id, nome) VALUES (3, 'CSS'); /* Não existe nenhum aluno matriculado em CSS */

/* Como incluir um aluno que não está matriculado em nenhum curso (Nico) 
Tipos de join: INNER JOIN (o mesmo que o JOIN padrão), LEFT JOIN; RIGHT JOIN; FULL JOIN (a junção de LEFT e RIGHT em um só comando). */
SELECT aluno.nome as aluno_nome, 
	   curso.nome as curso
	FROM aluno
	/* Aqui, com o left join toda a tabela aluno aparece na tabela final */
	LEFT JOIN aluno_curso ON aluno_curso.aluno_id = aluno.id
	/* Aqui, toda a tabela acima aparece na tabela final */
	LEFT JOIN curso ON curso.id = aluno_curso.curso_id;
	
/* Como incluir um curso que ninguém está matriculado (CSS) */
SELECT aluno.nome as aluno_nome, 
	   curso.nome as curso
	FROM aluno
	/* Aqui, tanto faz o tipo de join */
	JOIN aluno_curso ON aluno_curso.aluno_id = aluno.id
	/* Usamos o right join para que todos os cursos apareçam na tabela final */
	RIGHT JOIN curso ON curso.id = aluno_curso.curso_id;
	
/* Como incluir todos os alunos e cursos */
SELECT aluno.nome as aluno_nome, 
	   curso.nome as curso
	FROM aluno
	FULL JOIN aluno_curso ON aluno_curso.aluno_id = aluno.id
	FULL JOIN curso ON curso.id = aluno_curso.curso_id;
	

/* O CROSS JOIN multiplica a quantidade de dados da tabela aluno pela quantidade de dados da tabela curso
mostrando assim todas as combinações possíveis */
SELECT aluno.nome as aluno_nome, 
	   curso.nome as curso
	   FROM aluno
CROSS JOIN curso;

INSERT INTO aluno (nome) VALUES ('João');


/* DELETE FROM aluno WHERE id = 1 # Retorna um erro devido a um foreign key constraint
Para contornar isso, podemos usar um cascade durante a criação da tabela com foreign key.
se o CASCADE não for especificado, o default é ON DELETE RESTRICT*/
DROP TABLE aluno_curso;
CREATE TABLE aluno_curso (
	aluno_id INTEGER,
	curso_id INTEGER,
	PRIMARY KEY (aluno_id, curso_id),

	FOREIGN KEY (aluno_id)
	REFERENCES aluno (id)
	ON DELETE CASCADE,
	
	FOREIGN KEY (curso_id)
	REFERENCES curso (id)
);

INSERT INTO aluno_curso (aluno_id, curso_id) VALUES (1,1);
INSERT INTO aluno_curso (aluno_id, curso_id) VALUES (2,1);
INSERT INTO aluno_curso (aluno_id, curso_id) VALUES (3,1);
INSERT INTO aluno_curso (aluno_id, curso_id) VALUES (1,3);

SELECT * FROM aluno_curso;

SELECT aluno.nome as aluno_nome, 
	   curso.nome as curso
	FROM aluno
	JOIN aluno_curso ON aluno_curso.aluno_id = aluno.id
	JOIN curso ON curso.id = aluno_curso.curso_id;
	
DELETE FROM aluno WHERE id=1; /* Agora não retorna erro pois utilizamos o cascade */

/* UPDATE aluno 
	SET id = 10
	WHERE id = 2; # Nos retorna erro porque o aluno de id = 2 está relacionado com uma parent */

UPDATE aluno 
	SET id = 20
	WHERE id = 4; /* Não retorna erro pois o id=4 não está relacionado com uma parent */

/* Para contornar esse problema: */
DROP TABLE aluno_curso;
CREATE TABLE aluno_curso (
	aluno_id INTEGER,
	curso_id INTEGER,
	PRIMARY KEY (aluno_id, curso_id),

	FOREIGN KEY (aluno_id)
	REFERENCES aluno (id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	
	FOREIGN KEY (curso_id)
	REFERENCES curso (id)
);

INSERT INTO aluno_curso (aluno_id, curso_id) VALUES (2,1);
INSERT INTO aluno_curso (aluno_id, curso_id) VALUES (3,1);

SELECT 
		aluno.id AS aluno_id,
		aluno.nome AS "Nome do Aluno",
		curso.id AS curso_id,
		curso.nome AS "Nome do Curso"
	FROM aluno
	JOIN aluno_curso ON aluno_curso.aluno_id = aluno.id
	JOIN curso ON curso.id = aluno_curso.curso_id;
	
UPDATE aluno /* Não nos retorna mais erro devido ao ON UPDATE CASCADE */
	SET id = 10
	WHERE id = 2;
	
SELECT * FROM aluno_curso;




CREATE TABLE funcionarios (
	id SERIAL PRIMARY KEY,
	matricula VARCHAR(10),
	nome VARCHAR(255),
	sobrenome VARCHAR(255)
);

INSERT INTO funcionarios (matricula, nome, sobrenome) VALUES ('M001', 'Diogo', 'Mascarenhas');
INSERT INTO funcionarios (matricula, nome, sobrenome) VALUES ('M002', 'Vinícius', 'Dias');
INSERT INTO funcionarios (matricula, nome, sobrenome) VALUES ('M003', 'Nico', 'Steppat');
INSERT INTO funcionarios (matricula, nome, sobrenome) VALUES ('M004', 'João', 'Roberto');
INSERT INTO funcionarios (matricula, nome, sobrenome) VALUES ('M005', 'Diogo', 'Mascarenhas');
INSERT INTO funcionarios (matricula, nome, sobrenome) VALUES ('M006', 'Alberto', 'Martins');

/* Ordena com prioridade em nome, e depois pela matrícula */
SELECT * 
	FROM funcionarios
	ORDER BY nome, matricula
	
SELECT * 
	FROM funcionarios
	ORDER BY 3, 4 /* os numeros representam as colunas. igual à consulta acima */
	

SELECT *
	FROM funcionarios
	ORDER BY 4 DESC, nome DESC, 2 ASC
	
-- INSERT INTO aluno_curso (aluno_id, curso_id) VALUES (20, 3);


SELECT * 
	FROM funcionarios
	ORDER BY id
	LIMIT 5 /* nos mostra apenas 5 amostras */
	OFFSET 1 /* desconsidera a primeira linha */
;

-- COUNT - Retorna a quantidade de registros
-- SUM -   Retorna a soma dos registros
-- MAX -   Retorna o maior valor dos registros
-- MIN -   Retorna o menor valor dos registros
-- AVG -   Retorna a média dos registros

SELECT COUNT(*)
  FROM funcionarios;
  
  
SELECT COUNT(id),
	SUM(id),
	MAX(id),
	MIN(id),
	ROUND(AVG(id),2)
  FROM funcionarios;
  
  
SELECT nome, sobrenome
	FROM funcionarios
	ORDER BY nome;
  
-- Mostrando os nomes+sobrenomes distintos
SELECT DISTINCT nome, sobrenome
	FROM funcionarios
	ORDER BY nome;
	
-- Contando o número de ocorrencias de cada nome
SELECT 
	nome, 
	sobrenome, 
	COUNT(id)
FROM funcionarios
GROUP BY nome, sobrenome
ORDER BY nome;


SELECT curso.nome,
		COUNT(aluno.id)
	FROM aluno
	JOIN aluno_curso ON aluno.id = aluno_curso.aluno_id
	JOIN curso ON curso.id = aluno_curso.curso_id
GROUP BY 1
ORDER BY 1;


SELECT * FROM aluno;
SELECT * FROM aluno_curso;
SELECT * FROM curso;


SELECT curso.nome,
		COUNT(aluno.id)
	FROM curso
	LEFT JOIN aluno_curso ON aluno_curso.curso_id = curso.id
	LEFT JOIN aluno ON aluno.id = aluno_curso.aluno_id
	-- WHERE COUNT(aluno.id) = 0 # Errado!
GROUP BY 1
	HAVING COUNT(aluno.id) > 0 -- Se usa HAVING COUNT quando se utiliza um GROUP BY

SELECT nome,
		COUNT(id)
	FROM funcionarios
	GROUP BY nome
	HAVING COUNT(id) > 1;