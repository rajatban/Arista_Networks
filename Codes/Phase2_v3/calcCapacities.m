function Cap = calcCapacities(grid)
%CALCULATECAPACITIES Summary of this function goes here
%   Detailed explanation goes here
%C = ones(grid, grid);
Cap = zeros(5, grid, grid);

if grid == 8
    load('throughputCharts.mat', 'C');
    
    for i1 = 1:5
        Cap(i1, :, :) = C{i1};
    end
else
    for i1 = 1:5
        for i2 = 1:grid
            for i3 = 1:grid
                Cap(:, i2, i3) = calcCapacity(i2, i3, grid);
            end
        end
    end
end
end

function c = calcCapacity(i, j, grid)
% parameters
len = 20; %m
pos = [0   0  ;
    len 0  ;
    len len;
    0   len];
dist = ones(1, 4);

% function
x = len / (grid + 1) * (i - 0.5);
y = len / (grid + 1) * (j - 0.5);

for i1 = 1:4
    dist(i1) = sqrt(((pos(i1, 1) - x)^2 + (pos(i1, 2) - y)^2));
end

c = ones(5, 1, 1);

c(1) = 1;

end

