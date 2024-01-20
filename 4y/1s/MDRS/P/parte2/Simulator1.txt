function [PL , APD , MPD , TT] = Simulator1(lambda,C,f,P)
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

%State variables:
STATE = 0;          % 0 - connection free; 1 - connection bysy
QUEUEOCCUPATION= 0; % Occupation of the queue (in Bytes)
QUEUE= [];          % Size and arriving time instant of each packet in the queue

%Statistical Counters:
TOTALPACKETS= 0;       % No. of packets arrived to the system
LOSTPACKETS= 0;        % No. of packets dropped due to buffer overflow
TRANSMITTEDPACKETS= 0; % No. of transmitted packets
TRANSMITTEDBYTES= 0;   % Sum of the Bytes of transmitted packets
DELAYS= 0;             % Sum of the delays of transmitted packets
MAXDELAY= 0;           % Maximum delay among all transmitted packets

% Initializing the simulation clock:
Clock= 0;

% Initializing the List of Events with the first ARRIVAL:
tmp= Clock + exprnd(1/lambda);
Event_List = [ARRIVAL, tmp, GeneratePacketSize(), tmp];

%Similation loop:
while TRANSMITTEDPACKETS<P               % Stopping criterium
    Event_List= sortrows(Event_List,2);  % Order EventList by time
    Event= Event_List(1,1);              % Get first event and 
    Clock= Event_List(1,2);              %   and
    Packet_Size= Event_List(1,3);        %   associated
    Arrival_Instant= Event_List(1,4);    %   parameters.
    Event_List(1,:)= [];                 % Eliminate first event
    if Event == ARRIVAL         % If first event is an ARRIVAL
        TOTALPACKETS= TOTALPACKETS+1;
        tmp= Clock + exprnd(1/lambda);
        Event_List = [Event_List; ARRIVAL, tmp, GeneratePacketSize(), tmp];
        if STATE==0
            STATE= 1;
            Event_List = [Event_List; DEPARTURE, Clock + 8*Packet_Size/(C*10^6), Packet_Size, Clock];
        else
            if QUEUEOCCUPATION + Packet_Size <= f
                QUEUE= [QUEUE;Packet_Size , Clock];
                QUEUEOCCUPATION= QUEUEOCCUPATION + Packet_Size;
            else
                LOSTPACKETS= LOSTPACKETS + 1;
            end
        end
    else                        % If first event is a DEPARTURE
        TRANSMITTEDBYTES= TRANSMITTEDBYTES + Packet_Size;
        DELAYS= DELAYS + (Clock - Arrival_Instant);
        if Clock - Arrival_Instant > MAXDELAY
            MAXDELAY= Clock - Arrival_Instant;
        end
        TRANSMITTEDPACKETS= TRANSMITTEDPACKETS + 1;
        if QUEUEOCCUPATION > 0
            Event_List = [Event_List; DEPARTURE, Clock + 8*QUEUE(1,1)/(C*10^6), QUEUE(1,1), QUEUE(1,2)];
            QUEUEOCCUPATION= QUEUEOCCUPATION - QUEUE(1,1);
            QUEUE(1,:)= [];
        else
            STATE= 0;
        end
    end
end

%Performance parameters determination:
PL= 100*LOSTPACKETS/TOTALPACKETS;      % in %
APD= 1000*DELAYS/TRANSMITTEDPACKETS;   % in milliseconds
MPD= 1000*MAXDELAY;                    % in milliseconds
TT= 10^(-6)*TRANSMITTEDBYTES*8/Clock;  % in Mbps

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