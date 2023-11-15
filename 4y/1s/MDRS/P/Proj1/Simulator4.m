function [PLd, PLv, APDd, APDv, AQDd, AQDv, MPDd, MPDv, TT] = Simulator4(lambda,C,f,P,n)

% INPUT PARAMETERS:
%  lambda - packet rate (packets/sec)
%  C      - link bandwidth (Mbps)
%  f      - queue size (Bytes)
%  P      - number of packets (stopping criterium)
%  
% OUTPUT PARAMETERS:
%  PL   - packet loss (%)
%  APD  - average packet delay (milliseconds)
%  MPD  - maximum packet delay (milliseconds)
%  TT   - transmitted throughput (Mbps)

%Events:
ARRIVAL= 0;       % Arrival of a packet            
DEPARTURE= 1;     % Departure of a packet

%Packet type
DATA = 0;
VOIP = 1;

%State variables:
STATE = 0;          % 0 - connection free; 1 - connection bysy
QUEUEOCCUPATION= 0; % Occupation of the queue (in Bytes)
QUEUE= [];          % Size and arriving time instant of each packet in the queue

%Statistical Counters:
TOTALPACKETSD= 0;       % No. of packets arrived to the system
TOTALPACKETSV = 0;
LOSTPACKETSD= 0;        % No. of packets dropped due to buffer overflow
LOSTPACKETSV= 0;
TRANSMITTEDPACKETSD= 0; % No. of transmitted packets
TRANSMITTEDPACKETSV=0;
TRANSMITTEDBYTESD= 0;   % Sum of the Bytes of transmitted packets
TRANSMITTEDBYTESV=0;
DELAYSD= 0;             % Sum of the delays of transmitted packets
DELAYSV=0;

QUEUEDELAYSD = 0;
QUEUEDELAYSV = 0;

MAXDELAYD= 0;           % Maximum delay among all transmitted packets
MAXDELAYV=0;
% Initializing the simulation clock:
Clock= 0;

% Initializing the List of Events with the first ARRIVAL:
tmp= Clock + exprnd(1/lambda); 
Event_List = [ARRIVAL, tmp, GeneratePacketSize(), tmp, DATA];

for i = 1:n
    tmp = unifrnd(0,0.02);
    Event_List = [Event_List; ARRIVAL, tmp, randi([110 130]), tmp, VOIP];
end
%Similation loop:
while (TRANSMITTEDPACKETSD+TRANSMITTEDPACKETSV) < P               % Stopping criterium
    Event_List= sortrows(Event_List,2);  % Order EventList by time
    Event= Event_List(1,1);              % Get first event and 
    Clock= Event_List(1,2);              %   and
    Packet_Size= Event_List(1,3);        %   associated
    Arrival_Instant= Event_List(1,4);    %   parameters.
    Packet_type = Event_List(1,5);
    Event_List(1,:)= [];                 % Eliminate first event
    
    if Event == ARRIVAL         % If first event is an ARRIVAL
        if Packet_type == DATA
            TOTALPACKETSD= TOTALPACKETSD+1;
            tmp= Clock + exprnd(1/lambda);
            Event_List = [Event_List; ARRIVAL, tmp, GeneratePacketSize(), tmp, DATA];
            if STATE==0
                STATE= 1;
                Event_List = [Event_List; DEPARTURE, Clock + 8*Packet_Size/(C*10^6), Packet_Size, Clock, DATA];
            else
                if QUEUEOCCUPATION + Packet_Size <= f
                    QUEUE= [QUEUE;Packet_Size , Clock, DATA];
                    QUEUEOCCUPATION= QUEUEOCCUPATION + Packet_Size;
                else
                    LOSTPACKETSD= LOSTPACKETSD + 1;
                end
            end
        else
            TOTALPACKETSV= TOTALPACKETSV+1;
            tmp= Clock + unifrnd(0.016,0.024);
            Event_List = [Event_List; ARRIVAL, tmp, randi([110 130]), tmp, VOIP];
            if STATE==0
                STATE= 1;
                Event_List = [Event_List; DEPARTURE, Clock + 8*Packet_Size/(C*10^6), Packet_Size, Clock, VOIP];
            else
            

                if QUEUEOCCUPATION + Packet_Size <= f
                    QUEUE= [QUEUE;Packet_Size , Clock, VOIP];
                    QUEUEOCCUPATION= QUEUEOCCUPATION + Packet_Size;
                else
                    LOSTPACKETSV= LOSTPACKETSV + 1;
                end
            end
        end
    else                        % If first event is a DEPARTURE
        if Packet_type == DATA
            TRANSMITTEDBYTESD= TRANSMITTEDBYTESD + Packet_Size;
            DELAYSD= DELAYSD + (Clock - Arrival_Instant);
            if Clock - Arrival_Instant > MAXDELAYD
                MAXDELAYD= Clock - Arrival_Instant;
            end
            TRANSMITTEDPACKETSD= TRANSMITTEDPACKETSD + 1;
        else    
            TRANSMITTEDBYTESV= TRANSMITTEDBYTESV + Packet_Size;
            DELAYSV= DELAYSV + (Clock - Arrival_Instant);
            if Clock - Arrival_Instant > MAXDELAYV
                MAXDELAYV= Clock - Arrival_Instant;
            end
            TRANSMITTEDPACKETSV= TRANSMITTEDPACKETSV + 1;
        end
        if (TRANSMITTEDPACKETSD+TRANSMITTEDPACKETSV) < P
            if QUEUEOCCUPATION > 0
                % VoIP packets are given higher 
                % priority than data packets in the queue
                QUEUE = sortrows(QUEUE,3,"descend");    
                Event_List = [Event_List; DEPARTURE, Clock + 8*QUEUE(1,1)/(C*10^6), QUEUE(1,1), QUEUE(1,2), QUEUE(1,3)];
                QUEUEOCCUPATION= QUEUEOCCUPATION - QUEUE(1,1);
    
                if QUEUE(1,3) == DATA
                    QUEUEDELAYSD = QUEUEDELAYSD + (Clock - QUEUE(1,2));
                elseif QUEUE(1,3) == VOIP
                    QUEUEDELAYSV = QUEUEDELAYSV + (Clock - QUEUE(1,2));
                end
    
                QUEUE(1,:)= [];
            else
                STATE= 0;
            end
        end
    end
end

%Performance parameters determination:
PLd= 100*LOSTPACKETSD/TOTALPACKETSD;      % in %
PLv = 100*LOSTPACKETSV/TOTALPACKETSV;                        % in %
APDd = 1000*DELAYSD/TRANSMITTEDPACKETSD;                     % in milliseconds
APDv = 1000*DELAYSV/TRANSMITTEDPACKETSV;                     % in milliseconds
MPDd = 1000*MAXDELAYD;                                       % in milliseconds
MPDv = 1000*MAXDELAYV;                                       % in milliseconds
AQDd = 1000*QUEUEDELAYSD/TRANSMITTEDPACKETSD;
AQDv = 1000*QUEUEDELAYSV/TRANSMITTEDPACKETSV;
TT = 10^(-6)*(TRANSMITTEDBYTESD+TRANSMITTEDBYTESV)*8/Clock;  % in Mbps

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