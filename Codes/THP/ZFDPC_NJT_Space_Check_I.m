function[C]=ZFDPC_NJT_Space_Check_I(SNR,AP_cord,STA_cord,Nr,N_iter)
Nt=Nr;
alpha=4;
% P=10;
% N_iter=1;
% AP_cord=rand(4,2);
% STA_cord=rand(1,2);
dist=vecnorm(AP_cord-STA_cord,2,2); % N = vecnorm(A,p,DIM) finds the p-norm
P=10;                             % dB
No = P/10^(SNR/10);
D=[];
%% Joint Transmission first two APs
for ii=1:N_iter
    h1=1/sqrt(2)*[randn(Nr,Nt) + 1j*randn(Nr,Nt)]*dist(1)^(-alpha/2);
    h2=1/sqrt(2)*[randn(Nr,Nt) + 1j*randn(Nr,Nt)]*dist(2)^(-alpha/2);
    h3=1/sqrt(2)*[randn(Nr,Nt) + 1j*randn(Nr,Nt)]*dist(3)^(-alpha/2);
    h4=1/sqrt(2)*[randn(Nr,Nt) + 1j*randn(Nr,Nt)]*dist(4)^(-alpha/2);
    [~,R1] = qr(h1);
    [~,R2] = qr(h2);
    [~,R3] = qr(h3);
    [~,R4] = qr(h4);
    %% AP 1 DPC
    S=(abs(diag(R1)).^2)*P/Nt;
    I=sum((abs(h2).^2+abs(h3).^2+abs(h4).^2)*P/Nt,2);
    SINR=S./(I+No);
    C_ZF_AP1(ii)=sum(log2(1+SINR));
    
    %% AP 2 DPC
    S=(abs(diag(R2)).^2)*P/Nt;
    I=sum((abs(h1).^2+abs(h3).^2+abs(h4).^2)*P/Nt,2);
    SINR=S./(I+No);
    C_ZF_AP2(ii)=sum(log2(1+SINR));
    %% AP 3 DPC
    S=(abs(diag(R3)).^2)*P/Nt;
    I=sum((abs(h1).^2+abs(h2).^2+abs(h4).^2)*P/Nt,2);
    SINR=S./(I+No);
    C_ZF_AP3(ii)=sum(log2(1+SINR));
    %% AP 4 DPC
    S=(abs(diag(R4)).^2)*P/Nt;
    I=sum((abs(h1).^2+abs(h2).^2+abs(h3).^2)*P/Nt,2);
    SINR=S./(I+No);
    C_ZF_AP4(ii)=sum(log2(1+SINR));
end
C_ZF_AP1=mean(C_ZF_AP1);
C_ZF_AP2=mean(C_ZF_AP2);
C_ZF_AP3=mean(C_ZF_AP3);
C_ZF_AP4=mean(C_ZF_AP4);
C=[C_ZF_AP1,C_ZF_AP2,C_ZF_AP3,C_ZF_AP4];
end