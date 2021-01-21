% function [err] = CoMP_QR_THP(SNR_dB, Nr, M, N_times)
clear all
clc
N_times=1e3;
M=2;% Modulation Type
Nr=4;
SNR_dB=0:10:20;

Nt=Nr;
Mod_vect=4*ones(Nr,1);
A_mod=sqrt(Mod_vect./M);  %for modulo operation in thp
% A_mod=(M/(2*(M-1)/3))^0.5*ones(Nr,1);
Es=mean(abs(A_mod).^2);
D=[];
load 'constellation_LUT';
info_bits=[];info_a=[];info_bits_est=[];
for k=1:length(SNR_dB)
for ii=1:N_times
    % First AP THP
    H1=1/sqrt(2)*[randn(Nr,Nt) + 1j*randn(Nr,Nt)];
    [Q1,R1]=qr(H1');
    L1=R1';
    Q1=Q1';   % LQ factorisation
    S1=diag(diag(L1));
    B1=inv(S1)*L1;
    
    % Second AP THP
    H2=1/sqrt(2)*[randn(Nr,Nt) + 1j*randn(Nr,Nt)];
    [Q2,R2]=qr(H2');
    L2=R2';
    Q2=Q2';   % LQ factorisation
    S2=diag(diag(L2));
    B2=inv(S2)*L2;
    
    a=[];
    for nbs=1:Nr
        Data=randn(M,1)>.5;
        Data=Data+0;
        info_bits=[info_bits;Data]; % for ber calculations
        data1 = dig_modulations_LUT(Data,M);
        a=[a;data1];
    end    
    y1=THP_precTX(B1,Q1,A_mod,a,Nr);
    y2=THP_precTX(B2,Q2,A_mod,a,Nr);
    SNR_k=10^(SNR_dB(k)/10);
    No=Es/SNR_k;
    yr=H1*y1+H2*y2;%+sqrt(No)*1/sqrt(2)*[randn(Nr,1) + 1j*randn(Nr,1)];
    Y2=JT_THP_precRX(A_mod,yr,Nr,S1,S2);
    [bits] = dig_demodulations_LUT(Y2,M);
    info_bits_est=[info_bits_est; bits];
end
err(k)=sum(info_bits~=info_bits_est)/length(info_bits_est);
end