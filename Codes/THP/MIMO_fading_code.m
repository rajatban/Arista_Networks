clear all
close all

Nr=4;
Nt=4;
I=eye(Nr);
g=15.8489;

for n=1:10000
    H=sqrt(1/2)*randn(Nr,Nt)+j*sqrt(1/2)*randn(Nr,Nt);
    C(n)=log2(det(I+(g/Nt)*(H*H')));
end

[a,b]=hist(real(C),100);
a=a/sum(a);
plot(b,1-cumsum(a));
xlabel('Capacity (bps/Hz)')
ylabel('Probability (Capacity > Abcissa)')
grid on