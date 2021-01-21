function [A, T] = assignTiles(N, C, T, n)
% This function allocates tiles to AP(n) by choosing max capacity tile
% available in the tile set.
[i, j] = size(C);
Cmax = zeros(1, N);
A = zeros(N, 2);  %Tiles for each AP

for i1 = 1:i
    for i2 = 1:j
        for i3 = 1:N
            if T(i1, i2) ~= 0
                continue;
            end
            if C(i1, i2) > Cmax(i3)
                Cmax = [Cmax(1:i3-1) C(i1, i2) Cmax(i3:N-1)];
                A = [A(1:i3-1,:); [i1, i2]; A(i3:N-1,:)];
                break;
            end
        end
    end
end

for i1 = 1:N
    T(A(i1,1), A(i1,2)) = n;
end

end