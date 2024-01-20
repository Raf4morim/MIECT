function [avgDelay1, avgDelay2] = calculateServiceDelays(sP, sol, D, nFlows1, nFlows2)
    delays1 = zeros(1, nFlows1);
    delays2 = zeros(1, nFlows2);    
    % Calculate delays for service 1
    for f = 1:nFlows1
        if sol(f) ~= 0
            path = sP{f}{sol(f)};
            delays1(f) = 2 * sumPathDelays(path, D); % Round-trip delay
        else
            delays1(f) = inf; % Assign a large delay if no path exists
        end
    end
    avgDelay1 = mean(delays1);
    
    % Calculate delays for service 2
    % Make sure to start at 1 for delays2 indexing
    for f = 1:nFlows2
        flowIndex = f + nFlows1; % Adjust index for the second service
        if sol(flowIndex) ~= 0
            path = sP{flowIndex}{sol(flowIndex)};
            delays2(f) = 2 * sumPathDelays(path, D); % Round-trip delay
        else
            delays2(f) = inf; % Assign a large delay if no path exists
        end
    end
    avgDelay2 = mean(delays2);
end

function totalDelay = sumPathDelays(path, D)
    totalDelay = 0;
    for j = 2:length(path)
        totalDelay = totalDelay + D(path(j-1), path(j));
    end
end
