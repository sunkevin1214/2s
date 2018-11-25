clc;clear;
addpath('./GA_for_final');

problem_list = {'DTLZ1_'};
k_list = [5];

global M;
M = 3;

for p_index = 1:numel(problem_list)
    problem = problem_list{p_index};
    k = k_list(p_index);
    x_dim = k + M - 1;
    l_limit = zeros(1, x_dim)';
    u_limit = ones(1, x_dim)';
    rf_list = diag(ones(1, M));
    % find the subspace
    load(sprintf('./Data/%s_%d.mat', problem, M));
    learned_data = find_subspace_pca(optimal_x);
    mean_val = mean(learned_data, 1);
    for i = 1:numel(mean_val)
        if abs(learned_data(1,i)-mean_val(i)) < 0.1
            l_limit(i) = round(mean_val(i), 1);
            u_limit(i) = round(mean_val(i), 1);
        end
    end
    rs_x = zeros(M,x_dim);
    rs_y = zeros(M, M);
    for j = 1:M
        [xmin, y_val] = GA(problem, x_dim, l_limit, u_limit, rf_list(j,:));
        rs_x(j,:) = round(xmin, 1);
        rs_y(j,:) = round(feval(problem, xmin), 1);
        fprintf('for %d, min value:%f\n', j, y_val);
    end
    nadir_save_data = [];
    nadir_save_data.x = rs_x;
    nadir_save_data.y = rs_y;
    nadir_save_file = sprintf('./Nadir_data/%s_%d.mat', problem, M);
    save(nadir_save_file, 'nadir_save_data');
end