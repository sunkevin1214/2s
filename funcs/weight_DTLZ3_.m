function y = weight_DTLZ3_(x, w)
    f = DTLZ3_(x);
    y = sum(f.*w);
end