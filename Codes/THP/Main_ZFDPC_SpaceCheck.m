clear 
close all;
SNR=60;
Nr=4;
N_iter=1e2;
L=20;
W=20;
X=0.5:0.5:L-0.5;
Y=0.5:0.5:W-0.5;
AP_cord=[0,0;L,W;0,W;L,0];
for ix=1:length(X)
    for iy=1:length(Y)
        STA_cord=[X(ix),Y(iy)];
        % C=ZFDPC_SpaceCheck(P,AP_cord,STA_cord,Nr,N_iter); % JT 
        %% 2 AP coordinated
        C_JT=ZFDPC_Space_Check_I(SNR,AP_cord,STA_cord,Nr,N_iter);% JT with I
        ind=find(C_JT==max(C_JT));
        Best_AP_JT(ix,iy)=ind(1);
        C__JT(ix,iy,:)=C_JT;
        Cmax_JT(ix,iy)=max(C_JT);
        %% No AP coordinated
        C_NJT=ZFDPC_NJT_Space_Check_I(SNR,AP_cord,STA_cord,Nr,N_iter);
        ind=find(C_NJT==max(C_NJT));
        Best_AP_NJT(ix,iy)=ind(1);
        C__NJT(ix,iy,:)=C_NJT;
        Cmax_NJT(ix,iy)=max(C_NJT);
    end
end
time = datestr(now, 'yyyy_mm_dd');
filename = sprintf('THP_Space_%s.mat',time);
save (filename)
% imagesc(Best_AP)
% figure
% imagesc(Cmax)
range=0:0.05:3;
[Rcdf_JT]=1-ccdf(Cmax_JT(:),range);
[Rcdf_NJT]=1-ccdf(Cmax_NJT(:),range);
plot(range,Rcdf_JT,'r*-',range,Rcdf_NJT,'bo-');
legend('JT','NJT')
% figure
% hold on
% for ij=1:size(C_,3)
%     Cb=C_(:,:,ij);
%     Cc=Cb(:);
%     range=0:0.01:1;
%     [Rcdf]=1-ccdf(Cc,range);
%     txt=strcat('Sim',[' i = ',num2str(ij)]);
%     plot(range,Rcdf,'DisplayName',txt);
%     grid on
% end
% hold off
% legend show