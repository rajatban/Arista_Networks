grid = 8;
T = [1 1 1 1 1 2 2 2;
     1 1 1 1 1 2 2 2;
     1 1 1 1 1 5 2 2;
     1 1 1 5 5 5 3 3;
     1 1 5 5 5 3 3 3;
     4 4 5 3 3 3 3 3;
     4 4 4 3 3 3 3 3;
     4 4 4 3 3 3 3 3];

C = calcCapacities(grid);

[avgCapacity, avgCapacitiesPerAP, avgCapacitiesPerUser, count] = calcNetCapacity(T, C);

disp(['capacity = ' num2str(avgCapacity)]);
disp(avgCapacitiesPerUser);
disp(avgCapacitiesPerAP);
disp(count(1:4));

% disp(['Average Capacity = ' num2str(avgCapacity)]);
% disp(['Average Capacity per User= ' num2str(avgCapacitiesPerUser)]);
% disp(['Average Capacity per AP config. = ' num2str(avgCapacitiesPerAP)]);