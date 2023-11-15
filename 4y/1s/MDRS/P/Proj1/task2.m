clc;
clear all;
%% 2.a
fprintf("A)\n");
lambda = 1500;
C = 10;
f = 1000000;
N = 20;
P = 100000;
alfa = 0.1;
n = [10 20 30 40];


APD_d = zeros(4,N);
APD_v = zeros(4,N);
AQD_d = zeros(4,N);
AQD_v = zeros(4,N);

mean_APD_data = zeros(4, 1);
term_APD_data = zeros(4, 1);
mean_APD_voip = zeros(4, 1);
term_APD_voip = zeros(4, 1);

mean_AQD_data = zeros(4, 1);
term_AQD_data = zeros(4, 1);
mean_AQD_voip = zeros(4, 1);
term_AQD_voip = zeros(4, 1);

for i = 1:4
    for j = 1:N
        [~, ~, APD_d(i,j), APD_v(i,j), AQD_d(i,j), AQD_v(i,j), ~, ~, ~] = Simulator3(lambda, C, f, P, n(i));
    end
    
    % calculo do average delay of data packets
    mean_APD_data(i,1) = mean(APD_d(i,:));
    term_APD_data(i,1) = norminv(1-alfa/2) * sqrt(var(APD_d(i,:)) / N);
    % calculo do average delay of voip packets
    mean_APD_voip(i,1) = mean(APD_v(i,:));
    term_APD_voip(i,1) = norminv(1-alfa/2) * sqrt(var(APD_v(i,:)) / N);

    % calculo do average queuing delay of VoIP packets

    fprintf('APD data n%d Mbps (ms) = %.2e +- %.2e\n',n(i),mean_APD_data(i,1),term_APD_data(i,1));
    fprintf('APD voip n%d Mbps (ms) = %.2e +- %.2e\n',n(i),mean_APD_voip(i,1),term_APD_voip(i,1));

    % calculo do average delay of data packets
    mean_AQD_data(i,1) = mean(AQD_d(i,:));
    term_AQD_data(i,1) = norminv(1-alfa/2) * sqrt(var(AQD_d(i,:)) / N);
    % calculo do average delay of voip packets
    mean_AQD_voip(i,1) = mean(AQD_v(i,:));
    term_AQD_voip(i,1) = norminv(1-alfa/2) * sqrt(var(AQD_v(i,:)) / N);

    % calculo do average queuing delay of VoIP packets

    fprintf('AQD data n%d Mbps (ms) = %.2e +- %.2e\n',n(i),mean_AQD_data(i,1),term_AQD_data(i,1));
    fprintf('AQD voip n%d Mbps (ms) = %.2e +- %.2e\n\n',n(i),mean_AQD_voip(i,1),term_AQD_voip(i,1));
end

%% 2.b
fprintf("\nB)\n");
lambda = 1500;
C = 10;
f = 1000000;
N = 20;
P = 100000;
alfa = 0.1;
n = [10 20 30 40];

APD_d = zeros(4,N);
APD_v = zeros(4,N);
AQD_d = zeros(4,N);
AQD_v = zeros(4,N);

mean_APD_data_Priority = zeros(4, 1);
term_APD_data_Priority = zeros(4, 1);
mean_APD_voip_Priority = zeros(4, 1);
term_APD_voip_Priority = zeros(4, 1);

mean_AQD_data_Priority = zeros(4, 1);
term_AQD_data_Priority = zeros(4, 1);
mean_AQD_voip_Priority = zeros(4, 1);
term_AQD_voip_Priority = zeros(4, 1);

for i = 1:4
    for j = 1:N
        [~, ~, APD_d(i,j), APD_v(i,j), AQD_d(i,j), AQD_v(i,j), ~, ~, ~] = Simulator4(lambda, C, f, P, n(i));
    end
    
    % calculo do average delay of data packets
    mean_APD_data_Priority(i,1) = mean(APD_d(i,:));
    term_APD_data_Priority(i,1) = norminv(1-alfa/2) * sqrt(var(APD_d(i,:)) / N);
    % calculo do average delay of voip packets
    mean_APD_voip_Priority(i,1) = mean(APD_v(i,:));
    term_APD_voip_Priority(i,1) = norminv(1-alfa/2) * sqrt(var(APD_v(i,:)) / N);

    % calculo do average queuing delay of VoIP packets

    fprintf('Priority APD data n%d Mbps (ms) = %.2e +- %.2e\n',n(i),mean_APD_data_Priority(i,1),term_APD_data_Priority(i,1));
    fprintf('Priority APD voip n%d Mbps (ms) = %.2e +- %.2e\n',n(i),mean_APD_voip_Priority(i,1),term_APD_voip_Priority(i,1));

    % calculo do average delay of data packets
    mean_AQD_data_Priority(i,1) = mean(AQD_d(i,:));
    term_AQD_data_Priority(i,1) = norminv(1-alfa/2) * sqrt(var(AQD_d(i,:)) / N);
    % calculo do average delay of voip packets
    mean_AQD_voip_Priority(i,1) = mean(AQD_v(i,:));
    term_AQD_voip_Priority(i,1) = norminv(1-alfa/2) * sqrt(var(AQD_v(i,:)) / N);

    % calculo do average queuing delay of VoIP packets

    fprintf('Priority AQD data n%d Mbps (ms) = %.2e +- %.2e\n',n(i),mean_AQD_data_Priority(i,1),term_AQD_data_Priority(i,1));
    fprintf('Priority AQD voip n%d Mbps (ms) = %.2e +- %.2e\n\n',n(i),mean_AQD_voip_Priority(i,1),term_AQD_voip_Priority(i,1));
end

%% 2.c
fprintf('\nC)\n');
n = [10 20 30 40]; % Number of VoIP packet flows
C = 10;
C = C * 10^6; % Convert capacity to bps

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

perc_left = (1 - (0.19 + 0.23 + 0.17)) / ((109 - 64) + (1517 - 110));

x = 64:1518;
S = zeros(1,length(x));
S2 = zeros(1,length(x));

for i = 1:length(x)
    if x(i) == 64
        s = (x(i) * 8) / C;
        S(1,i) = 0.19 * s;
        S2(1,i) = 0.19 * s^2;
    elseif x(i) == 110
        s = (x(i) * 8) / C;
        S(1,i) = 0.23 * s;
        S2(1,i) = 0.23 * s^2;        
    elseif x(i) == 1518
        s = (x(i) * 8) / C;
        S(1,i) = 0.17 * s;
        S2(1,i) = 0.17 * s^2;    
    else
        s = (x(i) * 8) / C;
        S(1,i) = perc_left * s;
        S2(1,i) = perc_left * s^2;         
    end
end
ES = sum(S(1,:));
ES2 = sum(S2(1,:));
% Calcula mos no fim o M/G/1 with priorities
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VOIP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% tamanho dos pacotes voip é randi([110 130])
% taxa de chegada do tipo voip é 1 a ([16 24])
size_voip = sum((110:130)/21); % 120 bytes
lambda_voip = 1/(sum((16:24)/9) * 10^-3); % 0.02 seg = 20 ms % lambda_voip = 50 pps
u_voip = 10e6/(8*size_voip); % 9843 pps
ES_v = 1/u_voip; % Service time, S
ES2_v = 1/(u_voip^2); % S^2
% A seguir calculamos o M/G/1 with priorities

APDv = zeros(4, 1); % Initialize an array for VoIP VoIP
APDd = zeros(4, 1); % Initialize an array for VoIP APD
fprintf('Valores teóricos\n');
% Percorremos os fluxos todos
for i = 1:4
    % pk = lambda_k * E[S_k]
    lambda_nflows_voip = lambda_voip * n(i);
    pA = (lambda_nflows_voip) * ES_v;   % ró voip = 0.1920
    pB = lambda * ES;                   % ró data = 0.7440
    % Verifica-se a condição de validade pA+pB < 1 -> 0.9360
    wA = (((lambda_nflows_voip * ES2_v + lambda * ES2) / (2 * (1 - pA))) + ES_v) * 1e3; % segundos
    wB = ((lambda_nflows_voip * ES2_v + lambda * ES2) / (2 * (1 - pA) * (1- pA -pB) )+ ES_v) * 1e3; % segundos
    APDv(i) = wA;
    APDd(i) = wB;
end