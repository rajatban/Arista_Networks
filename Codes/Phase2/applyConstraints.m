function [newP] = applyConstraints(P)

sumP = sum(P, [1 2]);

sumP(4) = sumP(4) / sumP(2) * (sumP(2) + sumP(5));
sumP(5) = sumP(2) + sumP(5);
sumP(2) = sumP(5);

newP = P ./ sumP;

end

