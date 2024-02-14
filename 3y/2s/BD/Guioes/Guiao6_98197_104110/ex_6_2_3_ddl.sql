CREATE SCHEMA prescricao;
GO
CREATE TABLE farmacia(
    nome VARCHAR(50) NOT NULL,
    telefone INT NOT NULL,
	endereco VARCHAR(100) NOT NULL,
    PRIMARY KEY(nome)
);
CREATE TABLE paciente(
    numUtente INT NOT NULL,
    nome VARCHAR(50) NOT NULL,
    dataNasc DATE NOT NULL,
	endereco VARCHAR(100) NOT NULL,

    PRIMARY KEY(numUtente)
);

CREATE TABLE medico(
    numSNS INT NOT NULL,
    nome VARCHAR(50) NOT NULL,
    especialidade VARCHAR(50) NOT NULL,
    PRIMARY KEY(numSNS)
);

CREATE TABLE farmaceutica(
    numReg INT NOT NULL,
	nome VARCHAR(50) NOT NULL,
    endereco VARCHAR(100) NOT NULL,
    
    PRIMARY KEY(numReg)
);

CREATE TABLE farmaco(
	numRegFarm INT NOT NULL,
    nome VARCHAR(50) NOT NULL,
    formula VARCHAR(50) NOT NULL,
    
    PRIMARY KEY(nome, numRegFarm),
    FOREIGN KEY(numRegFarm) REFERENCES Farmaceutica(numReg)
);

CREATE TABLE prescricao(
    numPresc INT NOT NULL,
    numUtente INT NOT NULL,
    numMedico INT,
    farmacia VARCHAR(50),
	dataProc DATE,

    PRIMARY KEY(numPresc),
    FOREIGN KEY(numMedico) REFERENCES medico(numSNS),
    FOREIGN KEY(numUtente) REFERENCES paciente(numUtente),
    FOREIGN KEY(farmacia) REFERENCES farmacia(nome)
);

CREATE TABLE presc_farmaco(
    numPresc INT NOT NULL,
	numRegFarm INT NOT NULL,
	nomeFarmaco VARCHAR(50) NOT NULL,
	PRIMARY KEY(numPresc,numRegFarm, nomeFarmaco),
	FOREIGN KEY(numPresc) REFERENCES prescricao(numPresc),
	FOREIGN KEY(nomeFarmaco, numRegFarm) REFERENCES farmaco(nome, numRegFarm),
);