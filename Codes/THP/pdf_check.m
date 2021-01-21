clear all
close all
% To check the consistancy of the theoretical derivations
N=1e4;
Nr=4;
Nt=Nr;
alpha=4;
P=10;
r1a=1:1:19;
r2a=20-r1a;
SNR=40;
No = P/10^(SNR/10);
D=[];
for ir=1:length(r1a)
    r1=r1a(ir);r2=r2a(ir);
    for ii=1:N
        h1=1/sqrt(2)*[randn(Nr,Nt) + 1j*randn(Nr,Nt)]*r1^(-alpha/2);
        [Q1,R1] = qr(h1);
        h2=1/sqrt(2)*[randn(Nr,Nt) + 1j*randn(Nr,Nt)]*r2^(-alpha/2);
        [Q2,R2] = qr(h2);
        D=[(abs(diag(R1)).^2+abs(diag(R2)).^2)*P/Nt/No];
        %% ZF-DPC JT
        C_ZF(ii,:)=sum(log2(1+D));        
        %% Shannon joint
        H=h1+h2;
        lam=eig(H);
        C_Sh(ii,:)=sum(log2(1+P/Nt/No*abs(lam).^2));
        %% Shannon NJT
        %% Shannon joint
        H=h1;
        lam=eig(H);
        C_ShNJT(ii,:)=sum(log2(1+P/Nt/No*abs(lam).^2));
    end
    CZ(ir,:)=mean(C_ZF);
    CS(ir,:)=mean(C_Sh);
    CSnjt(ir,:)=0.5*mean(C_ShNJT);
end
plot(r1a,CZ,'b*-',r1a,CS,'g*-',r1a,CSnjt,'y*-'),hold on
x=(2:1:20);
the=[0.0220082,0.789197,7.3493,14.2525,11.1446,8.59905,6.87659,5.8812,5.7,5.8812,6.87659,8.59905,11.1446,14.6606,19.3922,25.8201,35.0975,51.0784,0.];
plot(x, the,'r-o');
