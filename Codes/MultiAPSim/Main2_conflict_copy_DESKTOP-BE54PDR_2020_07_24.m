%% Simulating Multi ap Environment with Joint Transmission


%% Defined Parameters
% simulation parameters
nAP = 2;        % no of APs
nSTA = 1;       % no of STAs
nTxVec = [2 2]; % no of tx antennas per AP
nRxVec = 2;     % no of rx antennas per STA
N = 100;       % iterations
distAP = 50;     % distance between APs
d = 0:(distAP / 10):(distAP);
d = d(2:end-1);
l = length(d);
snr = 3;

% transmission parameters
cfgVHT_AP1 = wlanVHTConfig;       % Create packet configuration
cfgVHT_AP1.NumTransmitAntennas = nTxVec(1);
cfgVHT_AP1.NumSpaceTimeStreams = nRxVec;

cfgVHT_AP2 = wlanVHTConfig;       % Create packet configuration
cfgVHT_AP2.NumTransmitAntennas = nTxVec(2);
cfgVHT_AP2.NumSpaceTimeStreams = nRxVec;

% channel parameters

%% Generating signal
% % generating data
% x = randi([0 1], 1, N);
% % modulating signal
% mod_x = pskmod(x,2);
% % generating tx data for each AP
% mod_x_AP1 = kron(mod_x, ones(nTxVec(1),1));
% mod_x_AP2 = kron(mod_x, ones(nTxVec(2),1));

txDataBits = randi([0 1],8*cfgVHT_AP1.PSDULength,1);
% txDataBits_AP1 = kron(txDataBits, ones(nTxVec(1),1));
% txDataBits_AP2 = kron(txDataBits, ones(nTxVec(2),1));

% generating waveform
txVHTLTF_AP1  = wlanVHTLTF(cfgVHT_AP1);
txWaveform_AP1 = wlanVHTData(txDataBits,cfgVHT_AP1);
powerDB_tx = 10*log10(var(txWaveform_AP1));
txVHTLTF_AP2  = wlanVHTLTF(cfgVHT_AP2);
txWaveform_AP2 = wlanVHTData(txDataBits,cfgVHT_AP2);

%% Calculating BER


mag = zeros(1,l);

BER1 = zeros(1,l);
BER2 = zeros(1,l);

for jj = 1:N
    for kk = 1:(l)
%         fprintf('Dist-%.2f', d(kk));
        
        d1 = kk;
        d2 = l - kk + 1;
        
        % Generating channel and noise
        channelObj = cell(1, nAP);
        for ii = 1:nAP
            channelObj{ii} = TGacChanObj(nTxVec(ii), nRxVec, abs(distAP*(ii-1) - d(kk)));
        end
        variance = 0.5e-9;
        noise = sqrt(variance).*randn(size([txWaveform_AP1; zeros(15,nTxVec(1))])); %Gaussian white noise W
        
        % Estimating channel
        rxVHTLTF_AP1 = channelObj{1}(txVHTLTF_AP1);
        rxVHTLTF_AP2 = channelObj{2}(txVHTLTF_AP2);
        
        demodVHTLTF_AP1 = wlanVHTLTFDemodulate(rxVHTLTF_AP1,cfgVHT_AP1.ChannelBandwidth,cfgVHT_AP1.NumSpaceTimeStreams);
        chanEst_AP1 = wlanVHTLTFChannelEstimate(demodVHTLTF_AP1,cfgVHT_AP1.ChannelBandwidth,cfgVHT_AP1.NumSpaceTimeStreams);
        demodVHTLTF_AP2 = wlanVHTLTFDemodulate(rxVHTLTF_AP2,cfgVHT_AP2.ChannelBandwidth,cfgVHT_AP2.NumSpaceTimeStreams);
        chanEst_AP2 = wlanVHTLTFChannelEstimate(demodVHTLTF_AP2,cfgVHT_AP2.ChannelBandwidth,cfgVHT_AP2.NumSpaceTimeStreams);
        
        mag(kk) = abs(chanEst_AP1(1,1,1));
        
        % Pass through channel (with zeros to allow for channel delay)
        rxWaveform_AP1 = channelObj{1}([txWaveform_AP1; zeros(15,nTxVec(1))]);
        rxWaveform_AP2 = channelObj{2}([txWaveform_AP2; zeros(15,nTxVec(2))]);
        
        %     rxWaveform1 = awgn(rxWaveform_AP1, snr, 0.000001);
        rxWaveform1 = rxWaveform_AP1 + noise;
        
        powerDB1 = 10*log10(var(rxWaveform1));
        noiseVarEst1 = variance;%mean(10.^(0.1*(powerDB1 - snr)));
        rxDataBits1 = wlanVHTDataRecover(rxWaveform1,chanEst_AP1,noiseVarEst1,cfgVHT_AP1,1);
        
        snr1 = snr + 3;
%         rxWaveform_sum = awgn(rxWaveform_AP1 + rxWaveform_AP2, snr1, 'measured');
        rxWaveform_sum =rxWaveform_AP1 + rxWaveform_AP2 + noise;
        
        powerDB_sum = 10*log10(var(rxWaveform_sum));
        noiseVarEst_sum = variance;%mean(10.^(0.1*(powerDB_sum - snr1)));
        rxDataBits = wlanVHTDataRecover(rxWaveform_sum,chanEst_AP1+chanEst_AP2,noiseVarEst_sum,cfgVHT_AP1,1);
        %ber(ii)=sum(xor(txDataBits,rxDataBits))/length(txDataBits);
        
        % calculating BER
        BER1(kk) = BER1(kk) + sum(xor(txDataBits,rxDataBits1))/length(txDataBits);
        BER2(kk) = BER2(kk) + sum(xor(txDataBits,rxDataBits))/length(txDataBits);
        %     fprintf('\n');
        
%         if(d(kk)==2.5)
%             fprintf('noiseVarEst1 - %f : %f', noiseVarEst1, noiseVarEst_sum);
%         end
        
    end
    fprintf('Iter-%d\n', jj);
end

BER1 = BER1 / jj;
BER2 = BER2 / jj;

%plot(mag)
% figure
plot(d,BER1,'b.-');
hold on;
plot(d,BER2,'r.-');
grid on
legend('Single AP','2 AP JT','location',"northwest");
%title(['BER plot for (SNR - ' num2str(snr) ')']);
title(['BER plot']);
xlabel('Dist');
ylabel('BER');
hold on