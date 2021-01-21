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
cfgVHT.ChannelBandwidth='CBW80';
% Configure channel
tgacChannel = wlanTGacChannel;
tgacChannel.SampleRate = 80e6;
tgacChannel.NumTransmitAntennas = nTx;
tgacChannel.NumReceiveAntennas = nRx;
tgacChannel.ChannelBandwidth = 'CBW80';
%tgacChannel.PathGainsOutputPort=1;
dist1=2.5;Dist=5;
tgacChannel1=tgacChannel;
tgacChannel2=tgacChannel;
tgacChannel1.TransmitReceiveDistance = dist1;
tgacChannel2.TransmitReceiveDistance = Dist-dist1; % such that dist1+dist2=Dist
snr=-10:5:20;
txDataBits = randi([0 1],8*cfgVHT.PSDULength,1);
%% txWaveform = wlanWaveformGenerator([txDataBits,cfgVHT);// generate from databits directly

txVHTLTF  = wlanVHTLTF(cfgVHT);
txWaveform = wlanVHTData(txDataBits,cfgVHT);

% Pass through channel (with zeros to allow for channel delay)
rxWaveform1 = tgacChannel1([txWaveform; zeros(15,nTx)]);
rxVHTLTF1 = tgacChannel1([txVHTLTF; zeros(15,nTx)]);
demodVHTLTF1 = wlanVHTLTFDemodulate(rxVHTLTF1,cfgVHT.ChannelBandwidth,cfgVHT.NumSpaceTimeStreams);
chanEst1 = wlanVHTLTFChannelEstimate(demodVHTLTF1,cfgVHT.ChannelBandwidth,cfgVHT.NumSpaceTimeStreams);

rxWaveform2 = tgacChannel2([txWaveform; zeros(15,nTx)]);
rxVHTLTF2 = tgacChannel2([txVHTLTF; zeros(15,nTx)]);
demodVHTLTF2 = wlanVHTLTFDemodulate(rxVHTLTF2,cfgVHT.ChannelBandwidth,cfgVHT.NumSpaceTimeStreams);
chanEst2 = wlanVHTLTFChannelEstimate(demodVHTLTF2,cfgVHT.ChannelBandwidth,cfgVHT.NumSpaceTimeStreams);

%%//txWaveform remains the same %for both
% awgn(txVHTLTF*H1,snr,'measured');
for ii=1:length(snr)
    rxWaveform_sum=awgn(rxWaveform1+rxWaveform2,snr(ii),'measured');
    powerDB1 = 10*log10(var(rxWaveform_sum));
    noiseVarEst1 = mean(10.^(0.1*(powerDB1-snr(ii))));
    rxDataBits = wlanVHTDataRecover(rxWaveform_sum,chanEst1+chanEst2,noiseVarEst1,cfgVHT,1);
    ber(ii)=sum(xor(txDataBits,rxDataBits))/length(txDataBits);
end