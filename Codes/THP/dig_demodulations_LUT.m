function [bits] = dig_demodulations_LUT(symb,type)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
switch type
    case 1 %'BPSK'
        load 'constellation_LUT' BPSK;
        bits=[];
        for ii=1:size(symb,2)
            dist=abs(BPSK-symb(ii));
            ind=find(dist==min(dist));
            bits=[bits; de2bi(ind-1,'left-msb',1)'];
        end
    case 2 %'QPSK'
        load 'constellation_LUT' QAM4;
        bits=[];
        for ii=1:size(symb,2)
            dist=abs(QAM4-symb(ii));
            ind=find(dist==min(dist));
            bits=[bits; de2bi(ind-1,'left-msb',2)'];
        end
    case 4 %'16QAM'
        load 'constellation_LUT' QAM16;
        bits=[];
        for ii=1:size(symb,2)
            dist=abs(QAM16-symb(ii));
            ind=find(dist==min(dist));
            bits=[bits; de2bi(ind-1,'left-msb',4)'];
        end
    case 6 %'64QAM'
        load 'constellation_LUT' QAM64;
        bits=[];
        for ii=1:size(symb,2)
            dist=abs(QAM64-symb(ii));
            ind=find(dist==min(dist));
            bits=[bits; de2bi(ind-1,'left-msb',6)'];
        end
    case 8 %'256QAM'
        load 'constellation_LUT' QAM256;
        bits=[];
        for ii=1:size(symb,2)
            dist=abs(QAM256-symb(ii));
            ind=find(dist==min(dist));
            bits=[bits; de2bi(ind-1,'left-msb',8)'];
        end
    otherwise
        warning('Unexpected Mod scheme.')
end
end

