function T0tilde = solve(fm, film_args, sub_args, Rth, ex_args, f0, X_probe)
arguments
    fm        (1,1) ForwardModel
    film_args (1,:) cell
    sub_args  (1,:) cell
    Rth       (:,:) double
    ex_args   (1,:) cell
    f0        (1,1,:) double
    X_probe   (:,2) double = [];
end
    [kf{1:6}] = fm.film.toTensor(film_args{1:fm.film.inputLen}, fm.exp_if_log);
    [Cf, af, Rf, hf] = getCaRh(fm, film_args(1+fm.film.inputLen:end));

    [ks{1:6}] = fm.substrate.toTensor(sub_args{1:fm.substrate.inputLen}, fm.exp_if_log);
    [Cs, as, Rs, hs] = getCaRh(fm, sub_args(1+fm.substrate.inputLen:end));

    Rth = fm.exp_if_log(Rth);

    sx = fm.exp_if_log(ex_args{1});
    sy = fm.exp_if_log(ex_args{2});
    P = fm.getP(ex_args);

    T0hat = fm.T0hat([ ...
        kf(:)', {Cf}, {af}, {Rf}, {hf}, ...
        ks(:)', {Cs}, {as}, {Rs}, {hs}, ...
        {Rth}, {sx}, {sy}, {P}, {f0}, ...
        {fm.solver.u}, {fm.solver.v} ...
    ]);

    T0tilde = fm.solver.solve(T0hat, X_probe);
end

function [C, a, R, h] = getCaRh(fm, args)
    C = fm.exp_if_log(args{1});
    a = fm.exp_if_log(args{2});
    R = fm.getR(args);
    h = fm.exp_if_log(args{end});
end