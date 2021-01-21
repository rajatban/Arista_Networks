%% TGAC test

%  Generate a time domain waveform for an 802.11ac VHT packet, pass it
%  through a TGac fading channel and perform VHT-LTF channel
%  estimation.

nTx = 2;
nRx = 2;
dist = 1;

cfgVHT = wlanVHTConfig;       % Create packet configuration
cfgVHT.NumTransmitAntennas = nTx;
cfgVHT.NumSpaceTimeStreams = nRx;

txWaveform = wlanWaveformGenerator([1;0;0;1],cfgVHT);

% Configure channel
tgacChannel = wlanTGacChannel;
tgacChannel.DelayProfile = 'Model-A';
tgacChannel.SampleRate = 80e6;
tgacChannel.NumTransmitAntennas = nTx;
tgacChannel.NumReceiveAntennas = nRx;
tgacChannel.TransmitReceiveDistance = dist;
tgacChannel.ChannelBandwidth = 'CBW80';
tgacChannel.PathGainsOutputPort=1;

% Pass through channel (with zeros to allow for channel delay)
[rxWaveform,h] = tgacChannel([txWaveform; zeros(15,nTx)]);
rxWaveform = rxWaveform(5:end,:); % Synchronize for channel delay

% Extract VHT-LTF and perform channel estimation
indVHTLTF = wlanFieldIndices(cfgVHT,'VHT-LTF');
sym = wlanVHTLTFDemodulate(rxWaveform( ...
    indVHTLTF(1):indVHTLTF(2),:),cfgVHT);
est = wlanVHTLTFChannelEstimate(sym,cfgVHT);