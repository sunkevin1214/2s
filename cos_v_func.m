function v= cos_v_func(rf, x, problem)
    y = feval(problem, x);
    r1 = sum(rf.*y);
    r2 = sqrt(sum(rf.^2));
    r3 = sqrt(sum(y.^2));
    v = -r1/(r2*r3); % convert to a minimization problem
end