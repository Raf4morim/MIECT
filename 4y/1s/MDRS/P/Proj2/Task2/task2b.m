clear all;
close all;
clc;

load('InputDataProject2.mat');
nNodes = size(Nodes, 1);
nLinks = size(Links, 1);
nFlows1= size(T1,1);
nFlows2= size(T2,1);
T = [T1; T2];
nFlows = size(T, 1);

% Matriz D -> atraso de propagacao
D = L / (2 * 10^5); % L -> Matriz com comprimento de todas ligacoes

%% 2.b) Energy Optimization
fprintf('\n2.b) Energy Optimization\n\n');

% Computing up to k=2 shortest paths for all flows:
k= 2;
sP= cell(1,nFlows);
nSP= zeros(1,nFlows);
for f=1:nFlows
    [shortestPath, totalCost] = kShortestPath(L,T(f,1),T(f,2),k);
    sP{f}= shortestPath;
    nSP(f)= length(totalCost);
end

t = tic;
timeLimit = 60; % runtime limit of 60 seconds
bestEnergy = inf;
contador = 0;
bestLoad = inf;
somador = 0;
while toc(t) < timeLimit
    %sol = zeros(1, nFlows);

    [sol, Loads, totalEnergy] = Task2a_GreedyRandomized_EnergyOptimized(nNodes, Links, T, L, sP, nSP);
    
    % First solution must have maxLoad bellow max capacity (100)
    while totalEnergy == inf
        [sol, Loads, totalEnergy] = Task2a_GreedyRandomized_EnergyOptimized(nNodes, Links, T, L, sP, nSP);
    end

    [sol, load, Loads, totalEnergy] = Task2a_hillClimbing_EnergyOptimized(sol, nNodes, Links, T, L, sP, nSP, totalEnergy, Loads);
    if totalEnergy < bestEnergy
        bestSol = sol;
        bestLoad = load;
        bestLoads = Loads;
        bestEnergy = totalEnergy;
        bestTime = toc(t);
    end
    contador = contador + 1;
    somador=somador+load;
end

% Calculate round-trip propagation delay
T1_idx = 1:nFlows1;
T2_idx = 1+nFlows1:nFlows;
delays = calculateServiceDelays(sP, bestSol, D, T);
averageRoundTripDelay1 = mean(delays(T1_idx));
averageRoundTripDelay2 = mean(delays(T2_idx));

% Calculate average Link Load
link_load_sum = 0;
for i=1:nLinks
    link_load_sum = link_load_sum + sum(bestLoads(i,3:4));
end
avgLinkLoadSol = link_load_sum / nLinks;
worstLinkLoad = max(max(Loads(:, 3:4)));

% Calculate links not supporting any traffic flow
linksNoTraffic = find(sum(Loads(:, 3:4), 2) == 0);

fprintf('For k= %s and time=%s\n',int2str(k), int2str(timeLimit));
fprintf('Worst link load of the solution = %.2f Gbps\n', worstLinkLoad);
fprintf('Average link load of the solution = %.2f Gbps\n', avgLinkLoadSol/2);
fprintf('Total network energy consumption of the solution = %.2f\n', bestEnergy);

fprintf('Average round-trip propagation delay of service 1 = %f sec\n',averageRoundTripDelay1);
fprintf('Average round-trip propagation delay of service 2 = %f sec\n',averageRoundTripDelay2);
fprintf('Number of links not supporting any traffic flow = %d\n', length(linksNoTraffic));
fprintf('List of links not supporting any traffic flow:\n');
for i = linksNoTraffic'
    fprintf('\t%d -> %d\n', Loads(i, 1), Loads(i, 2));
end
fprintf('Number of cycles run by the algorithm = %d\n', contador);
fprintf('Time obtained best solution = %f sec\n', bestTime);