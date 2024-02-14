# BD: Guião 9


## ​9.1
 
### *a)*

```
create proc rem_essn @ssn VARCHAR(9)
as
	begin
		delete from works_on where Essn = @ssn;
		delete from dependent_ where Essn = @ssn;
		update department set Mgr_ssn = NULL where Mgr_ssn = @ssn;
		update employee set Super_ssn =	NULL where Super_ssn = @ssn;
		delete from employee where Ssn = @ssn;
	end

go

select * from employee
exec rem_essn 12652121;
drop proc rem_essn ;
select * from department;
```

### *b)* 

```
go

create proc getEmployeeMgr (@essn as char(9) output, @num_anos as tinyint output)

as
	begin
		select @essn = Mgr_ssn, @num_anos=DATEDIFF(YEAR, Mgr_start_date, GETDATE())
		from department where Mgr_start_date is not null order by Mgr_start_date desc; -- desc para nos dar o mais antigo

		select Fname, Minit, Lname, ssn from employee join department on Ssn = Mgr_ssn;
	end

go

declare @essn as char(9), @num_anos as tinyint;
exec getEmployeeMgr @essn output, @num_anos output;
select @essn, @num_anos;

drop proc getEmployeeMgr;

```

### *c)* 

```
go 

create trigger mgrDepOnlyOne on DEPARTMENT
after insert, update
as
begin
	declare @essn as char(9);
	select @essn=mgr_ssn from inserted;
	print @essn;
	if ((select count(*) from department where mgr_ssn=@essn) > 1)
	begin
		raiserror ('Não é permitido que um Funcionario seja gestor de mais do que um departamento!',16,1);
		rollback tran;
	end
end
go

--PARA VER O ERRO DESCOMENTAR A LINHA ABAIXO
--INSERT INTO department VALUES('Comercial',2,21312332,'2013-05-16');

go

select * from DEPARTMENT;
select * from EMPLOYEE;
```

### *d)* 

```
GO
create trigger vencAdequado on EMPLOYEE after insert, update as 
begin 
	declare @essn as char(9), @Ssalary as DECIMAL(10,2), @Esalary as DECIMAL(10,2), @dno as int;
	SELECT @essn=inserted.Ssn, @Esalary=inserted.Salary, @dno=inserted.Dno FROM inserted;
	select @Ssalary=EMPLOYEE.Salary FROM DEPARTMENT
		JOIN EMPLOYEE ON DEPARTMENT.Mgr_ssn=EMPLOYEE.Ssn
		WHERE @Dno=DEPARTMENT.Dnumber;
	IF @Esalary>@Ssalary 
	BEGIN
		UPDATE EMPLOYEE SET EMPLOYEE.Salary=@Ssalary-1 WHERE EMPLOYEE.Ssn=@Essn;
	END
end
--Testes
go 
delete from EMPLOYEE where Ssn = 129996999;
delete from EMPLOYEE where Ssn = 128886888;

INSERT INTO EMPLOYEE VALUES ('Rafa', 'M', 'Amorim', 129996999, '2000-04-25', 'Lixo', 'M', 1201, 21312332, 1);-- Fica 1199 porque é maior que o Mgr
INSERT INTO EMPLOYEE VALUES ('Tiago', 'J', 'Alves', 128886888, '2010-05-09', 'Caminhos de Belem', 'M', 1200, 21312332, 1); -- Mantem porque é igual ao Mgr
SELECT Fname, Ssn, Salary, Super_ssn, Dno FROM EMPLOYEE;

```

### *e)* 

```
go
create function projects (@Ssn varchar(9)) returns @table table
	(Pname	varchar(30),
	Plocation varchar(20))
as
begin
	insert @table
		select Pname,Plocation
		from works_on, project
		where Essn = @Ssn and Pno = Pnumber;
	return;
end
-- TESTE
go
select * from projects(183623612);
```

### *f)* 

```
go
create function aboveAvgSalary (@dnumber int) returns @table table
	(Ssn varchar(9), 
	Fname varchar(15),
	Minit char(1),
	Lname varchar(15))
as
begin
	insert @table
		select Ssn, Fname, Minit, Lname
		from employee inner join(select Dno, avg(Salary) as avg_sal
								 from department, employee
								 where Dno=Dnumber
								 group by Dno) as avg_sal_dep
		on	employee.Dno =  @dnumber and avg_sal_dep.Dno = employee.Dno and Salary > avg_sal;
	return;
end

 go

-- TESTE
select Dno, avg(Salary) as avg_sal
from department, employee
where Dno=Dnumber
group by Dno;
select * from employee;
select * from aboveAvgSalary(2);
```

### *g)* 

```
 go

 create function employeeDeptHighAverage(@noDep int)
 returns @table table (
 		pname varchar(30),
 		pnumber int,
 		plocation varchar(20),
 		dnum int, 
 		budget float,
 		totalbudget float )
 as
 begin
 	declare c cursor
 	for
 		select Pname, Pnumber, Plocation, Dnum, sum((Salary*1.0*Hours_)/40) as budget
 		from project inner join works_on
 		on Pnumber=Pno inner join employee
 		on Essn=Ssn
 		where Dnum=@noDep
 		group by Pname, Pnumber, Plocation, Dnum;

 	declare @pname as varchar(30), @pnumber as int, @plocation as varchar(20), @dnum as int, @budget as float, @totalbudget as float;
 	set @totalbudget = 0;
	
 	open c;

 	fetch c into @pname, @pnumber, @plocation, @dnum, @budget;

 	while @@FETCH_STATUS = 0
 	begin
 		set @totalbudget += @budget;
 		insert into @table values (@pname, @pnumber, @plocation, @dnum, @budget, @totalbudget);
 		fetch c into @pname, @pnumber, @plocation, @dnum, @budget;
 	end

 	close c;

 	deallocate c;

 	return;
 end

  go

 -- TESTE
 SELECT * FROM employeeDeptHighAverage(3);
```

### *h)* 

```
--Instead
GO
CREATE TRIGGER delete_department_insteadOf ON department
INSTEAD OF DELETE
AS
BEGIN
	DECLARE @Dnumber AS INT;
	SELECT @Dnumber = Dnumber FROM deleted;

	IF NOT (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'Department_Deleted'))
	BEGIN
		CREATE TABLE Department_Deleted(
			Dname VARCHAR(15) NOT NULL,
			Dnumber INT NOT NULL,
			Mgr_ssn CHAR(9) NOT NULL,
			Mgr_start_date DATE,
			PRIMARY KEY (Dnumber),
		);
		INSERT INTO Department_Deleted SELECT * FROM deleted;
		DELETE FROM DEPARTMENT WHERE Dnumber = @Dnumber;
	END
	ELSE
	BEGIN
		INSERT INTO Department_Deleted SELECT * FROM deleted;
		DELETE FROM DEPARTMENT WHERE Dnumber = @Dnumber;
	END
END
GO

--After
GO
CREATE TRIGGER delete_department_after ON department
AFTER DELETE
AS
BEGIN
	IF NOT (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'Department_Deleted'))
	BEGIN
		CREATE TABLE Department_Deleted(
			Dname VARCHAR(15) NOT NULL,
			Dnumber INT NOT NULL,
			Mgr_ssn CHAR(9) NOT NULL,
			Mgr_start_date DATE,
			PRIMARY KEY (Dnumber),
		);
		INSERT INTO Department_Deleted SELECT * FROM deleted;
	END
	ELSE
	BEGIN
		INSERT INTO Department_Deleted SELECT * FROM deleted;
	END
END
GO

```

### *i)* 

```
 SPs e UDFs são igualmente compilados, uma única vez, e optimizados.

 Diferenças:
 	- SPs podem retornar vários valores (record-sets), enquanto que UDFs apenas retornam um único valor.
 	- SPs podem ter parâmetros de saída, enquanto que UDFs apenas têm parâmetros de entrada.
 	- SPs não podem usar as cláusulas SELECT/WHERE/HAVING, enquanto que UDFs podem.
 	- SPs permitem chamar outras SPs, enquanto que UDFs não.
 	- SPs permitem gerir exceções, enquanto que UDFs não.

 SPs podem ser utilizados para rotinas de backup e limpeza de base de dados.
 UDFs podem ser utilizados para cálculos de valores, como por exemplo, calcular o salário de um empregado.
```
