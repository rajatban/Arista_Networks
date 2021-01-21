%% Simulating Multi ap Environment with Joint Transmission


%% Defined Parameters
% simulation parameters
nAP = 2;        % no of APs
nSTA = 1;       % no of STAs
nTxVec = [2 2]; % no of tx antennas per AP
nRxVec = 2;     % no of rx antennas per STA
N = 50;       % bits per user
distAP = 4;    % distance between APs
snr = 60;

% transmission parameters

% channel parameters

%% Generating signal
% generating data
x = randi([0 1], 1, N);
% modulating signal
mod_x = pskmod(x,2);
% generating tx data for each AP
mod_x_AP1 = kron(mod_x, ones(nTxVec(1),1));
mod_x_AP2 = kron(mod_x, ones(nTxVec(2),1));

%% Calculating BER
d = 0:(distAP / 40):(distAP);
d = d(2:end-1);
l = length(d);
BER1 = zeros(1,l);
BER2 = zeros(1,l);
for kk = 1:(l)
    fprintf('Dist-%.2f', d(kk));
    mod_y_mrc1 = zeros(1,N);
    mod_y_mrc2 = zeros(1,N);
    
%     % Generating channel and noise
%     h = cell(1, nAP);
%     for ii = 1:nAP
%         h{ii} = TGacChanMat(nTxVec(ii), nRxVec, abs(distAP*(ii-1) - d(kk)));
%     end

    h_bar = readmatrix("tgacMats.xlsx");
    
    d1 = kk;
    d2 = l - kk + 1;
    
    for iteration = 1:N    
%         % Generating channel and noise
%         h = cell(1, nAP);
%         for ii = 1:nAP
%             h{ii} = genRayChan(nTxVec(ii), nRxVec, abs(distAP*(ii-1) - d(kk)));
%         end
%         % Generating channel and noise
%         h = cell(1, nAP);
%         for ii = 1:nAP
%             h{ii} = TGacChanMat(nTxVec(ii), nRxVec, abs(distAP*(ii-1) - d(kk)));
%         end

        nTx = nTxVec(1);
        nRx = nRxVec;
        
        h= reshape(h_bar((nTx*(iteration - 1) + 1):(nTx*iteration),:), nTx, nRx, l);
        n = 10^(-snr/20)/sqrt(2)*(randn(nRxVec, 1) + 1i*randn(nRxVec, 1)); % white gaussian noise, 0dB variance
        
%         % passing signal through channel
%         mod_y1 = h{1} * mod_x_AP1(:,iteration) + n;
%         mod_y2 = h{1} * mod_x_AP1(:,iteration) + h{2} *mod_x_AP2(:,iteration) + n;
        
        % passing signal through channel
        mod_y1 = h(:,:,d1) * mod_x_AP1(:,iteration) + n;
        mod_y2 = h(:,:,d1) * mod_x_AP1(:,iteration) + h(:,:,d2) *mod_x_AP2(:,iteration) + n;

        
        % estimating channel
        est_h1 = h(:,:,d1)*ones(nTxVec(1), 1) + n;
        est_h2 = h(:,:,d1)*ones(nTxVec(1), 1) + h(:,:,d2)*ones(nTxVec(2), 1) + n;
        
        % MRC
        w1 = (1/norm(est_h1)) * est_h1;
        mod_y_mrc1(iteration)= w1' * mod_y1;
        
        w2 = (1/norm(est_h2)) * est_h2;
        mod_y_mrc2(iteration)= w2' * mod_y2;
%         if (mod(iteration, 10) == 0)
%             fprintf('-');
%         end
    end
    % demodulating signal
    demod_y_mrc1 = pskdemod(mod_y_mrc1,2);
    demod_y_mrc2 = pskdemod(mod_y_mrc2,2);
    % calculating BER
    BER1(kk) = sum(demod_y_mrc1~=x,2)/N;
    BER2(kk) = sum(demod_y_mrc2~=x,2)/N;
%     fprintf('\n');
end

figure
plot(d,BER1);
hold on;
plot(d,BER2);
grid on
legend('Single AP','2 AP JT','location',"northwest");
title(['BER plot']);
xlabel('Dist');
ylabel('BER');
hold off