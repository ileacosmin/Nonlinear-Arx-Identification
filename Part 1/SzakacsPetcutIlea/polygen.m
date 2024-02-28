function [x] = polygen(polydegree, x1, x2)
i = 1;
x = [1];
while i < polydegree
    j = 0;
    while j <= i && i+j <= polydegree
        x = [x x1.^i .* x2.^j];
        if i ~= j
            x = [x x1.^j .* x2.^i];
        end
        j = j + 1;
    end
    i = i + 1;
end
j = 0;
x = [x x1.^i .* x2.^j];
x = [x x1.^j .* x2.^i];  
end