clear all
%% Create a VHT configuration object having a 160 MHz channel bandwidth, two users, and four transmit antennas. 
%% Assign one space-time stream to the first user and three space-time streams to the second user.
cbw = 'CBW160';
numSTS = [1 3];
vht = wlanVHTConfig('ChannelBandwidth',cbw,'NumUsers',2, ...
    'NumTransmitAntennas',4,'NumSpaceTimeStreams',numSTS);
%% Because there are two users, the PSDU length is a 1-by-2 row vector.
% psduLen = vht.PSDULength; % No use
% vht.PSDULength=[100*1050,100*3156]; %read-only property 'PSDULength'
%% Generate multiuser input data. This data must be in the form of a 1-by- N cell array, 
%% where N is the number of users.
txDataBits{1} = randi([0 1],8*vht.PSDULength(1),1);
txDataBits{2} = randi([0 1],8*vht.PSDULength(2),1);

%% Generate VHT-LTF and VHT-Data field signals.
txVHTLTF  = wlanVHTLTF(vht); 
txVHTData = wlanVHTData(txDataBits,vht);

%% Pass the data field for the first user through a 4x1 channel because it consists of a single space-time stream. 
% Pass the second user's data through a 4x3 channel because it consists of three space-time streams. 
% Apply white Gaussian noise to each user signal.



snr = 50;
H1 = 1/sqrt(2)*complex(randn(4,1),randn(4,1));
H2 = 1/sqrt(2)*complex(randn(4,3),randn(4,3));

rxVHTData1 = awgn(txVHTData*H1,snr,'measured');
rxVHTData2 = awgn(txVHTData*H2,snr,'measured');

%% Repeat the process for the VHT-LTF fields.
rxVHTLTF1  = awgn(txVHTLTF*H1,snr,'measured');
rxVHTLTF2  = awgn(txVHTLTF*H2,snr,'measured');

%% Calculate the received signal power for both users and use it to estimate the noise variance.
powerDB1 = 10*log10(var(rxVHTData1));
noiseVarEst1 = mean(10.^(0.1*(powerDB1-snr)));

powerDB2 = 10*log10(var(rxVHTData2));
noiseVarEst2 = mean(10.^(0.1*(powerDB2-snr)));

%% Estimate the channel characteristics using the VHT-LTF fields.
demodVHTLTF1 = wlanVHTLTFDemodulate(rxVHTLTF1,cbw,numSTS);
chanEst1 = wlanVHTLTFChannelEstimate(demodVHTLTF1,cbw,numSTS);

demodVHTLTF2 = wlanVHTLTFDemodulate(rxVHTLTF2,cbw,numSTS);
chanEst2 = wlanVHTLTFChannelEstimate(demodVHTLTF2,cbw,numSTS);

%% Recover VHT-Data field bits for the first user and compare against the original payload bits.
rxDataBits1 = wlanVHTDataRecover(rxVHTData1,chanEst1,noiseVarEst1,vht,1);
[~,ber1] = biterr(txDataBits{1},rxDataBits1)

rxDataBits2 = wlanVHTDataRecover(rxVHTData2,chanEst2,noiseVarEst2,vht,2);
[~,ber2] = biterr(txDataBits{2},rxDataBits2)