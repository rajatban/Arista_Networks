function [S] = generateAPSets(P)

[i, j, ~] = size(P);
S = zeros(8, 8);

for i1 = 1:i
    for i2 = 1:j
        if S(i1, i2) == 0
            cP = squeeze(cumsum(P(i1, i2, :)));
            r = rand;

            ap = 1;
            while r >= cP(ap)
                ap = ap + 1;
            end
            
            if i1 == i2 && (ap == 2 || ap == 4)
                ap = 5;
            end
            
            S(i1, i2) = ap;
            
            if ap == 2
                S(i2, i1) = 4;
            elseif ap == 4
                S(i2, i1) = 2;
            end
        end
    end
end

end
