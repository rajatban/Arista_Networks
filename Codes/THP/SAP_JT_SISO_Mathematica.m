clear
close all;
addpath 'D:\matlink'
math('quit')
pause(1)
SNR=60;
P1=10;                             % dB
P2=10;
No = P1/10^(SNR/10);
alpha=4;
L=10;
W=10;
% X=0.25:0.35:L-0.5;
% Y=0.5:0.25:W-0.5;
dist_f=0.5:0.35:20-0.5;
for ii=1:length(dist_f)
    dist=dist_f(ii);
    r1=dist;
    r2=20-dist;
    if r1~=r2
        math('matlab2math','No',No);
        math('matlab2math','P1',P1);
        math('matlab2math','r1',r1);
        math('matlab2math','P2',P2);
        math('matlab2math','r2',r2);
        % SAPT
        M_out=math('NumberForm[NIntegrate[Exp[-No (2^t - 1)/(P1 r1^-4)], {t, 0,Infinity}]//N,4]');
        Msapt_{ii,:}=M_out;
        B_sapt = convertCharsToStrings( M_out(3:end-2) );
        C_SAPT(ii) = str2num(B_sapt);
        % SAPI
        M_out=math('NumberForm[NIntegrate[Exp[-No (2^t - 1)/(P1 r1^-4)]/(1 + (2^t - 1) (P2 r2^-4)/(P1 r1^-4)), {t, 0,Infinity}]//N,4]');
        Msapi_{ii,:}=M_out;
%         if ii==39
%         pause
%         end
        B_sapi = convertCharsToStrings( M_out(3:end-2) );
        if isempty(str2num(B_sapi));
            C_SAPI(ii)=0;
        else
        C_SAPI(ii) = str2num(B_sapi);
        end
        % Joint Transmission
        M_out=math('No/( P1 r1^-4 - P2 r2^-4) ((E^((r1^4 No)/P1)P1 r1^-4 Gamma[0, (r1^4 No)/P1])/(No Log[2]) - (E^((r2^4 No)/P2 )P2 r2^-4  Gamma[0, (r2^4 No)/P2 ])/(No Log[2]))');
        Msap_{ii,:}=M_out;
        B_jt = convertCharsToStrings( M_out(3:end-2) );
        C_JT(ii) = str2num(B_jt);
%     else
%      M_out=math('(No^2 r1^(2*4)  MeijerG[{{-2}, {-1}}, {{-2, -2, 0}, {}}, (No r1^4)/  P1])/(P1^2 Log[2])');
%      B_jt = convertCharsToStrings( M_out(3:end-2) );
%      C_JT(ii) = str2num(B_jt);
    end
end

plot(dist_f,2*C_SAPI,'b'); hold on
plot(dist_f,C_JT,'r')
plot(dist_f,C_SAPT,'g');