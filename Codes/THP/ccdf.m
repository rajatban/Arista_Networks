function [y]=ccdf(x,range)
N=length(x);
y=[];
for i=range
    y=[y length(find(x>i))/N];
end
%plot(range,y)
