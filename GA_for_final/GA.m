 function [ xmin, y_val] = GA( fun_handle, x_dim, l_limit, u_limit, rf)
    pop_size = 40;
    max_gen = 500;
    V = x_dim;
    l_limit = l_limit';
    u_limit = u_limit';
    populations = rand(pop_size, V).*repmat(u_limit-l_limit, pop_size, 1) + repmat(l_limit, pop_size, 1);
    chromosomes = zeros(pop_size, V+1);
    chromosomes(:, 1:V) = populations;
    for i = 1:pop_size
        chromosomes(i, end) = feval('cos_v_func',rf, chromosomes(i, 1:V), fun_handle);
    end
    
    for gen=1:max_gen
        
        parent_chromosome = chromosomes;
        % generate offspring
        offspring_chromosome = ...
                genetic_operator(parent_chromosome, ...
                V, 20, 20, l_limit, u_limit, fun_handle, 0.9, 1/V, rf);
        
        % select the best
        combine_chromosome = [chromosomes; offspring_chromosome];
        combine_fitness = combine_chromosome(:, end);
        [~, I] = sort(combine_fitness);
        chromosomes = combine_chromosome(I(1:pop_size), :);
        xmin = chromosomes(1,1:end-1);
        y_val = chromosomes(1, end);
        %if mod(gen, 100) == 0
            %fprintf('%d/%d, cos:%f\n', gen, max_gen, y_val);
        %end
    end
    

end

