function [y_rt]=JT_THP_precRX(A_mod,y_recv,n,S1, S2)
%thp in receiver side
y=inv(S1)*y_recv+inv(S2)*y_recv1;
for i=1:n
    a(i)=rem(real(y(i)),2*A_mod(i))+1i*rem(imag(y(i)),2*A_mod(i));
    a_real(i)=real(a(i));
    a_imag(i)=imag(a(i));
    if(a_real(i)<-A_mod(i))
       a_real(i)=a_real(i)+2*A_mod(i);
    elseif(a_real(i)>A_mod(i))
       a_real(i)=a_real(i)-2*A_mod(i);
    else 
    end
    if(a_imag(i)<-A_mod(i))
       a_imag(i)=a_imag(i)+2*A_mod(i);
    elseif(a_imag(i)>A_mod(i))
       a_imag(i)=a_imag(i)-2*A_mod(i);
    else
    end
end
y_rt=a_real+1i*a_imag;