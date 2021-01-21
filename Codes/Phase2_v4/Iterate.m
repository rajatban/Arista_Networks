%% Iterate

% calc max capacities
[maxC1, maxC1id, secondMaxC1, secondMaxC1id] = calcMax(capacityMatrix(1, :, :), tiles, -1);
[maxC2, maxC2id, secondMaxC2, secondMaxC2id] = calcMax(capacityMatrix(2, :, :), tiles, -1);
[maxC3, maxC3id, secondMaxC3, secondMaxC3id] = calcMax(capacityMatrix(3, :, :), tiles, -1);
[maxC4, maxC4id, secondMaxC4, secondMaxC4id] = calcMax(capacityMatrix(4, :, :), tiles, -1);
[maxC5, maxC5id, secondMaxC5, secondMaxC5id] = calcMax(capacityMatrix(5, :, :), tiles, -1);

% check if AP2 and AP4 are serving same tile
if maxC2id == maxC4id
    if maxC4 + secondMaxC2 > maxC2 + secondMaxC4
        maxC2 = secondMaxC2;
        maxC2id = secondMaxC2id;
    else
        maxC4 = secondMaxC4;
        maxC4id = secondMaxC4id;
    end
end

% check if SAPI is better than JT
if maxC5 > (maxC2 + maxC4)
    JT = true;
else
    JT = false;
end

% check if same tile is being served

if maxC1id == maxC3id
    disp('1, 3 equal')
    if maxC3 + secondMaxC1 > maxC1 + secondMaxC3
        maxC1 = secondMaxC1;
        maxC1id = secondMaxC1id;
    else
        maxC3 = secondMaxC3;
        maxC3id = secondMaxC3id;
    end
end
if maxC1id == maxC5id
    disp('1, 5 equal')
    if maxC5 + secondMaxC1 > maxC1 + secondMaxC5
        maxC1 = secondMaxC1;
        maxC1id = secondMaxC1id;
    else
        maxC5 = secondMaxC5;
        maxC5id = secondMaxC5id;
    end
end
if maxC3id == maxC5id
    disp('3, 5 equal')
    if maxC5 + secondMaxC3 > maxC3 + secondMaxC5
        maxC3 = secondMaxC3;
        maxC3id = secondMaxC3id;
    else
        maxC5 = secondMaxC5;
        maxC5id = secondMaxC5id;
    end
end


% allocate the APs
tiles(maxC1id(1), maxC1id(2)) = 1;
tiles(maxC3id(1), maxC3id(2)) = 3;
if JT
    tiles(maxC5id(1), maxC5id(2)) = 5;
else
    tiles(maxC2id(1), maxC2id(2)) = 2;
    tiles(maxC4id(1), maxC4id(2)) = 4;
end

heatmap(tiles);