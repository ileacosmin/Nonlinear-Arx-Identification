function [phi] = compPhi(na,nb,u,y,powerMatrix)
phi = [];
for k = 1:length(u)
    elements = [];
    for i = 1:na
        if k - i > 0
            elements = [elements y(k-i)];
        else
            elements = [elements 0];
        end
    end
    for i = 1:nb
        if k - i > 0
            elements = [elements u(k-i)];
        else
            elements = [elements 0];
        end
    end
    aux = [];
    for i = 1:length(powerMatrix)
        aux = [aux prod(elements .^ powerMatrix(i,:))];
    end
    phi = [phi; aux];
end
end