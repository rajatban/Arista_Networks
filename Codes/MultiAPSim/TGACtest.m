% TGAC test

%  Generate a time domain waveform for an 802.11ac VHT packet, pass it
%  through a TGac fading channel and perform VHT-LTF channel
%  estimation.

nTx = 2;
nRx = 2;
Dist = 5;
dist1 = 1;

cfgVHT = wlanVHTConfig;       % Create packet configuration
cfgVHT.NumTransmitAntennas = nTx;
cfgVHT.NumSpaceTimeStreams = nRx;

txWaveform = wlanWaveformGenerator([1;0;0;1],cfgVHT);

psdu = wlanVHTData.PSDULength;
txWavefowm = wlanVHTData([1;0;0;1],cfgVHT);

% Configure channel
tgacChannel1 = wlanTGacChannel;
tgacChannel1.SampleRate = 80e6;
tgacChannel1.DelayProfile = 'Model-A';
tgacChannel1.NumTransmitAntennas = nTx;
tgacChannel1.NumReceiveAntennas = nRx;
tgacChannel1.TransmitReceiveDistance = dist1;
tgacChannel1.ChannelBandwidth = 'CBW80';
tgacChannel1.PathGainsOutputPort = 1;

tgacChannel2 = wlanTGacChannel;
tgacChannel2.SampleRate = 80e6;
tgacChannel2.DelayProfile = 'Model-A';
tgacChannel2.NumTransmitAntennas = nTx;
tgacChannel2.NumReceiveAntennas = nRx;
tgacChannel2.TransmitReceiveDistance = Dist - dist1;
tgacChannel2.ChannelBandwidth = 'CBW80';
tgacChannel2.PathGainsOutputPort = 1;

% Pass through channel (with zeros to allow for channel delay)
[rxWaveform1, h1] = tgacChannel1([txWaveform; zeros(15,nTx)]);
[rxWaveform2, h2] = tgacChannel2([txWaveform; zeros(15,nTx)]);
rxWaveform = rxWaveform1(5:end,:); % Synchronize for channel delay

% Extract VHT-LTF and perform channel estimation
indVHTLTF = wlanFieldIndices(cfgVHT,'VHT-LTF');
sym = wlanVHTLTFDemodulate(rxWaveform( ...
    indVHTLTF(1):indVHTLTF(2),:),cfgVHT);
est = wlanVHTLTFChannelEstimate(sym,cfgVHT);

