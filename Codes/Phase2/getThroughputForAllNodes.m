function [throughputs] = getThroughputForAllNodes(S, C)

[i, j] = size(S);
% 
% filename = 'throughputCharts.mat';
% load(filename, 'C1', 'C2', 'C3', 'C4', 'C5');
throughputs = zeros(i, j);

for i1 = 1:i
    for i2 = 1:j
        throughputs(i1, i2) = C{S(i1, i2)}(i1, i2);
%         switch S(i1, i2)
%             case 1
%                 throughputs(i1, i2) = C{1}(i1, i2);
%             case 2
%                 throughputs(i1, i2) = C{2}(i1, i2);
%             case 3
%                 throughputs(i1, i2) = C{3}(i1, i2);
%             case 4
%                 throughputs(i1, i2) = C{4}(i1, i2);
%             case 5
%                 throughputs(i1, i2) = C{5}(i1, i2);
%             otherwise
%                 throughputs(i1, i2) = 0;
%         end
    end
end

end
