clc; clear;
%% 3a
% Probabilidade do link em cada um dos 5 estados
% Media
BER = [10^-6 10^-5 10^-4 10^-3 10^-2];

Denominador = (1 ...
    +8/600 ...
    +8/600*5/100 ...
    +8/600*5/100*2/20 ...
    +8/600*5/100*2/20*1/5)*100;

E1 = 1/Denominador;
E2 = 8/600/Denominador;
E3 = 8/600*5/100/Denominador;
E4 = 8/600*5/100*2/20/Denominador;
E5 = 8/600*5/100*2/20*1/5/Denominador;

%% 3c
pState = [E1,E2,E3,E4,E5]./100;
M = sum(pState.* BER);

%% 3d
% percentagem media do tempo link em cada um dos 5 estados
% Em minutos
T1 = 1/8*60;
T2 = 1/605*60;
T3 = 1/102*60;
T4 = 1/21*60;
T5 = 1/5*60;

%% 3e
% A prob do link estar no estado normal e no estado de interferencia
% Normal é o estado 1 2 3 
% Interferencia é o estado 4 5
pN = sum(pState(1:3));
pI = sum(pState(4:5));

%% 3f
% BER medio do link quando está no normal e quando está na interferencia
E_Normal = sum(pState(1:3) .* BER(1:3))/pN;
E_Interferencia = sum(pState(4:5) .* BER(4:5))/pI;

%% 3g
% Envia uma estação fonte para a destino
% É recebido da estaçao destino com pelo menos 1 erro, 
% com pacotes de tamanho de 64 a 1500 bytes

size = 64 : 1500;
pErr = zeros(5, length(size));
for i = 1:5
    pErr(i, 1:length(size)) = 1 - (1-BER(i)).^(size.*8); 
    % em cada linha/ estado calculamos a prob de erro com o binomial
    % f(i) = (n i) p^i (1-p)^(n-i), i = 0 pois é pelo menos 1 erro logo 
    % complementar menos sem erros ---> 1 - f(0) = 1 - (1*1*(1-p)^(n-0))
    % em bits
end

pE1 = pErr(1, 1:length(size)) .* pState(1);
pE2 = pErr(2, 1:length(size)) .* pState(2);
pE3 = pErr(3, 1:length(size)) .* pState(3);
pE4 = pErr(4, 1:length(size)) .* pState(4);
pE5 = pErr(5, 1:length(size)) .* pState(5);

normal = pE1+pE2+pE3;
interferencia = pE4+pE5;
err = normal+interferencia;

figure(1);
plot(size, err, 'b')
title('Prob of at least one error');
xlabel('B(Bytes)');
grid on;

%% 3h
% Prob de estar no estado normal

pBeingInNormal = normal./err;

figure(2);
plot(size, pBeingInNormal, 'b');
title('Prob of Normal State');
xlabel('B(Bytes)');
grid on;

%% 3i
withoutErr = zeros(5,length(size));
for i = 1:5
    withoutErr(i, 1:length(size)) = (1-BER(i)).^(size.*8); % f(0)
end
p_noE1 = withoutErr(1, 1:length(size)) .* pState(1);
p_noE2 = withoutErr(2, 1:length(size)) .* pState(2);
p_noE3 = withoutErr(3, 1:length(size)) .* pState(3);
p_noE4 = withoutErr(4, 1:length(size)) .* pState(4);
p_noE5 = withoutErr(5, 1:length(size)) .* pState(5);
p_noErr = p_noE5 + p_noE4 + p_noE3 + p_noE2 + p_noE1;


pBeingInInterferencia = (p_noE5 + p_noE4)./p_noErr;

figure(3);
semilogy(size, pBeingInInterferencia, 'b');
title('Prob of Interference State');
xlabel('B(Bytes)');
grid on;

