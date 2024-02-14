# BD: Trabalho Prático APFE

**Grupo: P7G5**
- Rafael Amorim, MEC: 98197
- Tiago Alves, MEC: 104110

## Introdução / Introduction

Base de dados para gerir todo o processo logístico de uma Empresa de Alumínios. Esta aplicação permite a criação de uma ficha do cliente na qual é possível inserir as medidas das portas/janelas a construir/substituir, selecionar o material preferido e criar vários orçamentos consoante a preferência do cliente. Após todas as escolhas e tendo o tempo estimado para a realização do projeto é calculado o orçamento através do **Sistema Gestão de Alumínios**.
Para além destas funcionalidades, é possível ver o estado de um projeto, que envolve diversas encomendas, funcionários, impostos, rendas, etc.


## Análise de requisitos

  O sistema deve ser capaz de:
  - Inserir/remover novos clientes.
  - Inserir/remover novos funcionários.
  - Inserir/Remover novos projetos, com o cliente e os funcionários envolvidos.
  - Possibilitar ao Sr. Amorim criar orçamentos de acordo com a inserção de dados fornecidos pelos clientes na base de dados, como por exemplo, a quantidade e dimensões de janelas, portas, portadas que precisam de ser trabalhadas e tipo de material. O cliente pode definir um limite de preço. O orçamento será feito tendo em conta os transportes realizados, a mão de obra, preço do material e o limite de preço.
  - Editar características do projeto.
  - Pesquisar por funcionários da empresa, vendo as suas características e se estão disponíveis de momento ou não.
  - Pesquisar por características dos clientes.
  - Pesquisar por projetos a decorrer, clientes associados e datas limite impostas pelos clientes para os mesmos (urgência).
  - Verificar datas de chegada de encomendas e o material que se encontra nestas.
  - Inserir novas encomendas.
  - Verificar dados de fornecedores, como localização, IBANs, etc...
  - Consultar o stock de material.
  - Inserir e remover material do stock preciso para o projeto.
  - Deve ser possível consultar o historico dos projetos terminados.

## Topicos para Fazer o DER

1. O cliente tem associado a si um projeto, sendo este caracterizado por duração, identificação do projeto, quantidade de janelas, portas, portadas.
2. O cliente é caracterizado por Nome, Telemóvel, Mail, CC, NIF, morada, distância até à empresa.
3. Um projeto tem associado vários funcionários, caracterizados pelo Nome, Idade, CC, NIF, Mail, Ordenado, Seguro de Acidente.
4. Um funcionário pode ser responsável por um ou mais projetos.
5. Para um projeto pode ser preciso realizar encomendas se o material não estiver em stock.
6. A encomenda tem associado código, data de chegada total. A encomenda contém um ou mais materiais e as respetivas unidades.
7. Um material pode ser encomendado a diversos fornecedores e diversos materiais podem ser encomendados a um fornecedor.
8. O material é muito diversificado. Este é caracterizado por nome, preço por unidade, taxa de IVA, número de referência (tipo), dimensão e espessura (estores), termicidade e cor.
9. O fornecedor é caracterizado por nome, NIF, IBAN, localização, distância até à empresa, entre outros.
10. O orçamento de cada projeto é calculado somando a mão de obra, isto é, duração do projeto vezes o numero de funcionarios envolvidos, preço dos materiais e transportes.
11. O cliente procede ao pagamento depois da conclusão do projeto.

## ​Análise de Requisitos / Requirements

## DER
<div align="center">

![DER Diagram!](der.jpg "AnImage")

</div>

## ER

<div align="center">

![ER Diagram!](er.jpg "AnImage")

</div>