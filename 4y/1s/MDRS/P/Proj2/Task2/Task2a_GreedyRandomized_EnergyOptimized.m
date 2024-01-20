function [sol,Loads,totalEnergy] = Task2a_GreedyRandomized_EnergyOptimized(nNodes,Links,T,L,sP,nSP,sol)
    nFlows = size(T,1);
    sol = zeros(1,nFlows);

    for flow= randperm(nFlows) % rand order of flows
        path_index = 0;
        bestLoads = inf;
        best_energy = inf;

        for path = 1 : nSP(flow)
            sol(flow) = path;
            [Loads,linkEnergy] = calculateLinkLoads(nNodes, Links, T,L, sP, sol);
            % now we also need to take into account nodes energy
            if linkEnergy < inf
                nodesEnergy = calculateNodeEnergy(T,sP,nNodes,sol);
                totalEnergy = nodesEnergy + linkEnergy;
            else
                totalEnergy = inf;
            end

            if totalEnergy < best_energy
                path_index = path;
                bestLoads = Loads;
                best_energy = totalEnergy;
            end
        end

        if path_index > 0
            sol(flow) = path_index;
        else
            totalEnergy = inf;
            break;
        end
    end
    Loads = bestLoads;
    totalEnergy = best_energy;
end
