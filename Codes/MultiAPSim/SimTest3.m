%% Simulator test
nTx = 2;
nRx = 2;
distAP = 5;
gain = 1;

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
d = 0:(distAP / 40):(distAP);
d = d(2:end-1);
l = length(d);

powerDB13 = zeros(l, 2);
powerDB14 = zeros(l, 2);
powerDB23 = zeros(l, 2);
powerDB24 = zeros(l, 2);
powerDB5 = zeros(l, 2);
powerDB6 = zeros(l, 2);

for ii = 1:l
    tgacChannel1 = TGacChanObj(nTx, nRx, d(ii));
    tgacChannel2 = TGacChanObj(nTx, nRx, distAP - d(ii));
    
    rxVHTLTF1 = tgacChannel1([txVHTLTF1; zeros(15,nTx)]);
    rxWaveform1 = tgacChannel1([txWaveform1; zeros(15,nTx)]);
    
    rxVHTLTF2 = tgacChannel2([txVHTLTF2; zeros(15,nTx)]);
    rxWaveform2 = tgacChannel2([txWaveform2; zeros(15,nTx)]);
    
    rxVHTLTF_sum = rxVHTLTF1 + rxVHTLTF2;
    rxWaveform_sum = rxWaveform1 + rxWaveform2;
    
    % calc receive power
    powerDB13(ii,:) = 10*log10(var(rxVHTLTF1));
    powerDB14(ii,:) = 10*log10(var(rxWaveform1));
    powerDB23(ii,:) = 10*log10(var(rxVHTLTF2));
    powerDB24(ii,:) = 10*log10(var(rxWaveform2));
    powerDB5(ii,:) = 10*log10(var(rxVHTLTF_sum));
    powerDB6(ii,:) = 10*log10(var(rxWaveform_sum));
end

if plotGraph
    figure
    plot(d, powerDB12(1).* ones(1, l));
    hold on;
    plot(d, powerDB14(:,1));
    plot(d, powerDB24(:,1));
    plot(d, powerDB6(:,1));
    xlabel('Distance(m)');
    ylabel('Signal power(dB)');
    legend('txPower','rxPower1','rxPower2','rxPowerSum');
    title('Signal power vs Distance for 2 APs');
end
