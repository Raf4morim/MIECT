-- QUERIES EXTRA USADAS NA INTERFACE
use p7g5;

go
--________________________________________FUNCIONARIOS_______________________________________________--
--CHECK NA INTERFACE
---- Procurar por todos os funcionarios e seus respetivos nomes etc que está na entidade pessoa
select Nome, Mail, CC, NIF, Seguro, Idade, Ordenado  from (funcionario f join pessoa p on p.NIF=f.FK_NIF);

--_________________________________________PROJETOS_______________________________________________--
--Consultar informação de projetos através do nome do cliente
SELECT pe.Nome AS Nome_Cliente, ID, N_Janelas, N_Portas, N_Portadas, Duracao, Data_conclusao, c.FK_NIF AS NIF_Cliente 
FROM projeto p 
JOIN cliente c ON p.FK_NIF_Cliente = c.FK_NIF 
JOIN pessoa pe ON c.FK_NIF = pe.NIF 
where ID like '%1%' or pe.Nome like '%João%'

--Mostrar o numero de funcionarios envolvidos por projeto
SELECT NumFuncionarios = COUNT(FK_NIF_Funcionario) FROM responsavel WHERE FK_ID_Projeto = 2;

--Mostrar o tempo que dado projeto vai demorar
SELECT Duracao = Duracao FROM projeto WHERE ID = 1;

--_________________________________________Material_______________________________________________--

-- Mostrar informação de encomendas
select Codigo, Data_Chegada, Unidades, FK_N_Referencia_Material from encomenda join contem on FK_Codigo = Codigo;

-- Mostrar informação de fornecedores
SELECT NIF, Nome, IBAN, Localizacao, Distancia, Telefone FROM fornecedor;

--____________________________________Clientes_______________________________________________--

-- Listar características de todos os clientes
select p.Nome, p.Mail, p.CC, p.NIF, p.Telemovel, c.Localizacao from cliente c join pessoa p on p.NIF = c.FK_NIF;

--____________________________________Adicionar/ Remover_______________________________________________--

--DROPDOWNS
SELECT cliente.FK_NIF, Nome FROM cliente INNER JOIN pessoa ON cliente.FK_NIF = pessoa.NIF
SELECT DISTINCT ID FROM projeto;
SELECT DISTINCT codigo from encomenda;
SELECT funcionario.FK_NIF, Nome FROM funcionario INNER JOIN pessoa ON funcionario.FK_NIF = pessoa.NIF;

-- Verificar se o funcionário tem o projeto selecionado
SELECT COUNT(*) FROM responsavel WHERE FK_NIF_Funcionario = '123456789' AND FK_ID_Projeto = 1;

-- Consulta para obter os IDs dos responsáveis com base no NIF selecionado
SELECT FK_ID_Projeto FROM responsavel WHERE FK_NIF_Funcionario = '123456789'