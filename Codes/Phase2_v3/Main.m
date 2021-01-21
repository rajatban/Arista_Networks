%% Obtaining optimal scheduling in a 4 AP system
% program starts with randomly alloting AP to the tiles and changing them
% to increase the net average throughput.

%% Creating environment
grid = 4;

% generating tiles
T = ones(grid, grid);

% calculating capacities
C = calcCapacities(grid);

%% Changing assigned APs

