clear all
clc
N_times=1e3;
M=4;% Modulation Type
Nr=4;
SNR_dB=0:10:20;
[errNJT] = QR_THP_BER(SNR_dB, Nr, M, N_times)
[err_JT] = CoMP_QR_THP(SNR_dB, Nr, M, N_times)