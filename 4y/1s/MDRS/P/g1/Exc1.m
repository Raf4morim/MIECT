clear;
clc;

% p (with 0% ≤ p ≤ 100%)
% 100% of probability
% randomly one of the n answers with a uniform distribution

% 1a p = 60% e n = 4

P = 0.6;
N = 4;
Pe = P + (1-P)/N;

% 1b p = 70% e n = 5

P2 = 0.7;
N2 = 5;
pce = P2 * N2 / (1 + (N2 - 1) * P2);

% EXPLICAÇÃO
x = linspace(0,1,20);
fx = x.^2; % fazer ponto a ponto ao quadrado
gx = 1 - x.^3;

% help plot
% figure(1) % -> primeiro plot
% plot(x, fx, 'b-')
% title('Titulo 1')
% xlabel('Eixo x');
% grid on

nn1 = 3;
nn2 = 4;
nn3 = 5;

x = linspace(0,1,100);
P_correto1 = x + (1-x)/nn1;
P_correto2 = x + (1-x)/nn2;
P_correto3 = x + (1-x)/nn3;

figure(1) % -> segundo plot
plot(   100*x, P_correto1*100, 'b-', ...
        100*x, P_correto2*100, 'r--', ...
        100*x, P_correto3*100, 'g.' );

title('Probability of right answer (%)')
legend('n = 3', 'n = 4' , 'n = 5', 'location', 'north west');
xlabel('p(%)')
grid on
ylim([0 100])
yticks(0:20:100);



nnn1 = 3;
nnn2 = 4;
nnn3 = 5;

x1 = linspace(0,1,100);
P_S_correto1 = (x1*nnn1)./ (1 + (nnn1 - 1) * x1);
P_S_correto2 = (x1*nnn2)./ (1 + (nnn2 - 1) * x1);
P_S_correto3 = (x1*nnn3)./ (1 + (nnn3 - 1) * x1);

figure(1) % -> segundo plot
plot(   100*x1, P_S_correto1*100, 'b-', ...
        100*x1, P_S_correto2*100, 'r--', ...
        100*x1, P_S_correto3*100, 'g.' );

title('Probability of knowing the answer (%)')
legend('n = 3', 'n = 4' , 'n = 5', 'location', 'north west');
xlabel('p(%)')
grid on
ylim([0 100])
yticks(0:20:100);
