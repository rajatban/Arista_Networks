load('throughputCharts.mat', 'C');
N = 10000;

P = generateP(8, 8);

T1 = getAvgThroughputForAllNodes(P, C);

for i1 = 1:N
    delP = getDelP(P, C);
    P = getNewP(P, delP);
end

T2 = getAvgThroughputForAllNodes(P, C);

heatmap(T1);
figure
heatmap(T2);