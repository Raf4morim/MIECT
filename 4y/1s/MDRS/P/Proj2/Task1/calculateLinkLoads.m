function [Loads,solLinkEnergy]= calculateLinkLoads(nNodes,Links,T,L,sP,Solution)
    nFlows= size(T,1);
    nLinks= size(Links,1);
    aux= zeros(nNodes);
    for i= 1:nFlows
        if Solution(i)>0
            path= sP{i}{Solution(i)};
            for j=2:length(path)
                aux(path(j-1),path(j))= aux(path(j-1),path(j)) + T(i,3); 
                aux(path(j),path(j-1))= aux(path(j),path(j-1)) + T(i,4);
            end
        end
    end
    solLinkEnergy = 0;
    Loads= [Links zeros(nLinks,2)];
    for i= 1:nLinks
        Loads(i,3)= aux(Loads(i,1),Loads(i,2));
        Loads(i,4)= aux(Loads(i,2),Loads(i,1));

        % CALCULAR ENERGIA
        if (Loads(i,3:4) == 0) % Link is in sleepig mode
            energy = 2;
        else
           link_length = L(Loads(i,1),Loads(i,2));
           energy = 9 + 0.3 * link_length;
        end
        solLinkEnergy = solLinkEnergy + energy;
    end
    
    %If biggest link load is greater then link capacity energy is inf
    maxLoad = max(max(Loads(:,3:4)));
    if maxLoad > 100
        solLinkEnergy = inf;
    end
end