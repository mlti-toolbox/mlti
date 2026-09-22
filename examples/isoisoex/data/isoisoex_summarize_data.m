clear; clc;

load isoisoex_data_corrupted.mat
Ntrials = numel(phi_obs);
mu     = cell(Ntrials,1);
kappaD = cell(Ntrials,1);
for a = 1:Ntrials
    [Nprobe, N, n, Nf, Nrep] = size(phi_obs{a});
    mu{a} = circular_mean(phi_obs{a}, ndims(phi_obs{a}));
    nl_vM(phi_obs{a}, mu{a}, 100), ndims(phi_obs{a});
    kappa = fminunc(@(x) nl_vM(phi_obs{a}, mu{a}))

    kappaD{a} = zeros(Nprobe,N,n,Nf);
    for i = 1:N
        for j = 1:n
            for k = 1:Nf
                for l = 1:Nprobe
                    % x = fmincon(@(x) format4optim(@(xi) sum(nl_vM(phi_obs{:}(i,j,k,l,:), x(1), x(2))), [0, 100], [],[],[],[],[-pi,0],[pi,inf]);
                    mu{a}(i,j,k,l) = x(1);
                    kappaD{a}(i,j,k,l) = x(2);
                end
            end
        end
    end
    
    for i = randperm(N,3)
        j = 1;
        for k = randperm(Nf,3)
            for l = randperm(Nprobe,3)
                clf
                histogram(iso_phi_noisy(i,j,k,l,:), Normalization="pdf")
                hold on;
                x = linspace(min(iso_phi_noisy(i,j,k,l,:)), max(iso_phi_noisy(i,j,k,l,:)), 201);
                plot(x, exp(-vM(x,mu(i,j,k,l), kappaD(i,j,k,l))), LineWidth=2)
                drawnow;
                pause(1)
            end
        end
    end
end

save("isoisoex_data_stats.mat", "phi_obs", "kappaD", "T", "f", "Xprobe")

function mu = circular_mean(x, dim)

    if nargin < 2
        dim = find(size(x) ~= 1, 1);
        if isempty(dim)
            dim = 1;
        end
    end

    mu = atan2(sum(sin(x), dim), sum(cos(x), dim));

end