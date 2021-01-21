function [delP] = getDelP(P, C)

[i, j, k] = size(P);
delP = P .* rand(i, j, k);

T = getAvgThroughputForAllNodes(P, C);
newP = getNewP(P, delP);
newT = getAvgThroughputForAllNodes(newP, C);

delT = newT - T;

for i1 = 1:i
    for i2 = 1:j
        if delT(i1, i2) < 0
            delP(i1, i2, :) = 0;% ones(1, 1, k) + (delT(i1, i2) .* delP(i1, i2, :));
        else
            delP(i1, i2, :) = delT(i1, i2) .* delP(i1, i2, :);
        end
    end
end
end

