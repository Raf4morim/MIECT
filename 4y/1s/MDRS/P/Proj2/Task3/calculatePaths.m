function [sP, nSP] = calculatePaths(L,T, k, nFlows)    
    sP= cell(1,nFlows);
    nSP= zeros(1,nFlows);
    for f=1:nFlows
        [shortestPath, totalCost] = kShortestPath(L,T(f,1),T(f,2),k);
        sP{f}= shortestPath;
        nSP(f)= length(totalCost);
    end
end