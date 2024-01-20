clc;clear all;
%% 7.b -> run 100 times; stopping criterion P = 10000; 90% de confiança; taxa = 1800 pps
% C = 10 Mbps; f = 1000 000 and n = 20

Num = 100;
P = 10000;
alfa = 0.1;
taxa = 1800;
f = 1000000;
C = 10; % convert para M no simulador
n = 20;

PL_d = zeros(1,Num); % Packet Loss (%)
PL_v = zeros(1,Num); % Packet Loss (%)
APD_d = zeros(1,Num); % average packet delay (milliseconds)
APD_v = zeros(1,Num); % average packet delay (milliseconds)
MPD_d = zeros(1,Num); % maximum packet delay (milliseconds)
MPD_v = zeros(1,Num); % maximum packet delay (milliseconds)
TT = zeros(1,Num); % transmitted throughput (Mbps)

for i = 1:Num
    [PL_d(i), PL_v(i), APD_d(i), APD_v(i), MPD_d(i), MPD_v(i), TT(i)] = Simulator3(taxa, C, f, P, n);
end

mediaPL_d = mean(PL_d);
term1 = norminv(1-alfa/2) * sqrt(var(PL_d)/Num);
mediaAPD_d = mean(APD_d);
term2 = norminv(1-alfa/2) * sqrt(var(APD_d)/Num);
mediaMPD_d = mean(MPD_d);
term3 = norminv(1-alfa/2) * sqrt(var(MPD_d)/Num);

mediaPL_v = mean(PL_v);
term4 = norminv(1-alfa/2) * sqrt(var(PL_v)/Num);
mediaAPD_v = mean(APD_v);
term5 = norminv(1-alfa/2) * sqrt(var(APD_v)/Num);
mediaMPD_v = mean(MPD_v);
term6 = norminv(1-alfa/2) * sqrt(var(MPD_v)/Num);

mediaTT = mean(TT);
term7 = norminv(1-alfa/2) * sqrt(var(TT)/Num);

fprintf('\n\nPacketLoss of data (%%)\t\t = %.2e +/- %.2e \n', mediaPL_d, term1);
fprintf('PacketLoss of VoIP (%%)\t\t = %.2e +/- %.2e \n', mediaPL_v, term4);

fprintf('Av. Packet Delay of data (ms)\t = %.2e +/- %.2e \n', mediaAPD_d, term2);
fprintf('Av. Packet Delay of VoIP (ms)\t = %.2e +/- %.2e \n', mediaAPD_v, term5);

fprintf('Max. Packet Delay of data (ms) = %.2e +/- %.2e \n', mediaMPD_d, term3);
fprintf('Max. Packet Delay of VoIP (ms) = %.2e +/- %.2e \n', mediaMPD_v, term6);

fprintf('Throughput (Mbps)\t = %.2e +/- %.2e \n', mediaTT, term7);


%% 7.e -> run 100 times; stopping criterion P = 10000; 90% de confiança; taxa = 1800 pps
% C = 10 Mbps; f = 1000 000 and n = 20

Num = 100;
P = 10000;
alfa = 0.1;
taxa = 1800;
f = 1000000;
C = 10; % convert para M no simulador
n = 20;

PL_d = zeros(1,Num); % Packet Loss (%)
PL_v = zeros(1,Num); % Packet Loss (%)
APD_d = zeros(1,Num); % average packet delay (milliseconds)
APD_v = zeros(1,Num); % average packet delay (milliseconds)
MPD_d = zeros(1,Num); % maximum packet delay (milliseconds)
MPD_v = zeros(1,Num); % maximum packet delay (milliseconds)
TT = zeros(1,Num); % transmitted throughput (Mbps)

for i = 1:Num
    [PL_d(i), PL_v(i), APD_d(i), APD_v(i), MPD_d(i), MPD_v(i), TT(i)] = Simulator4(taxa, C, f, P, n);
end

mediaPL_d = mean(PL_d);
term1 = norminv(1-alfa/2) * sqrt(var(PL_d)/Num);
mediaAPD_d = mean(APD_d);
term2 = norminv(1-alfa/2) * sqrt(var(APD_d)/Num);
mediaMPD_d = mean(MPD_d);
term3 = norminv(1-alfa/2) * sqrt(var(MPD_d)/Num);

mediaPL_v = mean(PL_v);
term4 = norminv(1-alfa/2) * sqrt(var(PL_v)/Num);
mediaAPD_v = mean(APD_v);
term5 = norminv(1-alfa/2) * sqrt(var(APD_v)/Num);
mediaMPD_v = mean(MPD_v);
term6 = norminv(1-alfa/2) * sqrt(var(MPD_v)/Num);

mediaTT = mean(TT);
term7 = norminv(1-alfa/2) * sqrt(var(TT)/Num);

fprintf('\n\nPacketLoss of data (%%)\t\t = %.2e +/- %.2e \n', mediaPL_d, term1);
fprintf('PacketLoss of VoIP (%%)\t\t = %.2e +/- %.2e \n', mediaPL_v, term4);

fprintf('Av. Packet Delay of data (ms)\t = %.2e +/- %.2e \n', mediaAPD_d, term2);
fprintf('Av. Packet Delay of VoIP (ms)\t = %.2e +/- %.2e \n', mediaAPD_v, term5);

fprintf('Max. Packet Delay of data (ms) = %.2e +/- %.2e \n', mediaMPD_d, term3);
fprintf('Max. Packet Delay of VoIP (ms) = %.2e +/- %.2e \n', mediaMPD_v, term6);

fprintf('Throughput (Mbps)\t = %.2e +/- %.2e \n', mediaTT, term7);