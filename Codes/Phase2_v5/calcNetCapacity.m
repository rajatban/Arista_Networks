function [avgCapacity, avgCapacitiesPerAP, avgCapacitiesPerUser, totCount] = calcNetCapacity(T, C)
%CALCNETCAPACITY Summary of this function goes here
%   Detailed explanation goes here
[i, j] = size(T);

totCapacities = zeros(1, 5);
totCount = zeros(1, 5);   %
for i1 = 1:i
    for i2 = 1:j
        totCapacities(T(i1, i2)) = totCapacities(T(i1, i2)) + C{T(i1, i2)}(i1, i2);
        totCount(T(i1, i2)) = totCount(T(i1, i2)) + 1;
    end
end
% 
% totCapacities(2) = totCapacities(2) + totCapacities(5);
% totCapacities(4) = totCapacities(4) + totCapacities(5);

totCount(totCount==0) = 0.000000001;
avgCapacitiesPerAP = totCapacities ./ totCount;

totCount(2) = totCount(2) + totCount(5);
totCount(4) = totCount(4) + totCount(5);
totCount(5) = totCount(2);

avgCapacitiesPerUser = avgCapacitiesPerAP ./ totCount;
avgCapacity = sum(avgCapacitiesPerUser);
end

