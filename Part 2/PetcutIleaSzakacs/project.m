%|   Nonlinear ARX Identification  |
%|---------------------------------|
%|      Petcuț Adrian-Axente       |
%|---------------------------------|
%|       Ilea Cosmin-Ionuț         |
%|---------------------------------|
%|     Szakacs Armand-Antonio      |
%|---------------------------------|
%| SYSTEM IDENTIFICATION 2023-2024 |
%|            TUCN                 |
%|        Project part 2           |
%|---------------------------------|

clear all;
close all;
clc;

load("iddata-11.mat");

% choosing the parameters
na_max=3;
nb_max=3;
m_max=4;

% the time vectors
Ts=id.Ts;
t_id = id_array(:,1);
t_val = val_array(:,1);

% the input and output of the identification data
u_id = id_array(:,2);
y_id = id_array(:,3);

% the input and output of the validation data
u_val = val_array(:,2);
y_val = val_array(:,3);

% declaring the MSE matrices 
mse_prediction_matrix=zeros(na_max*nb_max, m_max);
mse_simulation_matrix=zeros(na_max*nb_max, m_max);
mse_simulation_min=1e200;

for m=1:m_max
    for na=1:na_max
        for nb=1:nb_max
        % generation the matrix with powers
        pow_matrix = powerGen(na+nb, m);

        % computing phi for identification data
        phi_id = compPhi(na, nb, u_id, y_id, pow_matrix);
    
        % computing theta
        theta = phi_id\y_id;

        % computing phi for validation data
        phi_val = compPhi(na, nb, u_val, y_val, pow_matrix);
    
        % the one step ahead prediction for validation
        y_hat_val = phi_val * theta;

        % computing the simulation for validation
        y_sim_val = compYSim(na, nb, u_val, pow_matrix, theta);

        % computing the MSE for prediction
        mse_prediction = compMSE(y_hat_val, y_val);
    
        % computing the MSE for simulation
        mse_simulation = compMSE(y_sim_val, y_val);
        
        % save the MSE values in matrices (each collum represents a value
        % of m)
        mse_prediction_matrix((na-1)*nb_max + nb, m) = mse_prediction;
        mse_simulation_matrix((na-1)*nb_max + nb, m) = mse_simulation;
            if mse_simulation<mse_simulation_min
                mse_prediction_min = mse_prediction;
                mse_simulation_min = mse_simulation;
                na_best_fit = na;
                nb_best_fit = nb;
                m_best_fit = m;
            end
        end
    end
end

%get the best MSE depending on na and nb
na = na_best_fit;
nb = nb_best_fit;
m = m_best_fit;

% generation the matrix with powers
pow_matrix = powerGen(na+nb, m);
phi_id = compPhi(na, nb, u_id, y_id, pow_matrix);
  
% computing theta
theta = phi_id\y_id;

% computing phi for validation data
phi_val = compPhi(na, nb, u_val, y_val, pow_matrix);
    
% the one step ahead prediction for validation
y_hat_val = phi_val * theta;

% computing the simulation for validation
y_sim_val = compYSim(na, nb, u_val, pow_matrix, theta);

% computing the simulation for identification
y_sim_id = compYSim(na, nb, u_id, pow_matrix, theta);

% the one step ahead prediction for identification
y_hat_id = phi_id * theta;

% computing the MSE for prediction
mse_prediction_id = compMSE(y_hat_id, y_id);
    
% computing the MSE for simulation
mse_simulation_id = compMSE(y_sim_id, y_id);
        

f1 = figure;
movegui(f1, 'northwest');
id_hat = iddata(y_hat_id,u_id,Ts);
compare(id,id_hat);
title("Prediction for identification set");

f2 = figure;
movegui(f2, 'southwest');
val_hat = iddata(y_hat_val,u_val,Ts);
compare(val,val_hat);
title("Prediction for validation set");

f3 = figure;
movegui(f3, 'northeast');
id_sim = iddata(y_sim_id,u_id,Ts);
compare(id,id_sim);
title("Simulation for identification set");

f4 = figure;
movegui(f4, 'southeast');
val_sim = iddata(y_sim_val,u_val,Ts);
compare(val,val_sim);
title("Simulation for validation set");


f5 = figure;
movegui(f5, 'north')
% taking the collum with the best MSE from mse_simulation matrix and
% computing matrix z (rows represent values for na and collums for nb)
vect = mse_simulation_matrix(:, m_best_fit)';
z = [];
for i = 1:na_max
    z = [z; vect((i-1)*na_max+1:i*na_max)];
end
bar3(z);
xlabel('nb'); 
ylabel('na'); 
zlabel('MSE'); 
title(['Degree= ' num2str(m_best_fit)]);