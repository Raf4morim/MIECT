use company;

insert into department(Dname,Dnumber,Mgr_ssn,Mgr_start_date) values('Investigacao',1,21312332,'2010-08-02')
insert into department(Dname,Dnumber,Mgr_ssn,Mgr_start_date) values('Comercial',2,321233765,'2013-05-16')
insert into department(Dname,Dnumber,Mgr_ssn,Mgr_start_date) values('Logistica',3,41124234,'2013-05-16')
insert into department(Dname,Dnumber,Mgr_ssn,Mgr_start_date) values('Recursos Humanos',4,12652121,'2014-04-02')
insert into department(Dname,Dnumber,Mgr_ssn,Mgr_start_date) values('Desporto',5,null,null)

insert into employee(Fname,Minit,Lname,Ssn,Bdate,e_Address,Sex,Salary,Super_ssn,Dno) values('Paula','A','Sousa','183623612','2001-08-11','Rua da FRENTE','F',1450,null,3)
insert into employee(Fname,Minit,Lname,Ssn,Bdate,e_Address,Sex,Salary,Super_ssn,Dno) values('Carlos','D','Gomes','21312332','2000-01-01','Rua XPTO','M',1200,null,1)
insert into employee(Fname,Minit,Lname,Ssn,Bdate,e_Address,Sex,Salary,Super_ssn,Dno) values('Juliana','A','Amaral','321233765','1980-08-11','Rua BZZZZ','F',1350,null,3)
insert into employee(Fname,Minit,Lname,Ssn,Bdate,e_Address,Sex,Salary,Super_ssn,Dno) values('Maria','I','Pereira','342343434','2001-05-01','Rua JANOTA','F',1250,'21312332',2)
insert into employee(Fname,Minit,Lname,Ssn,Bdate,e_Address,Sex,Salary,Super_ssn,Dno) values('Joao','G','Costa','41124234','2001-01-01','Rua YGZ','M',1300,'21312332',2)
insert into employee(Fname,Minit,Lname,Ssn,Bdate,e_Address,Sex,Salary,Super_ssn,Dno) values('Ana','L','Silva','12652121','1990-03-03','Rua ZIG ZAG','F',1400,'21312332',2)

insert into dept_locations(Dnumber,Dlocation) values(2,'Aveiro')
insert into dept_locations(Dnumber,Dlocation) values(3,'Coimbra')

insert into project(Pname,Pnumber,Plocation,Dnum) values('Aveiro Digital',1,'Aveiro',3)
insert into project(Pname,Pnumber,Plocation,Dnum) values('BD Open Day',2,'Espinho',2)
insert into project(Pname,Pnumber,Plocation,Dnum) values('Dicoogle',3,'Aveiro',3)
insert into project(Pname,Pnumber,Plocation,Dnum) values('GOPACS',4,'Aveiro',3)

insert into works_on(Essn,Pno,Hours_) values('183623612',1,20)
insert into works_on(Essn,Pno,Hours_) values('183623612',3,10)
insert into works_on(Essn,Pno,Hours_) values('21312332',1,20)
insert into works_on(Essn,Pno,Hours_) values('321233765',1,25)
insert into works_on(Essn,Pno,Hours_) values('342343434',1,20)
insert into works_on(Essn,Pno,Hours_) values('342343434',4,25)
insert into works_on(Essn,Pno,Hours_) values('41124234',2,20)
insert into works_on(Essn,Pno,Hours_) values('41124234',3,30)

insert into dependent_(Essn,Dependent_name,Sex,Bdate,Relationship) values('21312332','Joana Costa','F','2008-04-01','Filho')
insert into dependent_(Essn,Dependent_name,Sex,Bdate,Relationship) values('21312332','Maria Costa','F','1990-01-05','Neto')
insert into dependent_(Essn,Dependent_name,Sex,Bdate,Relationship) values('21312332','Rui Costa','M','2000-08-04','Neto')
insert into dependent_(Essn,Dependent_name,Sex,Bdate,Relationship) values('321233765','Filho Lindo','M','2001-02-22','Filho')
insert into dependent_(Essn,Dependent_name,Sex,Bdate,Relationship) values('342343434','Rosa Lima','F','2006-03-11','Filho')
insert into dependent_(Essn,Dependent_name,Sex,Bdate,Relationship) values('41124234','Ana Sousa','F','2007-04-13','Neto')
insert into dependent_(Essn,Dependent_name,Sex,Bdate,Relationship) values('41124234','Gaspar Pinto','M','2006-02-08','Sobrinho')




