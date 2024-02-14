use empresaGuiao9;

--SELECT 'ALTER TABLE ' + OBJECT_NAME(f.parent_object_id) + ' DROP CONSTRAINT ' + f.name + ';'
--FROM sys.foreign_keys f

---- AS LINHAS ABAIXO RESULTAM DA INSTRUÇÃO ACIMA SERVE PARA APAGAR AS CONSTRAINTS QUE EXISTEM NA BD
--ALTER TABLE EMPLOYEE DROP CONSTRAINT FK__EMPLOYEE__Dno__0662F0A3;
--ALTER TABLE EMPLOYEE DROP CONSTRAINT FK__EMPLOYEE__Super___753864A1;
--ALTER TABLE DEPARTMENT DROP CONSTRAINT FK__DEPARTMEN__Mgr_s__7814D14C;
--ALTER TABLE Project DROP CONSTRAINT FK__Project__Dnum__7EC1CEDB;

drop TABLE if exists EMPLOYEE; 
drop TABLE if exists DEPARTMENT; 
drop TABLE if exists DEPT_LOCATIONS; 
drop TABLE if exists Project; 
drop TABLE if exists Works_on; 
drop TABLE if exists Dependents; 

drop trigger if exists vencAdequado;
drop trigger if exists delete_department_insteadOf;
drop trigger if exists mgrDepOnlyOne;
--DELETE FROM DEPARTMENT WHERE Dnumber = 4;


drop trigger if exists dpt_manager;

drop proc IF EXISTS sp_dept_managers;