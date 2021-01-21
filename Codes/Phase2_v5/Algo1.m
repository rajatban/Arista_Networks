% algo 1

delN = [ 1 -1  1 -1  0;   %changes in N regarding
    -1  1 -1  1  0;
     1  0  1  0 -2;
    -1  0 -1  0  2;
     0  1  0  1 -2;
     0 -1  0 -1  2];
%      1  0 -1  0  0;
%     -1  0  1  0  0];


delC = zeros(1, 6);
maxDelC = 0;
maxDelCid = 0;

for i1 = 1:6
    newA = cell(1, 5);     % Tiles for each AP
    newT = zeros(8,8);     % Tile map
    
    newN = N + delN(i1,:);
    % error check
    if sum(newN) ~= 64
        error('error: No of tiles is not correct. Check variable N');
    end
    if newN(2) ~= newN(4)
        error('error: No of tiles for AP2 and AP4 are not same. Check variable N');
    end
    
    % assign tiles to APs
    for i2 = 1:5
        [newA{i2}, newT] = assignTiles(newN(i2), C{i2}, newT, i2);
    end
    
    
    [newAvgCapacity, newAvgCapacitiesPerAP, newAvgCapacitiesPerUser, newCount] = calcNetCapacity(newT, C);
    
    delC(i1) = newAvgCapacity - avgCapacity;
    %     disp(['capacity = ' num2str(avgCapacity)]);
    %     disp(avgCapacitiesPerUser);
    %     disp(avgCapacitiesPerAP);
    %     disp(count(1:4));
    
    if delC(i1) > maxDelC
        maxDelC = delC(i1);
        maxDelCid = i1;
    end
end


disp(delC);
disp(maxDelC);
disp(maxDelCid);

if maxDelCid ~= 0
    N = N + delN(maxDelCid, :);
    A = cell(1, 5);     % Tiles for each AP
    T = zeros(8,8);     % Tile map
    
    % assign tiles to APs
    for i1 = 1:5
        [A{i1}, T] = assignTiles(N(i1), C{i1}, T, i1);
    end
    
    [avgCapacity, avgCapacitiesPerAP, avgCapacitiesPerUser, count] = calcNetCapacity(T, C);
else
    disp('--------------- Converged ---------------');
end

disp(['new Capacity = ' num2str(avgCapacity)]);
disp(avgCapacitiesPerUser);
disp(avgCapacitiesPerAP);
disp(count(1:4));

heatmap(T);