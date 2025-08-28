function tests()
    %% 1: isotropic; input: k, C, a, R, h
    obj = Layer("iso");
    k = rand; C = rand; a = rand; R = rand; h = rand;
    [K11, K21, K31, K22, K32, K33, C, a, R, h] = obj.canonize(k, C, a, R, h);
    assert(K11 == k, K21 == 0, K31 == 0, K22 == k, K32 == 0, K33 == k, ...
        "Error in getFirst6");
    assert(C==C, a==a, R==R, h==h, ...
        "Error in getLast4");

    %% 2: too many inputs
    try
        obj.canonize(k, C, a, R, h, 3);
        error("Did not fail with too many inputs.")
    catch
    end

    %% 3: insufficient inputs
    try
        obj.canonize(k, C, a, R);
        error("Did not fail with insufficient inputs.")
    catch
    end


end