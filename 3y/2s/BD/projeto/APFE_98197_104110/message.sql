use projeto;

create table pessoa(
	Mail        varchar(20)	not null check(Mail like'[a-zA-Z_-0-9]+@[a-Z]+.[a-z]+'),
	CC          char(12)    not null unique check(CC like '[0-9]{8}'),
	Nome	    varchar(20)	not null,
    Telemovel   char(9)     not null check(Telemovel like '[0-9]{9}'),
    NIF         char(9)     not null check(NIF like '[0-9]{9}'),

	primary key(NIF)
);

create table cliente(
	Localizacao varchar(20) not null,
    Distancia   integer     not null,
    FK_NIF      char(9)     not null check(FK_NIF like '[0-9]{9}'),

	primary key(FK_NIF),
	foreign key(FK_NIF) references pessoa(NIF)
);

create table funcionario(
	Ordenado        real    not null check(Ordenado > 740.83),
	Seguro          integer not null check(Seguro = 0 or Seguro = 1), --boolean
    Idade           integer not null check(Idade > 16),
    FK_NIF          char(9) not null check(FK_NIF like '[0-9]{9}'),
    FK_ID_Projeto   integer not null,

	primary key(FK_NIF),
	foreign key(FK_NIF) references pessoa(NIF),
);

create table projeto(
    ID          		integer not null,
    N_Janelas   		integer not null,
    N_Portas    		integer not null,
    N_Portadas  		integer not null,
    Duracao     		time 	not null,
    FK_NIF_Cliente		char(9) not null check(FK_NIF_Cliente like '[0-9]{9}'),
    FK_NIF_Funcionario	char(9) not null,

	primary key(ID, FK_NIF_Cliente, FK_NIF_Funcionario),
	foreign key(FK_NIF_Cliente) references cliente(FK_NIF),
	foreign key(FK_NIF_Funcionario) references funcionario(FK_NIF)
);

alter table funcionario add constraint FK_ID_Projeto foreign key(FK_ID_Projeto) references projeto(ID);

create table material(
    N_Referencia_Material   	varchar(50) not null,
	Dimensao					varchar(20)	check(Dimensao like'[0-9]+x[0-9]'),
	Espessura					real,
	Preco						real not null,
	Stock						integer not null,
	Taxa_Iva					real not null,

	primary key(N_Referencia_Material),
);

create table necessita(
    FK_N_Referencia_Material   	varchar(50) not null,
	Unidades					integer not null,
	FK_ID_Projeto   			integer not null,
	FK_NIF_Cliente      char(9) not null,
    FK_NIF_Funcionario  char(9) not null

	primary key(FK_ID_Projeto, FK_N_Referencia_Material),
	foreign key(FK_ID_Projeto, FK_NIF_Cliente, FK_NIF_Funcionario) references projeto(ID, FK_NIF_Cliente, FK_NIF_Funcionario)
);

create table encomenda(
    FK_Codigo				integer not null,
	Data_Chegada		date not null,
    FK_ID_Projeto   	integer not null,
    FK_NIF_Cliente      char(9) not null,
    FK_NIF_Funcionario  char(9) not null,

	primary key(FK_Codigo),
	foreign key(FK_ID_Projeto, FK_NIF_Cliente, FK_NIF_Funcionario) references projeto(ID, FK_NIF_Cliente, FK_NIF_Funcionario)
);

create table contem(
    FK_ID_Projeto   			integer not null,
    FK_N_Referencia_Material   	varchar(50) not null,
	Unidades					integer not null,

	primary key(FK_ID_Projeto, FK_N_Referencia_Material),
);

create table fornecedor(
    NIF int,
    Nome varchar(20) not null,
    IBAN varchar(25) not null check(IBAN like '%PT50%[0-9]{21}%'), 
    Localizacao varchar(30) not null,
    Distancia int not null check(Distancia > 0),
    Telefone    char(9)    not null check(Telefone like '[0-9]{9}'),   /* Falta no diagrama */

    primary key(NIF)
);

create table fornece(
    FK_N_Referencia_Material   	varchar(50) not null,
    FK_NIF_Fornecedor int,

    primary key(FK_N_Referencia_Material, FK_NIF_Fornecedor),
    foreign key(FK_N_Referencia_Material) references material(N_Referencia_Material)
);

-- alter table fornece add constraint FK_NIF_Fornecedor foreign key(FK_NIF_Fornecedor) references fornecedor(NIF);

create table estore(
    FK_N_Referencia_Material   	varchar(50) not null,
    Controlo varchar(8) not null check(Controlo in ('Manual', 'Eletrico')),
    Termicidade varchar(20) not null check(Termicidade in ('Baixa', 'Media', 'Alta')),

    primary key(FK_N_Referencia_Material),
    foreign key(FK_N_Referencia_Material) references material(N_Referencia_Material)
);

create table janela(
    FK_N_Referencia_Material   	varchar(50) not null,
    Quantidade_folhas int not null check(Quantidade_folhas > 0),
    Abertura varchar(20) not null check(Abertura in ('Batente', 'Basculante', 'Guilhotina', 'Correr')),
    Cor varchar(20) not null,

    primary key(FK_N_Referencia_Material),
    foreign key(FK_N_Referencia_Material) references material(N_Referencia_Material)
);

create table porta(
    FK_N_Referencia_Material   	varchar(50) not null,
    Cor varchar(20) not null,

    primary key(FK_N_Referencia_Material),
    foreign key(FK_N_Referencia_Material) references material(N_Referencia_Material)
);

create table acessorio(
    FK_N_Referencia_Material   	varchar(50) not null,
    Nome varchar(20) not null,

    primary key(FK_N_Referencia_Material),
    foreign key(FK_N_Referencia_Material) references material(N_Referencia_Material)
);

create table vidro(
    FK_N_Referencia_Material   	varchar(50) not null,
    Termicidade varchar(20) not null check(Termicidade in ('Baixa', 'Media', 'Alta')),
    Camadas varchar(20) not null check(Camadas in ('Simples', 'Duplo', 'Triplo')),

    primary key(FK_N_Referencia_Material),
    foreign key(FK_N_Referencia_Material) references material(N_Referencia_Material)
);