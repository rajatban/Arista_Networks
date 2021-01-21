function [throughput] = getAvgThroughputForAllNodes(P, C)

[i, j, k] = size(P);
throughput = zeros(i, j);
for i1 = 1:k
    throughput = throughput + P(:, :, i1) .* C{i1};
end

end

