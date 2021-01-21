clear all
close all
% To check the consistancy of the theoretical derivations
N=1e4;
Nr=4;
Nt=Nr;
alpha=4;

P=10;
Rd=20;
rl=0:2:Rd;
SNR = 40;
No = P*10^(-0.1*SNR); % sigma^2;
for ir=1:length(rl)
    % JT
    Rate_JT=[];D=[];Rate_NJ=[];
    for ii=1:N
        r=rl(ir);
        h1=1/sqrt(2)*[randn(Nr,Nt) + 1j*randn(Nr,Nt)]*(1+r)^(-alpha/2);
        [Q1,R1] = qr(h1);
        h2=1/sqrt(2)*[randn(Nr,Nt) + 1j*randn(Nr,Nt)]*(1+Rd-r)^(-alpha/2);
        [Q2,R2] = qr(h2);
        D=abs(diag(R1)).^2+abs(diag(R2)).^2;
        Rate=sum(log2(1+D*P/No));
        Rate_JT=[Rate_JT,Rate];
        Rate_NJ=[Rate_NJ,sum(log2(1+abs(diag(R1)).^2*P/No))];
    end
    avg_rate(ir)=mean(Rate_JT);
    avg_rate_nj(ir)=mean(Rate_NJ);
end
plot(rl,avg_rate,rl,avg_rate_nj)