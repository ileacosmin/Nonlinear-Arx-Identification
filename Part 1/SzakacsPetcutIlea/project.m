%MSE vectors
MSE_v = [];
MSE_i = [];

%variables we use to find the degree for minium MSE
MSE_previous = 100;
degree_min = 0;

%from output matrix to collumn vector
newY_id = matToVec(id.Y);
newY_val = matToVec(val.Y);

for degree=2:20

    %COMPUTE THETA
    phi = compPhi(id.X, degree);
    theta = phi \ newY_id;
    
    %approximation for identification set
    approxId = phi*theta;
    
    %approximation for validation set
    phi = compPhi(val.X, degree);
    approxVal = phi*theta;
    
    %compute MSEs for both sets
    MSE_id = compMSE(approxId, newY_id);
    MSE_val = compMSE(approxVal, newY_val);
    MSE_v = [MSE_v MSE_val];
    MSE_i = [MSE_i MSE_id];

    %finding the degree with the minimum mse
    if MSE_val < MSE_previous
        MSE_previous = MSE_val;
        degree_min = degree;
    end
end

degree = degree_min;

%COMPUTE THETA
phi = compPhi(id.X, degree);
theta = phi \ newY_id;

%approximation for identification set
approxId = phi*theta;

%approximation for validation set
phi = compPhi(val.X, degree);
approxVal = phi*theta;

%approximation from vector to matrix
approxIdMat = vecToMat(approxId, id.dims(1));
approxValMat = vecToMat(approxVal, val.dims(1));

%plot the approximation vs real values
f3 = figure;
movegui(f3, 'north');
surf(id.X{1}, id.X{2}, id.Y);
title("Identificaton set")

f4 = figure;
movegui(f4, 'south');
surf(id.X{1}, id.X{2}, approxIdMat);
title("Identification approx")

f5 = figure;
movegui(f5, 'northeast');
surf(val.X{1}, val.X{2}, val.Y);
title("Validation set")

f6 = figure;
movegui(f6, 'southeast');
surf(val.X{1}, val.X{2}, approxValMat);
title("Validation approx")

%plot the MSE for both sets;
f1 = figure;
hold on;
movegui(f1, 'northwest');
plot(2:20, MSE_v);
xlabel('degree');
ylabel('MSE');
title("The MSE for validation set");
hold off;

%plot the MSE;
f2 = figure;
hold on;
movegui(f2, 'southwest');
plot(2:20, MSE_i);
xlabel('degree');
ylabel('MSE');
title("The MSE for identification set");
hold off;