use p7g5;
--------------------------------Views------------------------------------
go
-- Mostrar funcionários sem responsabilidades
CREATE VIEW FuncionariosSemResponsabilidadesView AS
SELECT p.Nome, p.NIF, f.Idade, f.Ordenado, f.Seguro, p.Telemovel
FROM funcionario f
LEFT JOIN pessoa p ON p.NIF = f.FK_NIF
WHERE f.FK_NIF NOT IN (SELECT FK_NIF_Funcionario FROM responsavel);
-- SELECT * FROM FuncionariosSemResponsabilidadesView 
go
-- Mostrar funcionários e os projetos ao qual estes estão responsáveis
CREATE VIEW FuncionariosResponsaveisView AS
SELECT p.Nome AS Responsavel, CAST(proj.duracao AS VARCHAR) + ' Dias' AS Duracao, proj.ID AS ID_Projeto, r.FK_NIF_Funcionario AS NIF_Funcionario, p.Telemovel
FROM projeto proj
JOIN responsavel r ON proj.ID = r.FK_ID_Projeto
JOIN pessoa p ON p.NIF = r.FK_NIF_Funcionario
JOIN funcionario f ON f.FK_NIF = r.FK_NIF_Funcionario;
--SELECT * FROM FuncionariosResponsaveisView 
go
-- Listar características dos clientes e projetos associados
CREATE VIEW Caracteristicas_Projetos_Clientes AS
SELECT p.Nome, pr.ID AS ID_Projeto, p.Mail, p.NIF, p.CC, p.Telemovel, c.Localizacao, pr.N_Janelas, pr.N_Portas, pr.N_Portadas
FROM projeto pr
JOIN cliente c ON c.FK_NIF = pr.FK_NIF_Cliente
JOIN pessoa p ON p.NIF = c.FK_NIF;
-- SELECT * FROM Caracteristicas_Projetos_Clientes
go
-- Listar características dos clientes sem projetos
CREATE VIEW Caracteristicas_Clientes_Sem_Projetos AS
SELECT p.Nome, p.Mail, p.NIF, p.CC, p.Telemovel, c.Localizacao
FROM pessoa p
JOIN cliente c ON c.FK_NIF = p.NIF
LEFT JOIN projeto pr ON pr.FK_NIF_Cliente = c.FK_NIF
WHERE pr.ID IS NULL;
-- SELECT * FROM Caracteristicas_Clientes_Sem_Projetos
