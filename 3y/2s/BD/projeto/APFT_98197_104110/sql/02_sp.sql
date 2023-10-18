--------------------------------SPS------------------------------------

go

CREATE proc ListarProjetosComUrgencia
AS
BEGIN
    DECLARE @CurrentDate DATE;
    SET @CurrentDate = GETDATE();  -- Retrieve current date

    SELECT
        ID AS ID_Projeto,
        Data_conclusao,
        CASE
            -- For projects with duration <= 8 days
            WHEN Duracao <= 8 THEN
                CASE
                    WHEN DATEDIFF(DAY, @CurrentDate, Data_conclusao) <= 2 THEN 'muito elevada'  -- If 2 days or less
                    WHEN DATEDIFF(DAY, @CurrentDate, Data_conclusao) <= 4 THEN 'elevada'  -- If 4 days or less
                    ELSE 'm�dia'  -- If more than 4 days
                END
            -- For projects with duration > 8 and <= 15 days
            WHEN Duracao <= 15 THEN
                CASE
                    WHEN DATEDIFF(DAY, @CurrentDate, Data_conclusao) <= 2 THEN 'muito elevada'  -- If 2 days or less
                    WHEN DATEDIFF(DAY, @CurrentDate, Data_conclusao) <= 4 THEN 'elevada'  -- If 4 days or less
                    WHEN DATEDIFF(DAY, @CurrentDate, Data_conclusao) <= 6 THEN 'm�dia'  -- If 6 days or less
                    ELSE 'baixa'  -- If more than 6 days
                END
            -- For projects with duration > 15 and <= 30 days
            WHEN Duracao <= 30 THEN
                CASE
                    WHEN DATEDIFF(DAY, @CurrentDate, Data_conclusao) <= 4 THEN 'muito elevada'  -- If 4 days or less
                    WHEN DATEDIFF(DAY, @CurrentDate, Data_conclusao) <= 8 THEN 'elevada'  -- If 8 days or less
                    WHEN DATEDIFF(DAY, @CurrentDate, Data_conclusao) <= 14 THEN 'm�dia'  -- If 14 days or less
                    ELSE 'baixa'  -- If more than 14 days
                END
            -- For projects with duration > 30 days
            ELSE
                CASE
                    WHEN DATEDIFF(DAY, @CurrentDate, Data_conclusao) <= 10 THEN 'muito elevada'  -- If 10 days or less
                    WHEN DATEDIFF(DAY, @CurrentDate, Data_conclusao) <= 18 THEN 'elevada'  -- If 18 days or less
                    WHEN DATEDIFF(DAY, @CurrentDate, Data_conclusao) <= 25 THEN 'm�dia'  -- If 25 days or less
                    ELSE 'baixa'  -- If more than 25 days
                END
        END AS Urgencia
    FROM projeto
    WHERE DATEDIFF(DAY, @CurrentDate, Data_conclusao) <= 80;
END;

go

create proc sp_add_cliente	@Mail varchar(50),
							@CC char(8),
							@Nome varchar(20),
							@Telemovel char(9),
							@NIF char(9),
							@Localizacao varchar(20),
							@Distancia int
as
	begin
		insert into pessoa(Mail, CC, Nome, Telemovel, NIF) 
		values (@Mail, @CC, @Nome, @Telemovel, @NIF);
		insert into cliente(Localizacao, Distancia, FK_NIF)
		values (@Localizacao,@Distancia,@NIF);
	end

go

--drop proc sp_add_cliente;
--TEST:
--exec sp_add_cliente 'toneeeee@ua.pt','88668888','toze manel', '922201100','900900999', 'Cantanholas', 15;  

create proc sp_add_funcionario	@Mail varchar(50),
								@CC char(8),
								@Nome varchar(20),
								@Telemovel char(9),
								@NIF char(9),
								@Idade int,
								@Ordenado real,
								@Seguro char(3)
as
	begin
		insert into pessoa(Mail, CC, Nome, Telemovel, NIF) 
		values (@Mail, @CC, @Nome, @Telemovel, @NIF);
		insert into funcionario(Ordenado, Seguro, Idade, FK_NIF)
		values (@Ordenado,@Seguro,@Idade,@NIF);
	end

--exec sp_add_funcionario 'mariooo@ua.pt','88668889','M�rio Loisas', '922201101','678901234', 17, 1500, 'Sim';  
--select * from pessoa;
--select * from funcionario;


go

CREATE PROCEDURE sp_update_projeto
    @id INT,
    @nJanelas INT = NULL,
    @nPortas INT = NULL,
    @nPortadas INT = NULL,
    @duracao INT = NULL,
    @dataConclusao DATE = NULL,
    @material VARCHAR(50) = NULL,
    @unidades INT = NULL,
    @nifCliente INT = NULL
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        
        DECLARE @old_id AS INT;
        DECLARE @old_nJanelas AS INT;
        DECLARE @old_nPortas AS INT;
        DECLARE @old_nPortadas AS INT;
        DECLARE @old_duracao AS INT;
        DECLARE @old_dataConclusao AS DATE;

        SELECT @old_id = ID, @old_nJanelas = N_Janelas, @old_nPortas = N_Portas, @old_nPortadas = N_Portadas, @old_duracao = Duracao, @old_dataConclusao = Data_conclusao
        FROM projeto
        WHERE projeto.ID = @id;

        IF @old_id IS NOT NULL
        BEGIN
            IF (@nJanelas IS NOT NULL AND @old_nJanelas != @nJanelas)
            BEGIN
                UPDATE projeto SET N_Janelas = @nJanelas WHERE ID = @old_id;
                PRINT 'Número de janelas do projeto atualizado com sucesso.';
            END

            IF (@nPortas IS NOT NULL AND @old_nPortas != @nPortas)
            BEGIN
                UPDATE projeto SET N_Portas = @nPortas WHERE ID = @old_id;
                PRINT 'Número de portas do projeto atualizado com sucesso.';
            END

            IF (@nPortadas IS NOT NULL AND @old_nPortadas != @nPortadas)
            BEGIN
                UPDATE projeto SET N_Portadas = @nPortadas WHERE ID = @old_id;
                PRINT 'Número de portadas do projeto atualizado com sucesso.';
            END

            IF (@duracao IS NOT NULL AND @old_duracao != @duracao)
            BEGIN
                UPDATE projeto SET Duracao = @duracao WHERE ID = @old_id;
                PRINT 'Duração do projeto atualizada com sucesso.';
            END

            IF (@dataConclusao IS NOT NULL AND @old_dataConclusao != @dataConclusao)
            BEGIN
                UPDATE projeto SET Data_conclusao = @dataConclusao WHERE ID = @old_id;
                PRINT 'Data de conclusão do projeto atualizada com sucesso.';
            END

            IF (@nifCliente IS NOT NULL)
            BEGIN
                IF EXISTS (SELECT 1 FROM cliente WHERE FK_NIF = @nifCliente)
                BEGIN
                    UPDATE projeto SET FK_NIF_Cliente = @nifCliente WHERE ID = @old_id;
                    PRINT 'Projeto atribuído ao cliente atualizado com sucesso.';
                END
                ELSE
                BEGIN
                    PRINT 'O NIF fornecido não corresponde a nenhum cliente existente.';
                END
            END

            IF (@material IS NOT NULL AND @unidades IS NOT NULL)
            BEGIN
                IF EXISTS (SELECT 1 FROM necessita WHERE FK_ID_Projeto = @old_id AND FK_N_Referencia_Material = @material)
                BEGIN
                    UPDATE necessita SET Unidades = @unidades WHERE FK_ID_Projeto = @old_id AND FK_N_Referencia_Material = @material;
                    PRINT 'Unidades atualizadas com sucesso.';
                END
                ELSE
                BEGIN
                    INSERT INTO necessita (FK_N_Referencia_Material, Unidades, FK_ID_Projeto) VALUES (@material, @unidades, @old_id);
                    PRINT 'Material inserido com sucesso.';
                END
            END

            IF (@nJanelas IS NULL AND @nPortas IS NULL AND @nPortadas IS NULL AND @duracao IS NULL AND @dataConclusao IS NULL AND @material IS NULL AND @unidades IS NULL AND @nifCliente IS NULL)
            BEGIN
                PRINT 'Nenhum campo foi fornecido para atualização.';
            END
        END
        ELSE
        BEGIN
            PRINT 'O ID fornecido não corresponde a nenhum projeto existente.';
        END

        COMMIT;
    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE();
        ROLLBACK;
    END CATCH
END


--drop proc sp_update_projeto
--go
--EXEC sp_update_projeto @id = 1, @nJanelas = 30, @nifCliente = 987654321;


--select * from projeto;
--select * from necessita;
--select * from cliente;

