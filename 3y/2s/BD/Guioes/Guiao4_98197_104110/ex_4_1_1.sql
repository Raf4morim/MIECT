use Rent_a_Car;

create table Balcao(
	Nome		varchar(20)		not null,
	Num_Balcao	smallint		not null,
	Endereco	varchar(50)		not null,

	constraint  UNQnome		unique(Nome),
	constraint  PKBalcao	primary key(Num_Balcao)
);

create table Cliente(
	NIF			integer		not null	unique,
	Num_Carta	integer		not null	unique,
	Nome		varchar(20)	not null,
	Endereco	varchar(50) not null,

	primary key (NIF),
);

create table TipoVeiculo (
	ArCondicionado		integer check(ArCondicionado = 0 or ArCondicionado = 1), --boolean
	Designacao			varchar(40),
	Codigo_TipoVeiculo	varchar(50) NOT NULL,

	primary key(Codigo_TipoVeiculo),
);

create table Veiculo (
	Ano				integer		not null,
	Matricula		char(8)		not null,
	Marca			varchar(15) not null,
	FK_TipoVeiculo	varchar(50) not null,

	primary key(Matricula),
	foreign key(FK_TipoVeiculo) references TipoVeiculo(Codigo_TipoVeiculo),
);

create table Aluguer (
	Num_Aluguer		integer		not null,
	Duracao			time		not null,
	Data_Aluguer	date		not null,
	FK_Cliente		integer		not null,
	FK_Balcao		smallint	not null,
	FK_Veiculo		char(8)		not null,

	primary key(Num_Aluguer),
	foreign key(FK_Cliente) references Cliente(NIF),
	foreign key(FK_Balcao) references Balcao(Num_Balcao),
	foreign key(FK_Veiculo) references Veiculo(Matricula),
	);

create table Similaridade(
	Codigo1			VARCHAR(50) not null,
	Codigo2			VARCHAR(50) not null,
	
	primary key(Codigo1, Codigo2),
	foreign key(Codigo1) references TipoVeiculo(Codigo_TipoVeiculo),
	foreign key(Codigo2) references TipoVeiculo(Codigo_TipoVeiculo),
);

create table Ligeiro(
	NumLugares		smallint	not null	check(NumLugares<=9),
	Combustivel		varchar(20) not null,
	Portas			smallint	not null,
	FK_TipoVeiculo	varchar(50) not null,

	foreign key(FK_TipoVeiculo)	references TipoVeiculo (Codigo_TipoVeiculo),
);

create table Pesado(
	Peso			integer  check(Peso > 3500) not null,
	Passageiros		integer check(Passageiros > 0) not null,
	FK_TipoVeiculo	varchar(50) not null,

	foreign key(FK_TipoVeiculo)	references TipoVeiculo (Codigo_TipoVeiculo),
);