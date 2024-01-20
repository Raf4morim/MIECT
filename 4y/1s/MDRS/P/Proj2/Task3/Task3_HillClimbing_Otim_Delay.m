function [sol, load,Loads,linkEnergy, delay]= Task3_HillClimbing_Otim_Delay(sol, nNodes,Links,T,D,sP,nSP,L,nFlows1,linkEnergy)
    nFlows = size(T,1);
    

    T1_idx = 1:nFlows1;
    T2_idx = 1+nFlows1:nFlows;

    Loads= calculateLinkLoads(nNodes,Links,T,L,sP,sol);
    load= max(max(Loads(:,3:4)));

    % delay calculado com sol do greedy, de todos os fluxos/serviços
    bestDelay = calculateServiceDelays(sP, sol, D, T);
    delay = (sum(calculateServiceDelays(sP, sol, D, T)))/20;
    %display(delay);
    improved = true;
    while improved
        loadBestNeigh = inf;
        for flow= 1:nFlows 
            for path= 1:nSP(flow) %Rodar por todos os vizinhos possiveis
                if sol(flow)~=path %Não trocar a sol por ela mesma
                    auxsol = sol;
                    auxsol(flow)= path;
                    [auxLoads,auxLinkEnergy]= calculateLinkLoads(nNodes,Links,T,L,sP,auxsol);
                    auxload= max(max(auxLoads(:,3:4)));
                    
                    % delay of this sol
                    auxDelay = calculateServiceDelays(sP, auxsol, D, T);
                    if mean(auxDelay(T1_idx)) > mean(auxDelay(T2_idx))
                        auxDelayWorst = auxDelay(T1_idx);
                        auxDelayOther = auxDelay(T2_idx);
                    else
                        auxDelayOther = auxDelay(T1_idx);
                        auxDelayWorst = auxDelay(T2_idx);
                    end

                    % 0.5 * other, porque worst é mais obrigatoria
                    auxDelayLowPriority = 0.5 * sum(auxDelayOther);
                    auxDelayHighPriority = sum(auxDelayWorst);
                    valueAuxDelay = (auxDelayHighPriority + auxDelayLowPriority)/20;
                    valueBestDelay = (auxDelayHighPriority + auxDelayLowPriority)/20;

                    if valueAuxDelay < valueBestDelay
                        loadBestNeigh = auxload;
                        energyBestNeigh = auxLinkEnergy;
                        LoadsBestNeigh = auxLoads;
                        bestSol = auxsol;
                        bestDelay = auxDelay;
                    end
                end
            end
        end
        if max(bestDelay(T1_idx)) < delay % Encontrado melhor vizinho, trocar valores
            load = loadBestNeigh;
            Loads = LoadsBestNeigh;
            linkEnergy = energyBestNeigh;
            sol = bestSol;
            delay = max(bestNeighDelay(T1_idx));
            
            
%             if Loads == inf
%                 load = inf;
%             end
        else
            improved = false;
        end
    end
end
