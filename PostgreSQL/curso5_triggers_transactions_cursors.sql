CREATE TABLE log_instrutores (
	id SERIAL PRIMARY KEY,
	informacao VARCHAR(255),
	momento_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
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

-- adaptando a função para retornar um trigger (executada com base em um evento)
-- nota: não podemos passar parâmetros nas funções executadas por triggers, eles serão
-- substituídos por variáveis do tipo NEW.
CREATE OR REPLACE FUNCTION cria_instrutor () RETURNS TRIGGER AS $$ 
	DECLARE
		-- id_instrutor_inserido INTEGER; -- foi substituído por NEW.id
		media_salarial DECIMAL;
		instrutores_recebem_menos INTEGER DEFAULT 0;
		total_instrutores INTEGER DEFAULT 0;
		salario DECIMAL;
		percentual DECIMAL(5, 2);
		-- logs_inseridos INTEGER; -- exemplo para raise exception no meio da função
	BEGIN
		-- INSERT INTO instrutor (nome, salario) VALUES (nome_instrutor, salario_instrutor) RETURNING id INTO id_instrutor_inserido;
		
		SELECT AVG(instrutor.salario) INTO media_salarial FROM instrutor WHERE id <> NEW.id;
		
		-- BEGIN; -- não conseguimos colocar um BEGIN (uma transação) dentro de uma função
		-- usando plpgsql pois ele entende que é um bloco da função
		-- alternativamente, podemos usar CALLS ao invés de funções, ou fazer as transações fora da função.
		-- nota: em caso de erro na execução da função, um rollback é feito automaticamente
		IF NEW.salario > media_salarial THEN
			INSERT INTO log_instrutores (informacao) VALUES (NEW.nome || ' recebe acima da média');
			
			/* -- exemplo para raise exception no meio da função usando GET DIAGNOSTICS
			GET DIAGNOSTICS logs_inseridos = ROW_COUNT;
			IF logs_inseridos > 1 THEN
				RAISE EXCEPTION 'Algo de errado não está certo';
			END IF;
			*/
		END IF;
		
		FOR salario IN SELECT instrutor.salario FROM instrutor WHERE id <> NEW.id LOOP
			total_instrutores := total_instrutores + 1;
			
			-- Podemos levantar mensagens durante a execução da função com RAISE NOTICE
			-- RAISE NOTICE 'Salário inserido: % Salário do instrutor existente: %', NEW.salario, salario;
			IF NEW.salario > salario THEN
				instrutores_recebem_menos := instrutores_recebem_menos + 1;
			END IF;
		END LOOP;
		
		percentual = instrutores_recebem_menos::DECIMAL / total_instrutores::DECIMAL * 100;
		
		-- caso percentual não seja menor do que 100, irá para uma exception
		-- ASSERT percentual < 100::DECIMAL, 'Instrutores novos não podem receber mais do que todos os antigos';
		
		INSERT INTO log_instrutores(informacao) 
			VALUES (NEW.nome || ' recebe mais do que ' || percentual || '% da grade de instrutores'); 
		RETURN NEW;
	
	-- tratamento de erro (caso ocorra um erro durante a execução da função, executar esse bloco
	-- e ignorar toda a execução que já havia sido feita)
	/*
	EXCEPTION
		-- undefined_column é um tipo de erro disponível na documentação
		-- nota: poderiamos utilizar o código de erro também - WHEN SQLSTATE 'Codigo_Erro'
		-- também podemos colocar WHEN OTHERS THEN para abrir uma exceção para todos os erros
		WHEN undefined_column THEN
			-- colocamos isso apenas para ter algum comando SQL sendo executado
			RAISE NOTICE 'Algo de errado não está certo'
			RAISE EXCEPTION 'Erro complicado de resolver';
		-- podemos inserir blocos RAISE EXCEPTION após alguma linha do bloco BEGIN, desse modo,
		-- caso ocorra um erro naquela linha, irá para o tratamento abaixo
		WHEN raise_exception THEN
			RETURN NULL;
	*/
	END;
$$ LANGUAGE plpgsql;


-- atenção para os parâmetros do trigger, há situações em que você quer
-- colocar BEFORE INSERT para nao permitir uma inserção se não satisfizer
-- determinadas condições.
CREATE TRIGGER cria_log_instrutores AFTER INSERT ON instrutor
	FOR EACH ROW EXECUTE FUNCTION cria_instrutor();
	

--Qual a diferença entre um trigger definido para executar FOR EACH ROW e FOR EACH STATEMENT?
--O primeiro executará a função uma vez para cada linha modificada. Já o segundo executará a função apenas uma vez para cada instrução, independente do número de linhas modificadas


SELECT * FROM instrutor;
SELECT cria_instrutor('Outro instrutor', 500);

-- tabela vazia antes de inserir valores
SELECT * FROM log_instrutores;


INSERT INTO instrutor (nome, salario) VALUES ('Outra instrutora', 600);
INSERT INTO instrutor (nome, salario) VALUES ('Mais uma pessoa', 1200);
INSERT INTO instrutor (nome, salario) VALUES ('Outro instrutor', 500);
INSERT INTO instrutor (nome, salario) VALUES ('Outra pessoa de novo', 600);

-- após as insersões acima, podemos visualizar que o trigger foi executado com sucesso
SELECT * FROM log_instrutores; 


BEGIN;
INSERT INTO instrutor (nome, salario) VALUES ('Maria', 700)
ROLLBACK;
-- com o rollback, a insersão é desfeita tanto na tabela instrutor quanto log_instrutores


DROP TRIGGER cria_log_instrutores ON instrutor;

CREATE TRIGGER cria_log_instrutores BEFORE INSERT ON instrutor
	FOR EACH ROW EXECUTE FUNCTION cria_instrutor();
	
INSERT INTO instrutor (nome, salario) VALUES ('João', 6000);


-- Iremos modificar nossa tabela para que algumas pessoas não tenham salário. Ao invés
-- de retornar uma query (tabela) inteira, podemos usar CURSORES para poupar a quantidade
-- de memória alocada.

-- primeiramente, mostraremos essa função conceitual, explicando a utilização de cursores
-- DROP FUNCTION instrutores_internos
CREATE OR REPLACE FUNCTION instrutores_internos(id_instrutor INTEGER) RETURNS refcursor AS $$
	DECLARE
		-- podemos instanciar cursores de diferentes formas, sendo abaixo um
		-- unbound cursor (não está ligado a nenhuma query)
		cursor_salarios refcursor;
		-- salario DECIMAL;
	BEGIN
		-- quando eu abro um cursor, eu ainda não o tenho apontado para nenhuma linha.
		OPEN cursor_salarios FOR SELECT instrutor.salario 
							 FROM instrutor 
							 WHERE id <> id_instrutor 
						 	 AND salario > 0;
							
		/* FETCH altera a linha do cursor e armazena em algum lugar (salario),
		e nos retorna o valor. algumas possibilidades:
		FETCH LAST FROM cursor_salario INTO salario;
		FETCH NEXT FROM cursor_salario INTO salario;
		FETCH PRIOR FROM cursor_salario INTO salario;
		FETCH FIRST FROM cursor_salario INTO salario;
		
		o MOVE apenas move o cursor até determinada linha, mas não armazena nada.
		MOVE LAST FROM cursor_salarios;
		MOVE NEXT .....
		*/
		
		-- Após manipular o cursor, podemos o fechar
		-- CLOSE cursor_salarios;
		
		RETURN cursor_salarios;
	END;
$$ LANGUAGE plpgsql;


-- alterando a função cria_instrutor, mais especificamente o laço de repetição FOR,
-- para mostrar como o FOR é executado por baixo dos panos (com cursores)

CREATE OR REPLACE FUNCTION cria_instrutor () RETURNS TRIGGER AS $$ 
	DECLARE
		media_salarial DECIMAL;
		instrutores_recebem_menos INTEGER DEFAULT 0;
		total_instrutores INTEGER DEFAULT 0;
		salario DECIMAL;
		percentual DECIMAL(5, 2);
		cursor_salarios refcursor; -- +++++
	BEGIN
		SELECT AVG(instrutor.salario) INTO media_salarial FROM instrutor WHERE id <> NEW.id;
		
		IF NEW.salario > media_salarial THEN
			INSERT INTO log_instrutores (informacao) VALUES (NEW.nome || ' recebe acima da média');
		END IF;
		
		-- substituiremos o FOR pelo cursor
		-- FOR salario IN SELECT instrutor.salario FROM instrutor WHERE id <> NEW.id LOOP
		-- 	total_instrutores := total_instrutores + 1;
		SELECT instrutores_internos(NEW.id) INTO cursor_salarios;-- +++++
		LOOP-- +++++
			FETCH cursor_salarios INTO salario;-- +++++
			EXIT WHEN NOT FOUND;-- quando não encontrar mais nada, sair do loop
			total_instrutores := total_instrutores + 1;
			
			IF NEW.salario > salario THEN
				instrutores_recebem_menos := instrutores_recebem_menos + 1;
			END IF;
		END LOOP;
		
		percentual = instrutores_recebem_menos::DECIMAL / total_instrutores::DECIMAL * 100;

		INSERT INTO log_instrutores(informacao) 
			VALUES (NEW.nome || ' recebe mais do que ' || percentual || '% da grade de instrutores'); 
		RETURN NEW;
	END;
$$ LANGUAGE plpgsql;

-- o DO é um bloco anônimo, isso é, um bloco de código pontual sem nome e que retorna void
-- é útil durante o processo de desenvolvimento de funções para
-- testar a lógica.
DO $$
	DECLARE
		cursor_salarios refcursor;
		salario DECIMAL;
		total_instrutores INTEGER DEFAULT 0;
		instrutores_recebem_menos INTEGER DEFAULT 0;
		percentual DECIMAL(5,2);
	BEGIN
		SELECT instrutores_internos(12) INTO cursor_salarios;
		LOOP
			FETCH cursor_salarios INTO salario;
			EXIT WHEN NOT FOUND;
			total_instrutores := total_instrutores + 1;
			
			IF 600::DECIMAL > salario THEN
				instrutores_recebem_menos := instrutores_recebem_menos + 1;
			END IF;
		END LOOP;
		percentual = instrutores_recebem_menos::DECIMAL / total_instrutores::DECIMAL * 100;
		
		RAISE NOTICE 'Percentual: % %%', percentual;
	END;
$$;