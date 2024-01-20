function [sol,load,Loads,energy]= Task2a_hillClimbing_EnergyOptimized(sol,nNodes,Links,T,L,sP,nSP,energy,Loads)
    nFlows = size(T,1);
    %Loads= calculateLinkLoads(nNodes,Links,T,L,sP,sol);
    load= max(max(Loads(:,3:4)));
    
    LoadsBestNeigh = Loads;
    energyBestNeigh = energy;

    improved = true;
    while improved
        for flow= 1:nFlows 
            for path= 1:nSP(flow) %check all neighbors
                if sol(flow)~=path % Não trocar a sol por ela mesma
                    auxsol = sol;
                    auxsol(flow)= path;
                    [auxLoads,auxLinkEnergy]= calculateLinkLoads(nNodes,Links,T,L,sP,auxsol);
                    nodesEnergy = calculateNodeEnergy(T,sP,nNodes,auxsol);
                    auxEnergy = nodesEnergy + auxLinkEnergy;
                    
                    % check if the neighbour energy is better than the current one
                    if auxEnergy<energyBestNeigh
                        LoadsBestNeigh= auxLoads;
                        fbest = flow;
                        pbest = path;
                        energyBestNeigh= auxEnergy;
                    end
                end
            end
        end
        if energyBestNeigh<energy % Encontrado melhor vizinho, trocar valores
            sol(fbest)= pbest;
            Loads= LoadsBestNeigh;
            energy = energyBestNeigh;

            % if Loads == inf
            %     load = inf;
            % else
            %     load = max(max(Loads(:,3:4)));
            % end
        else
            improved = false;
        end
    end
end