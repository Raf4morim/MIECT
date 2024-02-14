use GestaoATL;

CREATE TABLE Pessoa(
	num_CC CHAR(12) unique not null,
	nome VARCHAR(50) not null,
	morada VARCHAR(50) not null,
	data_nasc DATE not null,

	PRIMARY KEY(num_CC)
);

CREATE TABLE Professor(
	FK_num_CC CHAR(12) unique not null,
	num_funcionario INT not null,
	telefone CHAR(9) not null,
	email	VARCHAR(20)	not null check(email like'[a-zA-Z_-0-9]+@[a-Z]+.[a-z]+'),

	PRIMARY KEY(FK_num_CC),
	FOREIGN KEY(FK_num_CC) REFERENCES Pessoa(num_CC)
);

CREATE TABLE Autorizado(
	FK_num_CC CHAR(12) unique not null,
	email	VARCHAR(20)	not null check(email like'[a-zA-Z_-0-9]+@[a-Z]+.[a-z]+'),
	relacao VARCHAR(20) not null,
	contacto CHAR(9) not null,

	PRIMARY KEY(FK_num_CC),
	FOREIGN KEY(FK_num_CC) REFERENCES Pessoa(num_CC)
);

CREATE TABLE Encarregado_de_educacao(
	FK_num_CC CHAR(12) unique not null,
	relacao_familiar VARCHAR(20) not null,

	PRIMARY KEY(FK_num_CC),
	FOREIGN KEY(FK_num_CC) REFERENCES Autorizado(FK_num_CC)
);

CREATE TABLE Pessoa_autorizada(
	FK_num_CC CHAR(12) unique not null,
	relacao VARCHAR(20) not null,

	PRIMARY KEY(FK_num_CC),
	FOREIGN KEY(FK_num_CC) REFERENCES Autorizado(FK_num_CC)
);

CREATE TABLE Aluno(
	FK_num_CC CHAR(12) unique not null,
	FK_num_CC_encarregado CHAR(12) unique not null,

	PRIMARY KEY(FK_num_CC),
	FOREIGN KEY(FK_num_CC) REFERENCES Pessoa(num_CC),
	FOREIGN KEY(FK_num_CC_encarregado) REFERENCES Encarregado_de_educacao(FK_num_CC)
);

CREATE TABLE Entregar_Levantar(
	FK_num_CC_aluno CHAR(12) unique not null,
	FK_num_CC_autorizado CHAR(12) unique not null,

	PRIMARY KEY(FK_num_CC_aluno,FK_num_CC_autorizado),
	FOREIGN KEY(FK_num_CC_aluno) REFERENCES Aluno(FK_num_CC),
	FOREIGN KEY(FK_num_CC_autorizado) REFERENCES Autorizado(FK_num_CC)
);

CREATE TABLE Atividade(
	ID_atividade	VARCHAR(20) not null,
	Designacao	VARCHAR(50),
	Custo	INT not null

	PRIMARY KEY(ID_atividade)
);

CREATE TABLE Frequenta(
	FK_num_CC_aluno CHAR(12) unique not null,
	FK_ID_atividade	VARCHAR(20) not null,

	PRIMARY KEY(FK_num_CC_aluno, FK_ID_atividade),
	FOREIGN KEY(FK_num_CC_aluno) REFERENCES Aluno(FK_num_CC),
	FOREIGN KEY(FK_ID_atividade) REFERENCES Atividade(ID_atividade)
);

CREATE TABLE Turma(
	ID_turma	CHAR(2)  not null,  -- 1A, 2C, 3A
	Designacao	VARCHAR(30),
	Num_max_alunos INT not null,

	PRIMARY KEY(ID_turma)
);

CREATE TABLE Tem(
	FK_ID_turma CHAR(2) not null,
	FK_ID_atividade VARCHAR(20) not null,

	PRIMARY KEY(FK_ID_turma, FK_ID_atividade),
	FOREIGN KEY(FK_ID_turma) REFERENCES Turma(ID_turma),
	FOREIGN KEY(FK_ID_atividade) REFERENCES Atividade(ID_atividade)
);

CREATE TABLE Ano_letivo(
	FK_ID_turma CHAR(2) not null,
	Ano_letivo_turma INT CHECK(Ano_letivo_turma>0) not null,

	PRIMARY KEY(FK_ID_turma, Ano_letivo_turma),
	FOREIGN KEY(FK_ID_turma) REFERENCES Turma(ID_turma)
);





