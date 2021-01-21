function [symb] = dig_modulations_LUT(Data,type)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% load 'constellation_LUT';
switch type
    case 1 %'BPSK'
        load 'constellation_LUT' BPSK;
        symb=BPSK(bi2de(Data.','left-msb')+1,:);
    case 2 %'QAM4'
        load 'constellation_LUT' QAM4;
        symb=QAM4(bi2de(Data.','left-msb')+1,:);
    case 4 %'16QAM'
        load 'constellation_LUT' QAM16;
        symb=QAM16(bi2de(Data.','left-msb')+1,:);
    case 6 %'64QAM'
        load 'constellation_LUT' QAM64;
        symb=QAM64(bi2de(Data.','left-msb')+1,:);
    case 8 %'256QAM'
        symb=QAM256(bi2de(Data.','left-msb')+1,:);
    otherwise
        warning('Unexpected Mod scheme.')
end
end

