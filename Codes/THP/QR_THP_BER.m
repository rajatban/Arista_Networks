function [err] = QR_THP_BER(SNR_dB, Nr, M, N_times)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

% clear all
% clc
% N_times=1e3;
% M=4;% Modulation Type
% Nr=4;
% SNR_dB=0:10:50;

Nt=Nr;
Mod_vect=4*ones(Nr,1);
A_mod=sqrt(Mod_vect./M);  %for modulo operation in thp
A_mod1=(M/(2*(M-1)/3))^0.5*ones(Nr,1);

Es=mean(abs(A_mod).^2);
load 'constellation_LUT';
info_bits=[];info_a=[];info_bits_est=[];
for k=1:length(SNR_dB)
for ii=1:N_times
    H=1/sqrt(2)*[randn(Nr,Nt) + 1j*randn(Nr,Nt)];
    %THP precoding parameters
    [Q,R]=qr(H');
    L=R';
    Q=Q';   % LQ factorisation
    S=diag(diag(L));
    B=inv(S)*L;
    yl=[];
    l=[];
    a=[];
    for nbs=1:Nr
        Data=randn(M,1)>.5;
        Data=Data+0;
        info_bits=[info_bits;Data]; % for ber calculations
        data1 = dig_modulations_LUT(Data,M);
        a=[a;data1];
    end    
    y=THP_precTX(B,Q,A_mod,a,Nr);
    SNR_k=10^(SNR_dB(k)/10);
    No=Es/SNR_k;
    yr=H*y+sqrt(No)*1/sqrt(2)*[randn(Nr,1) + 1j*randn(Nr,1)];
    Y2=THP_precRX(A_mod,yr,Nr,S);
    [bits] = dig_demodulations_LUT(Y2,M);
    info_bits_est=[info_bits_est; bits];
end
err(k)=sum(info_bits~=info_bits_est)/length(info_bits_est);
end
end

