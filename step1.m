clc;clear;close all;
addpath('./funcs/');
addpath('./uniform_sampling/');
addpath('./GA/');

func_names = {'DTLZ1_'};
k_names = [5];
obj_names = [3];
for i = 1:numel(func_names)
    func = func_names{i};
    k = k_names(i);
    for q = 1:numel(obj_names)
        y_dim = obj_names(q);
         x_dim = y_dim + k - 1;
         l_bound = zeros(x_dim, 1);
         u_bound = ones(x_dim, 1);
        main(func, x_dim, y_dim, l_bound, u_bound);
    end
end