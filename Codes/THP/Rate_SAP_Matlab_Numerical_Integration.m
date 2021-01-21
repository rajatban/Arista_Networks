clear 
close all;
addpath 'D:\matlink'
math('quit')
pause(1)
SNR=35;
P1=10;                             % dB
P2=10;
No = P1/10^(SNR/10);
alpha=4;
L=10;
W=10;
X=0.5:0.25:L-0.5;
Y=0.5:0.25:W-0.5;
AP_cord=[0,0;L,W;0,W;L,0];
for ix=1:length(X)
    for iy=1:length(Y)
        STA_cord=[X(ix),Y(iy)];
        dist=vecnorm(AP_cord-STA_cord,2,2);
        % SAP
        r1=dist(1);r2=dist(2);
        if r1~=r2
        math('matlab2math','No',No);
        math('matlab2math','P1',P1);
        math('matlab2math','r1',r1);
        math('matlab2math','P2',P2);
        math('matlab2math','r2',r2);
%         C(ix,iy,:)=math('NIntegrate[Exp[-No (2^t - 1)/(P1 r1^-alpha)]/(1 + (2^t - 1) (P2 r2^-alpha)/(P1 r1^-alpha)), {t, 0,Infinity}]');
        M_out=math('NIntegrate[Exp[-No (2^t - 1)/(P1 r1^-4)]/(1 + (2^t - 1) (P2 r2^-4)/(P1 r1^-4)), {t, 0,Infinity}]');
        M_{ix,iy,:}=M_out;
        B = convertCharsToStrings( M_out(3:end-2) );
        C_SAP(ix,iy) = str2num(B);
        % Joint Transmission
        M_out=math('No/( P1 r1^-4 - P2 r2^-4) ((E^((r1^4 No)/P1)P1 r1^-4 Gamma[0, (r1^4 No)/P1])/(No Log[2]) - (E^((r2^4 No)/P2 )P2 r2^-4  Gamma[0, (r2^4 No)/P2 ])/(No Log[2]))');
        Msap_{ix,iy,:}=M_out;
        B = convertCharsToStrings( M_out(3:end-2) );
        C_JT(ix,iy) = str2num(B);
        end
    end
end
surf(C_JT)
figure
surf(C_SAP)
