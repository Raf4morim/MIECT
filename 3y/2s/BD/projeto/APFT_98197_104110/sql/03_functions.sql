use p7g5;

go
--________________________________________FUNCIONARIOS_______________________________________________--
-- Listar funcionarios com salário superior a x... (Nome, NIF, idade) *MUDAR* NA INTERFACE
create function SalarioSuperior (@Salario real) returns @table table
	(Nome varchar(20),
	 NIF char(9),
	 Idade int,
	 Ordenado real)
as
begin
	insert @table
		select p.Nome, f.FK_NIF as NIF, f.Idade, f.Ordenado
		from funcionario f
		join pessoa p on p.NIF = f.FK_NIF
		where f.Ordenado > @Salario;
	return;
end;
--go;
--drop function SalarioSuperior;
--go
--select * from SalarioSuperior(900);

--------------------------------------------------------------------------------------------------------

go
--_________________________________________PROJETO_______________________________________________--

-- Orçamento de um projeto é Transporte + Mão de obra (que é a duracao do projeto * numero de funcionários 
-- responsaveis pelo projeto em causa) + Preço dos materiais precisos para o projeto


CREATE FUNCTION CalcularOrcamento (@ProjectID INT)
RETURNS FLOAT
AS
BEGIN
    DECLARE @Transporte INT, @Duracao INT, @NumFuncionarios INT, @CustoMaterial FLOAT, @Orcamento FLOAT;

    -- Calcular transporte
    SET @Transporte = dbo.Dist_Total(@ProjectID);

    -- Obter duração do projeto
    SELECT @Duracao = Duracao
    FROM projeto
    WHERE ID = @ProjectID;

    -- Contar número de funcionários responsáveis
    SELECT @NumFuncionarios = COUNT(FK_NIF_Funcionario)
    FROM responsavel
    WHERE FK_ID_Projeto = @ProjectID;

    -- Calcular custo do material
    SELECT @CustoMaterial = SUM(m.Preco * n.Unidades)
    FROM ListarMateriaisProjeto(@ProjectID) n
    JOIN material m ON m.N_Referencia_Material = n.Referencia;

    -- Calcular o orçamento total
    SET @Orcamento = @Transporte + (@Duracao * @NumFuncionarios) + @CustoMaterial;

    RETURN @Orcamento;
END;
----Confirmar à mao
----Mao de obra duracao * funionarios responsaveis 
--select * from responsavel;
--select Duracao from projeto where ID = 1;
----preço x unidades de materiais
--select * from necessita where FK_ID_Projeto = 1;
--select * from material;

--SELECT dbo.CalcularOrcamento(1) AS OrcamentoTotal;

go
--_________________________________________Material_______________________________________________--
 --Para cada projeto obter o Material necessário com as unidades, e obter o stock de momento

CREATE FUNCTION ListarMateriaisProjeto (@ProjectID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT n.FK_N_Referencia_Material as Referencia, n.Unidades, m.Stock, m.preco as Preço, m.designacao as Designacao
    FROM necessita n
    JOIN material m ON m.N_Referencia_Material = n.FK_N_Referencia_Material
    WHERE n.FK_ID_Projeto = @ProjectID
);
--go
--SELECT * FROM ListarMateriaisProjeto(4);

--drop function ListarMateriaisProjeto;

--------------------------------------------------------------------------------------------------------

-- (por exemplo, Listar todos os estores abaixo do preço limite) usando uma variavel de entrada para definir um limite de preco em relação a outra variavel de entrada que será ou estore, janela, vidro, porta, acessorio.
-- estore é um IS-A de Material, cujo o seu nome aparece na designacao do material.
 go
  create function ListarMateriaisPorPreco(@PrecoLimite real, @Designacao varchar(20)) returns @table 
 	table (N_Referencia_Material varchar(50), Designacao varchar(20), Preco real, Stock int)
 	as
 	begin
 		declare @N_Referencia_Material varchar(50);
 		declare @Preco real;
 		declare @Stock int;

 		insert into @table (N_Referencia_Material, Designacao, Preco, Stock)
 		select m.N_Referencia_Material, m.Designacao, m.Preco, m.Stock
 		from material m
 		where m.Preco < @PrecoLimite and m.Designacao = @Designacao;
 		return;
 	end;

--go
--drop function ListarMateriaisPorPreco;
--go;
--select * from ListarMateriaisPorPreco(9,'Estore');

--------------------------------------------------------------------------------------------------------
-- Listar fornecedor de um determinado projeto, temos que ter em consideração o material do projeto
go
 CREATE FUNCTION ObterDetalhesFornecedoresPorProjeto (@ID INT)
 RETURNS TABLE
 AS
 RETURN
 (
     SELECT DISTINCT f.Nome, f.Localizacao, f.Distancia, f.Telefone, f.IBAN
     FROM fornecedor f
     JOIN fornece fr ON fr.FK_NIF_Fornecedor = f.NIF
     JOIN material m ON m.N_Referencia_Material = fr.FK_N_Referencia_Material
     JOIN necessita n ON n.FK_N_Referencia_Material = m.N_Referencia_Material
     JOIN projeto p ON p.ID = n.FK_ID_Projeto
     WHERE p.ID = @ID
 );
 --go
 --SELECT * FROM ObterDetalhesFornecedoresPorProjeto(1);

---- CONFIRMAÇÃO
 --select * from necessita where FK_ID_Projeto = 1;
 --select Distancia from cliente where FK_NIF = 987654321;
 ----drop function ObterDetalhesFornecedoresPorProjeto;

--------------------------------------------------------------------------------------------------------

go
-- Distancia do cliente e do fornecedor relacionados com um projeto, 
-- para tal ja temos uma funçao que diz os fornecedores de um projeto, ObterDetalhesFornecedoresPorProjeto
-- A Distancia total vai ser 2*distancia do cliente + 2 * distancia do fornecedor
-- Criar uma funcao que recebe o id de um projeto e retorna a distancia total em metros

CREATE FUNCTION Dist_Total (@ProjectID INT)
RETURNS INT
AS
BEGIN
    DECLARE @ClienteDistancia INT, @FornecedorDistancia INT;
    -- Obter a distância do cliente
    SELECT @ClienteDistancia = Distancia
    FROM cliente
    JOIN projeto ON projeto.FK_NIF_Cliente = cliente.FK_NIF
    WHERE projeto.ID = @ProjectID;

    -- Obter a distância do fornecedor usando a função existente
    SELECT @FornecedorDistancia = SUM(Distancia)
    FROM ObterDetalhesFornecedoresPorProjeto(@ProjectID);

    -- Calcular a distância total
    DECLARE @DistanciaTotal INT;
    SET @DistanciaTotal = 2 * @ClienteDistancia + 2 * @FornecedorDistancia;

    RETURN @DistanciaTotal;
END;
--go 
--SELECT dbo.Dist_Total(1) AS DistanciaTotal;

--drop function Dist_Total;

 -- CCCCCCCCCCCCCCCCCCCCCCCC USADO NA INTERFACE

--____________________________________Cliente_______________________________________________--
go

-- Listar informação do cliente associado ao projeto x (Nome, Telemóvel, Mail, Localização da obra)   (Necessidade de contactar a pessoa)

CREATE FUNCTION ListarClientePorProjeto (@ProjectID INT)
RETURNS TABLE
AS
RETURN
(
   SELECT p.Nome, p.NIF, p.Telemovel, p.Mail, c.Localizacao, c.Distancia
   FROM cliente c
   JOIN pessoa p ON p.NIF = c.FK_NIF
   JOIN projeto pr ON c.FK_NIF = pr.FK_NIF_Cliente
   WHERE pr.ID = @ProjectID
);

--go
--SELECT * FROM ListarClientePorProjeto(1); 

--DROP FUNCTION IF EXISTS ListarClientePorProjeto;

