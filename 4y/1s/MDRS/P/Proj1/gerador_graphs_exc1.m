clc;clear ALL;

load('ex1.mat');

%% 1.a
figure(1);
hold on;
bar(C_a, mean_APD_C);
errorbar(C_a, mean_APD_C, term_APD_C, 'r.', 'MarkerSize', 5, 'LineStyle', 'none');
xticks(C_a);
xlabel('C (Mbps)');
ylabel('Average Packet Delay (ms)');
title('Average Packet Delay with Error Bars');
set(gca, 'ColorOrder', [0 0 0.8; 0 0.8 0.5]);grid on; 
hold off;

%% 1.c
figure(2);

subplot(1,2,1);
hold on;
bar(rates, mean_APD);
errorbar(rates, mean_APD, term_APD, 'r.', 'MarkerSize', 5, 'LineStyle', 'none');
xticks(rates);
xlabel('Packet Arrival Rate (pps)');
% ylim([0 10]);
ylabel('Average Packet Delay (ms)');
title('Average Packet Delay');
set(gca, 'ColorOrder', [0 0 0.8; 0 0.8 0.5]);grid on;
hold off;

% Segundo subplot - Average Throughput
subplot(1, 2, 2);
hold on;
bar(rates, mean_Throughput);
errorbar(rates, mean_Throughput, term_Throughput, 'r.', 'MarkerSize', 5, 'LineStyle', 'none');
xticks(rates);
xlabel('Packet Arrival Rate (pps)');
ylabel('Average Throughput (Mbps)');
title('Average Throughput');
set(gca, 'ColorOrder', [0 0 0.8; 0 0.8 0.5]);grid on;
hold off;


%% 1.d
figure(3);

% Primeiro subplot - Average Packet Delay
subplot(1, 2, 1);
hold on;
bar(rates, [mean_APD, mean_APD_ber]);
errorbar((rates-45), mean_APD, term_APD, 'r.', 'MarkerSize', 5, 'LineStyle', 'none');
errorbar((rates+45), mean_APD_ber, term_APD_ber, 'r.', 'MarkerSize', 5, 'LineStyle', 'none');

xticks(rates);
xlabel('Packet Arrival Rate (pps)');
ylim([0 10]);
ylabel('Average Packet Delay (ms)');
title('Average Packet Delay');
legend({'Without BER', 'With BER'}, 'Location','northwest');
set(gca, 'ColorOrder', [0 0 0.8; 0 0.8 0.5]);grid on;
hold off;

% Segundo subplot - Average Throughput
subplot(1, 2, 2);
hold on;
bar(rates, [mean_Throughput, mean_Throughput_ber]);
errorbar(rates - 45, mean_Throughput, term_Throughput, 'r.', 'MarkerSize', 5, 'LineStyle', 'none');
errorbar(rates + 45, mean_Throughput_ber, term_Throughput_ber, 'r.', 'MarkerSize', 5, 'LineStyle', 'none');
xticks(rates);
xlabel('Packet Arrival Rate (pps)');
ylabel('Average Throughput (Mbps)');
title('Average Throughput');
legend({'Without BER', 'With BER'}, 'Location','northwest');
set(gca, 'ColorOrder', [0 0 0.8; 0 0.8 0.5]);grid on;
hold off;

%% 1.e.d
load('ex1e.mat');

figure(4);
% Primeiro subplot - Average Packet Delay BER
subplot(2, 2, 1);
hold on;
bar(rates, [mean_APD_ber, e_mean_APD_ber]);
errorbar((rates-45), mean_APD_ber, term_APD_ber, 'r.', 'MarkerSize', 5, 'LineStyle', 'none');
errorbar((rates+45), e_mean_APD_ber, e_term_APD_ber, 'r.', 'MarkerSize', 5, 'LineStyle', 'none');
xticks(rates);
xlabel('Packet Arrival Rate (pps)');
ylim([0 9]);
ylabel('Average Packet Delay w/ BER(ms)');
title('Average Packet Delay w/ size changed and BER');
legend({'Original size', 'Changed size'}, 'Location','northwest');
set(gca, 'ColorOrder', [0 0 0.8; 0 0.8 0.5]);grid on;
hold off;

% Segundo subplot - Average Throughput BER
subplot(2, 2, 2);
hold on;
bar(rates, [mean_Throughput_ber, e_mean_Throughput_ber]);
errorbar(rates - 45, mean_Throughput_ber, term_Throughput_ber, 'r.', 'MarkerSize', 5, 'LineStyle', 'none');
errorbar(rates + 45, e_mean_Throughput_ber, e_term_Throughput_ber, 'r.', 'MarkerSize', 5, 'LineStyle', 'none');
xticks(rates);
xlabel('Packet Arrival Rate (pps)');
ylim([0 10]);
ylabel('Average Throughput w/ BER (Mbps)');
title('Average Throughput w/ size changed and BER');
legend({'Original size', 'Changed size'}, 'Location','northwest');
set(gca, 'ColorOrder', [0 0 0.8; 0 0.8 0.5]);grid on;
hold off;

%% 1.e.d
% Terceiro subplot - Average Packet Delay
subplot(2, 2, 3);
hold on;
bar(rates, [mean_APD, e_mean_APD]);
errorbar((rates-45), mean_APD, term_APD, 'r.', 'MarkerSize', 5, 'LineStyle', 'none');
errorbar((rates+45), e_mean_APD, e_term_APD, 'r.', 'MarkerSize', 5, 'LineStyle', 'none');
xticks(rates);
xlabel('Packet Arrival Rate (pps)');
ylim([0 9]);
ylabel('Average Packet Delay (ms)');
title('Average Packet Delay w/ size changed');
legend({'Original size', 'Changed size'}, 'Location','northwest');
set(gca, 'ColorOrder', [0 0 0.8; 0 0.8 0.5]);grid on;
hold off;

% Quarto subplot - Average Throughput
subplot(2, 2, 4);
hold on;
bar(rates, [mean_Throughput, e_mean_Throughput]);
errorbar(rates - 45, mean_Throughput, term_Throughput, 'r.', 'MarkerSize', 5, 'LineStyle', 'none');
errorbar(rates + 45, e_mean_Throughput, e_term_Throughput, 'r.', 'MarkerSize', 5, 'LineStyle', 'none');
xticks(rates);
xlabel('Packet Arrival Rate (pps)');
ylabel('Average Throughput (Mbps)');
title('Average Throughput w/ size changed');
legend({'Original size', 'Changed size'}, 'Location','northwest');
set(gca, 'ColorOrder', [0 0 0.8; 0 0.8 0.5]);grid on;
hold off;