clear; clc;

[mu_lnkf, sigma_lnkf] = mode_S_2_mu_sigma(15, 30, 0.95);
mu_lnks_perp = mu_lnkf; sigma_lnks_perp = sigma_lnkf;
mu_lnks_par = mu_lnkf; sigma_lnks_par = sigma_lnkf;
[mu_lnCf, sigma_lnCf] = mode_S_2_mu_sigma(2.25, 2.5, 0.95);
mu_lnCs = mu_lnCf; sigma_lnCs = sigma_lnCf;
[mu_lnhf, sigma_lnhf] = mode_S_2_mu_sigma(0.145, 1.07, 0.95);
[mu_lnell, sigma_lnell] = mode_S_2_mu_sigma(300, 3, 0.95);
[mu_lnsigmaT, sigma_lnsigmaT] = mode_S_2_mu_sigma(deg2rad(1), 10, 0.95);
mu_lnkappaT = -2*mu_lnsigmaT; sigma_lnkappaT = 2*sigma_lnsigmaT;
Qs = [0,1,0
      1,0,0
      0,0,1];
Okappas = ones(2,1)./deg2rad(20)^2;

lnaf = log(72.4);
lnas = log(15.84);
logitRf = -inf;
logitRs = -inf;
P = 1000;
sx = 2;
sy = 2;
lnRth = -inf;

save("isouniex_constants.mat", ...
    "mu_lnkf", "mu_lnks_perp", "mu_lnks_par", "mu_lnCf", "mu_lnCs", "mu_lnhf", ...
    "mu_lnell", "mu_lnkappaT", ...
    "sigma_lnkf", "sigma_lnks_perp", "sigma_lnks_par", "sigma_lnCf", "sigma_lnCs", "sigma_lnhf", ...
    "sigma_lnell", "sigma_lnkappaT", "Qs", "Okappas", ...
    "lnaf", "lnas", "logitRf", "logitRs", "P", "sx", "sy", "lnRth");

function [mode, S] = mu_sigma_2_mode_S(mu, sigma, alpha)
    mode = exp(mu-sigma.^2);
    S = get_logN_HDI_param(sigma=sigma, alpha=alpha);
end

function [mu, sigma] = mode_S_2_mu_sigma(mode, S, alpha)
    sigma = get_logN_HDI_param(S=S, alpha=alpha);
    mu = log(mode) + sigma.^2;
end