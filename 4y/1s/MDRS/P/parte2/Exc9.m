%% 9a
clear all;
close all;
%clc;

load('InputData2.mat');
nNodes= size(Nodes,1);
nLinks= size(Links,1);
nFlows= size(T,1);

k= 6;
sP= cell(2,nFlows);
nSP= zeros(1,nFlows);

for f=1:nFlows
    [shortestPath, totalCost] = kShortestPath(L,T(f,1),T(f,2),k);
    sP{1,f}= shortestPath;
    nSP(f)= length(totalCost);
    for i= 1:nSP(f)
        Aaux= L;
        path1= sP{1,f}{i};
        
        % vou às ligaçoes do primeiro percurso e ponho as ligações com nsq infinito
        for j=2:length(path1)
            Aaux(path1(j),path1(j-1))= inf;
            Aaux(path1(j-1),path1(j))= inf;
        end
        [shortestPath, totalCost] = kShortestPath(Aaux,T(f,1),T(f,2),1);
        if ~isempty(shortestPath)
            sP{2,f}{i}= shortestPath{1};
        end
    end
end

t= tic;
timeLimit= 5;
bestLoad= inf;
contador= 0;
somador= 0;
while toc(t) < timeLimit
    sol= zeros(1,nFlows);
    for f= 1:nFlows
        sol(f)= randi(nSP(f));
    end
    %sol = HillClimbing(sol,nNodes,Links,T,sP,nSP);

    Loads= calculateLinkLoads(nNodes,Links,T,sP,sol);
    load= max(max(Loads(:,3:4)));
    if load<bestLoad
        bestSol= sol;
        bestLoad= load;
        bestLoads= Loads;
    end
    contador= contador+1;
    somador= somador+load;
end

fprintf('Random algorithm (all possible paths):\n');
fprintf('Worst link load of the best solution = %.2f\n',bestLoad);
fprintf('No. of generated solutions = %d\n',contador);
fprintf('Avg. worst link load among all solutions= %.2f\n',somador/contador);

%% HillClimbing

clear all;
close all;
%clc;

load('InputData2.mat');
nNodes= size(Nodes,1);
nLinks= size(Links,1);
nFlows= size(T,1);

k= 6;
sP= cell(2,nFlows);
nSP= zeros(1,nFlows);

for f=1:nFlows
    [shortestPath, totalCost] = kShortestPath(L,T(f,1),T(f,2),k);
    sP{1,f}= shortestPath;
    nSP(f)= length(totalCost);
    for i= 1:nSP(f)
        Aaux= L;
        path1= sP{1,f}{i};
        
        % vou às ligaçoes do primeiro percurso e ponho as ligações com nsq infinito
        for j=2:length(path1)
            Aaux(path1(j),path1(j-1))= inf;
            Aaux(path1(j-1),path1(j))= inf;
        end
        [shortestPath, totalCost] = kShortestPath(Aaux,T(f,1),T(f,2),1);
        if ~isempty(shortestPath)
            sP{2,f}{i}= shortestPath{1};
        end
    end
end

t= tic;
timeLimit= 5;
bestLoad= inf;
contador= 0;
somador= 0;
while toc(t) < timeLimit
    sol= zeros(1,nFlows);
    for f= 1:nFlows
        sol(f)= randi(nSP(f));
    end
    sol = HillClimbing(sol,nNodes,Links,T,sP,nSP);

    Loads= calculateLinkLoads(nNodes,Links,T,sP,sol);
    load= max(max(Loads(:,3:4)));
    if load<bestLoad
        bestSol= sol;
        bestLoad= load;
        bestLoads= Loads;
    end
    contador= contador+1;
    somador= somador+load;
end


fprintf('Multi start hill climbing with random (all possible paths):\n');
fprintf('Worst link load of the best solution = %.2f\n',bestLoad);
fprintf('No. of generated solutions = %d\n',contador);
fprintf('Avg. worst link load among all solutions= %.2f\n',somador/contador);


function sol = HillClimbing(sol,nNodes,Links,T,sP,nSP)
    nFlows = size(T,1);
    Loads= calculateLinkLoads(nNodes,Links,T,sP,sol);
    load= max(max(Loads(:,3:4)));
    improved=true;
    while improved
        loadBestNeigh = inf;
        for f = 1:nFlows
            for p = 1:nSP(f)
                if sol(f) ~= p
                    auxsol = sol;
                    auxsol(f) = p;
                    Loads= calculateLinkLoads(nNodes,Links,T,sP,auxsol);
                    auxload= max(max(Loads(:,3:4)));
                    if auxload < loadBestNeigh
                        loadBestNeigh = auxload;
                        fbest = f;
                        pbest = p;
                    end

                end
            end
        end
        if loadBestNeigh < load
            load = loadBestNeigh;
            sol(fbest) = pbest;
        else
            improved = false; % termina o ciclo
        end
    end

end