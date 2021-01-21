function C = capacityJT(r1, r2)
    a = 0.67;
    P1 = 1  ;
    P2 = 1  ;
    n  = 10.^(-5) ;
    SNR1 = P1*r1.^(-a)/n.^2 ;
    SNR2 = P2*r2.^(-a)/n.^2 ;
    g1 = gammainc(0, 1/SNR1);
    g2 = gammainc(0, 1/SNR2);
    
    C = (1/log10(2)) * 1/((P1* r1.^(-a)) - (P2* r2.^(-a))) *(((P1* r1.^(-a))*exp(1/SNR1)*g1) - ((P2* r2.^(-a))*exp(1/SNR2)*g2))    ;
end