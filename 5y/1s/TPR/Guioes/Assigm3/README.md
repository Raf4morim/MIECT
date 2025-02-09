# Resumo
O documento detalha técnicas de percepção de redes e conscientização de redes, com foco em perfis de entidades, extração de características, agrupamento, detecção de anomalias, detecção de anomalias por meio de aprendizado de máquina e classificação com aprendizado de máquina. Também aborda a avaliação dos resultados e a importância da escolha adequada dos parâmetros de observação.

### Capítulo 1: Perfil de Entidades e Detecção de Anomalias
- O capítulo discute a importância do perfil das entidades em redes.
- Técnicas de __clustering__, detecção de anomalias e __classificação__ para criar perfis de entidades.

### Capítulo 2: Extração de Características
- O capítulo introduz a extração de características, abordando características independentes e dependentes do tempo.
- Utiliza um script fornecido para extrair características como média, mediana e desvio padrão das contagens de pacotes e bytes ao longo do tempo.
- Também explora as características dos períodos de silêncio, como o número de períodos, média e desvio padrão da duração.
- Recomenda a análise de diferentes combinações de características e a busca por discriminadores entre as aplicações.

### Capítulo 3: Conjuntos de Características para Treinamento e Teste
- O capítulo destaca a importância da criação de conjuntos de características para treinamento e teste.
- Sugere a construção de três conjuntos de dados diferentes: 
1. um para detecção de anomalias com base nas classes YouTube e Browsing,
2. um para classificação de tráfego com base nas três classes de dados 
3. um para teste de detecção de anomalias e classificação de tráfego com base nos três conjuntos de treinamento.

### Capítulo 4: Agrupamento
- O capítulo aborda a aplicação do algoritmo de agrupamento **K-Means ao conjunto de dados de treinamento das três classes**.
- Sugere a análise dos rótulos de cada observação e a comparação com o rótulo conhecido.
- Propõe-se testar o algoritmo com diferentes números de clusters e aplicar normalização aos valores de entrada.
- Também sugere a proposição de um algoritmo de classificação para o conjunto de testes com base nos rótulos conhecidos do conjunto de treinamento.

### Capítulo 5: Clustering DBSCAN
- O capítulo propõe a aplicação do algoritmo de agrupamento DBSCAN ao conjunto de dados de treinamento das três classes.
- Destaca que o número de classes é desconhecido.
- Sugere a análise dos rótulos de cada observação e a comparação com o rótulo conhecido.
- Propõe testar o algoritmo com diferentes valores de epsilon (eps) e sem aplicar normalização aos valores de entrada.
- Explica o resultado insatisfatório da falta de normalização.
- Também sugere a proposição de um algoritmo de classificação para o conjunto de testes com base nos rótulos conhecidos do conjunto de treinamento.

### Capítulo 6: Algoritmos de Agrupamento Alternativos
- O capítulo menciona a possibilidade de testar outros algoritmos de agrupamento além do:

> K-Means 
    >> Requer que o número de clusters seja **especificado a priori**.<br>
    >> Funciona atribuindo pontos a clusters com base na proximidade das médias (centróides) dos clusters. <br>
    >> Ótimo para dados bem distribuídos e quando o número de clusters é conhecido.

> DBSCAN -> Mais indicado para wpp maybe
    >> Não requer a definição prévia do número de clusters. <br>
    >> Identifica clusters com base na densidade de pontos próximos, considerando regiões com alta densidade como clusters. <br>
    >> Lida bem com dados de forma irregular e pode identificar ruídos como pontos que não pertencem a nenhum cluster. <br>

### Capítulo 7: Detecção de Anomalias (Análise Estatística)
- O capítulo trata da detecção de anomalias por meio de análise estatística.
- Define as classes de tráfego Browsing e YouTube como tráfego lícito e a classe Crypto-Minning como uma anomalia.
- Propõe calcular a distância euclidiana relativa de cada observação do conjunto de testes em relação ao centróide de cada classe de tráfego lícito.
- Sugere a identificação de observações anormais com base em uma determinada distância limite.
- Propõe testar o algoritmo com diferentes valores do limiar de anomalia e aplicar normalização aos valores de entrada.
- Explica os resultados obtidos com a normalização dos valores.

### Capítulo 8: Detecção de Anomalias (Aprendizado de Máquina com SVM de Uma Classe)
- O capítulo propõe o uso de máquinas de vetores de suporte (SVM) de uma classe para a detecção de anomalias.
- Sugere o uso de diferentes kernels (linear, RBF e polinomial) com as SVMs.
- Propõe testar o modelo com diferentes valores de mu.
- Também sugere a aplicação de normalização aos valores de entrada e a proposição de um processo de decisão com base em uma metodologia de conjunto.

### Capítulo 9: Algoritmos Alternativos de Detecção de Anomalias
- O capítulo menciona a possibilidade de testar outros algoritmos de detecção de anomalias, como Local Outlier Factor (LOF) e Isolation Forest (IF).
- Fornece um link para esses algoritmos disponíveis na biblioteca scikit-learn.

<Capítulo 10: Classificação (Aprendizado de Máquina)>
- O capítulo aborda a classificação com o uso de máquinas de vetores de suporte (SVM) e diferentes kernels (linear, RBF e polinomial).
- Sugere a análise dos rótulos de cada observação do conjunto de testes e a comparação com o rótulo conhecido.
- Propõe a aplicação de normalização aos valores de entrada e a proposição de um processo de decisão com base em uma metodologia de conjunto.

<Capítulo 11: Classificação (Redes Neurais)>
- O capítulo propõe o uso de redes neurais para a classificação do conjunto de testes.
- Inicialmente, sugere uma camada oculta com 20 nós e posteriormente indica a exploração de outros tamanhos de camadas ocultas.
- Realiza a análise dos rótulos de cada observação do conjunto de testes e a comparação com o rótulo conhecido.
- Propõe testar o modelo com diferentes tamanhos de camada oculta e também sem a aplicação de normalização aos valores de entrada.
- Também sugere a proposição de um processo de decisão com base em uma metodologia de conjunto.

<Capítulo 12: Algoritmos Alternativos de Classificação>
- O capítulo menciona a possibilidade de testar outros algoritmos de classificação, como Árvores de Decisão (DTs) e Florestas Aleatórias (Random Forests).
- Fornece um link para esses algoritmos disponíveis na biblioteca scikit-learn.

<Capítulo 13: Avaliação dos Resultados de Classificação/Detecção de Anomalias>
- O capítulo destaca a importância da avaliação dos resultados por meio de métricas como precisão, recall, ac