% Implementing round robin like algorithm to schedule APs
load('throughputCharts.mat', 'C');

tiles = zeros(8, 8);

capacityMatrix = zeros(5,8,8);
for i1 = 1:5
    capacityMatrix(i1, :, :) = C{i1};
end
