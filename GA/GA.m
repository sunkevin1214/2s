 function [ xmin, x] = GA( fun_handle, x_dim, l_limit, u_limit, weights)
    global M;
    pop_size = 40;
    max_gen = 1000;
    V = x_dim;
    l_limit = l_limit';
    u_limit = u_limit';
    populations = rand(pop_size, V).*repmat(u_limit-l_limit, pop_size, 1) + repmat(l_limit, pop_size, 1);
    chromosomes = zeros(pop_size, V+1);
    chromosomes(:, 1:V) = populations;
    x = [];
%     weights = rand(1, M);
%     weights = weights./sqrt(sum(weights.^2));
    for i = 1:pop_size
        chromosomes(i, end) = feval(['weight_', fun_handle],chromosomes(i, 1:V), weights(1,:));
        %chromosomes(i, end) = feval(['weight_', fun_handle],chromosomes(i, 1:V), weights);
    end
     num_weights = size(weights, 1);
    for gen=1:max_gen
        
        weight_index = mod(gen+1, num_weights);
        if weight_index == 0
            weight_index = num_weights;
        end
        weight = weights(weight_index, :);
%         weights = rand(1, M);
%         weight = weights./sqrt(sum(weights.^2));
        fprintf('%d, w1:%f,w2:%f...\n',gen, weight(1), weight(2));
        parent_chromosome = chromosomes;
        % generate offspring
        offspring_chromosome = ...
                genetic_operator(parent_chromosome, ...
                V, 20, 20, l_limit, u_limit, fun_handle, 0.9, 1/V, weight);
        combine_chromosome = [chromosomes; offspring_chromosome];
        obj_list = zeros(size(combine_chromosome, 1), M);
        for j = 1:size(combine_chromosome, 1)
            obj_list(j, :) =  feval(fun_handle, combine_chromosome(j, 1:end-1));
        end
        front = ENS_BS(obj_list);
        f1 = front{1};
        f1_obj = obj_list(f1, :);
%         if M == 2
%             scatter(f1_obj(:,1), f1_obj(:,2));
%             drawnow;
%         end
%         if M == 3
%              hold on;
%             scatter3(f1_obj(:,1), f1_obj(:,2), f1_obj(:,3));
%             drawnow;
%         end
         
        temp = [];
        p = 0;
        q = 0;
        while p < pop_size
             q = q+1;
             p =  p + numel(front{q});
             
        end
        if p == pop_size
           for q1 = 1:q
            temp = [temp; combine_chromosome(front{q1}, 1:end)];
           end
        end
         
        if p > pop_size
            for q1 = 1:q-1
               temp = [temp; combine_chromosome(front{q1}, 1:end)];
            end
            extra = combine_chromosome(front{q}, 1:end);
            temp = [temp; extra(1:pop_size-size(temp, 1), :)];
        end
        
        chromosomes = temp;      
        x = [x; combine_chromosome(front{1}, 1:end-1)];
        
        if gen > 2
            x_obj = zeros(size(x, 1), M);
            for j = 1:size(x_obj, 1)
                x_obj(j, :) =  feval(fun_handle, x(j, 1:end-1));
            end
            x_front = ENS_BS(x_obj);
            x_f1 = x_front{1};
            x_f1_obj = x_obj(x_f1, :);
            x = x(x_f1, :);
         end

    end
    xmin = [];
end

