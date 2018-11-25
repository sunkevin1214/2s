function y = weight_DTLZ1_(x, w)
    f = DTLZ1_(x);
    y = sum(f.*w);
end