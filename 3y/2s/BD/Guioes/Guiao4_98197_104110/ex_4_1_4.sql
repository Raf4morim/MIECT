use PrescricaoEletronicaMedicamentos;


create table Medico(
	No_Id_SNS		integer		not null,
	Nome			varchar(20) not null,
	Especialidade	varchar(50)	not null,

	primary key (No_Id_SNS),
);

create table Paciente(
	No_Utente		integer		not null check(No_Utente > 0 and No_Utente < 999999999),
	Nome			varchar(20) not null,
	Data_Nasc		date		not null,
	Endereco		varchar(50)		not null,

	primary key (No_Utente),
);

create table Farmaceutica(
	No_Reg_Nacional integer not null,
	Nome			varchar(20) not null,
	Telefone		char(9) not null check(Telefone like '[0-9]{9}'),
	Endereco		varchar(50)		not null,

	primary key(No_Reg_Nacional),
);

create table Farmacia(
	NIF			varchar(9)	not null check(NIF like '[0-9]{9}') unique,
	Nome		varchar(20) not null,
	Telefone	char(9)	not null check(Telefone like '[0-9]{9}'),
	Endereco	varchar(50)	not null,

	primary key(NIF),
);

create table Farmaco(
	Nome_Comercial		varchar(20) not null,
	Formula				varchar(50)	not null,
	FK_No_Reg_Nacional	integer not null,

	primary key(Nome_Comercial, FK_No_Reg_Nacional),
	foreign key(FK_No_Reg_Nacional) references Farmaceutica(No_Reg_Nacional),
);

create table Prescricao(
	No_Prescricao		integer not null check(No_Prescricao > 0),
	Data_Prescricao		date not null,
	FK_No_Utente		integer not null,
	FK_No_Id_SNS		integer		not null,
	FK_NIF				varchar(9)	not null check(FK_NIF like '[0-9]{9}') unique,
	
	primary key(No_Prescricao),
	foreign key(FK_No_Utente) references Paciente(No_Utente),
	foreign key(FK_No_Id_SNS) references Medico(No_Id_SNS),
	foreign key(FK_NIF) references Farmacia(NIF),
);

create table Prescreve(
	FK_No_Prescricao	integer not null check(FK_No_Prescricao > 0),
	FK_No_Reg_Nacional	integer not null,
	FK_Nome_Comercial	varchar(20) not null,

	primary key (FK_No_Prescricao, FK_No_Reg_Nacional, FK_Nome_Comercial),
	foreign key(FK_No_Prescricao) references Prescricao(No_Prescricao),
	foreign key(FK_No_Reg_Nacional) references Farmaceutica(No_Reg_Nacional),
	foreign key(FK_Nome_Comercial) references Farmaco(Nome_Comercial),
);

create table Vende(
	FK_NIF				varchar(9)	not null check(FK_NIF like '[0-9]{9}') unique,
	FK_Nome_Comercial	varchar(20) not null,
	FK_No_Reg_Nacional	integer not null,

	primary key (FK_NIF, FK_No_Reg_Nacional, FK_Nome_Comercial),
	foreign key(FK_NIF) references Farmacia(NIF),
	foreign key(FK_No_Reg_Nacional) references Farmaceutica(No_Reg_Nacional),
	foreign key(FK_Nome_Comercial) references Farmaco(Nome_Comercial),
);