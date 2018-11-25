function new_w = normalize_weight(w, ideal_point, nadir_point)
    new_w = w.*repmat(nadir_point-ideal_point, size(w, 1), 1)+repmat(ideal_point, size(w, 1), 1);
end