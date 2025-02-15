%% a -> para cada flow, calcular o caminho mais disponivel
clear ALL;close ALL;clc;

load('InputData2.mat')
nNodes= size(Nodes,1);
nLinks= size(Links,1);
nFlows= size(T,1);

MTTR= 24;
CC= 450;
MTBF= (CC*365*24)./L;
A= MTBF./(MTBF + MTTR); % disponibilidade de cada link
A(isnan(A))= 1;
Alog= -log(A);          % usado para calcular o shortpath

k = 1;                  % flow
sP= cell(2,nFlows);
nSP= zeros(1,nFlows);



for f=1:nFlows
    [shortestPath, totalCost] = kShortestPath(Alog,T(f,1),T(f,2),k);
    sP{1,f}= shortestPath;
    nSP(f)= length(totalCost);
    for i= 1:nSP(f)
        Aaux= Alog;
        path1= sP{1,f}{i};
        for j=2:length(path1)
            Aaux(path1(j),path1(j-1))= inf;
            Aaux(path1(j-1),path1(j))= inf;
        end
        [shortestPath, totalCost] = kShortestPath(Aaux,T(f,1),T(f,2),1);
        if ~isempty(shortestPath)
            sP{2,f}{i}= shortestPath{1};
        end
    end

    disponibilidade = 1;    % calculate disponibilidadeailabilty -> multiplicador neutro
    for node_idx = 1 : length(sP{1, f}{1}) - 1    % iterate through the first element of the path until the penultimate
        nodeA = sP{1, f}{1}(node_idx);      % first node of the link -> nodeA é 10
        nodeB = sP{1, f}{1}(node_idx + 1);  % second node of the link -> nodeB é 11
        disponibilidade = disponibilidade * A(nodeA, nodeB); % disponibilidade of the link between nodeA and nodeB
    end

    fprintf('Flow %d: disponibilidade = %.7f - Path = %s\n', f, disponibilidade, num2str(sP{1, f}{1}));
end

%% b -> a disponibilidade média por cada flow quando cada fluxo é encaminhado pelo caminho mais disponivel calculado no 10a
av_sum = 0;
for f=1:nFlows
    [shortestPath, totalCost] = kShortestPath(Alog,T(f,1),T(f,2),k);
    sP{1,f}= shortestPath;
    nSP(f)= length(totalCost);
    for i= 1:nSP(f)
        Aaux= Alog;
        path1= sP{1,f}{i};
        for j=2:length(path1)
            Aaux(path1(j),path1(j-1))= inf;
            Aaux(path1(j-1),path1(j))= inf;
        end
        [shortestPath, totalCost] = kShortestPath(Aaux,T(f,1),T(f,2),1);
        if ~isempty(shortestPath)
            sP{2,f}{i}= shortestPath{1};
        end
    end

    disponibilidade = 1;    % calculate disponibilidadeailabilty -> multiplicador neutro
    for node_idx = 1 : length(sP{1, f}{1}) - 1    % iterate through the first element of the path until the penultimate
        nodeA = sP{1, f}{1}(node_idx);      % first node of the link -> nodeA é 10
        nodeB = sP{1, f}{1}(node_idx + 1);  % second node of the link -> nodeB é 11
        disponibilidade = disponibilidade * A(nodeA, nodeB); % disponibilidade of the link between nodeA and nodeB
    end
    av_sum = av_sum + disponibilidade;
    avg_av = av_sum/nFlows;
end
fprintf('Average availability= %f\n', avg_av);

%% c -> Assumindo que o caminho mais disponivel por flow é o 1º caminho de encaminhamento. Para cada flow calcula o 2º caminho de encaminhamento
% se exitir dado pelo caminho mais disponivel que é a ligação disjunta com
% o calculo previo 