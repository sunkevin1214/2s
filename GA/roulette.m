function index = roulette(fitness)
% fitness should be feed with the order of from large to small (for minimization problem)
    fitness = fitness(numel(fitness):-1:1);
    sum_fitness = sum(fitness);
    if sum_fitness < 1e-10
        error('sum of fitness is zero\n');
    end
    prob = fitness/sum_fitness;
    new_pro = cumsum(prob);
    a = rand();
    index = 1;
    while new_pro(index) < a
        index = index + 1;
    end
end