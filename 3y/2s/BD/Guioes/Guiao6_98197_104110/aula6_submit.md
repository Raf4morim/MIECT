# BD: Guião 6

## Problema 6.1

### *a)* Todos os tuplos da tabela autores (authors);

```
select * from authors
```

### *b)* O primeiro nome, o último nome e o telefone dos autores;

```
select au_fname, au_lname, phone from authors
```

### *c)* Consulta definida em b) mas ordenada pelo primeiro nome (ascendente) e depois o último nome (ascendente); 

```
select au_fname, au_lname, phone from authors order by au_fname, au_lname asc;
```

### *d)* Consulta definida em c) mas renomeando os atributos para (first_name, last_name, telephone); 

```
select au_fname as first_name,au_lname as last_name,phone as telephone
    from authors 
    order by au_fname, au_lname asc;
```

### *e)* Consulta definida em d) mas só os autores da Califórnia (CA) cujo último nome é diferente de ‘Ringer’; 

```
select au_fname as first_name,au_lname as last_name,phone as telephone
from authors 
where state='CA' and au_lname!='Ringer'
order by au_fname, au_lname asc
```

### *f)* Todas as editoras (publishers) que tenham ‘Bo’ em qualquer parte do nome; 

```
select pub_name from publishers
where pub_name LIKE '%bo%'
```

### *g)* Nome das editoras que têm pelo menos uma publicação do tipo ‘Business’; 

```
select pub_name from (publishers as p inner join titles as t on p.pub_id=t.pub_id)
where type='Business'
```

### *h)* Número total de vendas de cada editora; 

```
select pub_id, Ntotalvendas=sum(s.qty) from sales as s inner join titles as t on s.title_id = t.title_id
group by pub_id
```

### *i)* Número total de vendas de cada editora agrupado por título; 

```
select pub_id,title,Ntotalvendas=sum(s.qty) from sales as s inner join titles as t on s.title_id = t.title_id
group by pub_id, title
order by pub_id
```

### *j)* Nome dos títulos vendidos pela loja ‘Bookbeat’; 

```
select stor_name,title from (sales as s inner join titles as t on s.title_id = t.title_id inner join stores as sto on s.stor_id=sto.stor_id)
where stor_name='Bookbeat'
```

### *k)* Nome de autores que tenham publicações de tipos diferentes; 

```
select au_fname, au_lname from (authors as a inner join titleauthor as ta on a.au_id=ta.au_id inner join titles as t on ta.title_id=t.title_id )
group by au_fname, au_lname
having count(distinct type)>1
```

### *l)* Para os títulos, obter o preço médio e o número total de vendas agrupado por tipo (type) e editora (pub_id);

```
select  t.pub_id,type,preco_medio=avg(price), num_total_vendas=sum(qty) from titles as t inner join sales as s on t.title_id=s.title_id
group by t.pub_id,type
```

### *m)* Obter o(s) tipo(s) de título(s) para o(s) qual(is) o máximo de dinheiro “à cabeça” (advance) é uma vez e meia superior à média do grupo (tipo);

```
select type
from titles
group by type
having max(advance) > 1.5*avg(advance)
```

### *n)* Obter, para cada título, nome dos autores e valor arrecadado por estes com a sua venda;

```
select title, au_fname+' '+au_lname as fullname, ytd_sales * royalty * price /100 AS total_value   from titleauthor
join titles on titles.title_id = titleauthor.title_id
join authors on authors.au_id = titleauthor.au_id
```

### *o)* Obter uma lista que incluía o número de vendas de um título (ytd_sales), o seu nome, a faturação total, o valor da faturação relativa aos autores e o valor da faturação relativa à editora;

```
-- Renomeação de acordo com o enunciado
select distinct title, ytd_sales, ytd_sales*price as facturacao, 
ytd_sales * royalty * price /100 as auth_revenue,
ytd_sales*price-ytd_sales*price*royalty/100 as publisher_revenue
from titles
order by title;
```

### *p)* Obter uma lista que incluía o número de vendas de um título (ytd_sales), o seu nome, o nome de cada autor, o valor da faturação de cada autor e o valor da faturação relativa à editora;

```
select  title,ytd_sales, au_fname+' '+au_lname as author, titles.price * titles.royalty *  royaltyper/ 10000 * titles.ytd_sales as auth_revenue,
ytd_sales*price-ytd_sales*price*royalty/100 as publisher_revenue
from titles
join titleauthor on titleauthor.title_id=titles.title_id
join authors on authors.au_id=titleauthor.au_id
order by title, au_fname;
```

### *q)* Lista de lojas que venderam pelo menos um exemplar de todos os livros;

```
select distinct sales.stor_id, count(title_id) as title_per_store from sales
group by sales.stor_id having count(title_id) >= (select count(*) from titles)
```

### *r)* Lista de lojas que venderam mais livros do que a média de todas as lojas;

```
select stor_name, sum(qty) as sum_qty from sales 
join stores on sales.stor_id=stores.stor_id
group by stor_name
having sum(qty) > (	select avg(sum_qty)
from ( select sum(qty) as sum_qty, stor_id as store_id from sales group by stor_id) as SCL) -- soma por cada loja
```

### *s)* Nome dos títulos que nunca foram vendidos na loja “Bookbeat”;

```
select title from titles
except select title from titles
join sales on sales.title_id=titles.title_id
join stores on stores.stor_id=sales.stor_id
where stor_name='Bookbeat'
order by title;
```

### *t)* Para cada editora, a lista de todas as lojas que nunca venderam títulos dessa editora; 

```
(select pub_name, stor_name from stores, publishers )
except
(select pub_name, stor_name from publishers 
join (	select pub_id as new_pub_id, sales.stor_id, stor_name from titles 
join sales on titles.title_id=sales.title_id
join stores	on sales.stor_id=stores.stor_id) as tmp on pub_id=new_pub_id);
```

## Problema 6.2

### ​5.1

#### a) SQL DDL Script
 
[a) SQL DDL File](ex_6_2_1_ddl.sql "SQLFileQuestion")

#### b) Data Insertion Script

[b) SQL Data Insertion File](ex_6_2_1_data.sql "SQLFileQuestion")

#### c) Queries

##### *a)*

```
select Fname,Lname,Pname,Ssn 
from project inner join employee on Dno=Dnum
```

##### *b)* 

```
select Fname,Minit,Lname 
from employee 
where Super_ssn = (
	select Carlos_ssn.Ssn 
	from employee as Carlos_ssn
	where Fname='Carlos' and Minit='D' and Lname='Gomes')
```

##### *c)* 

```
select Pname, total_worked 
from project inner join(
		select Pno, sum(Hours_) as total_worked
		from works_on
		group by Pno) as project_hours
on Pnumber=Pno
```

##### *d)* 

```
select employee.Fname, employee.Lname, project.Pname, employee.Dno, works_on.Hours_
from employee 
inner join works_on on employee.Ssn=works_on.Essn
inner join project on works_on.Pno=project.Pnumber
where works_on.Hours_>20 and project.Pname='Aveiro Digital';
```

##### *e)* 

```
select employee.Fname, employee.Minit, employee.Lname
from employee 
left outer join works_on on employee.Ssn=works_on.Essn
where Pno is null
```

##### *f)* 

```
select department.Dname, avg(employee.Salary) as Salario_F 
from department 
inner join employee on department.Dnumber=employee.Dno
where employee.Sex='F'
group by department.Dname
```

##### *g)* 

```
select employee.Fname, employee.Minit, employee.Lname, count(dependent_.Essn) as nDep
from employee
inner join dependent_ on employee.Ssn=dependent_.Essn
group by employee.Fname, employee.Minit, employee.Lname
having count(dependent_.Essn)>2
```

##### *h)* 

```
from department
inner join employee on department.Mgr_ssn=employee.Ssn
left outer join dependent_ on  employee.Ssn=dependent_.Essn
where Essn is null
```

##### *i)* 

```
select Fname,Minit, Lname, e_Address
from dept_locations inner join
	(	select distinct employee.Fname,employee.Minit,employee.Lname,employee.e_Address, employee.Dno
		from project 
		inner join works_on on project.Pnumber=works_on.Pno
		inner join employee on works_on.Essn=employee.Ssn
		where project.Plocation='Aveiro') as funcionarios_proj_Aveiro
on dept_locations.Dnumber=funcionarios_proj_Aveiro.Dno
where dept_locations.Dlocation!='Aveiro'
```

### 5.2

#### a) SQL DDL Script
 
[a) SQL DDL File](ex_6_2_2_ddl.sql "SQLFileQuestion")

#### b) Data Insertion Script

[b) SQL Data Insertion File](ex_6_2_2_data.sql "SQLFileQuestion")

#### c) Queries

##### *a)*

```
 -- alteração (esquecimento no último guião, projeção em falta): adição de π nome
 -- π nome (σ fornecedor=null (fornecedor ⟕ nif=fornecedor encomenda))
select nome from fornecedor
left outer join encomenda on nif=fornecedor
where fornecedor is null
```

##### *b)* 

```
select nome, media from(
	select nome,codProd,avg(item.unidades) as media
	from item	
	inner join produto on codProd=codigo
	group by nome,codProd) as medias
```


##### *c)* 

```
select avg(Particular) as mediaProds
from 
	(select numEnc, count(codProd) as Particular
	from item
	group by numEnc) as ProdsEncomenda
```


##### *d)* 

```
select produto.nome, fornecedor.nome,quantidade_total 
from
	(select codProd,fornecedor,sum(unidades) as quantidade_total
	from item 
	inner join encomenda on numEnc=numero
	group by codProd,fornecedor) as quantidades
inner join produto on codProd=codigo
inner join fornecedor on fornecedor=nif
```

### 5.3

#### a) SQL DDL Script
 
[a) SQL DDL File](ex_6_2_3_ddl.sql "SQLFileQuestion")

#### b) Data Insertion Script

[b) SQL Data Insertion File](ex_6_2_3_data.sql "SQLFileQuestion")

#### c) Queries

##### *a)*

```
select paciente.numUtente, nome from paciente 
left join prescricao on paciente.numUtente = prescricao.numUtente 
where prescricao.numPresc is null;
```

##### *b)* 

```
select especialidade, count(numPresc) as numPrescricoes 
from (prescricao inner join medico on numMedico=numSNS) 
group by especialidade; 
```


##### *c)* 

```
select farmacia.nome, count(prescricao.numPresc) as numPrescricoes from prescricao
join farmacia on prescricao.farmacia = farmacia.nome
group by nome
```


##### *d)* 

```
select farmaco.nome from farmaco
join farmaceutica ON farmaco.numRegFarm = farmaceutica.numReg
where farmaceutica.numReg = 906
except
select farmaco.nome from farmaco
join presc_farmaco on farmaco.nome = presc_farmaco.nomeFarmaco
where presc_farmaco.numRegFarm = 906;
```

##### *e)* 

```
select farmacia, nome, n  from
----------------------------Tabela com a farmacia!=null
(select farmacia, numRegFarm, count(numRegFarm) as n from presc_farmaco 
join prescricao on presc_farmaco.numPresc = prescricao.numPresc
where farmacia IS NOT NULL 
group by farmacia, numRegFarm
) as tabelaContagem
----------------------------Tabela com a farmacia!=null
join farmaceutica on numReg = numRegFarm
order by farmacia
```

##### *f)* 

```
--select nome from paciente
select nU, nome, dataNasc, endereco  from 
--------------------------Tabela com a diferença
(select nU, min(numMedico) as minDiferentes from
--Tabela com numUtente, numMedico,numPresc
(select numUtente as nU, numMedico,numPresc from medico 
join prescricao on numMedico = numSNS ) as tabela1
group by nU

except

select nU, max(numMedico) as minDiferentes from
--Tabela com numUtente, numMedico,numPresc
(select numUtente as nU, numMedico,numPresc from medico 
join prescricao on numMedico = numSNS ) as tabela2
group by nU) as finalT
--------------------------Tabela com a diferença
join paciente on paciente.numUtente = nU
```
