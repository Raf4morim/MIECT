# BD: Guião 7


## ​7.2 
 
### *a)*

```
Está na 1ª Forma Normal porque os atributos são todos atómicos e não existem
relações dentro de relações.
Não está na 2ª FN porque existe dependência parcial. (Afiliação_Autor depende apenas de Nome_Autor).
```

### *b)* 
Para normalizar até à 2ªFN decompomos a relação em duas por forma a eliminar a dependência parcial de Afiliacao_Autor, que apenas depende do Nome_Autor:

R1 (<u>Titulo_Livro</u>, <u>Nome_Autor</u>, Tipo_Livro, Preco, NoPaginas, Editor, Endereco_Editor, Ano_Publicacao)
- Titulo_Livro, Nome_Autor -> Tipo_Livro, NoPaginas, Editor, Ano_Publicacao
- Tipo_Livro, NoPaginas -> Preco
- Editor -> Endereco_Editor

R2 (<u>Nome_Autor</u>, Afiliacao_Autor)
- Nome_Autor -> Afiliacao_Autor

Para normalizar até à 3ªFN é necessário eliminar as dependências transitivas, sendo que para tal passamos de duas 
relações para quatro.

R1 (<u>Titulo_Livro</u>, <u>Nome_Autor</u>, Tipo_Livro, NoPaginas, Editor, Ano_Publicacao)
- Titulo_Livro, Nome_Autor -> Tipo_Livro, NoPaginas, Editor, Ano_Publicacao

R2 (<u>Nome_Autor</u>, Afiliacao_Autor)
- Nome_Autor -> Afiliacao_Autor

R3 (<u>Tipo_Livro</u>, <u>NoPaginas</u>, Preco)
- Tipo_Livro, NoPaginas -> Preco

R4 (<u>Editor</u>, Endereco_Editor)
- Editor -> Endereco_Editor

## ​7.3

F= {
    {A,B}   -> {C},     
    {A}     -> {D,E},   
    {B}     -> {F},     
    {F}     -> {G,H},   
    {D}     -> {I,J}    
}
### *a)*
```
A chave de R é A e B, porque estes atributos não depende de nenhum outro e outros dependem destes.
```
### *b)* 

2FN -> Não pode ter dependências parciais

R1 (<u>A</u>, <u> B </u>, C)
- A, B -> C

R2 (<u>A</u>, D, E, I, J)    
- A -> D, E
- D -> I, J

R3 (<u>B</u>, F, G, H)
- B -> F
- F -> G, H

### *c)* 

3FN -> Não pode ter dependências transitivas

R1 (<u>A</u>, <u> B </u>, C)
- A, B -> C

R2 (<u>A</u>, D, E)    
- A -> D, E

R3 (<u>D</u>, I, J)

- D -> I, J

R4 (<u>B</u>, F)
- B -> F

R5 (<u>F</u>, G, H)

- F -> G, H

## ​7.4
 
### *a)*

```
A chave de R é A e B, porque os dois juntos determinam unicamente os valores de C, D e E.
```


### *b)* 

R1 (<u>A</u>, <u>B</u>, C, D)
- A, B -> C, D

R2 (<u>D</u>, E)
- D -> E

R3 (<u>C</u>, A)
- C -> A

### *c)* 

R1 (<u>C</u>, <u>B</u>, D)
- C, B -> D

R2 (<u>D</u>, E)
- D -> E

R3 (<u>C</u>, A)
- C -> A


## ​7.5
 
F= {
    {A,B}   -> {C, D, E},     
    {A}     -> {C},   
    {C}     -> {D},
}

### *a)*


```
A chave de R é A e B, porque estes atributos não depende de nenhum outro e outros dependem destes.
```

### *b)* 

2FN -> Não pode ter dependências parciais

R1 (<u>A</u>, <u>B</u>, C, D, E)
- A, B -> C, D, E

R2 (<u>A</u>, C, D)
- A -> C
- C -> D

### *c)* 

3FN -> Não pode ter dependências transitivas

R1 (<u>A</u>, <u>B</u>, C, D, E)
- A, B -> C, D, E

R2 (<u>A</u>, C)
- A -> C

R3 (<u>C</u>, D)
- C -> D

### *d)* 

BCNF -> Todos os atributos são funcionalmente dependentes da chave da relação, de toda a chave e de nada mais.

Logo BCNF = 3NF