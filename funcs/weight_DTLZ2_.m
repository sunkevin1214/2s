function y = weight_DTLZ2_(x, w)
    f = DTLZ2_(x);
    y = sum(f.*w);
end