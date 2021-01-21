function [newP] = getNewP(P, delP)

% delP should be positive only

newP = P + delP;
newP = applyConstraints(newP);

end

