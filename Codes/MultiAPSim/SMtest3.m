%% Calculating Spatial Multiplexing capacities for single AP transmission, Precoding, and Joint transmission

displayProgress = false;

%%
%parameters
N = 200;             % No of iterations
distAP = 15;         % Distance between the two APs
ntx = 1;            % No of transmit antennas
nrx = 1;            % No of recieve antennas
noisePower = -101;   % dBm
txSignalPower = 0;   % dBm

SNR = txSignalPower - noisePower;           % Signal to noise ratio(in dB)

% simulation vaiables
d = 0:(distAP / 8):(distAP);      % distances
d = d(1:end-1) + (distAP / 8 / 2).*ones(1, 8);
ll = length(d);

% servingAP = [1 1 1 1 2 2 2 2;
%              1 1 1 1 5 2 2 2;
%              1 1 1 5 5 5 2 2;
%              1 1 5 5 5 5 5 2;
%              4 5 5 5 5 5 3 3;
%              4 4 5 5 5 3 3 3;
%              4 4 4 5 3 3 3 3;
%              4 4 4 4 3 3 3 3];
servingAP = [1 1 1 1 2 2 2 2;
             1 1 1 1 2 2 2 2;
             1 1 1 1 2 2 2 2;
             1 1 1 1 2 2 2 2;
             4 4 4 4 3 3 3 3;
             4 4 4 4 3 3 3 3;
             4 4 4 4 3 3 3 3;
             4 4 4 4 3 3 3 3];
apCount = zeros(1, 5);

Cmat = zeros(8, 8);

Rss1 = [1 0; 0 1];
Rss2 = [1 0; 0 1];
%%
% output variables
R = zeros(1, 5);

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
    fprintf('%d', i1);
    
    for i2 = 1:ll
        posX = d(i1);
        posY = d(i2);
        
        d1 = distance(posX, posY, 0, 0);                % distance from AP1
        d2 = distance(posX, posY, 0, distAP);           % distance from AP2
        d3 = distance(posX, posY, distAP, distAP);      % distance from AP3
        d4 = distance(posX, posY, distAP, 0);           % distance from AP4
        
        C = 0;
        for i3 = 1:N
            chan1 = TGacChanMat(ntx, nrx, d1);          % channel for AP1
            chan2 = TGacChanMat(ntx, nrx, d2);          % channel for AP2
            chan3 = TGacChanMat(ntx, nrx, d3);          % channel for AP3
            chan4 = TGacChanMat(ntx, nrx, d4);          % channel for AP4
    
    %         chan3 = [chan1(1,:); chan2(1,:)];     % for rx1
    %         chan4 = [chan1(2,:); chan2(2,:)];     % for rx2
    
            % claculating capacities
%             C1_ = C1_ + capacity(chan1, Rss1, SNR);
%             C2_ = C2_ + capacity(chan1 + chan2, Rss2, SNR);
            if(servingAP(i1,i2) == 1)
                C = C + capacity(chan1, noisePower);
            elseif(servingAP(i1,i2) == 2)
                C = C + capacity(chan2, noisePower);
            elseif(servingAP(i1,i2) == 3)
                C = C + capacity(chan3, noisePower);
            elseif(servingAP(i1,i2) == 4)
                C = C + capacity(chan4, noisePower);
            elseif(servingAP(i1,i2) == 5)
                C = C + capacity(chan2 + chan4, noisePower);
            elseif(servingAP(i1,i2) == 6)
                C = C + capacityWithInterference(chan2, chan4, noisePower);
            elseif(servingAP(i1,i2) == 7)
                C = C + capacityWithInterference(chan4, chan2, noisePower);
            end
        end
        Cmat(i1, i2) = C./N;
        R(servingAP(i1,i2)) = R(servingAP(i1,i2)) + C./N;
        apCount(servingAP(i1,i2)) = apCount(servingAP(i1,i2)) + 1;
    end
end
% C1 = C1./N;
% C2 = C2./N;
R = R./apCount;

if displayProgress
    fprintf("]\n");
end
figure
heatmap(abs(Cmat));

disp(apCount);
disp(R);

%% Output display
 %figure
 %plot(d, abs(C1));
 %hold on
 %plot(d, abs(C2));
 %legend('C1','C2','C3')
 %xlabel('Distance from AP1');
 %ylabel('Capacity');
 %title(['Capacity curve (SNR=' num2str(SNR) 'dB)']);
% 

%% Helper functions
function dist = distance(x1, y1, x2, y2)
    dist = sqrt((x1 - x2)^2 + (y1 - y2)^2);
end

function C = capacity(H, No)
    C = log2(det(eye(size(H,1)) + 1/2/10^(No/10) .* (H * H')));
end

function C = capacityWithInterference(H1, H2, No)
    C = log2(det(eye(size(H1,1)) + 1/2/(10^(No/10) + H2 * H2') .* (H1 * H1')));
end

function R = calcR(H, SNR)
    e = eig(H);
    Ri = zeros(1,length(e));
    for i1 = 1:length(e)
        Ri(i1) = log2(1 + 10^(SNR/10)*e(i1));
    end
    R = sum(Ri);
end