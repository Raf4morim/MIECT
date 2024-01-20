function [sP, nSP] = bestCostPaths(nNodes, anycastNodes, L, T_anycast)
    % k=1, only shortest path
    % Best Cost Paths for each node. Determine which anycast node
    % should be the destination for each source node
    k= 1;
    sP= cell(1, nNodes);
    nSP= zeros(1,nNodes);
    for n = 1:nNodes
        if ismember(n, anycastNodes)
            if ismember(n, T_anycast(:,1))  
            % if node is in anycast matrix and is
            % anycast node, sP has source and dest
            % as itself
                sP{n} = {[n n]};
                nSP(n) = 1;
            else
                nSP(n) = -1;
            end
            continue;
        end
    
        if ~ismember(n, T_anycast(:,1)) % node needs to be in T3(the only anycast service)
            nSP(n) = -1;
            continue;
        end

        best = inf;
        for a = 1:length(anycastNodes)
            % Get SP and Cost for each destination (any cast) node
            [shortestPath, totalCost] = kShortestPath(L, n, anycastNodes(a), k);
    
            if totalCost < best
                sP{n}= shortestPath;
                nSP(n)= length(totalCost);
                best = totalCost;
            end
        end
    end
    nSP= nSP(nSP~=-1);
    sP= sP(~cellfun(@isempty, sP)); 
end