clear all
% To check the consistancy of the theoretical derivations
P=10;
Rd=10;
rl=0:0.25:Rd;
for ir=1:length(rl)
    % JT
    r=rl(ir);
    h1=1/sqrt(2)*[randn(1,1e4) + 1j*randn(1,1e4)];
    h2=1/sqrt(2)*[randn(1,1e4) + 1j*randn(1,1e4)];
    Gamma=(b*P*abs(h1).^2*(1+r)^-4+(1-b)*P*abs(h2).^2*(1+Rd-r)^-4)/No;
    Gamma_Full=[Gamma_Full,Gamma];
    BER(ir)=mean(aM*qfunc(sqrt(K*Gamma)));
    Rate=log2(1+Gamma);
    mean_Rate(ir)=mean(Rate);
    Rate_Full=[Rate_Full,Rate];
    
    % NJT 
    h=1/sqrt(2)*[randn(1,1e4) + 1j*randn(1,1e4)];
    GammaNJT=(P*abs(h).^2*(1+r)^-4)/No;
    GammaNJT_Full=[GammaNJT_Full,GammaNJT];
    BERNJT(ir)=mean(aM*qfunc(sqrt(K*GammaNJT)));
    RateNJT=0.5*log2(1+GammaNJT);
    mean_RateNJT(ir)=mean(RateNJT);
    RateNJT_Full=[RateNJT_Full,RateNJT];
end
%% Theoretical Values for \beta=0.6
BER_the=[0.0000919931,0.000223106,0.000459097,0.000842959,0.00142303,0.00225135,0.00338156,0.00486603,0.0067525,0.00907992,0.0118738,0.0151414,0.0188665,0.0230052,0.0274821,0.0321888,0.036984,0.0416966,0.0461317,0.0500803,0.0533314,0.055687,0.0569792,0.0570872,0.0559531,0.0535933,0.0501049,0.0456627,0.0405065,0.0349204,0.0292044,0.0236442,0.0184846,0.0139091,0.0100306,0.00689163,0.00447354,0.00271025,0.00150445,0.000743097,0.000310732];
RATE_the=[10.477,9.19504,8.15225,7.27645,6.52488,5.87018,5.29379,4.7826,4.32695,3.91954,3.55471,3.22796,2.93568,2.6749,2.44322,2.23867,2.05967,1.905,1.77378,1.66542,1.57971,1.51674,1.47695,1.46117,1.47057,1.50677,1.57178,1.66807,1.79859,1.96679,2.17672,2.43309,2.74142,3.10827,3.54167,4.05173,4.6517,5.35989,6.20303,7.22284,8.49002];
BERNJT_the=[0.0000790382,0.000192898,0.000399746,0.000739822,0.00126013,0.00201391,0.00305984,0.00446096,0.00628316,0.00859337,0.0114573,0.0149368,0.0190872,0.0239543,0.0295715,0.0359578,0.0431155,0.0510294,0.0596667,0.068978,0.0788988,0.0893527,0.100254,0.111511,0.123032,0.134723,0.146496,0.15827,0.16997,0.18153,0.192895,0.204016,0.214856,0.225386,0.235583,0.245431,0.254922,0.26405,0.272816,0.281221,0.289273];
RateNJT_the=[5.39894,4.75737,4.235,3.79567,3.4179,3.08791,2.79636,2.53659,2.30369,2.09394,1.90438,1.73267,1.57686,1.43532,1.30666,1.18965,1.08323,0.986446,0.898438,0.818429,0.745714,0.679647,0.619638,0.565145,0.515673,0.470767,0.430009,0.39302,0.359448,0.328977,0.301315,0.276197,0.253382,0.232652,0.213808,0.19667,0.181075,0.166876,0.153938,0.142143,0.131382];

%% Plotting results
subplot(2,1,1)
plot(rl,BER,'b*-',rl,BER_the,'ro-',rl,BERNJT,'go-',rl,BERNJT_the,'y+-')
% plot(rl,BER,'b*-',rl,BERNJT,'go-')
legend('JT','JT\_Th','NJT','NJT\_Th')
title('BER Vs r')
subplot(2,1,2)
plot(rl,mean_Rate,'b*-',rl,RATE_the,'ro-',rl,mean_RateNJT,'go-',rl,RateNJT_the,'y+-')
% plot(rl,mean_Rate,'b*-',rl,mean_RateNJT,'go-')
legend('JT','JT\_Th','NJT','NJT\_Th')
title('Mean Rate Vs r')
%%  Coverage 
figure
x_SNR=-25:5:50;
[Cov]=ccdf(10*log10(Gamma_Full),x_SNR);
[CovNJT]=ccdf(10*log10(GammaNJT_Full),x_SNR);
subplot(2,1,1)
plot(x_SNR,Cov,'r-o',x_SNR,CovNJT,'b-*');grid on
legend('JT','NJT')
title('Coverage')
%% Rate
subplot(2,1,2)
x_C=linspace(0,5,100);
[R_CDF]=1-ccdf(Rate_Full,x_C);
[R_CDF_NJT]=1-ccdf(RateNJT_Full,x_C);
plot(x_C,R_CDF,'r-',x_C,R_CDF_NJT,'b-');grid on
legend('JT','NJT')
title('Rate CDF')