use p7g5;

--SELECT 'ALTER TABLE ' + OBJECT_NAME(f.parent_object_id) + ' DROP CONSTRAINT ' + f.name + ';' FROM sys.foreign_keys f

-- Verificar se temos tudo bem;
--SELECT * FROM sys.triggers;
--SELECT * FROM sys.objects WHERE type_desc LIKE '%FUNCTION%';
--SELECT * FROM sys.tables;

go

ALTER TABLE cliente     DROP CONSTRAINT if exists FK_cliente_constraint;
ALTER TABLE funcionario DROP CONSTRAINT if exists FK_funcionario_constraint;
ALTER TABLE projeto     DROP CONSTRAINT if exists FK_projeto_constraint;
ALTER TABLE responsavel DROP CONSTRAINT if exists FK_responsavel_constraint1;
ALTER TABLE responsavel DROP CONSTRAINT if exists FK_responsavel_constraint2;
ALTER TABLE necessita   DROP CONSTRAINT if exists FK_necessita_constraint1;
ALTER TABLE necessita   DROP CONSTRAINT if exists FK_necessita_constraint2;
ALTER TABLE contem      DROP CONSTRAINT if exists FK_contem_constraint2;
ALTER TABLE contem      DROP CONSTRAINT if exists FK_contem_constraint1;
ALTER TABLE fornece     DROP CONSTRAINT if exists FK_fornece_constraint1;
ALTER TABLE fornece     DROP CONSTRAINT if exists FK_fornece_constraint2;
ALTER TABLE estore      DROP CONSTRAINT if exists FK_estore_constraint;
ALTER TABLE janela      DROP CONSTRAINT if exists FK_janela_constraint;
ALTER TABLE porta       DROP CONSTRAINT if exists FK_porta_constraint;
ALTER TABLE acessorio   DROP CONSTRAINT if exists FK_acessorio_constraint;
ALTER TABLE vidro       DROP CONSTRAINT if exists FK_vidro_constraint;

DROP TABLE IF EXISTS pessoa;
DROP TABLE IF EXISTS cliente;
DROP TABLE IF EXISTS funcionario;
DROP TABLE IF EXISTS projeto;
DROP TABLE IF EXISTS material;
DROP TABLE IF EXISTS necessita;
DROP TABLE IF EXISTS encomenda;
DROP TABLE IF EXISTS contem;
DROP TABLE IF EXISTS fornecedor;
DROP TABLE IF EXISTS fornece;
DROP TABLE IF EXISTS estore;
DROP TABLE IF EXISTS janela;
DROP TABLE IF EXISTS porta;
DROP TABLE IF EXISTS acessorio;
DROP TABLE IF EXISTS vidro;
DROP TABLE IF EXISTS responsavel;


drop function IF EXISTS SalarioSuperior;
drop function IF EXISTS dbo.CalcularOrcamento;
drop function IF EXISTS ListarMateriaisProjeto;
drop function IF EXISTS ListarMateriaisPorPreco;
drop function IF EXISTS ObterDetalhesFornecedoresPorProjeto;
drop function IF EXISTS Dist_Total;
DROP FUNCTION IF EXISTS ListarClientePorProjeto;

drop trigger IF EXISTS trg_delete_projeto;
drop trigger IF EXISTS trg_delete_projeto2;
drop trigger if exists trg_delete_func;
drop trigger if exists trg_delete_client;
drop trigger IF EXISTS trg_insert_projeto;
drop trigger IF EXISTS trg_encomenda_arrival;
drop trigger IF EXISTS trg_responsavel_projeto;
drop trigger IF EXISTS trg_dataConclusao;
drop trigger IF EXISTS trg_update_dataConclusao;
drop trigger IF EXISTS trg_delete_fornecedor;
drop trigger IF EXISTS VerificarNIFs;

drop proc if exists sp_add_funcionario;
drop proc if exists sp_add_cliente;
drop proc if exists ListarProjetosComUrgencia;
drop proc if exists sp_update_projeto;

drop view if exists FuncionariosSemResponsabilidadesView;
drop view if exists FuncionariosResponsaveisView;
drop view if exists Caracteristicas_Projetos_Clientes;
drop view if exists Caracteristicas_Clientes_Sem_Projetos;

drop INDEX if exists index_preco_designacao on material;
drop INDEX if exists index_nome on pessoa;









