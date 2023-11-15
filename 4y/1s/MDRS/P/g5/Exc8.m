%% 8a
clear all;
close all;
clc;

load('InputData.mat');
nNodes= size(Nodes,1);
nLinks= size(Links,1);
nFlows= size(T,1);

% Plotting network in figure 10:
plotGraph(Nodes,Links,10);

% Computing k=10 shortest paths for flow f= 4:
% k= 1;
% f= 4;
% T(f,1) -> nó origem
% T(f,2) -> no destino
% matriz T disponivel no guiao exc 8
% k é o numero de percursos que se quer obter (se quisermos obter o maximo
%   de percursos podemos escrever infinito)
% retorna caminhos mais curtos, com os custos associados
% [shortestPath, totalCost] = kShortestPath(L,T(f,1),T(f,2),k);

% Visualizing the 6th path and its length:
% i= 6;
% fprintf('Path %d:  %s  (length= %.1f)\n\n',i,num2str(shortestPath{i}),totalCost(i));

% Computing up to k=6 shortest paths for all flows from 1 to nFlows:
k= 1;
sP= cell(1,nFlows);
nSP= zeros(1,nFlows);
for f=1:nFlows
    [shortestPath, totalCost] = kShortestPath(L,T(f,1),T(f,2),k);
    sP{f}= shortestPath;
    nSP(f)= length(totalCost);
end
% sP{f}{i} is the i-th path of flow f
% nSP(f) is the number of paths of flow f

% Visualizing all paths of flow 2:
f= 2;
for i= 1:nSP(f)
    fprintf('Flow %d - Path %d:  %s\n',f,i,num2str(sP{f}{i}));
end

% Compute the link loads using the first (shortest) path of each flow:
sol= ones(1,nFlows);
Loads= calculateLinkLoads(nNodes,Links,T,sP,sol);
% Determine the worst link load:
maxLoad= max(max(Loads(:,3:4)));

%Optimization algorithm based on random strategy:
t= tic;
timeLimit= 5;
bestLoad= inf;
contador= 0;
somador= 0;
while toc(t) < timeLimit
    sol= zeros(1,nFlows);
    for f= 1:nFlows
        sol(f)= randi(nSP(f));
    end
    Loads= calculateLinkLoads(nNodes,Links,T,sP,sol);
    load= max(max(Loads(:,3:4)));
    if load<bestLoad
        bestSol= sol;
        bestLoad= load;
        bestLoads= Loads;
    end
    contador= contador+1;
    somador= somador+load;
end

% 8a
%Output of routing solution:
fprintf('\nRouting paths of the solution:\n')
for f= 1:nFlows
    selectedPath= bestSol(f);
    fprintf('Flow %d - Path %d:  %s\n',f,selectedPath,num2str(sP{f}{selectedPath}));
end

%% 8b
fprintf('8b\n')
%Output of link loads of the routing solution:
fprintf('Worst link load of the best solution = %.2f\n',bestLoad);
fprintf('Link loads of the best solution:\n')
for i= 1:nLinks
    fprintf('{%d-%d}:\t%.2f\t%.2f\n',bestLoads(i,1),bestLoads(i,2),bestLoads(i,3),bestLoads(i,4))
end
%Output of performace values:
fprintf('No. of generated solutions = %d\n',contador);
fprintf('Avg. worst link load among all solutions= %.2f\n',somador/contador);

%% 8c


%% 8d

fprintf('\n\n8 D\n');

k= inf;
sP= cell(1,nFlows);
nSP= zeros(1,nFlows);
for f=1:nFlows
    [shortestPath, totalCost] = kShortestPath(L,T(f,1),T(f,2),k);
    sP{f}= shortestPath;
    nSP(f)= length(totalCost);
end

t= tic;
timeLimit= 5;
bestLoad= inf;
contador= 0;
somador= 0;
while toc(t) < timeLimit
    sol= zeros(1,nFlows);
    for f= 1:nFlows
        sol(f)= randi(nSP(f));
    end
    Loads= calculateLinkLoads(nNodes,Links,T,sP,sol);
    load= max(max(Loads(:,3:4)));
    if load<bestLoad
        bestSol= sol;
        bestLoad= load;
        bestLoads= Loads;
    end
    contador= contador+1;
    somador= somador+load;
end

fprintf('Worst link load of the best solution = %.2f\n',bestLoad);
fprintf('No. of generated solutions = %d\n',contador);
fprintf('Avg. worst link load among all solutions= %.2f\n',somador/contador);


%% 8e

fprintf('\n\n8 E\n');

k= 6;
sP= cell(1,nFlows);
nSP= zeros(1,nFlows);
for f=1:nFlows
    [shortestPath, totalCost] = kShortestPath(L,T(f,1),T(f,2),k);
    sP{f}= shortestPath;
    nSP(f)= length(totalCost);
end

t= tic;
timeLimit= 5;
bestLoad= inf;
contador= 0;
somador= 0;
while toc(t) < timeLimit
    sol= zeros(1,nFlows);
    for f= 1:nFlows
        sol(f)= randi(nSP(f));
    end
    Loads= calculateLinkLoads(nNodes,Links,T,sP,sol);
    load= max(max(Loads(:,3:4)));
    if load<bestLoad
        bestSol= sol;
        bestLoad= load;
        bestLoads= Loads;
    end
    contador= contador+1;
    somador= somador+load;
end

fprintf('Worst link load of the best solution = %.2f\n',bestLoad);
fprintf('No. of generated solutions = %d\n',contador);
fprintf('Avg. worst link load among all solutions= %.2f\n',somador/contador);



%% 8g

fprintf('\n\n8 G\n');

k= inf;
sP= cell(1,nFlows);
nSP= zeros(1,nFlows);
for f=1:nFlows
    [shortestPath, totalCost] = kShortestPath(L,T(f,1),T(f,2),k);
    sP{f}= shortestPath;
    nSP(f)= length(totalCost);
end

t= tic;
timeLimit= 5;
bestLoad= inf;
contador= 0;
somador= 0;
while toc(t) < timeLimit
    sol= zeros(1,nFlows);
    for f= randperm(nFlows)
        auxBest=inf; % Melhor solução até agr tem um valor infinito, i.e., n tenho nenhuma
        for i = 1:nSP(f)
            sol(f)= i;
            auxLoads = calculateLinkLoads(nNodes, Links, T, sP, sol);
            auxLoad = max(max(auxLoads(:,3:4)));
            if auxLoad < auxBest
                auxBest = auxLoad; % guardo se for menor
                iBest = i;
            end
        end
        sol(f) = iBest;
    end
    Loads= calculateLinkLoads(nNodes,Links,T,sP,sol);
    load= max(max(Loads(:,3:4)));
    if load<bestLoad
        bestSol= sol;
        bestLoad= load;
        bestLoads= Loads;
    end
    contador= contador+1;
    somador= somador+load;
end

fprintf('Worst link load of the best solution = %.2f\n',bestLoad);
fprintf('No. of generated solutions = %d\n',contador);
fprintf('Avg. worst link load among all solutions= %.2f\n',somador/contador);


% Dando o mesmo tempo a 2 estrategias
% perceber o mais que tem mais benefios
% por 1 lado esta estratégia tem
% menos soluções mas as soluções são muito melhor

%% 8H

fprintf('\n\n8 H\n');

k= 6;
sP= cell(1,nFlows);
nSP= zeros(1,nFlows);
for f=1:nFlows
    [shortestPath, totalCost] = kShortestPath(L,T(f,1),T(f,2),k);
    sP{f}= shortestPath;
    nSP(f)= length(totalCost);
end

t= tic;
timeLimit= 5;
bestLoad= inf;
contador= 0;
somador= 0;
while toc(t) < timeLimit
    sol= zeros(1,nFlows);
    for f= randperm(nFlows)
        auxBest=inf; % Melhor solução até agr tem um valor infinito, i.e., n tenho nenhuma
        for i = 1:nSP(f)
            sol(f)= i;
            auxLoads = calculateLinkLoads(nNodes, Links, T, sP, sol);
            auxLoad = max(max(auxLoads(:,3:4)));
            if auxLoad < auxBest
                auxBest = auxLoad; % guardo se for menor
                iBest = i;
            end
        end
        sol(f) = iBest;
    end
    Loads= calculateLinkLoads(nNodes,Links,T,sP,sol);
    load= max(max(Loads(:,3:4)));
    if load<bestLoad
        bestSol= sol;
        bestLoad= load;
        bestLoads= Loads;
    end
    contador= contador+1;
    somador= somador+load;
end

fprintf('Worst link load of the best solution = %.2f\n',bestLoad);
fprintf('No. of generated solutions = %d\n',contador);
fprintf('Avg. worst link load among all solutions= %.2f\n',somador/contador);
