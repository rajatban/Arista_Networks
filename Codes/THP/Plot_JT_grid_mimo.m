% load('AP_ind_MIMO_JT4x4.mat');
% % AP_ind(find(AP_ind==0))=128;
% % AP_ind(find(AP_ind==1))=90;
% % AP_ind(find(AP_ind==2))=60;
% % AP_ind(find(AP_ind==3))=20;
% % AP_ind(find(AP_ind==4))=0;
% pcolor(X,Y,AP_ind),axis ij,axis square,grid off
% colormap(jet)
% colormap(hsv)
% colormapeditor

load("Capacity_crossover_vars.mat");
figure
plot(d, C1);
hold on
plot(d, C2);
plot(d, 2.*C3);
legend('Single AP transmission','JT-TC', '2 AP uncoordinated transmission', 'Location',"north");
xlabel('Distance from AP1');
ylabel('Capacity (Bits/sec/Hz)');
title(['Capacity curve (SNR=' num2str(SNR) 'dB)']);