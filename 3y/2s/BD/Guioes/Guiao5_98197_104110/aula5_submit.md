# BD: Guião 5


## ​Problema 5.1
 
### *a)*

```
π Fname,Lname, Pname,Ssn (project ⨝ Dno=Dnum employee)
```


### *b)* 

```
π Fname, Minit, Lname (employee ⨝employee.Super_ssn=Carlos_ssn.Ssn 
(ρ Carlos_ssn (π Ssn (σ Fname='Carlos' ∧ Minit='D' ∧ Lname='Gomes' (employee)))))
```


### *c)* 

```
total = γ Pno;
total_worked <- sum(Hours) works_on
π Pname, total_worked (project ⨝ Pnumber = Pno total)
```


### *d)* 

```
π Fname, Lname, Pname, Dno, Hours
(σ works_on.Hours > 20
(employee ⨝ Ssn = works_on.Essn
((σ Pname = 'Aveiro Digital' project) ⨝ Pnumber = Pno works_on)
) 
)
```


### *e)* 

```
π Fname, Minit, Lname (σ Pno=null (employee ⟕ Ssn=Essn works_on))
```


### *f)* 

```
Dep_F = department ⨝Dnumber = Dno (σ Sex='F' (employee))
γ Dname; avg(Salary) -> Salario_F (Dep_F)
```


### *g)* 

```
σ nDep > 2
(γ Fname, Minit, Lname;
nDep <- count(Essn)
(employee ⨝ Ssn = Essn dependent))
```


### *h)* 

```
-- Obtenha uma lista de todos os funcionários gestores de departamento que não têm dependentes;

π Fname, Lname (
department ⨝ Mgr_ssn = Ssn					-- Que sejam funcionários do departamento
σ Essn = null (dependent ⟖ Essn = Ssn employee) -- Buscar os empregados que n tem dependentes
)
```


### *i)* 

```
funcionarios_proj_Aveiro = π Fname,Minit,Lname,Address, Dno σ Plocation='Aveiro' (project ⨝Pnumber=Pno (works_on ⨝Essn = Ssn employee))
π Fname,Minit,Lname,Address (σ Dlocation!='Aveiro' (funcionarios_proj_Aveiro ⨝ Dno=Dnumber dept_location))
```


## ​Problema 5.2

### *a)*

```
σ fornecedor=null (fornecedor ⟕ nif=fornecedor encomenda)
```

### *b)* 

```
π nome, media 
(γ codProd;avg(unidades)-> media -- Em relação ao código de produção vemos as medias de unidades dos items 
(item) ⨝codProd=codigo produto) 
```

### *c)* 

```
γ  avg(Particular) -> TotalMedia					-- 2º Média total
γ numEnc;  count(codProd) -> Particular	(item)		-- 1º Contamos os nomes dos produtos por código do produto
```

### *d)* 

```
all_quantities = γ codProd,fornecedor;sum(unidades) -> quantidade_total (item ⨝numEnc=numero encomenda)
π produto.nome,fornecedor.nome,quantidade_total (fornecedor ⨝nif=fornecedor (all_quantities ⨝codProd=codigo produto))
```


## ​Problema 5.3

### *a)*

```
π numUtente,nome (σ numPresc=null (paciente ⟕ prescricao))
```

### *b)* 

```
γ especialidade; count(numPresc) -> numPrescricoes -- prescrições por especialidade 
(π numPresc, especialidade				-- ajuda a visualizar
(prescricao ⨝ numMedico=numSNS medico)) 
```


### *c)* 

```
γ nome;  count(numPresc) -> prescPorFarmacia
π numPresc,nome (
prescricao ⨝ farmacia=nome farmacia)
```


### *d)* 

```
todos_farmacos = π farmaco.nome (σ numReg=906 (farmaco ⨝numRegFarm=numReg farmaceutica))
farmacos_prescritos = π nomeFarmaco (σ numRegFarm=906 presc_farmaco)
todos_farmacos - farmacos_prescritos

```

### *e)* 

```
Todos_farmacos = σ farmacia!=null (presc_farmaco ⨝presc_farmaco.numPresc = prescricao.numPresc prescricao)
NumRegFarms = γ farmacia,numRegFarm;count(numRegFarm) -> farmacos_farmacia Todos_farmacos
π farmacia, nome, farmacos_farmacia (NumRegFarms ⨝numRegFarm=numReg farmaceutica)
```

### *f)* 

```
π paciente.numUtente, nome, dataNasc, endereco (paciente ⨝ paciente.numUtente = prescricao.numUtente

-- 
(γ numUtente; min(numMedico) -> minDiferentes
(π numUtente, numMedico, numPresc
(medico ⨝ numSNS = numMedico prescricao)) 
-
γ numUtente; max(numMedico) -> maxDiferentes
(π numUtente, numMedico, numPresc
(medico ⨝ numSNS = numMedico prescricao)) ))
```
