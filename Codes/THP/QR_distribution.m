clear all
clc
N=1e6;
Nr=4;
Nt=Nr;
D=[];
for ii=1:N
    h=1/sqrt(2)*[randn(Nr,Nt) + 1j*randn(Nr,Nt)];
    [Q,R] = qr(h);
    D=[D diag(abs(R).^2)];
end
hold on
for jj=1:Nr
    [f,x]=hist(D(jj,:),1000);
    txt=strcat('Sim',[' i = ',num2str(jj)]);
    plot(x,f/trapz(x,f),'DisplayName',txt);
    grid on
end

x=0:0.5:15;
alpha= Nr;      % shape
beta=  1;       % scale
for jj=1:Nr
    alpha=jj;
    fXx=beta^alpha*x.^(alpha-1).*exp(-beta.*x)/gamma(alpha);
    txt=strcat('Theo',[' i = ',num2str(jj)]);
    plot(x,fXx,'*-','DisplayName',txt);hold on
end
hold off
legend show