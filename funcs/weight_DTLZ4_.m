function y = weight_DTLZ4_(x, w)
    f = DTLZ4_(x);
    y = sum(f.*w);
end