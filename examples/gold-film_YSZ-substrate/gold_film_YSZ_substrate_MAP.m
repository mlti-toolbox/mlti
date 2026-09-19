clear; clc;

x = DesignVariable(5*ones(34,1));
nl_posterior(x)

function out = nl_posterior(x)
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

mu_lnkf     = 4.14;      mu_lnks = mu_lnkf;
mu_lnCf     = 0.9962;    mu_lnCs = mu_lnCf;
mu_lnhf     = -1.93;
mu_lnell    = 5.957;
mu_lnkappaT = 6.466;

lnsigma_lnkf   = 0.5*log(1.197);  lnsigma_lnks = lnsigma_lnkf;
lnsigma_lnCf   = 0.5*log(0.4305); lnsigma_lnCs = lnsigma_lnCf;
sigma_lnhf     = sqrt(0.0345);
sigma_lnell    = sqrt(0.503);
sigma_lnkappaT = sqrt(1.806);

% Ψ(θ)
psi_lnell = nln(lnell, mu_lnell, sigma_lnell, true);

% Ψ(lnkf|θ1)
psi_lnkf = nl_mvn_cov( ...
    lnkf(:), ...
    mu_lnkf*ones(size(T)), ...
    RBFKernel(T,T,lnsigma_lnkf,lnsigma_lnkf,lnell.at(1)) ...
);

% Ψ(lnCf|θ2)
psi_lnCf = nl_mvn_cov( ...
    lnCf(:), ...
    mu_lnCf*ones(size(T)), ...
    RBFKernel(T,T,lnsigma_lnCf,lnsigma_lnCf,lnell.at(2)) ...
);

% Ψ(lnks|θ3)
psi_lnks = nl_mvn_cov( ...
    lnks(:), ...
    mu_lnks*ones(size(T)), ...
    RBFKernel(T,T,lnsigma_lnks,lnsigma_lnks,lnell.at(3)) ...
);

% Ψ(lnCs|θ4)
psi_lnCs = nl_mvn_cov( ...
    lnCs(:), ...
    mu_lnCs*ones(size(T)), ...
    RBFKernel(T,T,lnsigma_lnCs,lnsigma_lnCs,lnell.at(4)) ...
);

% Ψ(lnhf)
psi_lnhf = nln(lnhf, mu_lnhf, sigma_lnhf);

% Ψ(lnkappaT)
psi_lnkappaT = nln(lnkappaT, mu_lnkappaT, sigma_lnkappaT);

% Ψ(ϕ|x)
fm = ForwardModel("iso", "iso", true);
[] = fm.solve
psi_phi = nll

end