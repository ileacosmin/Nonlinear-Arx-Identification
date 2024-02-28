function [phi] = compPhi(cellArray, degree)
phi = [];
for i = 1:length(cellArray{1})
    for j = 1:length(cellArray{2})
        phi = [phi; polygen(degree, cellArray{1}(i), cellArray{2}(j))];
    end
end
end