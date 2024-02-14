use GestaoStocks;

CREATE TABLE Produto(
	Nome_produto	VARCHAR(50)	not null,
	Preco	DECIMAL(18,2) CHECK(Preco>0) not null,
	Taxa_iva	INT not null,
	Codigo	INT CHECK(codigo>0) not null,
	Stock	INT not null,

	PRIMARY KEY(Codigo)
);

CREATE TABLE Fornecedor(
	Nome_fornecedor	VARCHAR(30)	not null,
	Endereco	VARCHAR(30) not null,
	Fax		VARCHAR(11) not null,
	NIF		INT CHECK(NIF>100000000 AND NIF<999999999) not null unique,
	Condicoes_pagamento VARCHAR(50),

	PRIMARY KEY(NIF)
);


CREATE TABLE Encomenda(
	Data_encomenda DATE not null,
	Num_encomenda INT CHECK(Num_encomenda>0) not null,
	FK_NIF INT CHECK(FK_NIF>100000000 AND FK_NIF<999999999) not null unique,

	PRIMARY KEY(Num_encomenda),
	FOREIGN KEY(FK_NIF) REFERENCES Fornecedor(NIF)
);

CREATE TABLE Contem(
	FK_Codigo INT not null,
	FK_Num_encomenda INT not null,

	PRIMARY KEY(FK_Codigo, FK_Num_encomenda),
	FOREIGN KEY(FK_Codigo) REFERENCES Produto(Codigo),
	FOREIGN KEY(FK_Num_encomenda) REFERENCES Encomenda(Num_encomenda)
);

CREATE TABLE TipoFornecedor(
	Designacao VARCHAR(30) not null,
	Codigo_interno	INT not null

	PRIMARY KEY(Codigo_interno)
);

CREATE TABLE Tipo(
	FK_Codigo_interno INT not null,
	FK_NIF INT CHECK(FK_NIF>100000000 AND FK_NIF<999999999) not null unique,

	PRIMARY KEY(FK_Codigo_interno, FK_NIF),
	FOREIGN KEY(FK_Codigo_interno) REFERENCES TipoFornecedor(Codigo_interno),
	FOREIGN KEY(FK_NIF) REFERENCES Fornecedor(NIF)
);






