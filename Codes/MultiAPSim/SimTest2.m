%% Simulator test
nTx = 2;
nRx = 2;
distAP = 5;
gain = 1;

plotGraph = true;

%% signal generator
% transmission parameters
cfgVHT = wlanVHTConfig;       % Create packet configuration
cfgVHT.NumTransmitAntennas = nTx;
cfgVHT.NumSpaceTimeStreams = nRx;

% generating data
txDataBits = randi([0 1],8*cfgVHT.PSDULength,1);
%txDataBits = ones(8*cfgVHT.PSDULength,1);

% generating waveform
txVHTLTF  = wlanVHTLTF(cfgVHT);
txWaveform = wlanVHTData(txDataBits,cfgVHT);

%% Power variation
% multiplying gain
txVHTLTF1  = gain .* txVHTLTF;
txWaveform1 = gain .* txWaveform;

% calc transmit power
powerDB1 = 10*log10(var(txVHTLTF1));
powerDB2 = 10*log10(var(txWaveform1));

disp(['tx LTF power(with gain)    : ' num2str(powerDB1)]);
disp(['tx signal power(with gain) : ' num2str(powerDB2)]);

%% Passing through channel
% generating channel
d = 0:(distAP / 40):(distAP);
d = d(2:end-1);
l = length(d);

powerDB3 = zeros(l, 2);
powerDB4 = zeros(l, 2);

for ii = 1:l
    tgacChannel = TGacChanObj(nTx, nRx, d(ii));
    
    rxVHTLTF = tgacChannel([txVHTLTF1; zeros(15,nTx)]);
    rxWaveform = tgacChannel([txWaveform1; zeros(15,nTx)]);
    
    % calc receive power
    powerDB3(ii,:) = 10*log10(var(rxVHTLTF));
    powerDB4(ii,:) = 10*log10(var(rxWaveform));
end

if plotGraph
    figure
    plot(d, powerDB2(1).* ones(1, l));
    hold on;
    plot(d, powerDB4(:,1));
    xlabel('Distance(m)');
    ylabel('Signal power(dB)');
    legend('txPower','rxPower');
    title('Signal power vs Distance for 1 AP');
end
