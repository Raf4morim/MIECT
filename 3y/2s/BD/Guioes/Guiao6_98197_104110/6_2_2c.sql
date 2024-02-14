use gestStock

-- a)
 -- alteração (esquecimento no último guião, projeção em falta): adição de π nome
 -- π nome (σ fornecedor=null (fornecedor ⟕ nif=fornecedor encomenda))
select nome from fornecedor
left outer join encomenda on nif=fornecedor
where fornecedor is null

-- b)
select nome, media from(
	select nome,codProd,avg(item.unidades) as media
	from item	
	inner join produto on codProd=codigo
	group by nome,codProd) as medias

-- c)
select avg(Particular) as mediaProds
from 
	(select numEnc, count(codProd) as Particular
	from item
	group by numEnc) as ProdsEncomenda

-- d)
select produto.nome, fornecedor.nome,quantidade_total 
from
	(select codProd,fornecedor,sum(unidades) as quantidade_total
	from item 
	inner join encomenda on numEnc=numero
	group by codProd,fornecedor) as quantidades
inner join produto on codProd=codigo
inner join fornecedor on fornecedor=nif