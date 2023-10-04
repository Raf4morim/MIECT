% 4
clc; clear;
% DADOS: 
% router A -> Link ideal (BER = 0) 
% router B -> capacity C Mbps (1Mbps = 10^6 bps) for IP communications 
% propag. delay = 10 us (1 us = 10^-6 s) ----- pacotes de chegada sao processo poisson com rate Y pps (pacotes por seg)
% size of cada pacote IP está entre 64 e 1518 bytes (inclui o overhead de Layer2)

% probs: 
% 19% to 64 bytes   
% 23% to 110 bytes   
% 17% to 1518 bytes 
% Igual prob, entre 65-109 e 111-1517 = ?
probSobra = (100 - (19 + 23 + 17));
qty_equiprob = (109 - 65 + 1) + (1517 - 111 + 1);
prob_resto = probSobra / qty_equiprob;

% Y = 1000 pps e C = 10*10^6 bps 

%% 4a -> Tamanho médio do pacote em bytes e o (PAG 19) tempo de transmissao médio do pacote do fluxo IP --> E[c]
cap_bits = (10*10^6);
cap_bytes = cap_bits /8;

a = (65:109) * prob_resto/100;
b = (111:1518) * prob_resto/100;

nMedio =(64)*0.19 + (110)*0.23 ...
        + (1518)*0.17 + sum(a) + sum(b); %bytes
tMedio = nMedio/cap_bytes; %s

%% 4b -> Rendimento médio em Mbps do fluxo IP
Y = 1000; %pps
rendMedio = Y * tMedio * cap_bits;

%% 4c -> Capacidade do link pps ????
cap_link = cap_bits / (nMedio*8);

%% 4d -> Pacote médio do atraso em fila e em sistema-> (atraso em fila+ tempo de transmissao+ propag de atraso) do fluxo IP 
% Usando o M/G/1

propagDelay = 10*10^-6;
sizePacket = 64:1518;
sistema = (sizePacket.*8)./cap_bits; % tamanho/capacidade
segundoMomento = (sizePacket.*8)./cap_bits; 
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
        segundoMomento(i) = prob_resto/100 * sistema(i)^2;
        sistema(i) = prob_resto/100 * sistema(i);
    end
end

ES = sum(sistema);
ES2 = sum(segundoMomento);
wQ = (Y*ES2)/(2*(1-Y*ES));

systDelay = wQ + tMedio + propagDelay;

fprintf('d) wQ: %.2d.\tO tempo do sistema é %.2d\n',wQ, systDelay);

%% e -> 
Ys = 100:2000;
wQ1 = (Ys.*ES2)./(2.*(1-Ys.*ES));
systDelay2 = wQ1 + tMedio + propagDelay;

figure(1);
plot(Ys,systDelay2,'b');
title('Average system delay (seconds)');
xlabel('{\lambda} (pps)');
grid on;

% Conclusao: Capacidade da ligação de pacotes/seg é 2016pps
% O rate maximo vai até 2000 onde podemos ver um atraso muito elevado
% Caso rate maximo fosse de 2016 para cima já tendia para infinito

%% f -> Cap 10 20 100Mbps
rate = [100:2000 200:4000 1000:20000];
cap = [10*10^6 20*10^6 100*10^6];

eixo_x1 = (rate(1)./ (cap(1) ./ (nMedio*8))) .* 100;
eixo_x2 = (rate(2)./ (cap(2) ./ (nMedio*8))) .* 100;
eixo_x3 = (rate(3)./ (cap(3) ./ (nMedio*8))) .* 100;


sistema1 = (sizePacket.*8)./cap(1); % tamanho/capacidade
segundoMomento1 = (sizePacket.*8)./cap(1); 
sistema2 = (sizePacket.*8)./cap(2); % tamanho/capacidade
segundoMomento2 = (sizePacket.*8)./cap(2); 
sistema3 = (sizePacket.*8)./cap(3); % tamanho/capacidade
segundoMomento3 = (sizePacket.*8)./cap(3); 
% Percorremos o pacote
for i = 1:length(sizePacket)
    if sizePacket(i) == 64
        segundoMomento1(i) = 0.19 * sistema1(i)^2;
        sistema1(i) = 0.19 * sistema1(i);
        segundoMomento2(i) = 0.19 * sistema2(i)^2;
        sistema2(i) = 0.19 * sistema2(i);
        segundoMomento3(i) = 0.19 * sistema3(i)^2;
        sistema3(i) = 0.19 * sistema3(i);
    elseif sizePacket(i) == 110
        segundoMomento1(i) = 0.23 * sistema1(i)^2;
        sistema1(i) = 0.23 * sistema1(i);
        segundoMomento2(i) = 0.23 * sistema2(i)^2;
        sistema2(i) = 0.19 * sistema2(i);
        segundoMomento3(i) = 0.23 * sistema3(i)^2;
        sistema3(i) = 0.23 * sistema3(i);
    elseif sizePacket(i) == 1518
        segundoMomento1(i) = 0.17 * sistema1(i)^2;
        sistema1(i) = 0.17 * sistema1(i);
        segundoMomento2(i) = 0.17 * sistema2(i)^2;
        sistema2(i) = 0.17 * sistema2(i);
        segundoMomento3(i) = 0.17 * sistema3(i)^2;
        sistema3(i) = 0.17 * sistema3(i);
    else
       segundoMomento1(i) = prob_resto/100 * sistema1(i)^2;
        sistema1(i) = prob_resto/100 * sistema1(i);
        segundoMomento2(i) = prob_resto/100 * sistema2(i)^2;
        sistema2(i) = prob_resto/100 * sistema2(i);
        segundoMomento3(i) = prob_resto/100 * sistema3(i)^2;
        sistema3(i) = prob_resto/100 * sistema3(i);
    end
end

