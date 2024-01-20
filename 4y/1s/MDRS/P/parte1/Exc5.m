clear; clc; % SHF + ALT + F ->>> FORMATAR
%% a
fprintf(' -------> A)\n');
N = 10;
lambda = 1800;
C = 10;
f = 1000000;
P = 10000;

PL = zeros(1,N); % PL = 100 * LOSTPACKETS/ TOTALPACKETS
APD = zeros(1,N); % APD = 1000 * DELAYS/ TRANSMITTED_PACKETS
MPD = zeros(1,N); % MPD = 1000 * MAXDELAY
TT =  zeros(1,N);

for it = 1:N
    [PL(it), APD(it), MPD(it), TT(it)] = Simulator1(lambda,C,f,P);
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

% 
% %% b
% fprintf('\n\n -------> B)\n');
% N = 100;
% lambda = 1800;
% C = 10;
% f = 1000000;
% P = 10000;
% 
% PL = zeros(1,N); % PL = 100 * LOSTPACKETS/ TOTALPACKETS
% APD = zeros(1,N); % APD = 1000 * DELAYS/ TRANSMITTED_PACKETS
% MPD = zeros(1,N); % MPD = 1000 * MAXDELAY
% TT =  zeros(1,N);
% 
% for it = 1:N
%     [PL(it), APD(it), MPD(it), TT(it)] = Simulator1(lambda,C,f,P);
% end
% 
% alfa = 0.1; % 90% intervalos de confiança
% 
% media1 = mean(PL);
% term = norminv(1-alfa/2) * sqrt(var(PL)/N);
% fprintf('PL = %.2e +/- %.2e \n', media1, term);
% 
% media2 = mean(APD);
% term = norminv(1-alfa/2) * sqrt(var(APD)/N);
% fprintf('APD = %.2e +/- %.2e \n', media2, term);
% 
% media3 = mean(MPD);
% term = norminv(1-alfa/2) * sqrt(var(MPD)/N);
% fprintf('MPD = %.2e +/- %.2e \n', media3, term);
% 
% media4 = mean(TT);
% term = norminv(1-alfa/2) * sqrt(var(TT)/N);
% fprintf('TT = %.2e +/- %.2e \n', media4, term);
% 
% %% c
% fprintf('\n\n -------> C)\n');
% 
% N = 100;
% lambda = 1800;
% C = 10;
% f = 10000;
% P = 10000;
% 
% PL = zeros(1,N); % PL = 100 * LOSTPACKETS/ TOTALPACKETS
% APD = zeros(1,N); % APD = 1000 * DELAYS/ TRANSMITTED_PACKETS
% MPD = zeros(1,N); % MPD = 1000 * MAXDELAY
% TT =  zeros(1,N);
% 
% for it = 1:N
%     [PL(it), APD(it), MPD(it), TT(it)] = Simulator1(lambda,C,f,P);
% end
% 
% alfa = 0.1; % 90% intervalos de confiança
% 
% 
% media1 = mean(PL);
% term = norminv(1-alfa/2) * sqrt(var(PL)/N);
% fprintf('PL = %.2e +/- %.2e \n', media1, term);
% 
% media2 = mean(APD);
% term = norminv(1-alfa/2) * sqrt(var(APD)/N);
% fprintf('APD = %.2e +/- %.2e \n', media2, term);
% 
% media3 = mean(MPD);
% term = norminv(1-alfa/2) * sqrt(var(MPD)/N);
% fprintf('MPD = %.2e +/- %.2e \n', media3, term);
% 
% media4 = mean(TT);
% term = norminv(1-alfa/2) * sqrt(var(TT)/N);
% fprintf('TT = %.2e +/- %.2e \n', media4, term);
% 
% %% d
% fprintf('\n\n -------> D)\n');
% 
% N = 100;
% lambda = 1800;
% C = 10;
% f = 2000;
% P = 10000;
% 
% PL = zeros(1,N); % PL = 100 * LOSTPACKETS/ TOTALPACKETS
% APD = zeros(1,N); % APD = 1000 * DELAYS/ TRANSMITTED_PACKETS
% MPD = zeros(1,N); % MPD = 1000 * MAXDELAY
% TT =  zeros(1,N);
% 
% for it = 1:N
%     [PL(it), APD(it), MPD(it), TT(it)] = Simulator1(lambda,C,f,P);
% end
% 
% alfa = 0.1; % 90% intervalos de confiança
% 
% 
% media1 = mean(PL);
% term = norminv(1-alfa/2) * sqrt(var(PL)/N);
% fprintf('PL = %.2e +/- %.2e \n', media1, term);
% 
% media2 = mean(APD);
% term = norminv(1-alfa/2) * sqrt(var(APD)/N);
% fprintf('APD = %.2e +/- %.2e \n', media2, term);
% 
% media3 = mean(MPD);
% term = norminv(1-alfa/2) * sqrt(var(MPD)/N);
% fprintf('MPD = %.2e +/- %.2e \n', media3, term);
% 
% media4 = mean(TT);
% term = norminv(1-alfa/2) * sqrt(var(TT)/N);
% fprintf('TT = %.2e +/- %.2e \n', media4, term);

fprintf(['\nConclusão das 4 alineas anteriores:\n' ...
    '\tNa alinea b aumentamos o N de 10 para 100, ou seja, a fila de espera fica muito grande infinita e assim a PL é 0.\n' ...
    '\tNa alinea c diminuimos o N de 1M para 10k, fila de espera mais pequena, ou seja, a perda de pacotes aumenta\n' ...
    'Em contra partida a media de atraso do pacote e o atraso maximo diminuiem, logo demora menos tempo a chegar à primeira posiçao da fila de espera\n' ...
    '\tNa alinea d como o TT está relacionado com a perda de pacote quando a perda de pacotes aumenta o desempenho diminui.']);

%% e -> M/G/1 queueing model
fprintf('\n\n -------> E)\n');
f = 10^6; %bytes

probSobra = (1 - (0.19 + 0.23 + 0.17));
qty_equiprob = (109 - 65 + 1) + (1517 - 111 + 1);
prob_resto = probSobra / qty_equiprob; % resto da probabilidade pelos restantes elementos 

a = (65:109) * prob_resto; 
b = (111:1518) * prob_resto;

cap_bits = 10*10^6;
cap_bytes = cap_bits /8;

nMedio =(64)*0.19 + (110)*0.23 ...
        + (1518)*0.17 + sum(a) + sum(b); %bytes
tMedio = nMedio/cap_bytes; %s

sizePacket = 64:1518;
sistema = (sizePacket)./(cap_bytes); % tamanho/capacidade
segundoMomento = (sizePacket)./(cap_bytes); 
% Percorremos o pacote
for i = 1:length(sizePacket)
    if sizePacket(i) == 64
        segundoMomento(i) = 0.19 * sistema(i)^2;
        sistema(i) = 0.19 * sistema(i);
    elseif sizePacket(i) == 110
        segundoMomento(i) = 0.23 * sistema(i)^2;
        sistema(i) = 0.23 * sistema(i);
    elseif sizePacket(i) == 1518
        segundoMomento(i) = 0.17 * sistema(i)^2;
        sistema(i) = 0.17 * sistema(i);
    else
        segundoMomento(i) = prob_resto * sistema(i)^2;
        sistema(i) = prob_resto * sistema(i);
    end
end

% Como a fila de espera M/G/1 é infinita ent não ha pacotes perdidos
PLost = 0;
fprintf('O PL (%%) = %.2f\n',PLost);

Y = 1800; %pps

ES = sum(sistema);
ES2 = sum(segundoMomento);
wQ = (Y*ES2)/(2*(1-Y*ES));
systDelay = wQ + tMedio;
fprintf('O tempo do sistema (ms) %.2f\n',systDelay*1000);

tt = Y * nMedio * (8/f);
fprintf('O TT (Mbps) = %.2f\n',tt);

