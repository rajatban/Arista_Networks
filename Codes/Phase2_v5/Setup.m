% Setup (Initialize)
clear;

N = zeros(1, 5);    % No of tiles assigned to each AP
A = cell(1, 5);     % Tiles for each AP
T = zeros(8,8);     % Tile map
load('throughputCharts.mat', 'C');  % Load capacity matrix

% C{1} = 1/2 .* C{1};

% initialize

% N = [10 14 10 14 16];
N = [18 10 18 10 8];

% error check
if sum(N) ~= 64
    error('error: No of tiles is not correct. Check variable N');
end
if N(2) ~= N(4)
    error('error: No of tiles for AP2 and AP4 are not same. Check variable N');
end

% assign tiles to APs
for i1 = 1:5
    [A{i1}, T] = assignTiles(N(i1), C{i1}, T, i1); % C is capacity matrix
end


[avgCapacity, avgCapacitiesPerAP, avgCapacitiesPerUser, count] = calcNetCapacity(T, C);

disp(['capacity = ' num2str(avgCapacity)]);
disp(avgCapacitiesPerUser);
disp(avgCapacitiesPerAP);
disp(count(1:4));

heatmap(T);

% ------------------------------------------------ %
% helper functions
