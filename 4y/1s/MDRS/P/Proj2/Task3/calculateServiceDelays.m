function [roundTripDelays] = calculateServiceDelays(sP, bestSol, D, T)
    nFlows = size(T,1);
    % Calculate round-trip propagation delay
    roundTripDelays = zeros(1,nFlows);

    for f = 1:nFlows
        if bestSol(f) > 0
            path= sP{f}{bestSol(f)}; % Para cada fluxo vamos buscar o caminho solucao
            for j=2:length(path)
                propagation_delay = D(path(j-1), path(j)); % D matrix represents propagation delays
                roundTripDelays(f) = roundTripDelays(f) + 2 * propagation_delay; % 2x because it's round trip delay
            end
        end
    end
end