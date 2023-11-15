clc;
clear all;
%% 1.a
fprintf('A)\n');

Num = 20;
P = 100000;   
alfa = 0.1;
rate = 1800;
f = 1000000;
C_a = [10 20 30 40];

APD_C = zeros(4, Num);
mean_APD_C = zeros(4, 1);
term_APD_C = zeros(4, 1);

for i = 1:4
    for j = 1:Num
        [~, APD_C(i, j), ~, ~] = Simulator1(rate, C_a(i), f, P);
    end
    mean_APD_C(i,1) = mean(APD_C(i,:));
    term_APD_C(i,1) = norminv(1-alfa/2) * sqrt(var(APD_C(i,:)) / Num);
    fprintf('APD C%d Mbps (ms) = %.2e +- %.2e\n',C_a(i),mean_APD_C(i,1),term_APD_C(i,1));
end

%% 1.b
fprintf('\nB)\n');
C_a = C_a.*10^6;

perc_left = (1 - (0.19+0.23+0.17))/((109 - 64) + (1517 - 110));

x = 64:1518;

S = zeros(4,length(x)); % Tempo de Atendimento, S
S2 = zeros(4,length(x)); % S^2
APD = zeros(1,4);

for j = 1:4 % Loop valores de C
    for i = 1:length(x)
        if x(i) == 64
            s = (x(i) * 8) / C_a(j);
            S(j,i) = 0.19 * s;
            S2(j,i) = 0.19 * s^2;
        elseif x(i) == 110
            s = (x(i) * 8) / C_a(j);
            S(j,i) = 0.23 * s;
            S2(j,i) = 0.23 * s^2;        
        elseif x(i) == 1518
            s = (x(i) * 8) / C_a(j);
            S(j,i) = 0.17 * s;
            S2(j,i) = 0.17 * s^2;    
        else
            s = (x(i) * 8) / C_a(j);
            S(j,i) = perc_left * s;
            S2(j,i) = perc_left * s^2;         
        end
    end
    ES = sum(S(j,:));
    ES2 = sum(S2(j,:));
    APD(j) = (rate * ES2)/(2*(1 - rate*ES)) + ES; % atraso médio de cada pacote no sistema
end

for i = 1:4
    fprintf('Theoretical value APD C%d Mbps (ms) = %.2e\n',C_a(i)/10^6,APD(i)*1000);
end

%% 1.c
fprintf('\nC)\n');

C = 10;
rates = [1000 1300 1600 1900];
TT = zeros(4, Num);
mean_Throughput = zeros(4, 1);
term_Throughput = zeros(4, 1);
APD = zeros(4, Num);
mean_APD = zeros(4, 1);
term_APD = zeros(4, 1);

for i = 1:4
    for j = 1:Num
        [~, APD(i, j), ~, TT(i, j)] = Simulator1(rates(i), C, f, P);
    end

    mean_APD(i,1) = mean(APD(i,:));
    term_APD(i,1) = norminv(1-alfa/2) * sqrt(var(APD(i,:)) / Num);
    
    % Display results for average packet delay
    fprintf('Average Packet Delay (ms) (rate = %d pps) = %.2e +- %.2e\n', rates(i), mean_APD(i), term_APD(i));
    
    mean_Throughput(i,1) = mean(TT(i,:));
    term_Throughput(i,1) = norminv(1-alfa/2) * sqrt(var(TT(i,:)) / Num);

    % Display results for average throughput
    fprintf('Average Throughput (Mbps) (rate = %d pps) = %.2e +- %.2e\n', rates(i), mean_Throughput(i), term_Throughput(i));
end

%% 1.d 
fprintf('\nD)\n');

b = 10^-5;
C = 10;
rates = [1000 1300 1600 1900];

TT_ber = zeros(4, Num);
mean_Throughput_ber = zeros(4, 1);
term_Throughput_ber = zeros(4, 1);
APD_ber = zeros(4, Num);
mean_APD_ber = zeros(4, 1);
term_APD_ber = zeros(4, 1);

for i = 1:4
    for j = 1:Num
        [~, APD_ber(i, j), ~, TT_ber(i, j)] = Simulator2(rates(i), C, f, P, b);
    end

    mean_APD_ber(i,1) = mean(APD_ber(i,:));
    term_APD_ber(i,1) = norminv(1-alfa/2) * sqrt(var(APD_ber(i,:)) / Num);
    
    % Display results for average packet delay
    fprintf('Average Packet Delay w/ BER (ms) (rate = %d pps) = %.2e +- %.2e\n', rates(i), mean_APD_ber(i), term_APD_ber(i));

    mean_Throughput_ber(i,1) = mean(TT_ber(i,:));
    term_Throughput_ber(i,1) = norminv(1-alfa/2) * sqrt(var(TT_ber(i,:)) / Num);
    % Display results for average throughput
    fprintf('Average Throughput w/ BER (Mbps) (rate = %d pps) = %.2e +- %.2e\n', rates(i), mean_Throughput_ber(i), term_Throughput_ber(i));
end