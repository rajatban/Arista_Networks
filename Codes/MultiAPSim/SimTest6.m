%% Simulator test
N = 10;        % no of iterations

d = d + 0.25;

nTx = 2;       % no of tx antennas
nRx = 2;       % no of rx antennas
distAP = 5;    % distance betwenn APs
gain = 1;      % initial gain (not used)
noisePowerDB = -63;   % noise power
variance = 10^(0.1*noisePowerDB);  % Noise Power = Variance * Sampling time

plotGraph = true;   % boolean to plot graph (not used)
 
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
P = 4;
p = 0:(P/10):P;      % powers
l = length(p);


powerDB13 = zeros([l, 2]);  % recieved LTF power of AP1 with gains
powerDB14 = zeros(l, 2);    % recieved signal power of AP1 with gains
powerDB23 = zeros(l, 2);    % recieved LTF power of AP2 with gains
powerDB24 = zeros(l, 2);    % recieved signal power of AP2 with gains
powerDB5 = zeros(l, 2);     % total recieved LTF power
powerDB6 = zeros(l, 2);     % total recieved signal power

BER1 = zeros(1, l);       % BER for single AP (not in use)
BER2 = zeros(1, l);       % BER for JT

for jj = 1:N
    %% generating channels
    tgacChannel1 = TGacChanObj(nTx, nRx, d);
    tgacChannel2 = TGacChanObj(nTx, nRx, distAP - d);
    
    noise = sqrt(variance).*(randn(size([txWaveform1; zeros(15,nTx)])) ...
        + randn(size([txWaveform1; zeros(15,nTx)]))); %Gaussian white noise W
    
    %% passing signals through channel
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
    
    %% calc recieved power without gain
    powerDB11 = powerDB11 + 10*log10(var(rxVHTLTF1));
    powerDB12 = powerDB12 + 10*log10(var(rxWaveform1));
    
    powerDB21 = powerDB21 + 10*log10(var(rxVHTLTF2));
    powerDB22 = powerDB22 + 10*log10(var(rxWaveform2));
    
    powerDBNoise1 = 10*log10(var(noise));
    
    %     %disp(['rx LTF power(with gain)1    : ' num2str(powerDB11)]);
    %     disp(['\nrx signal power(with gain)1 : ' num2str(powerDB12)]);
    %     %disp(['rx LTF power(with gain)2    : ' num2str(powerDB21)]);
    %     disp(['rx signal power(with gain)2 : ' num2str(powerDB22)]);
    %     disp(['noise signal power          : ' num2str(powerDBNoise1)]);
    

    for ii = 1:l
        %% passing through channel after applying gains
        rxVHTLTF1 = tgacChannel1(sqrt(P - p(ii)).*[txVHTLTF1; zeros(15,nTx)]);
        rxWaveform1 = tgacChannel1(sqrt(P - p(ii)).*[txWaveform1; zeros(15,nTx)]);
        
        rxVHTLTF2 = tgacChannel2(sqrt(p(ii)).*[txVHTLTF2; zeros(15,nTx)]);
        rxWaveform2 = tgacChannel2(sqrt(p(ii)).*[txWaveform2; zeros(15,nTx)]);
        
        rxVHTLTF_sum = rxVHTLTF1 + rxVHTLTF2;
        rxWaveform_sum = rxWaveform1 + rxWaveform2;
        
        %% calc received signal power
        powerDB13(ii,:) = powerDB13(ii,:) + 10*log10(var(rxVHTLTF1));
        powerDB14(ii,:) = powerDB14(ii,:) + 10*log10(var(rxWaveform1));
        powerDB23(ii,:) = powerDB23(ii,:) + 10*log10(var(rxVHTLTF2));
        powerDB24(ii,:) = powerDB24(ii,:) + 10*log10(var(rxWaveform2));
        powerDB5(ii,:) = powerDB5(ii,:) + 10*log10(var(rxVHTLTF_sum));
        powerDB6(ii,:) = powerDB6(ii,:) + 10*log10(var(rxWaveform_sum));
        
        %% recover signal
        
        noiseVarEst_sum = 10^(0.1*mean(powerDBNoise1));
        rxDataBits = wlanVHTDataRecover((rxWaveform_sum + noise),chanEstsum,noiseVarEst_sum,cfgVHT1,1);
        
        %% Calculating BER
    %     BER1(ll) = BER1(ll) + sum(xor(txDataBits,rxDataBits1))/length(txDataBits);
        BER2(ii) = BER2(ii) + sum(xor(txDataBits,rxDataBits))/length(txDataBits);
    end
    disp(jj);
end

%% Save variables
filename = ['Data/SimData-BER_P-',num2str(P),'_d-',num2str(d),'_v-0.mat'];
save(filename, 'P', 'd', "BER2");
