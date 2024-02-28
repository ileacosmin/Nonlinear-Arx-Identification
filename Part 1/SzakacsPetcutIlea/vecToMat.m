function [matrix] = vecToMat(vector, dimension)
matrix = [];
for i = 1:length(vector)
    if mod(i, dimension) == 0
        matrix = [matrix; vector(i-dimension+1:i)'];
    end
end