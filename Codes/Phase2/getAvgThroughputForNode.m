function [throughput] = getAvgThroughputForNode(P, C, i, j)

[~, ~, k] = size(P);
throughput = 0;
for i1 = 1:k
    throughput = throughput + P(i, j, i1) * C{i1}(i, j);
end

end

