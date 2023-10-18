use p7g5;

create table pessoa(
	Mail        varchar(50) not null constraint Mail_check check(Mail like '%@%.%'),
	CC          char(8)		not null constraint CC_check check(CC not like '%[^0-9]%')	unique,
	Nome	    varchar(20)	not null,
    Telemovel   char(9)     not null constraint Telemovel_check check(Telemovel not like '%[^0-9]%'),
    NIF         char(9)     not null constraint NIF_check check(NIF not like '%[^0-9]%'),

	primary key(NIF)
);

create table cliente(
	Localizacao varchar(20) not null,
    Distancia   integer     not null,
    Projeto		char(3)		not null constraint Projeto_check check(Projeto in ('Com','Sem')) default 'Sem', 
	FK_NIF      char(9)		not null  constraint FK_NIF_check check (FK_NIF not like '%[^0-9]%'),
	
	primary key(FK_NIF),
	constraint FK_cliente_constraint foreign key(FK_NIF) references pessoa(NIF)
);

create table funcionario(
	Ordenado			real    not null constraint Ordenado_check check(Ordenado > 740.83),
	Seguro				char(3) not null constraint Seguro_check check(Seguro in ('Sim','Não')), --boolean
    Idade				integer not null constraint Idade_check check(Idade > 16),
    FK_NIF				char(9) not null constraint FK_NIF_check1 check (FK_NIF not like '%[^0-9]%'),

	primary key(FK_NIF),
	constraint FK_funcionario_constraint foreign key(FK_NIF) references pessoa(NIF)
);

create table projeto(
    ID          		integer not null,
    N_Janelas   		integer not null,
    N_Portas    		integer not null,
    N_Portadas  		integer not null,
    Duracao     		integer	not null,
	Data_conclusao		date not null,
    FK_NIF_Cliente		char(9) not null constraint FK_NIF_Cliente_check1 check (FK_NIF_Cliente not like '%[^0-9]%'),

	primary key(ID),

	constraint FK_projeto_constraint foreign key(FK_NIF_Cliente) references cliente(FK_NIF)
);

create table responsavel(
    FK_NIF_Funcionario  char(9) not null constraint FK_NIF_Funcionario_check10 check (FK_NIF_Funcionario not like '%[^0-9]%'),
    FK_ID_Projeto       integer not null,

    primary key(FK_NIF_Funcionario, FK_ID_Projeto),

	constraint FK_responsavel_constraint1 foreign key(FK_NIF_Funcionario) references funcionario(FK_NIF), 
	constraint FK_responsavel_constraint2 foreign key(FK_ID_Projeto) references projeto(ID)
);

create table material(
    N_Referencia_Material   varchar(50) not null,
	Dimensao				varchar(20) constraint Dimensao_check check(Dimensao like '%x%'),
	Espessura				real,
	Preco					real not null,
	Stock					integer not null,
	Taxa_Iva				real not null, --check(Taxa_Iva like '%@%' escape '@'),
	Designacao				varchar(20) not null check(Designacao in ('Estore', 'Janela', 'Porta', 'Vidro', 'Acessorio')),

	primary key(N_Referencia_Material),
);

create table necessita(
    FK_N_Referencia_Material   	varchar(50) not null,
	Unidades					integer not null,
	FK_ID_Projeto   			integer not null,

	primary key(FK_ID_Projeto, FK_N_Referencia_Material),
	constraint FK_necessita_constraint1 foreign key(FK_ID_Projeto) references projeto(ID) ,
	constraint FK_necessita_constraint2 foreign key(FK_N_Referencia_Material) references material(N_Referencia_Material)
);


create table encomenda(
    Codigo			integer not null,
	Data_Chegada		date not null,
		
	primary key(Codigo),
);

create table contem(
	Unidades					integer not null,
    FK_N_Referencia_Material	varchar(50) not null,
    FK_Codigo			integer not null,

	primary key(FK_Codigo, FK_N_Referencia_Material),

	constraint FK_contem_constraint1 foreign key(FK_Codigo) references encomenda(Codigo) ,
	constraint FK_contem_constraint2 foreign key(FK_N_Referencia_Material) references material(N_Referencia_Material) 
);

alter table contem
drop constraint FK_contem_constraint1;

alter table contem
add constraint FK_contem_constraint1 foreign key(FK_Codigo) references encomenda(Codigo);

create table fornecedor(
    NIF			char(9) not null constraint NIF_check1 check (NIF not like '%[^0-9]%'),
    Nome		varchar(20) not null,
    IBAN		varchar(40) not null constraint IBAN_check1  check(IBAN like '%PT50%'),
    Localizacao varchar(30) not null,
    Distancia	int not null,
    Telefone    char(9) not null  constraint Telefone_check1  check(Telefone not like '%[^0-9]%'), /* Falta no diagrama */

    primary key(NIF)
);

create table fornece(
    FK_N_Referencia_Material   	varchar(50) not null,
    FK_NIF_Fornecedor char(9) not null constraint FK_NIF_Fornecedor_check1 check(FK_NIF_Fornecedor not like '%[^0-9]%'),
    
	primary key(FK_N_Referencia_Material, FK_NIF_Fornecedor),
    constraint FK_fornece_constraint1 foreign key(FK_N_Referencia_Material) references material(N_Referencia_Material) ,
    constraint FK_fornece_constraint2 foreign key(FK_NIF_Fornecedor) references fornecedor(NIF) 

);

create table estore(
    FK_N_Referencia_Material   	varchar(50) not null,
    Controlo varchar(8) not null constraint Controlo_check check(Controlo in ('Manual', 'Eletrico')),
    Termicidade varchar(20) not null constraint Termicidade_check check(Termicidade in ('Baixa', 'Media', 'Alta')),

	primary key(FK_N_Referencia_Material),
    CONSTRAINT FK_estore_constraint foreign key(FK_N_Referencia_Material) references material(N_Referencia_Material) 
);

create table janela(
    FK_N_Referencia_Material   	varchar(50) not null,
    Quantidade_folhas int not null  constraint Quantidade_folhas_check  check(Quantidade_folhas > 0),
    Abertura varchar(20) not null constraint Abertura_check check(Abertura in ('Batente', 'Basculante', 'Guilhotina', 'Correr')),
    Cor varchar(20) not null,

    primary key(FK_N_Referencia_Material),
    constraint FK_janela_constraint foreign key(FK_N_Referencia_Material) references material(N_Referencia_Material) 
);

create table porta(
    FK_N_Referencia_Material   	varchar(50) not null,
    Cor varchar(20) not null,

    primary key(FK_N_Referencia_Material),
    constraint FK_porta_constraint foreign key(FK_N_Referencia_Material) references material(N_Referencia_Material) 
);

create table acessorio(
    FK_N_Referencia_Material   	varchar(50) not null,
    Nome						varchar(20) not null,

    primary key(FK_N_Referencia_Material),
    constraint FK_acessorio_constraint foreign key(FK_N_Referencia_Material) references material(N_Referencia_Material) 
);

create table vidro(
    FK_N_Referencia_Material   	varchar(50) not null,
    Termicidade					varchar(20) not null constraint Termicidade_check1 check(Termicidade in ('Baixa', 'Media', 'Alta')),
    Camadas						varchar(20) not null constraint Camadas_check check(Camadas in ('Simples', 'Duplo', 'Triplo')),

    primary key(FK_N_Referencia_Material),
    constraint FK_vidro_constraint foreign key(FK_N_Referencia_Material) references material(N_Referencia_Material) 
);