function nodesEnergy = calculateNodeEnergy(T,sP,nNodes,Solution)
    nFlows= size(T,1);
    % criar o vetor para guardar valores do TT para cada nó
    nodes_TT = zeros(1,nNodes);
    for i= 1:nFlows
        if Solution(i)>0
            path= sP{i}{Solution(i)};
            for node = path
                % somar o TT para os nos todos aqui
                nodes_TT(node) = nodes_TT(node) + sum(T(i,3:4));
            end
        end
    end
    nodesEnergy = sum(20 + 80 * sqrt(nodes_TT/1000));
end

