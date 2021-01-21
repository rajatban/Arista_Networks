%% Calculating Spatial Multiplexing capacities for single AP transmission, Precoding, and Joint transmission

displayProgress = false;

%%
%parameters
N = 10;             % No of iterations
distAP = 5;         % Distance between the two APs
ntx = 2;            % No of transmit antennas
nrx = 2;            % No of recieve antennas
SNR = 50;           % Signal to noise ratio(in dB)

% simulation vaiables
d = 0:(distAP / 10):(distAP);      % distances
d = d(2:end-1);
ll = length(d);

Rss1 = [1 1; 1 1];
Rss2 = [1 0; 0 1];
Rss3 = [1 0; 0 1];

% output variables
C1 = zeros(1, ll);
C2 = zeros(1, ll);
C3 = zeros(1, ll);

if displayProgress
    fprintf("|");
    for i1 = 1:ll
        fprintf(">");
    end
    fprintf("|\n[");
end

% Simulation loop
for i1 = 1:ll
    if displayProgress
        fprintf("|");
    end
    
    d1 = d(i1);                 % distance from AP1
    d2 = distAP - d(i1);        % distance from AP2
    for i2 = 1:N
        chan1 = TGacChanMat(ntx, nrx, d1);   % channel for AP1
        chan2 = TGacChanMat(ntx, nrx, d2);   % channel for AP2

%         chan3 = [chan1(1,:); chan2(1,:)];     % for rx1
%         chan4 = [chan1(2,:); chan2(2,:)];     % for rx2

        Rss1 = calcR1(chan1);
        
        % claculating capacities
        C1(i1) = C1(i1) + capacity(chan1, Rss1, SNR);
        C2(i1) = C2(i1) + capacity(chan1, Rss2, SNR);
        C3(i1) = C3(i1) + capacity(chan1 + chan2, Rss3, SNR);
    end
end
C1 = C1./N;
C2 = C2./N;
C3 = C3./N;

if displayProgress
    fprintf("]\n");
end

%% Output display
figure
plot(d, abs(C1));
hold on
plot(d, abs(C2));
hold on
plot(d, abs(C3));
legend('C1','C2','C3')
xlabel('Distance from AP1');
ylabel('Capacity');
title(['Capacity curve (SNR=' num2str(SNR) 'dB)']);


%% Helper functions
function R = calcR1(H)
    P1 = 1;
    P2 = 1;
    P = [P1 0; 0 P2];
    
    [~, ~, V] = svd(H);
    K = V * P * V';
    R = K;
end

function C = capacity(H, Rss, SNR)
    C = log2(det(eye(size(H,1)) + 10^(SNR/10)/2 .* (H * Rss * H')));
end