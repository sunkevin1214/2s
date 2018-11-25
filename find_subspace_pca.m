function x1 = find_subspace_pca(input_data)
best_x = input_data;
x = best_x';
avg = mean(x, 1);
x = x - repmat(avg, size(x, 1), 1);
sigma = x*x'/size(x,1);
[~, S, ~] = svd(sigma);
s = diag(S);
v_list = cumsum(s)/sum(s);
select_i = 1;
while v_list(select_i) < 0.999
    select_i = select_i +1;
end
x1 = best_x;
avg1 = round(mean(x1, 1), 2);
x1(:, select_i+1:end) = repmat(avg1(select_i+1:end), size(x1, 1), 1);
end



