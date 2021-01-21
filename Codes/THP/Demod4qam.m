function a_out=Demod4qam(a,n,E1)
a_real=real(a);
a_imag=imag(a);
for i=1:n
       if(a_real(i)>0)
          a_real(i)=1/sqrt(E1);
       elseif(a_real(i)<-0)
          a_real(i)=-1/sqrt(E1);
       else
       end
       if(a_imag(i)>0)
          a_imag(i)=1/sqrt(E1);
       elseif(a_imag(i)<-0)
            a_imag(i)=-1/sqrt(E1);
       else
       end
end
a_out=a_real+1i*a_imag;