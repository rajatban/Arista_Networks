clear
close all;
SNR=60;
Rd=20;
Nr=1;
Nt=Nr;
N_iter=1e4;
P1=10;                             % dB
P2=10;
No = P1/10^(SNR/10);
alpha=4;
dist=0.5:0.35:20-0.5;

for ii=1:length(dist)
    r1=dist(ii);
    r2=Rd-r1;
    for ij=1:N_iter
        % ZF-DPC 2AP JT
        h1=1/sqrt(2)*[randn(Nr,Nt) + 1j*randn(Nr,Nt)]*r1^(-alpha/2);
        h2=1/sqrt(2)*[randn(Nr,Nt) + 1j*randn(Nr,Nt)]*r2^(-alpha/2);
        [~,R1] = qr(h1);
        [~,R2] = qr(h2);
        S=(P1/Nt*abs(diag(R1)).^2+P2/Nt*abs(diag(R2)).^2);
        C_ZF_JT_i(ij)=sum(log2(1+S/No));
        % SAPT
        S=(abs(diag(R1)).^2)*P1/Nt;
        C_SAPT_i(ij)=sum(log2(1+S/No));
        % SAPI
        I=sum((abs(h2).^2)*P2/Nt,2);
        SINR=S./(I+No);
        C_SAPI_i(ij)=sum(log2(1+SINR));
    end
    C_ZF_JT(ii)=mean(C_ZF_JT_i);
    C_SAPT(ii)=mean(C_SAPT_i);
    C_SAPI(ii)=mean(C_SAPI_i);
end

plot(dist,C_ZF_JT,'b'); hold on
plot(dist,C_SAPT,'r')
plot(dist,C_SAPI,'g');