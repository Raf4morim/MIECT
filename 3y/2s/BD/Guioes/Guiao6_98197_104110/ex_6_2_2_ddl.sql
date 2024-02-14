use gestStock


create table tipo_fornecedor(
	codigo int check(codigo>100) not null unique, 
	designacao varchar(20) not null,

	primary key(codigo)
);

create table fornecedor(
	nif int check(nif>100000000 AND nif<999999999) not null unique,	
	nome varchar(30) not null,
	fax varchar(11) not null,
	endereco varchar(30),
	condpag int not null, 
	tipo int,

	primary key(nif),
	foreign key(tipo) references tipo_fornecedor(codigo)
);

create table produto(
	codigo int check(codigo>10000) not null unique,
	nome varchar(30) not null,
	preco decimal(6,2) check(preco>0) not null,
	iva int default 23 not null,
	unidades int not null,

	primary key(codigo),
);

create table encomenda(
	numero int not null unique,
	data_ date not null,
	fornecedor int,
	
	primary key(numero),
	foreign key(fornecedor) references fornecedor(nif)
);

create table item(
	numEnc int,
	codProd int,
	unidades int not null,

	primary key(numEnc, codProd),
	foreign key(numEnc) references encomenda(numero),
	foreign key(codProd) references produto(codigo)
);





