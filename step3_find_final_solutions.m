clc;clear;
addpath('./GA_for_final');
total_run = 1;
 problem_list = {'DTLZ1_'};
 k_list = [5];

global M;
M = 3;
for run=1:total_run
    for p_index = 1:numel(problem_list)
        problem = problem_list{p_index};
        k = k_list(p_index);
        x_dim = k + M - 1;
        l_limit = zeros(1, x_dim)';
        u_limit = ones(1, x_dim)';
        load(sprintf('./Data/%s_%d.mat', problem, M));
        learned_data = optimal_x;
        mean_val = mean(learned_data, 1);
        for i = 1:numel(mean_val)
            if abs(learned_data(1,i)-mean_val(i)) < 0.1
                l_limit(i) = round(mean_val(i), 1);
                u_limit(i) = round(mean_val(i), 1);
            end
        end
        % calculate ideal and nadir point
        load(sprintf('./Nadir_data/%s_%d.mat', problem, M));
        ideal_point = min(nadir_save_data.y, [], 1);
        nadir_point = max(nadir_save_data.y, [], 1);
        load(sprintf('./uniform_sampling/obj%d.mat', M));
        new_rf = normalize_weight(w, ideal_point, nadir_point);
        final_x = zeros(size(w, 1), x_dim);
        final_y = zeros(size(w, 1), M);
        for i = 1:size(new_rf,1)
            [xmin, y_val] = GA(problem, x_dim, l_limit, u_limit, new_rf(i,:));
            final_x(i,:) = xmin;
            final_y(i,:) = feval(problem, xmin);
            fprintf('for %d/%d, min value:%f\n', i,size(new_rf,1), y_val);
        end
        final_data  = [];
        final_data.x = final_x;
        final_data.y = final_y;
        save_file_name = sprintf('./final_data/%s%d_%d.mat', problem, M,run);
        save(save_file_name, 'final_data');
    end
end