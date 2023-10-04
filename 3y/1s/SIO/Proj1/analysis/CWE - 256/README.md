# CWE-256:  Plaintext Storage of a Password

## Definição

> *Storing a password in plaintext may result in a system compromise*
>
>by **Common Weakness Enumeration**

## Explicação

Esta vulnerabilidade refere-se a situações em que uma password criada, é registada na respetiva base de dados mas não é encriptada. Não havendo qualquer criptografia, um atacante que consiga aceder à base de dados, consegue obter todas as passwords de todos os utilizadores registados.
