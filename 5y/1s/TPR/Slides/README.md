# Consciência Situacional Cibernética

## Tipos de Consciência:

**Consciência Direta**: Obtida por observação direta.

**Consciência Indireta**: Adquirida por meio da análise de reações a eventos.

**Consciência por Correlação**: Envolve a análise conjunta de múltiplas fontes de dados para detectar padrões e relações ocultas, geralmente considerada um problema de Big Data.

**Consciência por Predição**: Detecção de padrões ao longo do tempo, incluindo o problema de prever eventos raros e impactantes, conhecidos como "Black Swan".

# Conceito Consciência Situacional Cibernética

Destaca a habilidade de adquirir dados efetivamente monitorando redes e sistemas para otimizar serviços e detectar e contrariar atividades ou eventos anômalos.
Inclui a análise e processamento de dados para conhecer e caracterizar entidades de rede, fluxos de dados e a percepção de serviços e usuários.
Fontes de Dados e sua Relevância:

Todos os tipos de fontes de dados são considerados aceitáveis e nunca se deve assumir que dados são irrelevantes.
Os dados podem ser quantitativos, permitindo análise estatística e podendo servir como entrada para treinamento de aprendizado de máquina, ou qualitativos, que podem ser transformados em quantitativos através de técnicas de contagem e caracterização estatística.

## Relevância do Tempo:

O tempo é um fator relevante, tanto de forma relativa quanto absoluta, indicando que um evento ocorre em um instante específico e faz parte de uma sequência de eventos.

A escala de tempo da análise deve incluir as características do alvo e permitir a percepção do evento em tempo hábil para uma resposta. Além disso, os dados podem ser reescalados para diversos propósitos analíticos.

### 4 Etapas Situacional Cibernética:
- **Aquisição de Dados**: Esta é a primeira etapa na qual os dados são coletados de várias fontes para análise.
- **Processamento de Dados**: Criação de sequências temporais com diferentes intervalos de contagem (escalas de tempo mínimas).
Criação de sequências temporais com diferentes métricas estatísticas (escalas de tempo maiores).
- **Criação de Perfis de Comportamento de Entidades**: Isso geralmente é dependente do tempo e envolve o monitoramento e a análise do comportamento de entidades específicas ao longo do tempo para estabelecer um perfil de comportamento "normal".
- **Classificação de Comportamentos de Entidades**: Identificação e classificação de comportamentos, que podem ser usados para diferenciar entre comportamentos típicos e atípicos.
Detecção de anomalias, uma parte crucial da consciência situacional que envolve a identificação de comportamentos que desviam dos padrões normais.

Estas etapas são críticas para o desenvolvimento de uma consciência situacional eficaz, permitindo que os responsáveis pela segurança cibernética compreendam e respondam de forma proativa a ameaças potenciais e eventos em tempo real.

## Tipos de Network Atack Vectors (1 e 2):

### Objetivos:

Ataques podem ser motivados por diversão, reputação no hacking, propósitos políticos, militares, econômicos, ou outros fins não especificados.

### Objetivos Técnicos:

Os ataques técnicos podem ter como objetivo interromper operações, interceptar dados ou ambos. Há estratégias que utilizam a interrupção para facilitar a interceptação de dados, ou vice-versa.

### Métodos de Ataque Específicos:

Interrupção de operações, como ataques de negação de serviço distribuído (DDoS).
Sequestro de recursos para enviar spam, mineração de criptomoedas ou como plataforma para outros ataques.
Interceptação ou roubo de dados, que podem incluir dados pessoais, técnicos ou comerciais.

### Defesas Tradicionais:

Incluem a aplicação de patches de segurança para vulnerabilidades conhecidas, o uso de firewalls (centralizados ou distribuídos) e sistemas de prevenção e detecção de intrusão (IDS/IPS).
O uso de antivírus é comum, mas todas essas estratégias tradicionais dependem do conhecimento prévio da ameaça ou do problema.

### Defesas "Inteligentes":

Focam na detecção de ameaças desconhecidas em tempo hábil para implantar contramedidas.
Utilizam técnicas de Big Data e Ciência de Dados para monitorar dados de rede e sistemas.
Algumas soluções tradicionais começaram a incorporar Inteligência Artificial (IA) em seus equipamentos, como firewalls da Palo Alto Networks e dispositivos da Cisco.
No entanto, essas defesas ainda são limitadas em escopo e baseadas em soluções específicas do fabricante e dados localizados.
A implantação ótima ainda requer um conhecimento abrangente da rede e dos sistemas para uma verdadeira Consciência Situacional Cibernética.

## Ataques de Perturbação (Disrupt):

Ataques DoS Distribuídos (Distributed Denial of Service - DDoS) usam vários dispositivos para gerar tráfego excessivo a um alvo, interrompendo suas operações normais. As soluções incluem balanceadores de carga e reset de sessão para tráfego TCP, além de bloqueio de requisições para servidores DNS externos a fim de prevenir amplificação de ataques e spoofing de IP. A detecção de comportamentos anômalos é utilizada para identificar esses ataques, embora variações de tráfego baixas sejam difíceis de detectar. Também há menção a ataques de negação de serviço por jamming de sinal físico, que podem ser usados para perturbar ou ativar canais secundários mais vulneráveis.

## Fases de Ataques Mais Avançados:

Descrevem um processo cíclico que começa com a aquisição de conhecimento e segue com infiltração, aprendizado, propagação, e exfiltração de dados. Este ciclo pode ser repetido várias vezes, cada vez com mais conhecimento adquirido pelo atacante, permitindo o acesso a áreas cada vez mais protegidas até que a exfiltração de dados relevantes seja possível.

## Fase de Infiltração:

Máquinas legítimas podem ser comprometidas para implementar diferentes fases de ataques, idealmente dentro de uma zona privilegiada da rede com credenciais de acesso e software especializado.

## Explorando Users Legítimos:

Ataques remotos podem ser realizados explorando usuários legítimos, através de phishing por e-mail ou redes sociais, inserção de software malicioso, e ransomware. Vetores incluem execução de binários maliciosos e software baixável de fontes não certificadas.

## Ações do Atacante Remoto:

Ataques são possíveis quando há vulnerabilidades não corrigidas ou sistemas mal configurados. Geralmente, esses ataques não são realizados primeiro, mas depois de adquirir algumas credenciais ou privilégios de usuários legítimos.

## Localmente por Interação Física:

Inclui a exploração de acessos físicos, como portas Ethernet em locais públicos ou desprotegidos, torneiras de rede e pontos de acesso falsos.

## Uso Ilícito de Portas Ethernet:

Discute a proteção comum contra uso ilícito de portas Ethernet, como isolamento de VLAN e 802.1X. Portas não utilizadas e em uso podem ser exploradas para ataques como inundação de MAC e sobrecarga de rede, além de permitir espionagem de tráfego, injeção e ataques de man-in-the-middle (MITM).

## Tapping de Rede:

Descreve como os ataques podem ser realizados através de pontos de espelho (mirror ports) em switches e torneiras de cabos Ethernet, permitindo a espionagem de tráfego.

**Switch Rogue Mirror Ports**: Estas são portas de switch configuradas para receber cópias do tráfego que passa por outras portas do switch. Isso permite que alguém monitore silenciosamente o tráfego de rede sem interferir na comunicação normal. A solução para prevenir o uso malicioso é monitorar constantemente as mudanças de configuração nos dispositivos de rede.

**Ethernet Cable Tap**: Dispositivos físicos podem ser conectados a um cabo Ethernet, permitindo que o tráfego seja interceptado ("snooping") e, potencialmente, que dados sejam injetados na rede. A detecção desses dispositivos pode ser desafiadora, e uma possível solução seria procurar por variações elétricas que indiquem interferência.

**Optical Cable Tap**: Semelhante aos cabos Ethernet, os cabos de fibra óptica podem ser alvos de dispositivos de interceptação que capturam o tráfego de dados sem interromper a comunicação. A solução para prevenir esse tipo de espionagem pode ser a criptografia quântica, que utiliza os princípios da mecânica quântica para detectar qualquer tentativa de interceptação, já que a medição do estado quântico dos dados alteraria os próprios dados, revelando a presença do espião.

## Wireless Attack Vectors:

Apresenta vetores de ataque wireless, incluindo pontos de acesso falsos e vulnerabilidades em autenticações baseadas na web, que podem ser exploradas para ataques DoS ou interceptação de dados wireless.



