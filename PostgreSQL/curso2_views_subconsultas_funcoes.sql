
-- PostgreSQL: Views, Sub-Consultas e Funções

--CREATE DATABASE alura;

CREATE TABLE aluno (
    id SERIAL PRIMARY KEY,
	primeiro_nome VARCHAR(255) NOT NULL,
	ultimo_nome VARCHAR(255) NOT NULL,
	data_nascimento DATE NOT NULL
);

-- foi criado uma tabela de categoria para otimizar o espaço no banco de dados
-- Dessa forma, na tabela curso a coluna categoria será referenciada na tabela categoria
CREATE TABLE categoria (
    id SERIAL PRIMARY KEY,
	nome VARCHAR(255) NOT NULL UNIQUE
);

-- Obs: a relação entre categoria e curso é do tipo "Muitos para um (N:1)", já a relação
-- entre curso e categoria é do tipo "Um para muitos (1:N)"

CREATE TABLE curso (
    id SERIAL PRIMARY KEY,
	nome VARCHAR(255) NOT NULL,
	categoria_id INTEGER NOT NULL REFERENCES categoria(id)
);

-- A tabela aluno_curso é do tipo "muitos para muitos" (N:N). Nesses casos, é
-- Necessário uma tabela como a abaixo, como uma tabela de junção.

CREATE TABLE aluno_curso (
	-- a sintaxe abaixo é similar a uma foreign key (FOREIGN KEY (aluno_id) REFERENCES aluno(id))
	aluno_id INTEGER NOT NULL REFERENCES aluno(id),
	curso_id INTEGER NOT NULL REFERENCES curso(id),
	
	PRIMARY KEY (aluno_id, curso_id)
);

INSERT INTO aluno (primeiro_nome, ultimo_nome, data_nascimento) VALUES (
    'Vinicius', 'Dias', '1997-10-15'
), (
    'Patrícia', 'Freitas', '1996-10-25'
), (
    'Diogo', 'Oliveira', '1994-08-27'
), (
    'Maria', 'Rosa', '1985-01-01'
);

INSERT INTO categoria (nome) VALUES ('Front-End'), ('Programação'), ('Banco de dados'), ('Data Science');

INSERT INTO curso (nome, categoria_id) VALUES
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
	
INSERT INTO aluno_curso VALUES (1,4), (1,11), (2,1), (2,2), (3,4), (3,3),(4,4),(4,6),(4,5);

SELECT * FROM categoria;
UPDATE categoria SET nome = 'Ciência de Dados' WHERE id = 4;

-- Número de cursos que os alunos estão matriculados
SELECT aluno.primeiro_nome, 
	   aluno.ultimo_nome,
	   COUNT(aluno_curso.curso_id) AS numero_cursos
	FROM aluno
	JOIN aluno_curso ON aluno_curso.aluno_id = aluno.id
GROUP BY 1, 2
ORDER BY numero_cursos DESC
	LIMIT 1;
	
SELECT * FROM curso;

-- Número de alunos matriculados por curso
SELECT curso.nome, 
	   COUNT(aluno_curso.aluno_id) AS numero_alunos
	FROM curso
	JOIN aluno_curso ON aluno_curso.curso_id = curso.id
GROUP BY 1
ORDER BY numero_alunos DESC
	LIMIT 1;

-- Número de alunos matriculados por categoria
SELECT categoria.nome, 
	   COUNT(aluno_curso.aluno_id) AS numero_alunos
	FROM curso
	JOIN aluno_curso ON aluno_curso.curso_id = curso.id
	JOIN categoria ON categoria.id = curso.categoria_id
GROUP BY 1
ORDER BY numero_alunos DESC
	LIMIT 1;
	
SELECT * FROM curso;
SELECT * FROM categoria;

-- As duas linhas abaixo apresentam o mesmo resultado
SELECT * FROM curso WHERE categoria_id = 1 OR categoria_id = 2;
SELECT * FROM curso WHERE categoria_id IN (1,2);

SELECT id FROM categoria WHERE nome NOT LIKE '% %'

SELECT curso.nome FROM curso WHERE categoria_id IN (
	-- o segundo SELECT é considerado uma subquery pois está dentro de uma query
	SELECT id FROM categoria WHERE nome LIKE '% de %'
);

SELECT categoria
	FROM (
			-- mais uma subquery
			SELECT categoria.nome AS categoria,
					COUNT(curso.id) as numero_cursos
				FROM categoria
				JOIN curso ON curso.categoria_id = categoria.id
			GROUP BY categoria
		) AS categoria_cursos
	WHERE numero_cursos >= 3;
	
-- No caso acima, a query poderia ter sido simplificada com um HAVING
SELECT categoria.nome AS categoria,
		COUNT(curso.id) as numero_cursos
			FROM categoria
			JOIN curso ON curso.categoria_id = categoria.id
		GROUP BY categoria
		HAVING COUNT(curso.id) >= 3;
		
-- A partir de agora, usaremos operadores e funções exclusivos do postgresql
-- o operador de concatenação '||' é exclusivo do postgresql
SELECT (primeiro_nome || ' ' || ultimo_nome) AS nome_completo FROM aluno;
-- vai retornar erro devido ao null: SELECT (primeiro_nome || ' ' || NULL) AS nome_completo FROM aluno;
SELECT UPPER(CONCAT ('Vinicius', ' ', NULL, 'Dias')); -- a função CONCAT faz o mesmo de '||' mas ignora o NULL

SELECT (primeiro_nome || ' ' || ultimo_nome) AS nome_completo, 
		NOW()::DATE, EXTRACT(YEAR FROM AGE(data_nascimento)) AS idade 
FROM aluno;

SELECT NOW();
SELECT TO_CHAR(NOW(), 'DD/MM/YYYY');
SELECT TO_CHAR(NOW(), 'DD, MM, YYYY');
SELECT TO_CHAR(128.3::REAL, '999D99')


/* Assim como fizemos uma subquery anteriormente para realizar uma query,
nós poderíamos querer criar uma tabela virtual daquela subquery - uma VIEW.
uma VIEW é muito utilizado para fornecer apenas uma parte do banco de dados
a um cliente externo. O consultor não consegue manipular, inserir ou alterar,
apenas consultar. */

-- a VIEW em alguns casos podem causar perda de performance pois um determinado
-- filtro pode ser otimizado durante uma query, e na prática o VIEW executa toda
-- a query sempre que a VIEW é chamada

CREATE VIEW vw_cursos_por_categoria AS SELECT categoria.nome AS categoria,
		COUNT(curso.id) as numero_cursos
			FROM categoria
			JOIN curso ON curso.categoria_id = categoria.id
		GROUP BY categoria
	HAVING COUNT(curso.id) >= 3;
	
SELECT * FROM vw_cursos_por_categoria;

-- Podemos fazer todo tipo de manipulação que fazíamos com uma tabela
-- comum ao utilizarmos VIEWS.
SELECT categoria
	FROM vw_cursos_por_categoria AS categoria_cursos
	WHERE numero_cursos >= 3;
	
CREATE VIEW vw_cursos_programacao AS SELECT nome FROM curso WHERE categoria_id = 2;

SELECT * FROM vw_cursos_programacao;

SELECT * FROM vw_cursos_programacao WHERE nome = 'PHP';

SELECT categoria.id AS categoria_id, vw_cursos_por_categoria.*
	FROM vw_cursos_por_categoria
	JOIN categoria ON categoria.nome = vw_cursos_por_categoria.categoria;