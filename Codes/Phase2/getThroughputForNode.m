function [throughput] = getThroughputForNode(S, C, i, j)

throughput = C{S(i, j)}(i, j);

end

