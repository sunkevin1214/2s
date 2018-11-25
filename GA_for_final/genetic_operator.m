function f  = genetic_operator(parent_chromosome, V, mu, mum, l_limit, u_limit, benchmark, crossover_rate, mutation_rate, rf)
% parent_chromosmome ����solutions��parents
% M ��Ŀ�����
% V �Ǿ��߱�������
% mu, mum, distribution indeices for crossover and mutation
% l_limit, u_limit, the lower and upper bound of the decision variables
% benchmark, handle of the function
% crossover_rate, mutation_rate, just as the variable name indicates

N = size(parent_chromosome, 1);

for i = 1:2:N
    rnd = rand();
    par1_index1 = randperm(N, 1);
    par1_index2 = randperm(N, 1);
    while par1_index2 == par1_index1
        par1_index2 = randperm(N);
    end
    if parent_chromosome(par1_index1, end) < parent_chromosome(par1_index2, end)
        par1_index = par1_index1;
    elseif parent_chromosome(par1_index1, end) < parent_chromosome(par1_index2, end)
        par1_index = par1_index2;
    else
        temp_index = [par1_index1 par1_index2];
        par1_index = temp_index(randperm(2, 1));
    end

    par2_index1 = randperm(N, 1);
    par2_index2 = randperm(N, 1);
    while par2_index2 == par2_index1
        par2_index2 = randperm(N);
    end
    if parent_chromosome(par2_index1, end) < parent_chromosome(par2_index2, end)
        par2_index = par2_index1;
    elseif parent_chromosome(par2_index1, end) < parent_chromosome(par2_index2, end)
        par2_index = par2_index2;
    else
        temp_index = [par2_index1 par2_index2];
        par2_index = temp_index(randperm(2, 1));
    end
    if rnd<=crossover_rate
        for j = 1:V
            % selected two parents
            
            par1 = parent_chromosome(par1_index, j);
            par2 = parent_chromosome(par2_index, j);
            yl = l_limit(j);
            yu = u_limit(j);
            rnd = rand();
            % chech whether variable is selected or not
            if rnd <= 0.5
                if abs(par1-par2)>0.000001
                    if par2 > par1
                        y2 = par2;
                        y1 = par1;
                    else
                        y2 = par1;
                        y1 = par2;
                    end
                    % find beta
                    if (y1-yl)>(yu-y2)
                        beta = 1+(2*(yu-y2)/(y2-yl));
                    else
                        beta = 1+(2*(y1-yl)/(y2-y1));
                    end
                    % find alpha
                    expp = mu + 1;
                    beta = 1.0/beta;
                    alpha = 2.0 - power(beta, expp);
                    if alpha <0
                        error('ERROR');
                    end
                    rnd = rand();
                    if rnd <=1.0/alpha
                        alpha = alpha*rnd;
                        expp = 1.0/(mu+1.0);
                        betaq = power(alpha, expp);
                    else
                        alpha = alpha*rnd;
                        alpha = 1.0/(2.0-alpha);
                        expp = 1/(mu+1.0);
                        if alpha < 0.0
                            error('ERROR');
                        end
                        betaq = power(alpha, expp);
                    end
                    chld1 = 0.5*((y1+y2)-betaq*(y2-y1));
                    chld2 = 0.5*((y1+y2)+betaq*(y2-y1));
                else
                    betaq = 1.0;
                    y1 = par1;
                    y2 = par2;
                    chld1 = 0.5*((y1+y2)-betaq*(y2-y1));
                    chld2 = 0.5*((y1+y2)+betaq*(y2-y1));
                end
                if chld1 < yl
                    chld1 = yl;
                end
                if chld1 > yu
                    chld1 = yu;
                end
                if chld2 < yl
                    chld2 = yl;
                end
                if chld2 > yu
                    chld2 = yu;
                end
            else
                chld1 = par1;
                chld2 = par2;
            end
            parent_chromosome(par1_index, j) = chld1;
            parent_chromosome(par2_index, j) = chld2;
        end
        child(i, 1:V) = parent_chromosome(par1_index, 1:V);
        child(i+1, 1:V) = parent_chromosome(par2_index, 1:V);
        
        child(i,V + 1) = feval('cos_v_func',rf, child(i, 1:V), benchmark);
        child(i+1,V + 1) = feval('cos_v_func',rf, child(i+1, 1:V), benchmark);
    else
        child(i, 1:V+1) = parent_chromosome(par1_index, 1:V+1);
        child(i+1, 1:V+1) = parent_chromosome(par2_index, 1:V+1);
    end
end

%% mutation
for j = 1:N
    for i=1:V
        rnd = rand();
        if rnd <= mutation_rate
            y = child(j, i);
            yl = l_limit(i);
            yu = u_limit(i);
            if y > yu
                if (y-yl)<(yu-yl)
                    delta = (y-yl)/(yu-yl);
                else
                    delta = (yu-y)/(yu-yl);
                end
                rnd = rand();
                indi = 1.0/(mum+1.0);
                if rnd <= 0.5
                    xy = 1.0-delta;
                    val = 2*rnd+(1-2*rnd)*(power(xy, mum+1));
                    deltaq = power(val, indi)-1.0;
                else
                    xy = 1.0 - delta;
                    val = 2.0*(1.0-rnd)+2.0*(rnd-0.5)*(power(xy, mum+1));
                    deltaq = 1.0 - power(val, indi);
                end
                y = y+deltaq*(yu-yl);
                if y < yl
                    y = yl;
                end
                if y > yu
                    y = yu;
                end
            else
                xy = rand();
                y = xy*(yu-yl)+yl;
            end
            child(j, i) = y;
        end  
        
    
    child(j,V + 1) = feval('cos_v_func',rf, child(j, 1:V), benchmark);
end

f = child;
end