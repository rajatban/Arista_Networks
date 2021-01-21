function [P] = generateP(i, j)

% Generating P matrix
% -P(i, j) = [p1, p2, p3, p4, p5]
% -Constraints:
% - p1(i, j) + p2(i, j) + p3(i, j) + p4(i, j) + p5(i, j) = x(i, j); a node 
%   will be served by any AP(Tile centric view of scheduling).
% - P1 = sum(p1(i, j)) = 1; probability that an AP will be selected for the 
%   particular time slot(AP centric view of scheduling).
% - P1 = P3 = P2 + P5 = P4 + P5 = 1; probability of each AP serving in a 
%   time slot is equal
% 

% P = rand(i, j, k);

P = ones(i, j, 5);
P = applyConstraints(P);

end
