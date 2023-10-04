clear; clc;
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


%% b
fprintf('\n\n -------> B)\n');
N = 100;
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

%% c
fprintf('\n\n -------> C)\n');

N = 100;
lambda = 1800;
C = 10;
f = 10000;
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

%% d
fprintf('\n\n -------> D)\n');

N = 100;
lambda = 1800;
C = 10;
f = 2000;
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

%% e
fprintf('\n\n -------> E)\n');

