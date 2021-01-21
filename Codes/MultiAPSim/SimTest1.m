%% Simulator test
nTx = 2;
nRx = 2;
d = 0.1;

plotGraph = false;

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

% calc transmit power
powerDB1 = 10*log10(var(txVHTLTF));
powerDB2 = 10*log10(var(txWaveform));

disp(['tx LTF power    : ' num2str(powerDB1)]);
disp(['tx signal power : ' num2str(powerDB2)]);

if plotGraph
    figure
    plot(txVHTLTF(:,1),'.');
    title('tx LTF');
    figure
    plot(txWaveform(:,1),'.');
    title('tx signal');
end
%% Power variation

gain = 1.414;

% multiplying gain
txVHTLTF1  = gain .* txVHTLTF;
txWaveform1 = gain .* txWaveform;

% calc transmit power
powerDB3 = 10*log10(var(txVHTLTF1));
powerDB4 = 10*log10(var(txWaveform1));

disp(['tx LTF power(with gain)    : ' num2str(powerDB3)]);
disp(['tx signal power(with gain) : ' num2str(powerDB4)]);

if plotGraph
    figure
    plot(txVHTLTF1(:,1),'.');
    title('tx LTF with gain');
    figure
    plot(txWaveform1(:,1),'.');
    title('tx signal with gain');
end

%% Passing through channel
% generating channel
tgacChannel = TGacChanObj(nTx, nRx, d);

rxVHTLTF = tgacChannel([txVHTLTF1; zeros(15,nTx)]);
rxWaveform = tgacChannel([txWaveform1; zeros(15,nTx)]);

% calc receive power
powerDB5 = 10*log10(var(rxVHTLTF));
powerDB6 = 10*log10(var(rxWaveform));

disp(['rx LTF power    : ' num2str(powerDB5)]);
disp(['rx signal power : ' num2str(powerDB6)]);

if plotGraph
    figure
    plot(rxVHTLTF(:,1),'.');
    title('rx LTF with gain');
    figure
    plot(rxWaveform(:,1),'.');
    title('rx signal with gain');
end
