function [vec] = matToVec(matrix)
vec = [];
for i = 1:length(matrix)
    vec = [vec matrix(i,:)];
end
vec = vec';
end