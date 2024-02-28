function [power_mat] = powerGen(no_inputs, power)
power_mat = [];
aux = zeros(1,no_inputs);
power_mat = aux;
aux(no_inputs) = 1;
power_mat = [power_mat; aux];
while aux(1) ~= power
    sum_aux = sum(aux);
    changed = 0;
    i = length(aux);
    while changed == 0
        if sum_aux < power
            aux(i) = aux(i) + 1;
            changed = 1;
        else
            found = 0;
            while found == 0
                aux(i) = 0;
                aux(i-1) = aux(i-1) + 1;
                sum_aux = sum(aux);
                if sum_aux <= power
                    found = 1;
                else
                    i = i - 1;
                end
            end
            changed = 1;
        end
    end
    power_mat = [power_mat; aux];
end
end