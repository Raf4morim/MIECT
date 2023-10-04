# Projeto 1 - Vulnerabilidades 

## Equipa nº18

| Nmec | Nome | Email |
| :---: | :---: | :---: |
| 98197 | Rafael Amorim | rafael.amorim@ua.pt | 
| 98403 | Diogo Fontes | diogo.fontes@ua.pt |
| 98506 | João Figueiredo | jrcidra@ua.pt |
| 104110 | Tiago Alves | tiagojba9@ua.pt |

## Descrição

Este projeto foi realizado no âmbito da disciplina de Segurança Informática e nas Organizações, sendo o objetivo explorar vulnerabilidades e criar uma correção para as mesmas.

O projeto pretende representar uma página web de uma clínica de saúde, onde o  utilizador pode consultar informação acerca da mesma, contactar a clínica e fazer pedidos aos médicos.

Para representar e explorar as vulnerabilidades neste projeto, foram desenvolvidas duas aplicações, uma vulnerável e outra segura.
A aplicação vulnerável não possui qualquer mecanismo para prevenir as vulnerabilidades de serem exploradas, permitindo que o correto funcionamento da aplicação e privacidade de dados seja comprometida.
Já a aplicação segura possui formas de prevenir a exploração dessas vulnerabilidades.

Para o projeto, ambas as aplicações, foram desenvolvidas em python com recurso à framework, FLASK.

## Vulnerabilidades

### Obrigatórias
* [CWE-79: Improper Neutralization of Input During Web Page Generation ('Cross-site Scripting')](/analysis/CWE%20-%2079/README.md)
* [CWE-89: Improper Neutralization of Special Elements used in an SQL Command ('SQL Injection')](/analysis/CWE%20-%2089/README.md)

### Adicionais
*   [CWE-200: Exposure of Sensitive Information to an Unauthorized Actor](/analysis/CWE%20-%20200/README.md)
*   [CWE-256:  Improper Input Validation](/analysis/CWE%20-%20256/README.md)
*   [CWE-287: Improper Authentication](/analysis/CWE%20-%20287/README.md)
*   [CWE-425: Direct Request ('Forced Browsing')](/analysis/CWE%20-%20425/README.md)
*   [CWE-521: Weak Password Requirements](/analysis/CWE%20-%20521/README.md)


## Pontuação das Vulnerabilidades

Versão das pontuações é a 3.0

| Vulnerabilidade  | Pontuação |
| ------------- | ------------- |
| [CWE-79](/analysis/CWE%20-%2079/README.md)   | 6.5 | 
| [CWE-89](/analysis/CWE%20-%2089/README.md)   | 9.1 |
| [CWE-200](/analysis/CWE%20-%20200/README.md) | 5.6 |
| [CWE-256](/analysis/CWE%20-%20256/README.md) | 6.5 |
| [CWE-287](/analysis/CWE%20-%20287/README.md) | 8.2 |
| [CWE-425](/analysis/CWE%20-%20425/README.md) | 5.3 |
| [CWE-521](/analysis/CWE%20-%20521/README.md) | 7.5 |

Pontuação total = 48.7
