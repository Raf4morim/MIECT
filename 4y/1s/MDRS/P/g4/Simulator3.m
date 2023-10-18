%% 7.a
% fluxos de pacote = n; 
% size uniforme distribuido [110 130]
% tempo distribuido uniforme [16 24] ms

function [PL_d, PL_v,APD_d,APD_v,MPD_d,MPD_v,TT] = Simulator3(lambda,C,f,P,n)
% INPUT PARAMETERS:
%  lambda - packet rate (packets/sec)
%  C      - link bandwidth (Mbps)
%  f      - queue size (Bytes)
%  P      - number of packets (stopping criterium)
% OUTPUT PARAMETERS:
%  PL   - packet loss (%)
%  APD  - average packet delay (milliseconds)
%  MPD  - maximum packet delay (milliseconds)
%  TT   - transmitted throughput (Mbps)

%Events:
ARRIVAL= 0;       % Arrival of a packet            
DEPARTURE= 1;     % Departure of a packet

%Tipo do pacote
DATA = 0;
VOIP = 1;

%State variables:
STATE = 0;          % 0 - connection free; 1 - connection bysy
QUEUEOCCUPATION= 0; % Occupation of the queue (in Bytes)
QUEUE= [];          % Size and arriving time instant of each packet in the queue

%Statistical Counters:
TOTALPACKETS_D= 0;       % No. of packets arrived to the system
LOSTPACKETS_D= 0;        % No. of packets dropped due to buffer overflow
TRANSMITTEDPACKETS_D= 0; % No. of transmitted packets
TRANSMITTEDBYTES_D= 0;   % Sum of the Bytes of transmitted packets
DELAYS_D= 0;             % Sum of the delays of transmitted packets
MAXDELAY_D= 0;           % Maximum delay among all transmitted packets

TOTALPACKETS_V= 0;       % No. of packets arrived to the system
LOSTPACKETS_V= 0;        % No. of packets dropped due to buffer overflow
TRANSMITTEDPACKETS_V= 0; % No. of transmitted packets
TRANSMITTEDBYTES_V= 0;   % Sum of the Bytes of transmitted packets
DELAYS_V= 0;             % Sum of the delays of transmitted packets
MAXDELAY_V= 0;           % Maximum delay among all transmitted packets

% Initializing the simulation clock:
Clock= 0;

% Initializing the List of Events with the first ARRIVAL:
tmp= Clock + exprnd(1/lambda);
Event_List = [ARRIVAL, tmp, GeneratePacketSize(), tmp, DATA];

for i = 1:n
    tmp= unifrnd(0, 0.02);
    Event_List = [Event_List; ARRIVAL, tmp, randi([110 130]), tmp, VOIP];
end

%Similation loop:
while TRANSMITTEDPACKETS_D+TRANSMITTEDPACKETS_V<P               % Stopping criterium
    Event_List= sortrows(Event_List,2);  % Order EventList by time
    Event= Event_List(1,1);              % Get first event and 
    Clock= Event_List(1,2);              %   and
    Packet_Size = Event_List(1,3);       %   associated
    Packet_type = Event_List(1,5);       % tipo do pacote VOIP ou DATA
    Arrival_Instant= Event_List(1,4);    %   parameters.
    Event_List(1,:)= [];                 % Eliminate first event
    
    if Event == ARRIVAL         % If first event is an ARRIVAL
        if Packet_type == DATA
            TOTALPACKETS_D= TOTALPACKETS_D+1;
            tmp= Clock + exprnd(1/lambda); % clock atual mais um tempo distribuido
            Event_List = [Event_List; ARRIVAL, tmp, GeneratePacketSize(), tmp, DATA];
            if STATE==0
                STATE= 1;
                Event_List = [Event_List; DEPARTURE, Clock + 8*Packet_Size/(C*10^6), Packet_Size, Clock, DATA];
            else
                if QUEUEOCCUPATION + Packet_Size <= f
                    QUEUE= [QUEUE;Packet_Size , Clock, DATA];
                    QUEUEOCCUPATION= QUEUEOCCUPATION + Packet_Size;
                else
                    LOSTPACKETS_D= LOSTPACKETS_D + 1; % Se não couber é descartado
                end
            end
        else
            TOTALPACKETS_V= TOTALPACKETS_V+1;
            tmp= Clock + unifrnd(0.016, 0.024); % clock atual mais um tempo distribuido
            Event_List = [Event_List; ARRIVAL, tmp, randi([110 130]), tmp, VOIP];
            if STATE==0
                STATE= 1;
                Event_List = [Event_List; DEPARTURE, Clock + 8*Packet_Size/(C*10^6), Packet_Size, Clock, VOIP];
            else
                if QUEUEOCCUPATION + Packet_Size <= f
                    QUEUE= [QUEUE;Packet_Size , Clock, VOIP];
                    QUEUEOCCUPATION= QUEUEOCCUPATION + Packet_Size;
                else
                    LOSTPACKETS_V= LOSTPACKETS_V + 1; % Se não couber é descartado
                end
            end
        end
    else  % If first event is a DEPARTURE
        if Packet_type == DATA
            TRANSMITTEDBYTES_D= TRANSMITTEDBYTES_D + Packet_Size;
            DELAYS_D= DELAYS_D + (Clock - Arrival_Instant); % tempo atual menos o instante em que chegou ao sistema
            if Clock - Arrival_Instant > MAXDELAY_D
                MAXDELAY_D= Clock - Arrival_Instant;
            end
            TRANSMITTEDPACKETS_D= TRANSMITTEDPACKETS_D + 1;
        else
            TRANSMITTEDBYTES_V= TRANSMITTEDBYTES_V + Packet_Size;
            DELAYS_V= DELAYS_V + (Clock - Arrival_Instant); % tempo atual menos o instante em que chegou ao sistema
            if Clock - Arrival_Instant > MAXDELAY_V
                MAXDELAY_V= Clock - Arrival_Instant;
            end
            TRANSMITTEDPACKETS_V= TRANSMITTEDPACKETS_V + 1;
        end

        if QUEUEOCCUPATION > 0 % QUEUE(1,1) TAMANHO DO PRIMEIRO PACOTE DA FILA DE ESPERA
                Event_List = [Event_List; DEPARTURE, Clock + 8*QUEUE(1,1)/(C*10^6), QUEUE(1,1), QUEUE(1,2), QUEUE(1,3)];
                QUEUEOCCUPATION= QUEUEOCCUPATION - QUEUE(1,1);
                QUEUE(1,:)= []; % Depois elimina a linha do pacote
            else
                STATE= 0; % Quando n há pacotes para serem transmitidos passa para o estado 0
        end
    end
end

%Performance parameters determination:
PL_d= 100*LOSTPACKETS_D/TOTALPACKETS_D;      % in %
APD_d= 1000*DELAYS_D/TRANSMITTEDPACKETS_D;   % in milliseconds
MPD_d= 1000*MAXDELAY_D;                    % in milliseconds

PL_v= 100*LOSTPACKETS_V/TOTALPACKETS_V;      % in %
APD_v= 1000*DELAYS_V/TRANSMITTEDPACKETS_V;   % in milliseconds
MPD_v= 1000*MAXDELAY_V;                    % in milliseconds

TT= 10^(-6)*(TRANSMITTEDBYTES_V+TRANSMITTEDBYTES_D)*8/Clock;  % in Mbps

end

function out= GeneratePacketSize()
    aux= rand();
    aux2= [65:109 111:1517];
    if aux <= 0.19
        out= 64;
    elseif aux <= 0.19 + 0.23
        out= 110;
    elseif aux <= 0.19 + 0.23 + 0.17
        out= 1518;
    else
        out = aux2(randi(length(aux2)));
    end
end