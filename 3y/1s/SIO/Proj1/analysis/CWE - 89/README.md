# CWE-89: Improper Neutralization of Special Elements used in an SQL Command ('SQL Injection')

## Definição

> *The software constructs all or part of an SQL command using externally-influenced input from an upstream component, but it does not neutralize or incorrectly neutralizes special elements that could modify the intended SQL command when it is sent to a downstream component.*
>
>by **Common Weakness Enumeration**

## Explicação

Para ser possível desenvolver uma aplicação/website dinâmico com dados persistentes, temos de os armazenar em algum lado. Para esse objetivo são usadas bases de dados, mas estas têm de ser protegidas de ataques, como "SQL injections". Caso contrário, um atacante poderá manipular intruções SQL com o objetivo comprometer a aplicação/ o website ou até aceder a dados, que lhe são privados.

Isto levanta a questão, o que fazer para proteger a base de dados deste tipo de ataques? 

A solução será abordada no relatório do projeto.


