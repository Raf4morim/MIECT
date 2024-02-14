use company;

create table department(
	Dname	VARCHAR(25)	not null,
	Dnumber INT	 check(Dnumber>0) not null,
	Mgr_ssn VARCHAR(9) ,
	Mgr_start_date DATE, 

	primary key(Dnumber)
);

create table employee(
	Fname VARCHAR(15) not null,
	Minit CHAR	not null,
	Lname VARCHAR(15) not null,
	Ssn VARCHAR(9) not null,
	Bdate DATE not null,
	e_Address VARCHAR(40) not null, 
	Sex	CHAR	check(Sex='F' OR Sex='M') not null,
	Salary	INT check(Salary >=0) not null,
	Super_ssn VARCHAR(9),
	Dno	INT,

	primary key(Ssn),
	foreign key(Dno) references department(Dnumber)
);

alter table employee add constraint e_superSsn foreign key(Super_ssn) references employee(Ssn);

create table dept_locations(
	Dnumber INT,
	Dlocation VARCHAR(20) not null,

	primary key(Dnumber,Dlocation),
	foreign key(Dnumber) references department(Dnumber)
);

create table project(
	Pname VARCHAR(30) not null,
	Pnumber INT check(Pnumber>0) not null,
	Plocation VARCHAR(20) not null,
	Dnum INT,

	primary key(Pnumber),
	foreign key(Dnum) references department(Dnumber)
);

create table works_on(
	Essn VARCHAR(9),
	Pno INT,
	Hours_ INT not null,

	primary key(Essn,Pno),
	foreign key(Essn) references employee(Ssn),
	foreign key(Pno) references project(Pnumber)
);

create table dependent_(
	Essn VARCHAR(9),
	Dependent_name VARCHAR(30) not null,
	Sex	CHAR	check(Sex='F' OR Sex='M') not null,
	Bdate DATE not null,
	Relationship VARCHAR(10) not null,

	primary key(Essn, Dependent_name),
	foreign key(Essn) references employee(Ssn)
);