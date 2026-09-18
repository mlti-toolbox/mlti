clear; clc;

rehash

x = DesignVariable(1:7,1:7,8);
newRootLen(x, 20)
mu = 4;
T = (3:9).';
sigma = 1;
ell = DesignVariable(1, 9, 10);
[psi, Jac] = nl_GP_prior(x, mu, T, sigma, ell);

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

[psi_lnell, Jac_lnell] = nln(lnell, 5.957, 0.503);
psi_lnell = sum(psi_lnell); Jac_lnell = sum(Jac_lnell, 1);

[K_lnkf, Jac_K_lnkf] = RBFKernel(T,T,1.197,1.197,lnell.at(1))
[psi_lnkf, Jac_lnkf] = nl_mvn_cov(lnkf, 4.14, RBFKernel())
end

function [psi, Jac] = nl_GP_prior(x, mu, T, sigma, ell)
    if nargout < 2
        K = RBFKernel(T,T,sigma,sigma,ell);
        psi = nl_mvn_cov(x, mu, K);
    else
        [K, Jac1] = RBFKernel(T,T,sigma,sigma,ell);
        if isempty(Jac1)
            [psi, Jac] = nl_mvn_cov(x, mu, K);
        else
            [N2, Nz] = size(Jac1);
            inputs = { ...
                newRootLen(x, Nz+N2), ...
                newRootLen(mu, Nz+N2), ...
                DesignVariable(K, reshape(Nz+1:Nz+N2, size(K)), Nz+N2) ...
            };
            [psi, Jac2] = nl_mvn_cov(inputs{:});
            Jac = Jac2 * [eye(Nz);Jac1];
        end
    end
end