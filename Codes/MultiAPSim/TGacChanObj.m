function tgacChannel = TGacChanObj(nTx, nRx, dist)
    %TGACCHANMAT Summary of this function goes here
    %   Detailed explanation goes here
    
%     cfgVHT = wlanVHTConfig;       % Create packet configuration
%     cfgVHT.NumTransmitAntennas = nTx;
%     cfgVHT.NumSpaceTimeStreams = nRx;
%     
%     txWaveform = wlanWaveformGenerator([1;0;0;1],cfgVHT);
    
    % Configure channel
    tgacChannel = wlanTGacChannel;
    tgacChannel.DelayProfile = 'Model-B';
    tgacChannel.SampleRate = 80e6;
    tgacChannel.NumTransmitAntennas = nTx;
    tgacChannel.NumReceiveAntennas = nRx;
    tgacChannel.ChannelBandwidth = 'CBW80';
    tgacChannel.TransmitReceiveDistance = dist;
    %tgacChannel.UserIndex = 1;
    tgacChannel.LargeScaleFadingEffect = 'Pathloss';
    tgacChannel.PathGainsOutputPort=1;
    
%     % Pass through channel (with zeros to allow for channel delay)
%     rxWaveform = tgacChannel([txWaveform; zeros(15,nTx)]);
%     rxWaveform = rxWaveform(5:end,:); % Synchronize for channel delay
%     
%     % Extract VHT-LTF and perform channel estimation
%     indVHTLTF = wlanFieldIndices(cfgVHT,'VHT-LTF');
%     sym = wlanVHTLTFDemodulate(rxWaveform( ...
%         indVHTLTF(1):indVHTLTF(2),:),cfgVHT);
%     est = wlanVHTLTFChannelEstimate(sym,cfgVHT);
%     
%     h = squeeze(est(2,:,:));
end