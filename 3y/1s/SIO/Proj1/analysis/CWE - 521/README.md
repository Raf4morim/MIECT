#  CWE-521: Weak Password Requirements
## Definição

> *The product does not require that users should have strong passwords, which makes it easier for attackers to compromise user accounts.*
>
>by **Common Weakness Enumeration**

## Explicação

Esta será, talvez, a vulnerabilidade mais conhecida e aquela com a qual lidamos mais vezes. Maior parte dos processos de autenticação costumam precisar de uma palavra passe, sendo esta criada pelo utilizador e fundamental em operações como o "login". É fundamental que existam vários critérios para a criação da mesma, aumentando, significativamente, a sua complexidade. Com isso torna-se bastante mais complicado a um atacante, adivinhar a palavra passe.

Em quase todas as plataformas, é comum vermos estas condições ou semelhantes:

* Tamanho mínimo de caractéres
* Incluir caractéres numéricos, alfabéticos e especiais
* Dentro da gama de caractéres alfabéticos, incluir pelo menos uma letra maíscula e uma minúscula
