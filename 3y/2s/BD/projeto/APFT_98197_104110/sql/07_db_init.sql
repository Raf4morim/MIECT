use p7g5;

insert into pessoa(Mail, CC, Nome, Telemovel, NIF) 
	values('joao@gmail.com', '12345678', 'João Silva', '912345678', '123456789'),
      ('ana@yahoo.pt', '23456789', 'Ana Rodrigues', '965432176', '234567890'),
      ('marco@hotmail.com', '34567890', 'Marco Costa', '921345678', '345678901'), 
      ('carla@gmail.com', '45678901', 'Carla Sousa', '938745612', '456789012'), 
      ('tiago@yahoo.com', '56789012', 'Tiago Santos', '936587412', '567890123'),
	  ('tonio@gmail.com', '87654321', 'António Neves', '914202353', '987654321'), 
	  ('maria@gmail.com', '98765432', 'Maria Mendes', '912340212', '098765432'), 
	  ('manuel@sapo.pt', '09876543', 'Manuel Cristóvão', '916707452', '109876543'), 
	  ('joni@yahoo.pt', '10987654', 'João Brito', '914000121', '210987654'), 
	  ('tone@ua.pt','11221122', 'António Zé', '910202202', '220556655'),
	  ('z@ua.pt','91918181','Zeca','993344221','931212123');

insert into cliente(Localizacao, Distancia, FK_NIF)
values('Porto', 20, '987654321'),
      ('Lisboa', 30, '098765432'),
      ('Braga', 25, '109876543'),
      ('Funchal', 50, '210987654'),
	  ('Porto', 18, '345678901'),
	  ('Viseu', 30, '931212123')
	  ;

insert into funcionario(Ordenado, Seguro, Idade, FK_NIF)
values(900,'Sim',45,'123456789'),
	  (1000, 'Sim', 21, '220556655'),
	  (800, 'Não', 27, '234567890'),
      (1100, 'Não', 29, '456789012'),
      (1200, 'Sim', 37, '567890123');


insert into projeto(ID, N_Janelas, N_Portas, N_Portadas, Duracao, Data_conclusao, FK_NIF_Cliente)
values(1, 2, 5, 4, 5, '2023-06-15', '345678901'),
      (2, 8, 4, 3, 7, '2023-06-28', '109876543'),
      (3, 12, 6, 1, 15, '2023-07-15', '210987654'),
	  (4, 9, 2, 1, 10, '2023-07-20', '210987654'),
	  (5, 12, 6, 1, 15, '2023-07-30', '098765432');

insert into responsavel (FK_NIF_Funcionario, FK_ID_Projeto)
values('220556655', 1),
	  ('234567890', 2),
	  ('567890123', 3);
insert into responsavel (FK_NIF_Funcionario, FK_ID_Projeto) values('234567890', 3); -- Separei por causa do trigger de limite de projetos por funcionário
insert into responsavel (FK_NIF_Funcionario, FK_ID_Projeto) values('567890123', 2);

INSERT INTO material(N_Referencia_Material, Dimensao, Espessura, Preco, Stock, Taxa_Iva, Designacao)
VALUES
	('E001', '30x40', 0.5, 10.50, 100, 0.23, 'Estore'),
	('E002', '50x50', 0.75, 15.30, 50, 0.23, 'Estore'),
	('E003', '40x60', 0.6, 12.75, 80, 0.23, 'Estore'),
	('E004', '25x35', 0.4, 8.90, 120, 0.23, 'Estore'),
	('E005', '20x30', 0.3, 7.60, 150, 0.23, 'Estore'),
	('J001', '60x80', 1.0, 20.50, 200, 0.23, 'Janela'),
	('J002', '70x90', 1.2, 25.80, 150, 0.23, 'Janela'),
	('J003', '80x100', 1.5, 30.75, 180, 0.23, 'Janela'),
	('J004', '40x50', 0.8, 15.90, 100, 0.23, 'Janela'),
	('J005', '50x60', 1.0, 18.60, 120, 0.23, 'Janela'),
	('V001', '30x40', 0.5, 10.50, 80, 0.23, 'Vidro'),
	('V002', '60x60', 1.0, 20.50, 150, 0.23, 'Vidro'),
	('V003', '70x80', 1.2, 25.80, 100, 0.23, 'Vidro'),
	('V004', '80x90', 1.5, 30.75, 120, 0.23, 'Vidro'),
	('V005', '50x50', 0.8, 15.90, 90, 0.23, 'Vidro'),
	('A001', '80x90', 1.5, 30.75, 120, 0.23, 'Acessorio'),
	('A002', '80x90', 1.5, 30.75, 120, 0.23, 'Acessorio'),
	('A003', '80x90', 1.5, 30.75, 120, 0.23, 'Acessorio'),
	('A004', '80x90', 1.5, 30.75, 120, 0.23, 'Acessorio'),
	('A005', '80x90', 1.5, 30.75, 120, 0.23, 'Acessorio'),
	('P001', '80x90', 1.5, 30.75, 120, 0.23, 'Porta'),
	('P002', '80x90', 1.5, 30.75, 120, 0.23, 'Porta'),
	('P003', '80x90', 1.5, 30.75, 120, 0.23, 'Porta'),
	('P004', '80x90', 1.5, 30.75, 120, 0.23, 'Porta');

INSERT INTO necessita(FK_N_Referencia_Material, Unidades, FK_ID_Projeto) 
VALUES
	('P004', 30, 1),
	('J003', 10, 1),
	('V003', 20, 1),
	('V001', 10, 2),
	('A001', 15, 2),
	('J002', 30, 3),
	('P001', 40, 3),
	('E002', 20, 4),
	('V002', 15, 4),
	('A002', 10, 5),
	('P002', 5, 5);


insert into encomenda(Codigo, Data_Chegada) 
values
	(1, '2023-05-06'),
	(2, '2023-05-05'),
	(3, '2023-05-04'),
	(4, '2023-05-04'),
	(5, '2023-05-04');



INSERT INTO contem (Unidades, FK_N_Referencia_Material, FK_Codigo) 
VALUES
	(50, 'J001', 1),
	(30, 'V001', 1),
	(20, 'E001', 1),
	(40, 'A001', 2),
	(25, 'P001', 2),
	(10, 'V001', 3),
	(5, 'E001', 3),
	(15, 'A001', 3),
	(30, 'J002', 4),
	(20, 'P001', 4),
	(20, 'P001', 5);

INSERT INTO fornecedor (NIF, Nome, IBAN, Localizacao, Distancia, Telefone)
VALUES 
    ('555890123', 'Fornecedor A', 'PT50 0000 0000 0000 0000 0000 1', 'Lisboa', 10, '912345678'),
    ('789012345', 'Fornecedor B', 'PT50 1111 1111 1111 1111 1111 2', 'Porto', 5, '923456789'),
    ('654321098', 'Fornecedor D', 'PT50 3333 3333 3333 3333 3333 4', 'Faro', 30, '945678901'),
    ('234567890', 'Fornecedor E', 'PT50 4444 4444 4444 4444 4444 5', 'Lisboa', 10, '956789012'),
    ('432109876', 'Fornecedor F', 'PT50 5555 5555 5555 5555 5555 6', 'Porto', 5, '967890123'),
    ('543210987', 'Fornecedor G', 'PT50 6666 6666 6666 6666 6666 7', 'Braga', 15, '978901234'),
    ('765432109', 'Fornecedor H', 'PT50 7777 7777 7777 7777 7777 8', 'Faro', 30, '989012345'),
    ('876543210', 'Fornecedor I', 'PT50 8888 8888 8888 8888 8888 9', 'Lisboa', 10, '990123456'),
    ('987654321', 'Fornecedor J', 'PT50 9999 9999 9999 9999 9999 0', 'Porto', 5, '901234567');

INSERT INTO fornece (FK_N_Referencia_Material, FK_NIF_Fornecedor)
VALUES 
    ('J001', '555890123'),
    ('V001', '789012345'),
    ('E001', '654321098'),
    ('E002', '543210987'),
    ('E003', '876543210'),
    ('E004', '654321098'),
    ('E005', '987654321'),
    ('J002', '555890123'),
    ('J003', '789012345'),
    ('J004', '234567890'),
    ('J005', '876543210'),
    ('V002', '234567890'),
    ('V003', '789012345'),
    ('V004', '543210987'),
    ('V005', '432109876'),
    ('A001', '555890123'),
    ('A002', '987654321'),
    ('A003', '543210987'),
    ('A004', '432109876'),
    ('A005', '987654321'),
    ('P001', '789012345'),
    ('P002', '555890123'),
    ('P003', '432109876'),
    ('P004', '987654321');

INSERT INTO estore(FK_N_Referencia_Material, Controlo, Termicidade)
VALUES 
	('E001', 'Manual', 'Alta'),
	('E002', 'Eletrico', 'Media'),
	('E003', 'Manual', 'Media'),
	('E004', 'Eletrico', 'Alta'),
	('E005', 'Manual', 'Alta');


INSERT INTO janela(FK_N_Referencia_Material, Quantidade_folhas, Abertura, Cor)
VALUES
	('J001', 1, 'Basculante', 'Preto'),
	('J002', 1, 'Batente', 'Branco'),
	('J003', 2, 'Basculante', 'Preto'),
	('J004', 3, 'Guilhotina', 'Castanho'),
	('J005', 1, 'Correr', 'Branco');

INSERT INTO porta (FK_N_Referencia_Material, Cor)
VALUES
	('P004', 'Branco'),
	('P001', 'Branco'),
	('P002', 'Preto'),
	('P003', 'Castanho');

INSERT INTO acessorio (FK_N_Referencia_Material, Nome)
VALUES
	('A003', 'Puxador'),
	('A004', 'Dobradica'),
	('A001', 'Maçaneta'),
	('A005', 'Parafusos'),
	('A002', 'Fechadura');

INSERT INTO vidro (FK_N_Referencia_Material, Termicidade, Camadas)
VALUES
	('V004', 'Media', 'Duplo'),
	('V005', 'Alta', 'Triplo'),
	('V001', 'Alta', 'Triplo'),
	('V002', 'Media', 'Duplo'),
	('V003', 'Baixa', 'Simples');

	--select * from funcionario;
	--delete from funcionario where FK_NIF = 220556655
	--select Nome, Mail, CC, NIF, Seguro, Idade, Ordenado  from (funcionario f join pessoa p on p.NIF=f.FK_NIF);
