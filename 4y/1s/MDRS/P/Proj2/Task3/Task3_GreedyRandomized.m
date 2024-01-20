function [sol,load,linkEnergy] = Task3_GreedyRandomized(nNodes,Links,T,L,sP,nSP,sol)
    nFlows = size(T,1);

    for flow= randperm(nFlows) % ordem random dos fluxos
        path_index = 0;
        best_load = inf;
        best_energy = inf;

        for path = 1 : nSP(flow)
            sol(flow) = path;
            [Loads,linkEnergy] = calculateLinkLoads(nNodes, Links, T,L, sP, sol);
            maxLoad = max(max(Loads(:,3:4)));
            
            if maxLoad < best_load % se load obtida for menor a melhor obtida anteriormente, trocar
                path_index = path;
                best_load = maxLoad;
                best_energy = linkEnergy;
            end
        end
        sol(flow) = path_index;
    end
    load = best_load;
    linkEnergy = best_energy;
end