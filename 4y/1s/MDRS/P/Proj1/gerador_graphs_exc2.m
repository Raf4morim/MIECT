load('ex2.mat');
%% 2.a
% Crie uma única figura
figure(1);


% Configure a primeira subplot
subplot(1, 2, 1);
bar(n, [mean_APD_data,mean_AQD_data]);
hold on;

errorbar((n-1.5), mean_APD_data, term_APD_data, 'r.', 'MarkerSize', 5, 'LineStyle', 'none');
errorbar((n+1.5), mean_AQD_data, term_AQD_data,'r.', 'MarkerSize', 5, 'LineStyle', 'none');

xlabel('n VoIP flows');
ylabel('Average Delay (ms)');
title('Average Packet Delay vs Average Queueing Delay of Data');
legend({'APD', 'AQD'}, 'Location','northwest');
set(gca, 'ColorOrder', [0 0 0.8; 0 0.8 0.5]);grid on;
hold off;

% Configure a terceira subplot
subplot(1, 2, 2);
bar(n, [mean_APD_voip,mean_AQD_voip]);
hold on;

errorbar((n-1.5), mean_APD_voip, term_APD_voip,'r.', 'MarkerSize', 5, 'LineStyle', 'none');
errorbar((n+1.5), mean_AQD_voip, term_AQD_voip,'r.', 'MarkerSize', 5, 'LineStyle', 'none');

xlabel('n VoIP flows');
ylim([0 7])
ylabel('Average Delay (ms)');
title('Average Packet Delay vs Average Queueing Delay of VoIP');
legend({'APD', 'AQD'}, 'Location','northwest');
set(gca, 'ColorOrder', [0 0 0.8; 0 0.8 0.5]);grid on;
hold off;

%% 2.b
figure(2);

% Configure a primeira subplot
subplot(2, 2, 1);
hold on;
bar(n, [mean_APD_data, mean_APD_data_Priority]);
errorbar((n-1.5), mean_APD_data, term_APD_data,'r.', 'MarkerSize', 5, 'LineStyle', 'none');
errorbar((n+1.5), mean_APD_data_Priority, term_APD_data_Priority,'r.', 'MarkerSize', 5, 'LineStyle', 'none');
xlabel('n VoIP flows');
xticks(n);
ylabel('Average Packet Delay (ms)');
title('Average Packet Delay of Data');
legend({'Without priority higher to VoIP', 'With priority higher to VoIP'}, 'Location', 'NorthWest');
ylim([0 8]);
set(gca, 'ColorOrder', [0 0 0.8; 0 0.8 0.5]);
grid on;
hold off;

% Configure a segunda subplot
subplot(2, 2, 2);
hold on;
bar(n, [mean_APD_voip, mean_APD_voip_Priority]);
errorbar((n-1.5), mean_APD_voip, term_APD_voip,'r.', 'MarkerSize', 5, 'LineStyle', 'none');
errorbar((n+1.5), mean_APD_voip_Priority, term_APD_voip_Priority,'r.', 'MarkerSize', 5, 'LineStyle', 'none');
xlabel('n VoIP flows');
xticks(n);
ylabel('Average Packet Delay (ms)');
title('Average Packet Delay of VoIP');
legend({'Without priority higher to VoIP', 'With priority higher to VoIP'}, 'Location', 'NorthWest');
ylim([0 8]);
set(gca, 'ColorOrder', [0 0 0.8; 0 0.8 0.5]);
grid on;
hold off;

% Configure a terceira subplot
subplot(2, 2, 3);
hold on;
bar(n, [mean_AQD_data, mean_AQD_data_Priority]);
errorbar((n-1.5), mean_AQD_data, term_AQD_data,'r.', 'MarkerSize', 5, 'LineStyle', 'none');
errorbar((n+1.5), mean_AQD_data_Priority, term_AQD_data_Priority,'r.', 'MarkerSize', 5, 'LineStyle', 'none');
xlabel('n VoIP flows');
xticks(n);
ylabel('Average Queue Delay (ms)');
title('Average Queue Delay of Data');
legend({'Without priority higher to VoIP', 'With priority higher to VoIP'}, 'Location', 'NorthWest');
ylim([0 8]);
set(gca, 'ColorOrder', [0 0 0.8; 0 0.8 0.5]);
grid on;
hold off;

% Configure a quarta subplot
subplot(2, 2, 4);
hold on;
bar(n, [mean_AQD_voip, mean_AQD_voip_Priority]);
errorbar((n-1.5), mean_AQD_voip, term_AQD_voip,'r.', 'MarkerSize', 5, 'LineStyle', 'none');
errorbar((n+1.5), mean_AQD_voip_Priority, term_AQD_voip_Priority,'r.', 'MarkerSize', 5, 'LineStyle', 'none');
xlabel('n VoIP flows');
xticks(n);
ylabel('Average Queue Delay (ms)');
title('Average Queue Delay of VoIP');
legend({'Without priority higher to VoIP', 'With priority higher to VoIP'}, 'Location', 'NorthWest');
ylim([0 8]);
set(gca, 'ColorOrder', [0 0 0.8; 0 0.8 0.5]);
grid on;
hold off;

%% 2.c


figure(3);

% Configure a primeira subplot
subplot(1, 2, 1);
hold on;
bar(n, [mean_APD_data_Priority, APDd]);

errorbar((n-1.5), mean_APD_data_Priority, term_APD_data_Priority,'r.', 'MarkerSize', 5, 'LineStyle', 'none');
xlabel('n VoIP flows');
xticks(n);
ylabel('Average Packet Delay (ms)');
title('Average Packet Delay of Data w/ priority VoIP');
legend({'Simulation Values', 'Theorical values'}, 'Location', 'NorthWest');
ylim([0 8]);
set(gca, 'ColorOrder', [0 0.8 0.5; 0 0 0.8]);
grid on;
hold off;

% Configure a segunda subplot
subplot(1, 2, 2);
hold on;
bar(n, [mean_APD_voip_Priority, APDv]);

errorbar((n-1.5), mean_APD_voip_Priority, term_APD_voip_Priority,'r.', 'MarkerSize', 5, 'LineStyle', 'none');
xlabel('n VoIP flows');
xticks(n);
ylabel('Average Packet Delay (ms)');
title('Average Packet Delay of VoIP w/ priority VoIP');
legend({'Simulation Values', 'Theorical values'}, 'Location', 'NorthWest');
ylim([0 8]);
set(gca, 'ColorOrder', [0 0.8 0.5; 0 0 0.8]);
grid on;
hold off;
