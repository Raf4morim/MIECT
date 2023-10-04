# CWE-79: Improper Neutralization of Input During Web Page Generation ('Cross-site Scripting')

## Definição

> *The software does not neutralzie or incorrectly neutralizes user-controllable input before it is placed in output that is used as a web page that is served to other users.*
>
>by **Common Weakness Enumeration**

## Explicação

Conhecida como "Cross-site Scripting"(XSS), é um tipo de vulnerabilidade de segurança. Encontra-se normalmente em aplicações web, que permitem ataques maléficos ao injetaram "client-side scripts" dentro de páginas web, estas vistas por outros utilizadores.

Através de XSS, o atacante injeta código javascript nos campos de texto presentes no site, por exemplo, comentários num fórum.
