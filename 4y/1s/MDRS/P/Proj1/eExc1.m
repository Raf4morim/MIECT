clc;
clear all;
%% 1.c

fprintf('\nC)\n');
Num = 20;
P = 100000;   
alfa = 0.1;
rate = 1800;
f = 1000000;
C = 10;
rates = [1000 1300 1600 1900];
e_TT = zeros(4, Num);
e_mean_Throughput= zeros(4, 1);
e_term_Throughput = zeros(4, 1);
e_APD = zeros(4, Num);
e_mean_APD = zeros(4, 1);
e_term_APD = zeros(4, 1);

for i = 1:4
    for j = 1:Num
        [~, e_APD(i, j), ~, e_TT(i, j)] = eSimulator1(rates(i), C, f, P);
    end

    e_mean_APD(i,1) = mean(e_APD(i,:));
    e_term_APD(i,1) = norminv(1-alfa/2) * sqrt(var(e_APD(i,:)) / Num);
    
    % Display results for average packet delay
    fprintf('Average Packet Delay (ms) (rate = %d pps) = %.2e +- %.2e\n', rates(i), e_mean_APD(i), e_term_APD(i));
    
    e_mean_Throughput(i,1) = mean(e_TT(i,:));
    e_term_Throughput(i,1) = norminv(1-alfa/2) * sqrt(var(e_TT(i,:)) / Num);

    % Display results for average throughput
    fprintf('Average Throughput (Mbps) (rate = %d pps) = %.2e +- %.2e\n', rates(i), e_mean_Throughput(i), e_term_Throughput(i));
end

%% 1.d 
fprintf('\nD)\n');

b = 10^-5;
C = 10;
rates = [1000 1300 1600 1900];

e_TT_ber = zeros(4, Num);
e_mean_Throughput_ber = zeros(4, 1);
e_term_Throughput_ber = zeros(4, 1);
e_APD_ber = zeros(4, Num);
e_mean_APD_ber = zeros(4, 1);
e_term_APD_ber = zeros(4, 1);

for i = 1:4
    for j = 1:Num
        [~, e_APD_ber(i, j), ~, e_TT_ber(i, j)] = eSimulator2(rates(i), C, f, P, b);
    end

    e_mean_APD_ber(i,1) = mean(e_APD_ber(i,:));
    e_term_APD_ber(i,1) = norminv(1-alfa/2) * sqrt(var(e_APD_ber(i,:)) / Num);
    
    % Display results for average packet delay
    fprintf('Average Packet Delay w/ BER (ms) (rate = %d pps) = %.2e +- %.2e\n', rates(i), e_mean_APD_ber(i), e_term_APD_ber(i));

    e_mean_Throughput_ber(i,1) = mean(e_TT_ber(i,:));
    e_term_Throughput_ber(i,1) = norminv(1-alfa/2) * sqrt(var(e_TT_ber(i,:)) / Num);
    % Display results for average throughput
    fprintf('Average Throughput w/ BER (Mbps) (rate = %d pps) = %.2e +- %.2e\n', rates(i), e_mean_Throughput_ber(i), e_term_Throughput_ber(i));
end
