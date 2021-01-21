% TGAC test

%  Generate a time domain waveform for an 802.11ac VHT packet, pass it
%  through a TGac fading channel and perform VHT-LTF channel
%  estimation.

nTx = 2;
nRx = 2;
dist = 1;

cfgVHT = wlanVHTConfig;       % Create packet configuration
cfgVHT.NumTransmitAntennas = nTx;
cfgVHT.NumSpaceTimeStreams = nRx;

% Configure channel
tgacChannel = wlanTGacChannel;
tgacChannel.SampleRate = 80e6;
tgacChannel.NumTransmitAntennas = nTx;
tgacChannel.NumReceiveAntennas = nRx;
tgacChannel.ChannelBandwidth = 'CBW80';
%tgacChannel.PathGainsOutputPort=1;

tgacChannel1.TransmitReceiveDistance = dist1;
tgacChannel2.TransmitReceiveDistance = Dist-dist1;%such that dist1+dist2=Dist


txDataBits = randi([0 1],8*cfgVHT.PSDULength,1);

%//txWaveform = wlanWaveformGenerator([txDataBits,cfgVHT);// generate from databits directly

txVHTLTF  = wlanVHTLTF(cfgVHT);
txWaveform = wlanVHTData(txDataBits,cfgVHT);

% Pass through channel (with zeros to allow for channel delay)
rxWaveform1 = tgacChannel1([txWaveform; zeros(15,nTx)]);
rxVHTLTF1 = tgacChannel1([txVHTLTF; zeros(15,nTx)]);
demodVHTLTF1 = wlanVHTLTFDemodulate(rxVHTLTF1,cfgVHT.cbw,cfgVHT.numSTS);
chanEst1 = wlanVHTLTFChannelEstimate(demodVHTLTF1,cfgVHT.cbw,cfgVHT.numSTS);

rxWaveform2 = tgacChannel2([txWaveform; zeros(15,nTx)]);
rxVHTLTF2 = tgacChannel2([txVHTLTF; zeros(15,nTx)]);
demodVHTLTF2 = wlanVHTLTFDemodulate(rxVHTLTF2,cfgVHT.cbw,cfgVHT.numSTS);
chanEst2 = wlanVHTLTFChannelEstimate(demodVHTLTF2,cfgVHT.cbw,cfgVHT.numSTS);

%//txWaveform remains the same %for both

rxDataBits = wlanVHTDataRecover(rxWaveform1+rxWaveform2,chanEst1+chanEst2,noiseVarEst1,cfgVHT,1);
scatterplot(chanEst2)
grid

%compare rxDataBits1 and txDataBits
%generate the BER statistics

rxWaveform = rxWaveform(5:end,:); % Synchronize for channel delay

% Extract VHT-LTF and perform channel estimation
indVHTLTF = wlanFieldIndices(cfgVHT,'VHT-LTF');
sym = wlanVHTLTFDemodulate(rxWaveform( ...
    indVHTLTF(1):indVHTLTF(2),:),cfgVHT);
est = wlanVHTLTFChannelEstimate(sym,cfgVHT);