function Loads= calculateLinkBand1plus1(nNodes,Links,T,sP,Solution)
    nFlows= size(T,1);
    nLinks= size(Links,1);
    aux= zeros(nNodes);
    for i= 1:nFlows
        if Solution(i)>0
            path= sP{1,i}{Solution(i)};
            if ~isempty(path)
                for j=2:length(path)
                    aux(path(j-1),path(j))= aux(path(j-1),path(j)) + T(i,3); 
                    aux(path(j),path(j-1))= aux(path(j),path(j-1)) + T(i,4);
                end
            end
            if ~isempty(sP{2,i})    % temos de fazer isto pq há 1 cell vazia
                path= sP{2,i}{Solution(i)};
                for j=2:length(path)
                    aux(path(j-1),path(j))= aux(path(j-1),path(j)) + T(i,3); 
                    aux(path(j),path(j-1))= aux(path(j),path(j-1)) + T(i,4);
                end
            end
        end
    end
    Loads= [Links zeros(nLinks,2)];
    for i= 1:nLinks
        Loads(i,3)= aux(Loads(i,1),Loads(i,2));
        Loads(i,4)= aux(Loads(i,2),Loads(i,1));
    end
end