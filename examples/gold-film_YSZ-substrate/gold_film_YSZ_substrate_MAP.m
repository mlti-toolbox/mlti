clear; clc;

x = DesignVariable(500*ones(34,1));
nl_prior(x)

function [psi, Jac] = nl_prior(x)
arguments
    x (1,1) DesignVariable
end
lnkf = reshape(x.at(1:7),  1, 1, []);
lnCf = reshape(x.at(8:14), 1, 1, []);
lnhf = x.at(15);
lnks = reshape(x.at(16:22), 1, 1, []);
lnCs = reshape(x.at(23:29), 1, 1, []);
lnkappaT = x.at(30);
lnell = reshape(x.at(31:34), [], 1);

T = (300:100:900).';

mu_lnkf   = 4.14;      mu_lnks = mu_lnkf;
mu_lnCf   = 0.9962;     mu_LnCs = mu_lnCf;
mu_lnhf   = -1.93;
mu_lnell  = 5.957;
mu_kappaT = 6.466;

lnsigma_lnkf  = 0.5*log(1.197);  lnsigma_lnks = lnsigma_lnkf;
sigma2_lnCf   = 0.4305; sigma2_LnCs = sigma2_lnCf;
sigma2_lnhf   = 0.0345;
sigma2_lnell  = 0.503;
sigma2_kappaT = 1.806;

% Ψ(θ)
[psi_lnell, jac_lnell] = nln(lnell, mu_lnell, sqrt(sigma2_lnell), true);

% Ψ(M|θ)
[psi_lnkf, jac_lnkf] = nl_mvn_cov( ...
    lnkf, ...
    mu_lnkf*ones(size(T)), ...
    RBFKernel(T,T,lnsigma_lnkf,lnsigma_lnkf,lnell.at(1)) ...
);
 
end