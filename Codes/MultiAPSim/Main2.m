%% Simulating Multi ap Environment with Joint Transmission


%% Defined Parameters
% simulation parameters
nAP = 2;        % no of APs
nSTA = 1;       % no of STAs
nTxVec = [2 2]; % no of tx antennas per AP
nRxVec = 2;     % no of rx antennas per STA
N = 10;         % no of iterations
distAP = 20;     % distance between APs
snr = 60;

% transmission parameters
cfgVHT_AP1 = wlanVHTConfig;       % Create packet configuration
cfgVHT_AP1.NumTransmitAntennas = nTxVec(1);
cfgVHT_AP1.NumSpaceTimeStreams = nRxVec;

cfgVHT_AP2 = wlanVHTConfig;       % Create packet configuration
cfgVHT_AP2.NumTransmitAntennas = nTxVec(2);
cfgVHT_AP2.NumSpaceTimeStreams = nRxVec;

% channel parameters
txPowerDB = -3;
noisePowerDB = txPowerDB - snr;
variance = 10^(0.1*noisePowerDB);  % Noise Power = Variance * Sampling time
% variance = 0.000005;


%% Generating signal
% generating data
txDataBits = randi([0 1],8*cfgVHT_AP1.PSDULength,1);

% generating waveform
txVHTLTF_AP1  = wlanVHTLTF(cfgVHT_AP1);
txWaveform_AP1 = wlanVHTData(txDataBits,cfgVHT_AP1);

txVHTLTF_AP2  = wlanVHTLTF(cfgVHT_AP2);
txWaveform_AP2 = wlanVHTData(txDataBits,cfgVHT_AP2);

%% Calculating BER
d = 0:(distAP / 40):(distAP);
d = d(2:end-1);
l = length(d);

mag = zeros(3,l);

BER1 = zeros(1,l);
BER2 = zeros(1,l);

for jj = 1:N
    for kk = 1:(l)
        %% Generating channel and noise
        channelObj = cell(1, nAP);
        for ii = 1:nAP
            channelObj{ii} = TGacChanObj(nTxVec(ii), nRxVec, abs(distAP*(ii-1) - d(kk)));
        end
        noise = sqrt(variance).*randn(size([txWaveform_AP1; zeros(15,nTxVec(1))])); %Gaussian white noise W
        
        %% Estimating channel
        rxVHTLTF_AP1 = channelObj{1}([txVHTLTF_AP1; zeros(15,nTxVec(1))]);
        rxVHTLTF_AP2 = channelObj{2}([txVHTLTF_AP2; zeros(15,nTxVec(2))]);
        
        demodVHTLTF_AP1 = wlanVHTLTFDemodulate(rxVHTLTF_AP1,cfgVHT_AP1.ChannelBandwidth,cfgVHT_AP1.NumSpaceTimeStreams);
        chanEst_AP1 = wlanVHTLTFChannelEstimate(demodVHTLTF_AP1,cfgVHT_AP1.ChannelBandwidth,cfgVHT_AP1.NumSpaceTimeStreams);
        demodVHTLTF_AP2 = wlanVHTLTFDemodulate(rxVHTLTF_AP2,cfgVHT_AP2.ChannelBandwidth,cfgVHT_AP2.NumSpaceTimeStreams);
        chanEst_AP2 = wlanVHTLTFChannelEstimate(demodVHTLTF_AP2,cfgVHT_AP2.ChannelBandwidth,cfgVHT_AP2.NumSpaceTimeStreams);
        
%         mag(kk) = abs(chanEst_AP1(1,1,1));
        
        %% Pass through channel (with zeros to allow for channel delay)
        rxWaveform_AP1 = channelObj{1}([txWaveform_AP1; zeros(15,nTxVec(1))]);
        rxWaveform_AP2 = channelObj{2}([txWaveform_AP2; zeros(15,nTxVec(2))]);
        
        powerDB1 = 10*log10(var(rxWaveform_AP1));
%         mag(1,kk) = abs(powerDB1(1));
        
        rxWaveform1 = rxWaveform_AP1 + noise;
        rxWaveform2 = rxWaveform_AP2 + noise;
        rxWaveform_sum = rxWaveform_AP1 + rxWaveform_AP2 + noise;
        
        %% Recovering data from signal
        snr1 = snr;
        powerDB1 = 10*log10(var(rxWaveform1));
        noiseVarEst1 = mean(10.^(0.1*(powerDB1 - snr1)));
        rxDataBits1 = wlanVHTDataRecover(rxWaveform1,chanEst_AP1,noiseVarEst1,cfgVHT_AP1,1);
        
        mag(1,kk) = abs(powerDB1(1));
        powerDB2 = 10*log10(var(rxWaveform2));
        mag(2,kk) = abs(powerDB2(1));
        
        snr2 = snr + 3;
        powerDB_sum = 10*log10(var(rxWaveform_sum));
        noiseVarEst_sum = mean(10.^(0.1*(powerDB_sum - snr2)));
        rxDataBits = wlanVHTDataRecover(rxWaveform_sum,chanEst_AP1+chanEst_AP2,noiseVarEst_sum,cfgVHT_AP1,1);
        
        mag(3,kk) = abs(powerDB_sum(1));
        
        %% Calculating BER
        BER1(kk) = BER1(kk) + sum(xor(txDataBits,rxDataBits1))/length(txDataBits);
        BER2(kk) = BER2(kk) + sum(xor(txDataBits,rxDataBits))/length(txDataBits);
    end
    fprintf('Iter-%d', jj);
end

BER1 = BER1 / N;
BER2 = BER2 / N;

%% Ploting the graphs
figure
plot(mag(1,:))
hold on
plot(mag(2,:))
plot(mag(3,:))
figure
plot(d,BER1);
hold on;
plot(d,BER2);
grid on;
legend('Single AP','2 AP JT','location',"northwest");
% title(['BER plot for (SNR - ' num2str(snr) ')']);
title('BER plot');
xlabel('Dist');
ylabel('BER');
hold off;