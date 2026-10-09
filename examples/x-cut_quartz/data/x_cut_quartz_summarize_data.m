clear; clc;

load x-cut_quartz_data_reps.mat

[Nprobe, N, n, Nf, Nrep] = size(phi_obs);
mu = circular_mean(phi_obs, ndims(phi_obs));
Rbar = R(phi_obs, ndims(phi_obs))./Nrep;
kappa = get_kappa(Rbar);
kappa_mu = Nrep.*Rbar.*kappa;

save("x-cut_quartz_data_stats.mat", "mu", "Rbar", "kappa", "kappa_mu", "f", "Xprobe", "Sxx", "Syy", "Sxy")

function out = circular_mean(x, dim)
    s = sin(x);
    c = cos(x);
    out = atan2(sum(s, dim), sum(c, dim));
end

function out = R(x, dim)
    s = sum(sin(x), dim);
    c = sum(cos(x), dim);
    out = sqrt(c.^2+s.^2);
end

function kappas = get_kappa(Rbar)
    kappas = zeros(numel(Rbar), 1);
    for i = 1:numel(Rbar) 
        kappas(i) = fzero(@(x) besseli(1, x, 1)./besseli(0, x, 1) - Rbar(i), 100);
    end
    kappas = reshape(kappas, size(Rbar));
end