clear 
close all;
SNR=60;
Nr=4;
N_iter=1e2;
L=20;
W=20;
X=0.5:0.25:L-0.5;
Y=0.5:0.25:W-0.5;
AP_cord=[0,0;L,W;0,W;L,0];
for ix=1:length(X)
    for iy=1:length(Y)
        STA_cord=[X(ix),Y(iy)];
        % C=ZFDPC_SpaceCheck(P,AP_cord,STA_cord,Nr,N_iter); % JT 
        C=ZFDPC_SpaceCheck(SNR,AP_cord,STA_cord,Nr,N_iter);
        ind=find(max(C)==C);
        AP_ind(ix,iy,:)=ind-1;
        C_full(ix,iy,:)=C;
    end    
end
pcolor(X,Y,AP_ind)
axis ij
axis square
filename=strcat('AP_ind_MIMO_JT',num2str(Nr),'x',num2str(Nr),'.xlsx');
% filename = 'AP_ind_MIMO_JT.xlsx';
writematrix(AP_ind,filename,'Sheet',1)