function main(func_name, x_dim, y_dim, l_bound, u_bound)
weight_file = sprintf('obj%d.mat', y_dim);
load(weight_file);
temp_w = w;
num = size(temp_w, 1);
re_index = num:-1:1;
temp_w1 = temp_w(re_index,:);
unform_weight = [temp_w; temp_w1];
global M;
M  = y_dim;

[xmin, all_solutions] = GA(func_name, x_dim, l_bound, u_bound, unform_weight);
objs = zeros(size(all_solutions, 1), y_dim);
for i = 1:size(all_solutions, 1)
    objs(i,:) = feval(func_name, all_solutions(i,:));
end
fronts = ENS_BS(objs);
optimal_solutions = objs(fronts{1}, :);
optimal_x = all_solutions(fronts{1}, :);
file_name = sprintf('Data/%s_%d', func_name, M);
save(file_name, 'optimal_x');
if size(optimal_solutions, 2) == 2
    scatter(optimal_solutions(:,1), optimal_solutions(:,2));
elseif size(optimal_solutions, 2) == 3
    scatter3(optimal_solutions(:,1), optimal_solutions(:,2), optimal_solutions(:,3));
end