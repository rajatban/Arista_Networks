%% Simulator test
N = 50;

nTx = 2;
nRx = 2;
distAP = 10;
gain = 1;
noisePowerDB = -63;
variance = 10^(0.1*noisePowerDB);  % Noise Power = Variance * Sampling time

plotGraph = true;
 
%% signal generator
% transmission parameters
cfgVHT1 = wlanVHTConfig;       % Create packet configuration
cfgVHT1.NumTransmitAntennas = nTx;
cfgVHT1.NumSpaceTimeStreams = nRx;

cfgVHT2 = wlanVHTConfig;       % Create packet configuration
cfgVHT2.NumTransmitAntennas = nTx;
cfgVHT2.NumSpaceTimeStreams = nRx;

% generating data
txDataBits = randi([0 1],8*cfgVHT1.PSDULength,1);
%txDataBits = ones(8*cfgVHT.PSDULength,1);

% generating waveform
txVHTLTF1  = wlanVHTLTF(cfgVHT1);
txWaveform1 = wlanVHTData(txDataBits,cfgVHT1);

txVHTLTF2  = wlanVHTLTF(cfgVHT2);
txWaveform2 = wlanVHTData(txDataBits,cfgVHT2);

%% Power variation
% multiplying gain
txVHTLTF1  = gain .* txVHTLTF1;
txWaveform1 = gain .* txWaveform1;
txVHTLTF2  = gain .* txVHTLTF2;
txWaveform2 = gain .* txWaveform2;

% calc transmit power
powerDB11 = 10*log10(var(txVHTLTF1));
powerDB12 = 10*log10(var(txWaveform1));

powerDB21 = 10*log10(var(txVHTLTF2));
powerDB22 = 10*log10(var(txWaveform2));

disp(['tx LTF power(with gain)1    : ' num2str(powerDB11)]);
disp(['tx signal power(with gain)1 : ' num2str(powerDB12)]);
disp(['tx LTF power(with gain)2    : ' num2str(powerDB21)]);
disp(['tx signal power(with gain)2 : ' num2str(powerDB22)]);

%% Passing through channel
% generating channel
d = 5;

P = 1;
p = 0:0.1:P;
l = length(p);


powerDB13 = zeros([l, 2]);
powerDB14 = zeros(l, 2);
powerDB23 = zeros(l, 2);
powerDB24 = zeros(l, 2);
powerDB5 = zeros(l, 2);
powerDB6 = zeros(l, 2);

BER1 = zeros(1, l);
BER2 = zeros(1, l);

for jj = 1:N
    tgacChannel1 = TGacChanObj(nTx, nRx, d);
    tgacChannel2 = TGacChanObj(nTx, nRx, distAP - d);
    
    noise = sqrt(variance).*(randn(size([txWaveform1; zeros(15,nTx)])) + 1i * randn(size([txWaveform1; zeros(15,nTx)]))); %Gaussian white noise W
    
    rxVHTLTF1 = tgacChannel1([txVHTLTF1; zeros(15,nTx)]);
    rxWaveform1 = tgacChannel1([txWaveform1; zeros(15,nTx)]);
    
    rxVHTLTF2 = tgacChannel2([txVHTLTF2; zeros(15,nTx)]);
    rxWaveform2 = tgacChannel2([txWaveform2; zeros(15,nTx)]);
    
    %% Estimating channel
    demodVHTLTF1 = wlanVHTLTFDemodulate(rxVHTLTF1,cfgVHT1.ChannelBandwidth,cfgVHT1.NumSpaceTimeStreams);
    chanEst1 = wlanVHTLTFChannelEstimate(demodVHTLTF1,cfgVHT1.ChannelBandwidth,cfgVHT1.NumSpaceTimeStreams);
    demodVHTLTF2 = wlanVHTLTFDemodulate(rxVHTLTF2,cfgVHT2.ChannelBandwidth,cfgVHT2.NumSpaceTimeStreams);
    chanEst2 = wlanVHTLTFChannelEstimate(demodVHTLTF2,cfgVHT2.ChannelBandwidth,cfgVHT2.NumSpaceTimeStreams);
    
    demodVHTLTFsum = wlanVHTLTFDemodulate(rxVHTLTF1 + rxVHTLTF2,cfgVHT1.ChannelBandwidth,cfgVHT1.NumSpaceTimeStreams);
    chanEstsum = wlanVHTLTFChannelEstimate(demodVHTLTFsum,cfgVHT1.ChannelBandwidth,cfgVHT1.NumSpaceTimeStreams);
    
    % calc transmit power
    powerDB11 = powerDB11 + 10*log10(var(rxVHTLTF1));
    powerDB12 = powerDB12 + 10*log10(var(rxWaveform1));
    
    powerDB21 = powerDB21 + 10*log10(var(rxVHTLTF2));
    powerDB22 = powerDB22 + 10*log10(var(rxWaveform2));
    
    powerDBNoise1 = 10*log10(var(noise));
    
    %disp(['rx LTF power(with gain)1    : ' num2str(powerDB11)]);
    disp(['\nrx signal power(with gain)1 : ' num2str(powerDB12)]);
    %disp(['rx LTF power(with gain)2    : ' num2str(powerDB21)]);
    disp(['rx signal power(with gain)2 : ' num2str(powerDB22)]);
    disp(['noise signal power          : ' num2str(powerDBNoise1)]);
    

    for ii = 1:l
        rxVHTLTF1 = tgacChannel1(sqrt(P - p(ii)).*[txVHTLTF1; zeros(15,nTx)]);
        rxWaveform1 = tgacChannel1(sqrt(P - p(ii)).*[txWaveform1; zeros(15,nTx)]);
        
        rxVHTLTF2 = tgacChannel2(sqrt(p(ii)).*[txVHTLTF2; zeros(15,nTx)]);
        rxWaveform2 = tgacChannel2(sqrt(p(ii)).*[txWaveform2; zeros(15,nTx)]);
        
        rxVHTLTF_sum = rxVHTLTF1 + rxVHTLTF2;
        rxWaveform_sum = rxWaveform1 + rxWaveform2;
        
        % calc receive power
        powerDB13(ii,:) = powerDB13(ii,:) + 10*log10(var(rxVHTLTF1));
        powerDB14(ii,:) = powerDB14(ii,:) + 10*log10(var(rxWaveform1));
        powerDB23(ii,:) = powerDB23(ii,:) + 10*log10(var(rxVHTLTF2));
        powerDB24(ii,:) = powerDB24(ii,:) + 10*log10(var(rxWaveform2));
        powerDB5(ii,:) = powerDB5(ii,:) + 10*log10(var(rxVHTLTF_sum));
        powerDB6(ii,:) = powerDB6(ii,:) + 10*log10(var(rxWaveform_sum));
        
        % recover signal
        
        
        noiseVarEst_sum = 10^(0.1*mean(powerDBNoise1));
        rxDataBits = wlanVHTDataRecover((rxWaveform_sum + noise),chanEstsum,noiseVarEst_sum,cfgVHT1,1);
        
        %% Calculating BER
    %     BER1(ll) = BER1(ll) + sum(xor(txDataBits,rxDataBits1))/length(txDataBits);
        BER2(ii) = BER2(ii) + sum(xor(txDataBits,rxDataBits))/length(txDataBits);
    end
end
if plotGraph
    figure
    plot(p, powerDB12(1)/N.* ones(1, l));
    hold on;
    plot(p, powerDB22(1)/N.* ones(1, l));
    plot(p, powerDB14(:,1)./N);
    plot(p, powerDB24(:,1)./N);
    plot(p, powerDB6(:,1)./N);
    xlabel('Power gain AP2');
    ylabel('Signal power(dB)');
    legend('rxPower1','rxPower2','rxPower1(with gain)','rxPower2(with gain)','rxPowerSum', 'Location',"best");
    title(['Received signal power for 2 APs (dist' num2str(d) ')']);
    
    figure
    plot(p, BER2./N);
    xlabel('Power gain AP2');
    ylabel('BER');
    title(['BER for 2 APs (dist ' num2str(d) ')']);
end
