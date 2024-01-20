% ----------------- Task 2 ----------------- %
clear all;
close all;
clc;

load('InputDataProject2.mat')
nNodes= size(Nodes,1);
nLinks= size(Links,1);
nFlows1= size(T1,1);
nFlows2= size(T2,1);

D = L/(2*10^5);
%% 2a
% ----------------- Service 1 ----------------- %
k= 6;
sP= cell(1,nFlows);
nSP= zeros(1,nFlows);
for f=1:nFlows
    [shortestPath, totalCost] = kShortestPath(L,T(f,1),T(f,2),k);
    sP{f}= shortestPath;
    nSP(f)= length(totalCost);
end

t = tic;
timeLimit = 2;
bestLinkEnergy= inf;
bestMinDelay = inf;
contador = 0;
while toc(t) < timeLimit
    sol = zeros(1,nFlows);
    [sol, ~, linkEnergy] = Task3_GreedyRandomized(nNodes, Links, T, L, sP, nSP, sol);
    [sol, minDelay, linkEnergy] = Task3_hillClimbing(sol, nNodes, Links, T, L, sP, nSP, linkEnergy);

    if minDelay < bestMinDelay
        bestSol = sol;
        bestMinDelay = minDelay;
        bestLinkEnergy = linkEnergy;
        bestTime = toc(t);
    end
    contador=contador+1;
end

% Calculate energy comsuption
nodesEnergy = calculateNodeEnergy(T,sP,bestSol);
total_energy = nodesEnergy + bestLinkEnergy;


fprintf('Service 1\n');

fprintf('\nBest average round-trip delay = %.2f\n', bestMinDelay);
fprintf('Network energy comsuption of the solution = %.2f\n',total_energy);
fprintf('Best link energy consumption = %.2f\n', bestLinkEnergy);
fprintf('Time to obtain best solution = %f sec\n', bestTime);
fprintf('Number of algorithm iterations = %d\n', contador);

% ----------------- Service 2 ----------------- %
sP= cell(1,nFlows2);
nSP= zeros(1,nFlows2);
for f=1:nFlows2
    [shortestPath, totalCost] = kShortestPath(L,T2(f,1),T2(f,2),k);
    sP{f}= shortestPath;
    nSP(f)= length(totalCost);
end

t= tic;
timeLimit= 2; % runtime limit of 60 seconds
bestLinkEnergy= inf;
bestMinDelay = inf;
contador= 0;
while toc(t) < timeLimit
    sol= zeros(1,nFlows2);
    [sol, ~, linkEnergy] = Task3_GreedyRandomized(nNodes, Links, T2, L, sP, nSP, sol);
    [sol, minDelay, linkEnergy] = Task3_hillClimbing(sol, nNodes, Links, T2, L, sP, nSP, linkEnergy);

    if minDelay < bestMinDelay
        bestSol = sol;
        bestMinDelay = minDelay;
        bestLinkEnergy = linkEnergy;
        bestTime = toc(t);
    end

    contador= contador+1;
end

% Calculate energy comsuption
nodesEnergy = calculateNodeEnergy(T2,sP,bestSol);
total_energy = nodesEnergy + bestLinkEnergy;

fprintf('Service 2\n');
fprintf('\nBest average round-trip delay = %.2f\n', bestMinDelay);
fprintf('Network energy comsuption of the solution = %.2f\n',total_energy);
fprintf('Best link energy consumption = %.2f\n', bestLinkEnergy);
fprintf('Time to obtain best solution = %f sec\n', bestTime);
fprintf('Number of algorithm iterations = %d\n', contador);
