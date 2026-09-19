clear; clc;

%% LOAD DATA
load("iso_data_stats.mat");
data.f = f;
data.Xprobe = Xprobe;
N = length(T);

%% Initial Guess: x0
lnkf = [4.6606, 4.6407, 4.6199, 4.5980, 4.5751, 4.5510, 4.5257];
lnCf = [0.9133, 0.9223, 0.9344, 0.9490, 0.9653, 0.9828, 1.0007];
lnhf = log(0.15);
lnks = [0.6625, 0.6689, 0.6797, 0.6940, 0.7112, 0.7304, 0.7510];
lnCs = [1.0217, 1.1174, 1.1847, 1.2319, 1.2645, 1.2865, 1.3008];
lnkappaT = log(3000);
lnell = log(600)*ones(1,4);

options = optimoptions("fminunc", Display="iter-detailed", ...
    SpecifyObjectiveGradient=true, ...
    FiniteDifferenceType="central", ...
    StepTolerance=1e-10, FunctionTolerance=1e-10);

%% WARM START
err_ind = cell(N, 1);
x_ind = cell(N,1);
fval_ind = cell(N,1);
exitflag_ind = cell(N,1);
output_ind = cell(N,1);
grad_ind = cell(N,1);
hessian_ind = cell(N,1);
for i = 1:N
    x0 = [lnkf(i), lnCf(i), lnhf, lnks(i), lnCs(i), lnkappaT];
    data.T = T(i);
    data.phi_obs = phi_obs(:,i,:,:);
    data.kappaD = kappaD(:,i,:,:);
    obj_fun = @(x) format_output_for_checkGradients( ...
        @(xi) nl_posterior( ...
            xi(1), xi(2), xi(3), ...
            xi(4), xi(5), xi(6), ones(4,1), data ...
        ), DesignVariable(x) ...
    );
    [~, err_ind{i}] = checkGradients(obj_fun, x0, options, "Display","on");
    [ ...
        x_ind{i}, fval_ind{i}, exitflag_ind{i}, ...
        output_ind{i}, grad_ind{i}, hessian_ind{i} ...
    ] = fminunc(obj_fun, x0, options);
end

%% FULL OPTIMIZATION
x0 = horzcat(x_ind{:});
data.T = T;
data.phi_obs = phi_obs;
data.kappaD = kappaD;
obj_fun = @(x) format_output_for_checkGradients( ...
    @(xi) nl_posterior( ...
        xi(1:7), ...
        xi(8:14), ...
        xi(15), ...
        xi(16:22), ...
        xi(23:29), ...
        xi(30), ...
        xi(31:34), ...
        data ...
    ), DesignVariable(x) ...
);
[~, err] = checkGradients(obj_fun, x0, options, "Display","on");
[x,fval,exitflag,output,grad,hessian] = fminunc(obj_fun, x0, options);

save("examples\gold-film_YSZ-substrate\gold-film_YSZ-substrate_MAP_results.mat", ...
    "err", "x", "fval", "exitflag", "output", "grad", "hessian", ...
    "err_ind", "x_ind", "fval_ind", "exitflag_ind", "output_ind", "grad_ind", "hessian_ind");

function psi = nl_posterior(lnkf, lnCf, lnhf, lnks, lnCs, lnkappaT, lnell, data)
    %% DATA
    T = data.T;
    f = data.f;
    phi_obs = data.phi_obs;
    kappaD = data.kappaD;
    Xprobe = data.Xprobe;    

    %% PRIOR PARAMS
    mu_lnkf     = 4.14*ones(size(lnkf));      mu_lnks = 4.14*ones(size(lnks));
    mu_lnCf     = 0.9962*ones(size(lnCf));    mu_lnCs = 0.9962*ones(size(lnCs));
    mu_lnhf     = -1.93*ones(size(lnhf));
    mu_lnell    = 5.957*ones(size(lnell));
    mu_lnkappaT = 6.466*ones(size(lnkappaT));
    
    lnsigma_lnkf   = 0.5*log(1.197);  lnsigma_lnks = lnsigma_lnkf;
    lnsigma_lnCf   = 0.5*log(0.4305); lnsigma_lnCs = lnsigma_lnCf;
    sigma_lnhf     = sqrt(0.0345);
    sigma_lnell    = sqrt(0.503);
    sigma_lnkappaT = sqrt(1.806);

    %% PRIOR FUNCTIONS
    % Ψ(θ)
    psi_lnell = nln(lnell, mu_lnell, sigma_lnell, true);

    % Ψ(lnkf|θ1)
    psi_lnkf = nl_mvn_cov(lnkf, mu_lnkf, ...
        RBFKernel(T,T,lnsigma_lnkf,lnsigma_lnkf,lnell(1)));
    
    % Ψ(lnCf|θ2)
    psi_lnCf = nl_mvn_cov(lnCf, mu_lnCf, ...
        RBFKernel(T,T,lnsigma_lnCf,lnsigma_lnCf,lnell(2)));
    
    % Ψ(lnks|θ3)
    psi_lnks = nl_mvn_cov(lnks, mu_lnks, ...
        RBFKernel(T,T,lnsigma_lnks,lnsigma_lnks,lnell(3)));
    
    % Ψ(lnCs|θ4)
    psi_lnCs = nl_mvn_cov(lnCs, mu_lnCs, ...
        RBFKernel(T,T,lnsigma_lnCs,lnsigma_lnCs,lnell(4)));
    
    % Ψ(lnhf)
    psi_lnhf = nln(lnhf, mu_lnhf, sigma_lnhf);
    
    % Ψ(lnkappaT)
    psi_lnkappaT = nln(lnkappaT, mu_lnkappaT, sigma_lnkappaT);
    
    %% OTHER DETERMINISTIC PARAMS
    lnaf = log(72.4);
    lnas = log(13.2e-6);
    logitRf = -inf;
    logitRs = -inf;
    P = 1000;
    sx = 2;
    sy = 2;
    lnRth = -inf;
    Nx = 160;

    %% CALCULATE X_MAX
    Df = exp(get_val(lnkf)-get_val(lnCf)); % mm^2/s
    Ds = exp(get_val(lnks)-get_val(lnCs)); % mm^2/s
    Lthf = sqrt(reshape(Df,1,1,[]) ./ pi ./ reshape(f,1,1,1,1,[])); % um
    Lths = sqrt(reshape(Ds,1,1,[]) ./ pi ./ reshape(f,1,1,1,1,[])); % um
    x_max = max(10*max(sqrt(sum(Xprobe.^2, 2))), max(Lthf, Lths));

    %% LIKELIHOOD
    % Ψ(ϕ|x)
    T0tilde = ForwardModel("iso", "iso", true).solve( ...
        {lnkf}, {}, lnCf, lnaf, logitRf, lnhf, ...
        {lnks},  {},  lnCs, lnas, logitRs, [], ...
        lnRth, sx, sy, P, f, x_max, Nx, Xprobe ...
    );
    psi_nll = nll_phase(phi_obs, phase(T0tilde), exp(lnkappaT), kappaD, true);
    
    %% POSTERIOR
    psi = sum_nl_probs( ...
        psi_lnell, psi_lnkf, psi_lnCf, psi_lnhf, ...
        psi_lnks, psi_lnCs, psi_lnkappaT, psi_nll ...
    );
end