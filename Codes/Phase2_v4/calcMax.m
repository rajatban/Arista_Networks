function [max, maxid, secondMax, secondMaxid] = calcMax(Cmat, t, val) % cmat--- , t--- , val --

Cmat = squeeze(Cmat);

[i, j] = size(Cmat);

max = 0;
maxid = ones(1, 2);
secondMax = 0;
secondMaxid = ones(1, 2);

for i1 = 1:i
    for i2 = 1:j
        c = Cmat(i1, i2);
        if (val ~= -1 && c >= val) || t(i1, i2) ~= 0
            continue;
        end
        if c > max
            secondMax = max;
            max = c;
            secondMaxid = maxid;
            maxid = [i1, i2];
        elseif c > secondMax
            secondMax = c;
            secondMaxid = [i1, i2];
        end
    end
end

end

