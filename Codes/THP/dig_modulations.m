function [symb] = dig_modulations(in,type)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
load 'constellation_LUT';
switch type
    case 'BPSK'
        symb=1/sqrt(2)*[(1-2*in)+1j*(1-2*in)];
    case 'QPSK'
        symb=1/sqrt(2)*[(1-2*in(1))+1j*(1-2*in(2))];
    case '16QAM'
        symb=1/sqrt(10)*[ (1-2*in(1))*[2-(1-2*in(2))]+ 1j*(1-2*in(3))*[2-(1-2*in(4))]];
    case '64QAM'
        symb=1/sqrt(42)*[(1-2*in(1))*[4-(1-2*in(3))*[2-(1-2*in(5))]]+ 1j*(1-2*in(2))*[4-(1-2*in(4))*[2-(1-2*in(6))]]];
    case '256QAM'
        disp('Not defined')
    otherwise
        warning('Unexpected Mod scheme.')
end
end

