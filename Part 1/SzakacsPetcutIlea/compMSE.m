function [MSE] = compMSE(approx, trueVal)
MSE = 0;
for i=1:length(approx)
    MSE = MSE + (approx(i) - trueVal(i))^2;
end
MSE = MSE / length(approx);
end