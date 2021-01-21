function [P,ybs,M]=Data_gen4qam(NBS)
%Generates n distinct signals for each BS
% NBS=10;
Nfft=2048;
Nused=1200;
N_Cp=144;
ybs=[]; %information bits
a=[];  %modulated symbols
M=[]; %modulation index vector 
P=[];
load 'constellation_LUT'
for nbs=1:NBS
    a=[];  %modulated symbols
    for i=1:1200
       Data=randn(2,1)>.5;
       Data=Data+0;
       ybs=[ybs;Data];
       data1=QAM4(bi2de(Data.','left-msb')+1,:);
       a=[a data1];
    end
    M=[M 4];
    P=[P;a];
end