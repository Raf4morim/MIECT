clc; clear; 
% Communications with a bit error rate (ber) of p
% Assume that transmission errors in the different bits of a data frame are statistically independent
% The number of errors of a data packet is a binomial random variable

% 2a)
% p_of_Dframe = ?;
cap = 100*8;
p = 10^-2;
% formula (n!/(i!*(n-i)!)) * (p^i*(1-p)^(n-i))
%         = 1 * (p^i*(1-p)^(n-i)), pq i = 0
p_of_Dframe = (1 - p) ^ cap;
percentA = p_of_Dframe * 100;

% 2b)
cap1 = 1000*8;
p1  = 10^-3;
% (n!/(i!*(n-i)!)) ===== b = nchoosek( n , i ) -> binomial coefficient
p_of_Dframe1 = nchoosek( cap1 , 1 ) * (p1^1*(1-p1)^(cap1-1)) ;
percentB = p_of_Dframe1 * 100;

% 2c) 
% 1-f(0) = 1 - binomial(n,0)*p^0*(1-p)^(n-0)
cap2 = 200*8;
p2   = 10^-4;
p_of_Dframe2 = 1 - nchoosek(cap2,0)*p2^0*(1-p2)^(cap2-0);
percentC = p_of_Dframe2 * 100;

% 2d) 

size1 = 100 * 8; size2 = 200 * 8; size3 = 1000 * 8;
p = logspace(-8,-2);
p_Dframe1 = nchoosek(size1, 0) .* (1-p).^(size1-0);
p_Dframe2 = nchoosek(size2, 0) .* (1-p).^(size2-0);
p_Dframe3 = nchoosek(size3, 0) .* (1-p).^(size3-0);

figure(1);
semilogx(p, 100*p_Dframe1,'b', p, 100*p_Dframe2, 'r', p, 100*p_Dframe3, 'g');
title('Probability of packet reception without errors (%)');
legend('100 Bytes', '200 Bytes', '1000 Bytes', 'Location','southwest');
xlabel('Bit Error Rate');
yticks(0:20:100);
grid on;

% 2e

x = linspace(64*8, 1518*8);

no_e1= (1-10^-4).^x;
no_e2= (1-10^-3).^x;
no_e3= (1-10^-2).^x;

figure(2);
semilogy(x, 100*no_e1,'b', x, 100*no_e2, 'r', x, 100*no_e3, 'g');
title('Probability of packet reception without errors');
legend('ber = 1e-4', 'ber = 1e-3', 'ber = 1e-2', 'Location','southwest');
xlabel('Packet Size (Bytes)');

grid on;

