use gestStock;

insert into tipo_fornecedor(codigo, designacao) values(101,'Carnes')
insert into tipo_fornecedor(codigo, designacao) values(102,'Laticinios')
insert into tipo_fornecedor(codigo, designacao) values(103,'Frutas e Legumes')
insert into tipo_fornecedor(codigo, designacao) values(104,'Mercearia')
insert into tipo_fornecedor(codigo, designacao) values(105,'Bebidas')
insert into tipo_fornecedor(codigo, designacao) values(106,'Peixe')
insert into tipo_fornecedor(codigo, designacao) values(107,'Detergente')


insert into fornecedor(nif, nome, fax, endereco, condpag, tipo) values(509111222,'LactoSerrano','234872372',NULL,60,102)
insert into fornecedor(nif, nome, fax, endereco, condpag, tipo) values(509121212,'FrescoNorte','221234567','Rua do Complexo Grande - Edf 3',90,102)
insert into fornecedor(nif, nome, fax, endereco, condpag, tipo) values(509294734,'PinkDrinks','2123231732','Rua Poente 723',30,105)
insert into fornecedor(nif, nome, fax, endereco, condpag, tipo) values(509827353,'LactoSerrano','234872372',NULL,60,102)
insert into fornecedor(nif, nome, fax, endereco, condpag, tipo) values(509836433,'LeviClean','229343284','Rua Sol Poente 6243',30,107)
insert into fornecedor(nif, nome, fax, endereco, condpag, tipo) values(509987654,'MaduTex','234873434','Estrada da Cincunvalacao 213',30,104)
insert into fornecedor(nif, nome, fax, endereco, condpag, tipo) values(590972623,'ConservasMac', '234112233','Rua da Recta 233',30,104)


insert into produto(codigo, nome, preco, iva, unidades) values (10001,'Bife da Pa', 8.75,23,125)
insert into produto(codigo, nome, preco, iva, unidades) values (10002,'Laranja Algarve',1.25,23,1000)
insert into produto(codigo, nome, preco, iva, unidades) values (10003,'Pera Rocha',1.45,23,2000)
insert into produto(codigo, nome, preco, iva, unidades) values (10004,'Secretos de Porco Preto',10.15,23,342)
insert into produto(codigo, nome, preco, iva, unidades) values (10005,'Vinho Rose Plus',2.99,13,5232)
insert into produto(codigo, nome, preco, iva, unidades) values (10006,'Queijo de Cabra da Serra',15.00,23,3243)
insert into produto(codigo, nome, preco, iva, unidades) values (10007,'Queijo Fresco do Dia',0.65,23,452)
insert into produto(codigo, nome, preco, iva, unidades) values (10008,'Cerveja Preta Artesanal',1.65,13,937)
insert into produto(codigo, nome, preco, iva, unidades) values (10009,'Lixivia de Cor', 1.85,23,9382)
insert into produto(codigo, nome, preco, iva, unidades) values (10010,'Amaciador Neutro', 4.05,23,932432)
insert into produto(codigo, nome, preco, iva, unidades) values (10011,'Agua Natural',0.55,6,919323)
insert into produto(codigo, nome, preco, iva, unidades) values (10012,'Pao de Leite',0.15,6,5434)
insert into produto(codigo, nome, preco, iva, unidades) values (10013,'Arroz Agulha',1.00,13,7665)
insert into produto(codigo, nome, preco, iva, unidades) values (10014,'Iogurte Natural',0.40,13,998)


insert into encomenda(numero, data_, fornecedor) values (1,'2015-03-03',509111222)
insert into encomenda(numero, data_, fornecedor) values (2,'2015-03-04',509121212)
insert into encomenda(numero, data_, fornecedor) values (3,'2015-03-05',509987654)
insert into encomenda(numero, data_, fornecedor) values (4,'2015-03-06',509827353)
insert into encomenda(numero, data_, fornecedor) values (5,'2015-03-07',509294734)
insert into encomenda(numero, data_, fornecedor) values (6,'2015-03-08',509836433)
insert into encomenda(numero, data_, fornecedor) values (7,'2015-03-09',509121212)
insert into encomenda(numero, data_, fornecedor) values (8,'2015-03-10',509987654)
insert into encomenda(numero, data_, fornecedor) values (9,'2015-03-11',509836433)
insert into encomenda(numero, data_, fornecedor) values (10,'2015-03-12',509987654)


insert into item(numEnc, codProd, unidades) values(1,10001,200)
insert into item(numEnc, codProd, unidades) values(1,10004,300)
insert into item(numEnc, codProd, unidades) values(2,10002,1200)
insert into item(numEnc, codProd, unidades) values(2,10003,3200)
insert into item(numEnc, codProd, unidades) values(3,10013,900)
insert into item(numEnc, codProd, unidades) values(4,10006,50)
insert into item(numEnc, codProd, unidades) values(4,10007,40)
insert into item(numEnc, codProd, unidades) values(4,10014,200)
insert into item(numEnc, codProd, unidades) values(5,10005,500)
insert into item(numEnc, codProd, unidades) values(5,10008,10)
insert into item(numEnc, codProd, unidades) values(5,10011,1000)
insert into item(numEnc, codProd, unidades) values(6,10009,200)
insert into item(numEnc, codProd, unidades) values(6,10010,200)
insert into item(numEnc, codProd, unidades) values(7,10003,1200)
insert into item(numEnc, codProd, unidades) values(8,10013,350)
insert into item(numEnc, codProd, unidades) values(9,10009,100)
insert into item(numEnc, codProd, unidades) values(9,10010,300)
insert into item(numEnc, codProd, unidades) values(10,10012,200)	
