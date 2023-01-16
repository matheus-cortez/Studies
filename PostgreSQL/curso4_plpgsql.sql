/* Com SQL em si, não conseguimos fazer lógica de programação (IF ELSE, por exemplo)
Nesses cenários mais complexos, a gente utiliza uma extensão ao SQL, através de Functions (Schemas > seu_schema > Foregin Tables > Functions)
Na documentação do PostgreSQL, se trata de Server Programming */

CREATE FUNCTION primeira_funcao() RETURNS INTEGER AS '
	SELECT (5-3) * 2
' LANGUAGE SQL;

-- podemos chamar o SELECT sem o FROM pois essa função só retorna um único INTEGER
SELECT primeira_funcao() AS numero; 
SELECT * FROM primeira_funcao() AS numero;

CREATE FUNCTION soma_dois_numeros(numero_1 INTEGER, numero_2 INTEGER) RETURNS INTEGER AS '
	SELECT numero_1 + numero_2
' LANGUAGE SQL;

DROP FUNCTION soma_dois_numeros;

-- Também podemos definir os parâmetros apenas com o tipo
CREATE FUNCTION soma_dois_numeros(INTEGER, INTEGER) RETURNS INTEGER AS '
	SELECT $1 + $2;
' LANGUAGE SQL;

SELECT soma_dois_numeros(3,17);


CREATE TABLE a (nome VARCHAR(255) NOT NULL);

/* O objetivo da função é inserir um valor. Porém, como colocamos para
retornar um VARCHAR, precisamos colocar um SELECT ao final para dar match
no tipo de retorno esperado. */
CREATE OR REPLACE FUNCTION cria_a(nome VARCHAR) RETURNS VARCHAR AS $$
	INSERT INTO a (nome) VALUES(cria_a.nome);
	SELECT nome; -- OBS: É retornada a PRIMEIRA LINHA do SELECT de retorno
$$ LANGUAGE SQL;

-- Caso alteremos o tipo de parâmetro e/ou retorno da função,
--  precisamos dar um DROP pois o OR REPLACE não será o suficiente

SELECT cria_a('Vinícius Dias');
SELECT * FROM a;

-- Podemos usar uma PROCEDURE ao inves de uma função. Uma PROCEDURE
-- Não retorna valor

CREATE PROCEDURE exemplo() AS $$
	SELECT 2;
$$ LANGUAGE SQL;

CALL exemplo();

-- https://www.postgresql.org/docs/current/dml-returning.html



CREATE TABLE instrutor (
	id SERIAL PRIMARY KEY,
	nome VARCHAR(255) NOT NULL,
	salario DECIMAL(10, 2)
);

INSERT INTO instrutor (nome, salario) VALUES ('Vinicius Dias', 100);
INSERT INTO instrutor (nome, salario) VALUES ('Diogo Mascarenhas', 200);
INSERT INTO instrutor (nome, salario) VALUES ('Nico Steppat', 300);
INSERT INTO instrutor (nome, salario) VALUES ('Juliana', 400);
INSERT INTO instrutor (nome, salario) VALUES ('Priscila', 500);

CREATE FUNCTION dobro_do_salario(instrutor instrutor) RETURNS DECIMAL AS $$ 
	SELECT instrutor.salario * 2 AS dobro;
$$ LANGUAGE SQL;

SELECT * FROM instrutor

SELECT nome, dobro_do_salario(instrutor.* /*esse .* não é necessário*/) AS desejo FROM instrutor;

CREATE OR REPLACE FUNCTION cria_instrutor_falso() RETURNS instrutor AS $$ 
	SELECT 22, 'Nome falso', 200::DECIMAL;
$$ LANGUAGE SQL;

SELECT cria_instrutor_falso();
SELECT * FROM cria_instrutor_falso();

-- Ao utilizar RETURNS SETOF, nós retornamos a tabela inteira de instrutores
-- Também funcionaria se utilizarmos RETURNS TABLE(id INTEGER, nome VARCHAR, salario DECIMAL)
CREATE FUNCTION instrutores_bem_pagos(valor_salario DECIMAL) RETURNS SETOF instrutor AS $$ 
	SELECT * FROM instrutor WHERE salario > valor_salario;
$$ LANGUAGE SQL;

SELECT * FROM instrutores_bem_pagos(300);


CREATE FUNCTION soma_e_produto (IN numero_1 INTEGER, IN numero_2 INTEGER, OUT soma INTEGER, OUT produto INTEGER) AS $$ 
	SELECT numero_1 + numero_2 AS soma, numero_1 * numero_2 AS produto;
$$ LANGUAGE SQL;

SELECT * FROM soma_e_produto(3, 3);

/* 
-- também poderíamos ter criado o tipo dos parâmetros de saída
-- e especificado no RETURN ao invés de usar os parâmetros OUT
CREATE TYPE dois_valores AS (soma INTEGER, produto INTEGER);
CREATE FUNCTION soma_e_produto (numero_1 INTEGER, numero_2 INTEGER) RETURNS dois_valores AS $$...... 

-- assim, podemos reescrever a função de instrutores bem pagos */

DROP FUNCTION instrutores_bem_pagos;
CREATE FUNCTION instrutores_bem_pagos(valor_salario DECIMAL, OUT nome VARCHAR, OUT salario DECIMAL) RETURNS SETOF record AS $$ 
	SELECT nome, salario FROM instrutor WHERE salario > valor_salario;
$$ LANGUAGE SQL;

SELECT * FROM instrutores_bem_pagos(300);

/* Podemos criar uma função em schemas>seu_schema>functions > botao direito > create > function
ao falarmos de PlpgSQL, nos referimos a uma uma linguagem procedural do postgres que é semelhante
ao SQL mas com muito mais funcionalidades. 
OBS: o PLPGSQL é um módulo externo do SQL que por padrão vem habilitado no Postgresql */

-- é padrão do plpgsql ter BEGIN e END e RETORNAR um valor
CREATE OR REPLACE FUNCTION primeira_pl() RETURNS INTEGER AS $$ 
	DECLARE -- campo opcional para definir variáveis
		primeira_variavel INTEGER DEFAULT 3;
	BEGIN
	-- := significa atribuição
		primeira_variavel := primeira_variavel * 2;
		
		-- subbloco
		DECLARE
			-- ao declarar uma variavel que já existe no bloco pai, o valor atribuido
			-- fica apenas no subbloco
			primeira_variavel INTEGER;
		BEGIN
			primeira_variavel :=7; -- atribuindo 7 no subbloco
		END;
		
		RETURN primeira_variavel; -- retorna 6
	END
$$ LANGUAGE plpgsql;

SELECT primeira_pl();

-- Reescrevendo as funções já feitas com SQL utilizando PGSQL

DROP FUNCTION cria_a;
CREATE OR REPLACE FUNCTION cria_a(nome VARCHAR) RETURNS void AS $$
	BEGIN
		INSERT INTO a (nome) VALUES('Patricia');
	END
$$ LANGUAGE plpgsql;

SELECT cria_a()
SELECT * FROM a;

DROP FUNCTION cria_instrutor_falso;
CREATE OR REPLACE FUNCTION cria_instrutor_falso() RETURNS instrutor AS $$ 
	DECLARE
		retorno instrutor;
	BEGIN
		-- RETURN ROW(22, 'Nome falso', 200::DECIMAL)::instrutor; # daria certo assim
		SELECT 22, 'Nome Falso', 200::DECIMAL INTO retorno; -- adiciona o valor à variável retorno
		RETURN retorno;
	END;
$$ LANGUAGE plpgsql;

SELECT cria_instrutor_falso();


DROP FUNCTION instrutores_bem_pagos;
CREATE OR REPLACE FUNCTION instrutores_bem_pagos(valor_salario DECIMAL) RETURNS SETOF instrutor AS $$ 
	BEGIN
		RETURN QUERY SELECT * FROM instrutor WHERE salario > valor_salario;
	END;
$$ LANGUAGE plpgsql;

SELECT * FROM instrutores_bem_pagos(300);


CREATE OR REPLACE FUNCTION salario_ok(instrutor instrutor) RETURNS VARCHAR AS $$ 
	BEGIN
		IF instrutor.salario > 200 THEN
			RETURN 'Salário está ok';
		ELSE
			RETURN 'Salário pode aumentar';
		END IF;
	END;
$$ LANGUAGE plpgsql;

SELECT nome, salario_ok(instrutor) FROM instrutor;


DROP FUNCTION salario_ok(instrutor instrutor);
CREATE OR REPLACE FUNCTION salario_ok(id_instrutor INTEGER) RETURNS VARCHAR AS $$ 
	DECLARE
		instrutor instrutor;
	BEGIN
		-- Essa solução com esse select é mais custoso do que a solução anterior
		SELECT * FROM instrutor WHERE id = id_instrutor INTO instrutor;
		
		
		/*IF instrutor.salario > 300 THEN
			RETURN 'Salário está ok';
		ELSEIF instrutor.salario = 300 THEN
			RETURN 'Salário pode aumentar';
		ELSE
			RETURN 'Salário está defasado';
		END IF;*/
		
		CASE instrutor.salario
			WHEN 100 THEN
				RETURN 'Salário muito baixo';
			WHEN 200 THEN
				RETURN 'Salário baixo';
			WHEN 300 THEN
				RETURN 'Salário ok';
			ELSE
				RETURN 'Salário ótimo';
		END CASE;
	END;
$$ LANGUAGE plpgsql;

SELECT nome, salario_ok(instrutor.id) FROM instrutor;

-- DROP FUNCTION tabuada;
CREATE OR REPLACE FUNCTION tabuada(numero INTEGER) RETURNS SETOF VARCHAR AS $$ 
	-- Não é necessário declarar nada se você usar um loop do tipo for
	/* DECLARE
		multiplicador INTEGER DEFAULT 1;*/
	BEGIN
		/*
		RETURN NEXT numero * 1;
		RETURN NEXT numero * 2;
		RETURN NEXT numero * 3;
		RETURN NEXT numero * 4;
		RETURN NEXT numero * 5;
		RETURN NEXT numero * 6;
		RETURN NEXT numero * 7;
		RETURN NEXT numero * 8;
		RETURN NEXT numero * 9;
		*/
		
		/* LOOP tradicional
		LOOP
			RETURN NEXT numero || ' x ' || multiplicador || ' = ' || numero * multiplicador;
			multiplicador := multiplicador + 1;
			EXIT WHEN multiplicador = 10;
		END LOOP;
		*/
		
		/* LOOP WHILE
		WHILE multiplicador < 10 LOOP
			RETURN NEXT numero || ' x ' || multiplicador || ' = ' || numero * multiplicador;
			multiplicador := multiplicador + 1;
		END LOOP;
		*/
		
		FOR multiplicador IN 1..9 LOOP
			RETURN NEXT numero || ' x ' || multiplicador || ' = ' || numero * multiplicador;
		END LOOP;
	END;
$$ LANGUAGE plpgsql;

SELECT tabuada(9);

CREATE FUNCTION instrutor_com_salario(OUT nome VARCHAR, OUT salario_ok VARCHAR) RETURNS SETOF record AS $$ 
	DECLARE
		instrutor instrutor; -- como estamos utilizando uma query no FOR, é necessário declarar a variável
	BEGIN
		FOR instrutor IN SELECT * FROM instrutor LOOP
			nome := instrutor.nome;
			salario_ok := salario_ok(instrutor.id);
			
			RETURN NEXT;
		END LOOP;
	END;
$$ LANGUAGE plpgsql;

SELECT * FROM instrutor_com_salario();



CREATE TABLE IF NOT EXISTS aluno (
    id SERIAL PRIMARY KEY,
	primeiro_nome VARCHAR(255) NOT NULL CHECK (primeiro_nome <> ''),
	ultimo_nome VARCHAR(255) NOT NULL,
	data_nascimento DATE NOT NULL DEFAULT NOW()::DATE
);


CREATE TABLE categoria (
    id SERIAL PRIMARY KEY,
	nome VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE curso (
    id SERIAL PRIMARY KEY,
	nome VARCHAR(255) NOT NULL,
	categoria_id INTEGER NOT NULL REFERENCES categoria(id)
);

CREATE TABLE aluno_curso (
	aluno_id INTEGER NOT NULL REFERENCES aluno(id),
	curso_id INTEGER NOT NULL REFERENCES curso(id),
	
	PRIMARY KEY (aluno_id, curso_id)
);


CREATE OR REPLACE FUNCTION cria_curso(nome_curso VARCHAR, nome_categoria VARCHAR) RETURNS void AS $$ 
	DECLARE
		id_categoria INTEGER;
	BEGIN
		-- SELECT id INTO id_categoria FROM categoria WHERE nome = nome_categoria;
		SELECT id FROM categoria WHERE nome = nome_categoria INTO id_categoria;
		-- Apenas executa se o SELECT acima não encontrar nada
		IF NOT FOUND THEN 
			INSERT INTO categoria (nome) VALUES (nome_categoria) RETURNING id INTO id_categoria;
		END IF;
		
		INSERT INTO curso (nome, categoria_id) VALUES (nome_curso, id_categoria);
	END;
$$ LANGUAGE plpgsql;

--DROP TABLE aluno_curso, curso, categoria, aluno;

-- Se houver em categoria um campo com Programação, pegar o id dessa categoria
-- ELSE, acrescentar o nome "Programação" em categoria e pegar o id dessa nova linha criada
-- Inserir em curso o nome "PHP" e acrescentar o ID da categoria obtido com o condicional acima
SELECT cria_curso('PHP', 'Programação');
SELECT * FROM curso;
SELECT * FROM categoria;
SELECT cria_curso('Java', 'Programação');
SELECT * FROM curso;
SELECT * FROM categoria;



CREATE TABLE log_instrutores (
	id SERIAL PRIMARY KEY,
	informacao VARCHAR(255),
	momento_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION cria_instrutor (nome_instrutor VARCHAR, salario_instrutor DECIMAL) RETURNS void AS $$ 
	DECLARE
		id_instrutor_inserido INTEGER;
		media_salarial DECIMAL;
		instrutores_recebem_menos INTEGER DEFAULT 0;
		total_instrutores INTEGER DEFAULT 0;
		salario DECIMAL;
		percentual DECIMAL;
	BEGIN
		INSERT INTO instrutor (nome, salario) VALUES (nome_instrutor, salario_instrutor) RETURNING id INTO id_instrutor_inserido;
		
		SELECT AVG(instrutor.salario) INTO media_salarial FROM instrutor WHERE id <> id_instrutor_inserido;
		
		IF salario_instrutor > media_salarial THEN
			INSERT INTO log_instrutores (informacao) VALUES (nome_instrutor || ' recebe acima da média');
		END IF;
		
		FOR salario IN SELECT instrutor.salario FROM instrutor WHERE id <> id_instrutor_inserido LOOP
			total_instrutores := total_instrutores + 1;
			
			IF salario_instrutor > salario THEN
				instrutores_recebem_menos := instrutores_recebem_menos + 1;
			END IF;
		END LOOP;
		
		percentual = instrutores_recebem_menos::DECIMAL / total_instrutores::DECIMAL * 100;
		
		INSERT INTO log_instrutores(informacao) 
			VALUES (nome_instrutor || ' recebe mais do que ' || percentual || '% da grade de instrutores'); 
	END;
$$ LANGUAGE plpgsql;

SELECT * FROM instrutor;

SELECT cria_instrutor('Fulana de tal', 1000);

SELECT * FROM log_instrutores;