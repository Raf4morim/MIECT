clear all;
close all;
clc;

load('InputDataProject2.mat');
nNodes= size(Nodes,1);
nLinks= size(Links,1);
T_Unicast=[T1;T2];
nFlowsUnicast= size(T_Unicast,1);
nFlows1= size(T1,1);
nFlows2= size(T2,1);
nFlowsAnycast= size(T3,1);

D = L/(2*10^5);

anycastPairs = nchoosek(1:15,2);


%% 4 c)
% Computing up to k=6 shortest paths for all flows:
k= 6;
sP_Unicast= cell(1,nFlowsUnicast);
nSP_Unicast= zeros(1,nFlowsUnicast);
for f=1:nFlowsUnicast
    [shortestPath, totalCost] = kShortestPath(D,T_Unicast(f,1),T_Unicast(f,2),k);
    sP_Unicast{f}= shortestPath;
    nSP_Unicast(f)= length(totalCost);
end

bestRoundTripDelay = inf;
bestPair = [0 0];
for pair = 1:size(anycastPairs,1)
    anycastNodes = anycastPairs(pair,:);
    %fprintf("pair: %d,%d \n", anycastNodes(1), anycastNodes(2));
    [sP_Anycast,nSP_Anycast]= bestCostPaths(nNodes,anycastNodes,D,T3);

    % Pair that minimizes average round trip delay of the anycast service
    roundTripDelays = zeros(1,nFlowsAnycast);
    for f = 1:nFlowsAnycast   
        path= sP_Anycast{f}{1}; 
        total_delay = 0;
        for j=2:length(path)
            propagation_delay = D(path(j-1), path(j)); % D matrix represents propagation delays
            total_delay = total_delay + propagation_delay;
        end
        roundTripDelays(f) = 2*total_delay; % 2x because it's round trip delay
    end
    totalRoundTripDelay = sum(roundTripDelays);
    averageRoundTripDelay = totalRoundTripDelay / nFlowsAnycast;

    %fprintf("avg round-trip delay: %f\n\n",averageRoundTripDelay);

    if averageRoundTripDelay < bestRoundTripDelay
        bestRoundTripDelay = averageRoundTripDelay;
        bestPair = anycastNodes;
    end
end

fprintf("Melhor par: %d,%d\n",bestPair(1),bestPair(2));

