clear; clc;
%% b correr 100x com criterio de paragem P=10000, 90% confiança 
% com rate 1800pps, capacidade 10Mbps, f=1 000 000 Bytes and b=10^-6
fprintf(' -------> B)\n');
N = 100;
lambda = 1800;
C = 10;
P = 10000;
f = 1000000;
b = 10^-6;

PL  = zeros(1,N);
APD = zeros(1,N); % APD = 1000 * DELAYS/ TRANSMITTED_PACKETS
MPD = zeros(1,N); % MPD = 1000 * MAXDELAY
TT  = zeros(1,N);

for it = 1:N
    [PL(it), APD(it), MPD(it), TT(it)] = Simulator2(lambda,C,f,P,b);
end

alfa = 0.1; % 90% intervalos de confiança

media1 = mean(PL);
term = norminv(1-alfa/2) * sqrt(var(PL)/N);
fprintf('PL = %.2e +/- %.2e \n', media1, term);

media2 = mean(APD);
term = norminv(1-alfa/2) * sqrt(var(APD)/N);
fprintf('APD = %.2e +/- %.2e \n', media2, term);

media3 = mean(MPD);
term = norminv(1-alfa/2) * sqrt(var(MPD)/N);
fprintf('MPD = %.2e +/- %.2e \n', media3, term);

media4 = mean(TT);
term = norminv(1-alfa/2) * sqrt(var(TT)/N);
fprintf('TT = %.2e +/- %.2e \n', media4, term);

%% c correr 100x com criterio de paragem P=10000, 90% confiança 
% com rate 1800pps, capacidade 10Mbps, f=10 000 Bytes and b=10^-6
fprintf(' -------> C)\n');
N = 100;
lambda = 1800;
C = 10;
P = 10000;
f = 10000;
b = 10^-6;

PL  = zeros(1,N);
APD = zeros(1,N); % APD = 1000 * DELAYS/ TRANSMITTED_PACKETS
MPD = zeros(1,N); % MPD = 1000 * MAXDELAY
TT  = zeros(1,N);

for it = 1:N
    [PL(it), APD(it), MPD(it), TT(it)] = Simulator2(lambda,C,f,P,b);
end

alfa = 0.1; % 90% intervalos de confiança

media1 = mean(PL);
term = norminv(1-alfa/2) * sqrt(var(PL)/N);
fprintf('PL = %.2e +/- %.2e \n', media1, term);

media2 = mean(APD);
term = norminv(1-alfa/2) * sqrt(var(APD)/N);
fprintf('APD = %.2e +/- %.2e \n', media2, term);

media3 = mean(MPD);
term = norminv(1-alfa/2) * sqrt(var(MPD)/N);
fprintf('MPD = %.2e +/- %.2e \n', media3, term);

media4 = mean(TT);
term = norminv(1-alfa/2) * sqrt(var(TT)/N);
fprintf('TT = %.2e +/- %.2e \n', media4, term);


%% d correr 100x com criterio de paragem P=10000, 90% confiança 
% com rate 1800pps, capacidade 10Mbps, f=2 000 Bytes and b=10^-6
fprintf(' -------> D)\n');
N = 100;
lambda = 1800;
C = 10;
P = 10000;
f = 2000;
b = 10^-6;

PL  = zeros(1,N);
APD = zeros(1,N); % APD = 1000 * DELAYS/ TRANSMITTED_PACKETS
MPD = zeros(1,N); % MPD = 1000 * MAXDELAY
TT  = zeros(1,N);

for it = 1:N
    [PL(it), APD(it), MPD(it), TT(it)] = Simulator2(lambda,C,f,P,b);
end

alfa = 0.1; % 90% intervalos de confiança

media1 = mean(PL);
term = norminv(1-alfa/2) * sqrt(var(PL)/N);
fprintf('PL = %.2e +/- %.2e \n', media1, term);

media2 = mean(APD);
term = norminv(1-alfa/2) * sqrt(var(APD)/N);
fprintf('APD = %.2e +/- %.2e \n', media2, term);

media3 = mean(MPD);
term = norminv(1-alfa/2) * sqrt(var(MPD)/N);
fprintf('MPD = %.2e +/- %.2e \n', media3, term);

media4 = mean(TT);
term = norminv(1-alfa/2) * sqrt(var(TT)/N);
fprintf('TT = %.2e +/- %.2e \n', media4, term);


%%Conclusao 
% Tamanhos de pacote menores resultam em menor perda de pacotes, mas atrasos mais altos. 
% A escolha do tamanho de pacote depende das necessidades do 
% sistema e dos requisitos de desempenho. 
% Um tamanho de pacote maior pode ser preferível em cenários 
% onde a latência é crítica, enquanto um tamanho de pacote 
% menor pode ser adequado quando a perda de pacotes é inaceitável. 
% É importante considerar os trade-offs entre essas métricas 
% ao determinar o tamanho de pacote ideal para uma 
% aplicação específica.




