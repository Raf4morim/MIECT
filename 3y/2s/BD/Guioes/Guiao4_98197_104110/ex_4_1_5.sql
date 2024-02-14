use GestaoConferencias;


create table Conferencia(
	Id			integer not null,

	primary key (Id),
);

create table ArtigoCientifico(
	Nome		varchar(20) not null,
	NumRegito	integer not null,
	FK_Id		integer not null,

	primary key(NumRegito),
	foreign key(FK_Id) references Conferencia(Id),

);

create table SistemaInfo(
	Id			integer not null,

	primary key (Id),
);

create table Instituicao(
	Nome			varchar(20)		not null,
	Endereco		varchar(50)		not null,

	primary key(Endereco),
);

create table Pessoa(
	Nome		varchar(20) not null,
	Mail		varchar(20)	not null check(Mail like'[a-zA-Z_-0-9]+@[a-Z]+.[a-z]+'),

	primary key (Mail),
);

create table Participante(
	Morada				varchar(20) not null,
	DataInscricao		varchar(50)	not null,
	FK_Mail				varchar(20)	not null check(FK_Mail like'[a-zA-Z_-0-9]+@[a-Z]+.[a-z]+'),
	FK_Endereco			varchar(50)		not null,

	primary key(FK_Mail),
	foreign key(FK_Mail) references Pessoa(Mail),
	foreign key(FK_Endereco) references Instituicao(Endereco),
);

create table Autor(
	FK_Mail				varchar(20)	not null check(FK_Mail like'[a-zA-Z_-0-9]+@[a-Z]+.[a-z]+'),
	FK_Endereco			varchar(50)		not null,

	primary key(FK_Mail),
	foreign key(FK_Mail) references Pessoa(Mail),
	foreign key(FK_Endereco) references Instituicao(Endereco),
);

create table Tem( -- Entre Autor e Artigo Cientifico N:M
	FK_NumRegito	integer not null,
	FK_Mail			varchar(20)	not null check(FK_Mail like'[a-zA-Z_-0-9]+@[a-Z]+.[a-z]+'),

	primary key(FK_NumRegito, FK_Mail),
	foreign key(FK_NumRegito) references ArtigoCientifico(NumRegito),
	foreign key(FK_Mail) references Autor(FK_Mail),
);

create table Comprovativo(
	ID_Comprovativo			integer not null unique,
	LocalizacaoEletronica	varchar(50)	not null,
	IsencaoCustoInscricao	bit  not null, --boolean
	FK_ID_Sistema_Info		integer		not null,

	primary key(ID_Comprovativo),
	foreign key(FK_ID_Sistema_Info) references SistemaInfo(Id),
);

create table Estudante(
	FK_Mail				varchar(20)	not null check(FK_Mail like'[a-zA-Z_-0-9]+@[a-Z]+.[a-z]+'),
	FK_ID_Comprovativo	integer		not null unique,

	primary key(FK_Mail),
	foreign key(FK_Mail) references Participante(FK_Mail),
	foreign key(FK_ID_Comprovativo) references Comprovativo(ID_Comprovativo),
);

create table NaoEstudante(
	FK_Mail					varchar(20)	not null check(FK_Mail like'[a-zA-Z_-0-9]+@[a-Z]+.[a-z]+'),
	ReferenciaTransBancaria	varchar(50) not null unique,

	primary key(FK_Mail),
	foreign key(FK_Mail) references Participante(FK_Mail),
);