function [y_sim] = compYSim(na, nb, u, PowerMatrix, theta)
y_sim = zeros(length(u),1);

for k = 1:length(u)
    line = [];
    for i = 1:na
        if k - i > 0
            line = [line y_sim(k-i)];
        else
            line = [line 0];
        end
    end
    for i = 1:nb
        if k - i > 0
            line = [line u(k-i)];
        else
            line = [line 0];
        end
    end
    aux = [];
    for i = 1:length(PowerMatrix)
        aux = [aux prod(line .^ PowerMatrix(i,:))];
    end
    y_sim(k) = aux * theta;
end
end