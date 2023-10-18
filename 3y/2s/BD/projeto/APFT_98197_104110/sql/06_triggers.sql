use p7g5;

go
-- Quando se remove um projeto, cliente fica Sem projeto associado (se tiver mais que um projeto e o projeto for eliminado continua 'Com' projeto)
-- e é retirado ao stock o material usado no projeto
CREATE TRIGGER trg_delete_projeto ON projeto INSTEAD OF DELETE
AS 
BEGIN
	-- Decrement stock
	update material
	set Stock = Stock - n.Unidades
	from necessita n
	where material.N_Referencia_Material = n.FK_N_Referencia_Material
		and n.FK_ID_Projeto in (select ID from deleted);

	-- Delete from the 'responsavel' table
	DELETE FROM responsavel
	WHERE FK_ID_Projeto IN (SELECT ID FROM deleted);
	
	-- Delete from the 'necessita' table
	DELETE FROM necessita
	WHERE FK_ID_Projeto IN (SELECT ID FROM deleted);
	
	-- Delete from the 'projeto' table
	DELETE FROM projeto
	WHERE ID IN (SELECT ID FROM deleted);
END;
--drop trigger trg_delete_projeto
--WORKING
go

create trigger trg_delete_projeto2 on projeto after delete
as
begin
	-- Update the 'cliente' table
	UPDATE cliente
	SET Projeto = 'Sem'
	WHERE FK_NIF IN (
		SELECT FK_NIF_Cliente
		FROM deleted
		GROUP BY FK_NIF_Cliente
		HAVING FK_NIF_Cliente NOT IN (
			SELECT FK_NIF_Cliente
			FROM projeto
		)
	);
end;
--WORKING
-- TEST:
--delete from projeto where ID = 2;
--delete from projeto where ID = 7;
-- delete from projeto where FK_NIF_Cliente = 987654321;
--select * from cliente;
--select * from projeto;
--select * from necessita;
--select * from responsavel;
--select * from contem;
--select * from material;

--drop trigger trg_delete_projeto2;

go

create trigger trg_delete_func on funcionario instead of delete
as
begin
    delete from responsavel
    where FK_NIF_Funcionario in (select FK_NIF from deleted);

    delete from funcionario
    where FK_NIF in (select FK_NIF from deleted);

    delete from pessoa
    where NIF in (select FK_NIF from deleted);
end;

--drop trigger trg_delete_func;

go

CREATE TRIGGER trg_delete_client ON cliente INSTEAD OF DELETE
AS 
BEGIN
    -- Delete from the 'responsavel' table
    DELETE FROM responsavel
    WHERE FK_ID_Projeto IN (SELECT ID FROM projeto WHERE FK_NIF_Cliente IN (SELECT FK_NIF FROM deleted));

    -- Delete from the 'necessita' table
    DELETE FROM necessita
    WHERE FK_ID_Projeto IN (SELECT ID FROM projeto WHERE FK_NIF_Cliente IN (SELECT FK_NIF FROM deleted));

    -- Delete from the 'projeto' table
    DELETE FROM projeto
    WHERE FK_NIF_Cliente IN (SELECT FK_NIF FROM deleted);

    -- Delete from the 'cliente' table
    DELETE FROM cliente
    WHERE FK_NIF IN (SELECT FK_NIF FROM deleted);

    -- Delete from the 'pessoa' table
    DELETE FROM pessoa
    WHERE NIF IN (SELECT FK_NIF FROM deleted);
END;

--drop trigger trg_delete_client;

--select * from pessoa;
--select * from cliente;

--DELETE FROM cliente WHERE FK_NIF = '987654321';
--DELETE FROM pessoa WHERE NIF = '098765432';

go

-- Quando se adiciona um projeto, cliente fica Com projeto associado
create trigger trg_insert_projeto on projeto after insert
as 
begin
	update cliente
	set Projeto = 'Com'
    where FK_NIF IN (select FK_NIF_Cliente from inserted);
end;
-- WORKING
--select * from cliente;
--insert into projeto values(8, 10, 5, 2, 4, '2023-06-21', '321098765');
go

-- TRIGGER Remoçao da encomenda aumenta o stock do material
CREATE TRIGGER trg_encomenda_arrival ON encomenda INSTEAD OF DELETE
AS 
BEGIN
    -- Update the Stock column in the material table
    UPDATE material
    SET Stock = Stock + c.Unidades
    FROM contem c
    WHERE material.N_Referencia_Material = c.FK_N_Referencia_Material
      AND c.FK_Codigo IN (SELECT Codigo FROM deleted);

    DELETE FROM contem
    WHERE FK_Codigo IN (SELECT Codigo FROM deleted);

    DELETE FROM encomenda
    WHERE Codigo IN (SELECT Codigo FROM deleted);
END;
-- WORKING
-- TEST:
--delete from encomenda where Codigo = 2;
--select * from deleted;
--select * from contem;
--select * from encomenda;
--select * from contem;
--select * from material; 

--drop trigger trg_encomenda_arrival;
go

-- TRIGGER Funcionario não pode ter mais de 2 projetos ao mesmo tempo (insert)
create trigger trg_responsavel_projeto on responsavel after insert
as
begin
    if exists (
            select 1
            from inserted i
            inner join responsavel r on i.FK_NIF_Funcionario = r.FK_NIF_Funcionario
            where i.FK_NIF_Funcionario = r.FK_NIF_Funcionario
            group by i.FK_NIF_Funcionario
            having count(*) > 2
            )
    begin
        raiserror('Funcionario não pode ter mais de 2 projetos ao mesmo tempo', 16, 1);
        rollback transaction;
    end;
end;
-- WORKING;
-- TEST:
--insert into responsavel (FK_NIF_Funcionario, FK_ID_Projeto, FK_NIF_Cliente) values('123456789', 4, '210987654');
--insert into responsavel (FK_NIF_Funcionario, FK_ID_Projeto, FK_NIF_Cliente) values('234567890', 4, '210987654');
--insert into responsavel (FK_NIF_Funcionario, FK_ID_Projeto, FK_NIF_Cliente) values('234567890', 1, '987654321');
--select * from responsavel;
--select * from funcionario;
--select * from projeto;

go

-- TRIGGER no update da data de conclusão de um projeto (diferença entre o dia conclusão de um projeto e dia atual não pode ser menor que a duração do projeto)
create trigger trg_dataConclusao on projeto after update, insert
as
begin
    declare @CurrentDate date;
    set @CurrentDate = getdate();  -- Retrieve current date

    if update(Data_conclusao) or exists(select 1 from inserted)
    begin
        if exists (
            select p.ID
            from projeto p
            join inserted i ON p.ID = i.ID
            where datediff(day, @CurrentDate, i.Data_conclusao) < p.Duracao
        )
        begin
            raiserror('A data de conclusão do projeto não pode ser menor que a duração do mesmo.', 16, 1);
            rollback transaction;
        end
    end
end;
-- WORKING


--drop trigger trg_update_dataConclusao

-- TEST1:
-- *erro*
-- UPDATE projeto SET Data_conclusao = '2023-05-28' WHERE ID = 1;

-- *possível*
-- UPDATE projeto SET Data_conclusao = '2023-05-31' WHERE ID = 1;
-- select * from projeto

-- TEST2:
-- *erro*

-- insert into pessoa(Mail, CC, Nome, Telemovel, NIF) values('teste@gmail.com', '99991111', 'Testes', '912345678', '111222333')
-- insert into cliente(Localizacao, Distancia, FK_NIF) values ('testLocaliz', 100, '111222333');
-- insert into projeto(ID, N_Janelas, N_Portas, N_Portadas, Duracao, Data_conclusao, FK_NIF_Cliente) values(8, 10, 5, 2, 20, '2023-06-02', '111222333')

go

CREATE TRIGGER trg_delete_fornecedor ON fornecedor INSTEAD OF DELETE
AS
BEGIN
	-- Delete from the 'fornece' table
	DELETE FROM fornece
	WHERE FK_NIF_Fornecedor IN (SELECT NIF FROM deleted);

	-- Delete from the 'fornecedor' table
	DELETE FROM fornecedor
	WHERE NIF IN (SELECT NIF FROM deleted);

	END;

--SELECT * FROM fornecedor;
--SELECT * FROM fornece;

--DROP TRIGGER trg_delete_fornecedor;

--DELETE FROM fornecedor WHERE NIF = '987654321';
go


-- Trigger for the "cliente" table
CREATE TRIGGER VerificarNIFs_Cliente ON cliente AFTER INSERT 
AS 
BEGIN
    -- Check if the NIF of the inserted client matches any employee's NIF
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN funcionario f ON i.FK_NIF = f.FK_NIF
    )
    BEGIN
        RAISERROR('O NIF do cliente deve ser diferente do NIF do funcionário.', 16, 1);
        ROLLBACK TRANSACTION;
        DELETE c
        FROM cliente c
        INNER JOIN inserted i ON c.FK_NIF = i.FK_NIF;
    END;
END;
GO

-- Trigger for the "funcionario" table
CREATE TRIGGER VerificarNIFs_Funcionario ON funcionario AFTER INSERT 
AS 
BEGIN
    -- Check if the NIF of the inserted employee matches any client's NIF
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN cliente c ON i.FK_NIF = c.FK_NIF
    )
    BEGIN
        RAISERROR('O NIF do funcionário deve ser diferente do NIF do cliente.', 16, 1);
        ROLLBACK TRANSACTION;
        DELETE f
        FROM funcionario f
        INNER JOIN inserted i ON f.FK_NIF = i.FK_NIF;
    END;
END;
GO



--SELECT * FROM cliente;
--SELECT * FROM funcionario;

----DROP TRIGGER VerificarNIFs;

--INSERT INTO cliente (Localizacao, Distancia, FK_NIF) VALUES ('Porto', 20, '123456789'); -- Ja existe  no funcionario logo da RAISERROR('O NIF do cliente deve ser diferente do NIF do funcionário.', 16, 1); ROLLBACK TRANSACTION;
--insert into funcionario(Ordenado, Seguro, Idade, FK_NIF) values(800, 'Não', 27, '987654321'); -- Este não funciona

