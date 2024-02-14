-- 6.2 -> 5.3
-----------------------------------------------------
-- A
-- select paciente.numUtente, nome from paciente 
-- left join prescricao on paciente.numUtente = prescricao.numUtente 
-- where prescricao.numPresc is null;

-----------------------------------------------------
-- B
-- select especialidade, count(numPresc) as numPrescricoes 
-- from (prescricao inner join medico on numMedico=numSNS) 
-- group by especialidade; 
-----------------------------------------------------
-- C
-- select farmacia.nome, count(prescricao.numPresc) as numPrescricoes from prescricao
-- join farmacia on prescricao.farmacia = farmacia.nome
-- group by nome
-----------------------------------------------------
-- D
-- select farmaco.nome from farmaco
-- join farmaceutica ON farmaco.numRegFarm = farmaceutica.numReg
-- where farmaceutica.numReg = 906
-- except
-- select farmaco.nome from farmaco
-- join presc_farmaco on farmaco.nome = presc_farmaco.nomeFarmaco
-- where presc_farmaco.numRegFarm = 906;
-----------------------------------------------------
-- E
-- select farmacia, nome, n  from
-- ----------------------------Tabela com a farmacia!=null
-- (select farmacia, numRegFarm, count(numRegFarm) as n from presc_farmaco 
-- join prescricao on presc_farmaco.numPresc = prescricao.numPresc
-- where farmacia IS NOT NULL 
-- group by farmacia, numRegFarm
-- ) as tabelaContagem
-- ----------------------------Tabela com a farmacia!=null
-- join farmaceutica on numReg = numRegFarm
-- order by farmacia
-----------------------------------------------------
-- F
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