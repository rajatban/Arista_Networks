function [y]=THP_precTX(B,Q,A_mod,a,n)
x=zeros(n,1);
for ii=1:n
    x=rem(real(a-(B-eye(n,n))*x),2*A_mod(ii))+1i*rem(imag(a-(B-eye(n,n))*x),2*A_mod(ii));
    a_real=real(x);
    a_imag=imag(x);
    for l=1:n
        if(a_real(l)<-A_mod(l))
           a_real(l)=a_real(l)+2*A_mod(l);
        elseif(a_real(l)>A_mod(l))
            a_real(l)=a_real(l)-2*A_mod(l);
        else 
        end
        if(a_imag(l)<-A_mod(l))
            a_imag(l)=a_imag(l)+2*A_mod(l);
        elseif(a_imag(l)>A_mod(l))
            a_imag(l)=a_imag(l)-2*A_mod(l);
        else
        end
    end
        x=a_real+1i*a_imag;
end
y=Q'*x;