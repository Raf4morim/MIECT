use company

--a) 
select Fname,Lname,Pname,Ssn 
from project inner join employee on Dno=Dnum

--b)
select Fname,Minit,Lname 
from employee 
where Super_ssn = (
	select Carlos_ssn.Ssn 
	from employee as Carlos_ssn
	where Fname='Carlos' and Minit='D' and Lname='Gomes')

--c)
select Pname, total_worked 
from project inner join(
		select Pno, sum(Hours_) as total_worked
		from works_on
		group by Pno) as project_hours
on Pnumber=Pno

--d)
select employee.Fname, employee.Lname, project.Pname, employee.Dno, works_on.Hours_
from employee 
inner join works_on on employee.Ssn=works_on.Essn
inner join project on works_on.Pno=project.Pnumber
where works_on.Hours_>20 and project.Pname='Aveiro Digital';

--e)
select employee.Fname, employee.Minit, employee.Lname
from employee 
left outer join works_on on employee.Ssn=works_on.Essn
where Pno is null

--f)
select department.Dname, avg(employee.Salary) as Salario_F 
from department 
inner join employee on department.Dnumber=employee.Dno
where employee.Sex='F'
group by department.Dname

--g)
select employee.Fname, employee.Minit, employee.Lname, count(dependent_.Essn) as nDep
from employee
inner join dependent_ on employee.Ssn=dependent_.Essn
group by employee.Fname, employee.Minit, employee.Lname
having count(dependent_.Essn)>2

--h)
select employee.Fname, employee.Lname
from department
inner join employee on department.Mgr_ssn=employee.Ssn
left outer join dependent_ on  employee.Ssn=dependent_.Essn
where Essn is null

--i)
select Fname,Minit, Lname, e_Address
from dept_locations inner join
	(	select distinct employee.Fname,employee.Minit,employee.Lname,employee.e_Address, employee.Dno
		from project 
		inner join works_on on project.Pnumber=works_on.Pno
		inner join employee on works_on.Essn=employee.Ssn
		where project.Plocation='Aveiro') as funcionarios_proj_Aveiro
on dept_locations.Dnumber=funcionarios_proj_Aveiro.Dno
where dept_locations.Dlocation!='Aveiro'
