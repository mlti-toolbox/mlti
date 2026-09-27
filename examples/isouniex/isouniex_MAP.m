function isouniex_MAP(trialNum, x0)
options = optimoptions("fminunc", Display="iter-detailed", ...
    SpecifyObjectiveGradient=true, ...
    FiniteDifferenceType="central", ...
    StepTolerance=1e-10, FunctionTolerance=1e-10, ...
    MaxFunctionEvaluations=1e4);
data = load("isouniex_data_stats.mat");
data.kappa_mu = data.kappa_mu{trialNum};
data.mu = data.mu{trialNum};

checkpointDir = "checkpoints";
if ~exist(checkpointDir, 'dir')
    mkdir(checkpointDir);
end

resultsDir = "results";
if ~exist(checkpointDir, 'dir')
    mkdir(checkpointDir);
end

if nargin < 2
    %% LOAD DATA
    data_ws.f = data.f;
    data_ws.Xprobe = data.Xprobe;
    N = length(data.T);
    
    %% Initial Guess: x0 - Sample from Prior
    rng("shuffle");
    consts = load("isouniex_constants.mat");
    lnkf = normrnd(consts.mu_lnkf, consts.sigma_lnkf, 7, 1);
    lnCf = normrnd(consts.mu_lnCf, consts.sigma_lnCf, 7, 1);
    lnhf = normrnd(consts.mu_lnhf, consts.sigma_lnhf, 1, 1);
    lnks_perp = normrnd(consts.mu_lnks_perp, consts.sigma_lnks_perp, 7, 1);
    lnks_par = normrnd(consts.mu_lnks_par, consts.sigma_lnks_par, 7, 1);
    Os_theta = normrnd(0, deg2rad(20), 5, 1);
    Os_phi = pi*rand;
    Os1 = sin(Os_theta) .* cos(Os_phi);
    Os2 = cos(Os_theta);
    Os3 = sin(Os_theta) .* sin(Os_phi);
    lnCs = normrnd(consts.mu_lnCs, consts.sigma_lnCs, 7, 1);
    lnkappaT = normrnd(consts.mu_lnkappaT, consts.sigma_lnkappaT, 1, 1);
    lnell = normrnd(consts.mu_lnell, consts.sigma_lnell, 4, 1);
    
    %% WARM START
    err_ind = cell(N, 1);
    x_ind = cell(N,1);
    fval_ind = cell(N,1);
    exitflag_ind = cell(N,1);
    output_ind = cell(N,1);
    grad_ind = cell(N,1);
    hessian_ind = cell(N,1);
    for i = 1:N
        x0 = [lnkf(i); lnCf(i); lnhf; lnks_perp(i); lnks_par(i); lnCs(i); lnkappaT; Os1; Os2; Os3];
        data_ws.T = data.T(i);
        data_ws.mu = data.mu(:,i,:,:);
        data_ws.kappa_mu = data.kappa_mu(:,i,:,:);
        obj_fun = @(x) format4optim( ...
            @(xi) nl_posterior( ...
                xi(1), xi(2), xi(3), ...
                xi(4), xi(5), xi(6), xi(7), lnell, ...
                xi(8:12), xi(13:17), xi(18:22), data_ws ...
            ), x ...
        );
        [~, err_ind{i}] = checkGradients(obj_fun, x0, options, "Display","on");
        [ ...
            x_ind{i}, fval_ind{i}, exitflag_ind{i}, ...
            output_ind{i}, grad_ind{i}, hessian_ind{i} ...
        ] = fminunc(obj_fun, x0, options);
    end
    
    %% FULL OPTIMIZATION
    x = horzcat(x_ind{:});
    x = x.';
    x = [x(:,1); x(:,2); mean(x(:,3)); x(:,4); x(:,5); x(:,6); mean(x(:,7)); lnell];

    x0 = [lnkf; lnCf; lnhf; lnks_perp; lnks_par; lnCs; lnkappaT; lnell; Os1; Os2; Os3];

    save(fullfile(checkpointDir, "isouniex_MAP_results_warm_start_" ...
        + sprintf('%03d', trialNum) ...
        + "_" ...
        + string(datetime("now", Format="uuuuMMdd'T'HHmmss")) ...
        + ".mat"), "x0", "x", "err_ind", "x_ind", "fval_ind", ...
        "exitflag_ind", "output_ind", "grad_ind", "hessian_ind" ...
    );
    save(fullfile(resultsDir, "isouniex_MAP_results_" ...
        + sprintf('%03d', trialNum) ...
        + ".mat"), "x0", "x", "err_ind", "x_ind", "fval_ind", ...
        "exitflag_ind", "output_ind", "grad_ind", "hessian_ind" ...
    );

    x0 = x;
end

obj_fun = @(x) format4optim( ...
    @(xi) nl_posterior( ...
        xi(1:7), ...
        xi(8:14), ...
        xi(15), ...
        xi(16:22), ...
        xi(23:29), ...
        xi(30:37), ...
        xi(38), ...
        xi(39:43), ...
        xi(44:48), ...
        xi(49:53), ...
        xi(54:58), ...
        data ...
    ), x ...
);
[~, err] = checkGradients(obj_fun, x0, options, "Display","on");
[x,fval,exitflag,output,grad,hessian] = fminunc(obj_fun, x0, options);

save(fullfile(checkpointDir, "isouniex_MAP_results_" ...
    + sprintf('%03d', trialNum) ...
    + "_" ...
    + string(datetime("now", Format="uuuuMMdd'T'HHmmss")) ...
    + ".mat"), "x0", "x", "err", "fval", ...
    "exitflag", "output", "grad", "hessian" ...
);
save(fullfile(resultsDir, "isouniex_MAP_results_" ...
    + sprintf('%03d', trialNum) ...
    + ".mat"), "x0", "x", "err", "fval", ...
    "exitflag", "output", "grad", "hessian" ...
);
end

function psi = nl_posterior(lnkf, lnCf, lnhf, lnks_perp, lnks_par, lnCs, lnkappaT, lnell, Os1, Os2, Os3, data)
    %% DATA
    T = data.T;
    f = data.f;
    Xprobe = data.Xprobe;   
    Nx = 160;

    %% PRIOR PARAMS
    consts = load("isouniex_constants.mat");
    mu_lnkf         = consts.mu_lnkf         * ones(size(lnkf));
    sigma_lnkf      = consts.sigma_lnkf      * ones(size(lnkf));
    mu_lnCf         = consts.mu_lnCf         * ones(size(lnCf));
    sigma_lnCf      = consts.sigma_lnCf      * ones(size(lnCf));
    mu_lnhf         = consts.mu_lnhf         * ones(size(lnhf));
    sigma_lnhf      = consts.sigma_lnhf      * ones(size(lnhf));
    mu_lnks_perp    = consts.mu_lnks_perp    * ones(size(lnks_perp));
    sigma_lnks_perp = consts.sigma_lnks_perp * ones(size(lnks_perp));
    mu_lnks_par     = consts.mu_lnks_par     * ones(size(lnks_par));
    sigma_lnks_par  = consts.sigma_lnks_par  * ones(size(lnks_par));
    mu_lnCs         = consts.mu_lnCs         * ones(size(lnCs));
    sigma_lnCs      = consts.sigma_lnCs      * ones(size(lnCs));
    mu_lnkappaT     = consts.mu_lnkappaT     * ones(size(lnkappaT));
    sigma_lnkappaT  = consts.sigma_lnkappaT  * ones(size(lnkappaT));
    mu_lnell        = consts.mu_lnell        * ones(size(lnell));
    sigma_lnell     = consts.sigma_lnell     * ones(size(lnell));
    Qs              = consts.Qs;
    Okappas         = consts.Okappas;

    %% PRIOR FUNCTIONS
    % Ψ(θ)
    psi_lnell = nln(lnell, mu_lnell, sigma_lnell, true);

    % Ψ(lnkf|θ1)
    psi_lnkf = nl_mvn_cov(lnkf, mu_lnkf, ...
        RBFKernel(T,T,log(sigma_lnkf),log(sigma_lnkf),lnell(1)));
    
    % Ψ(lnCf|θ2)
    psi_lnCf = nl_mvn_cov(lnCf, mu_lnCf, ...
        RBFKernel(T,T,log(sigma_lnCf),log(sigma_lnCf),lnell(2)));
    
    % Ψ(lnks_perp|θ3)
    psi_lnks_perp = nl_mvn_cov(lnks_perp, mu_lnks_perp, ...
        RBFKernel(T,T,log(sigma_lnks_perp),log(sigma_lnks_perp),lnell(3)));

    % Ψ(lnks_par|θ3)
    psi_lnks_par = nl_mvn_cov(lnks_par, mu_lnks_par, ...
        RBFKernel(T,T,log(sigma_lnks_par),log(sigma_lnks_par),lnell(4)));
    
    % Ψ(lnCs|θ4)
    psi_lnCs = nl_mvn_cov(lnCs, mu_lnCs, ...
        RBFKernel(T,T,log(sigma_lnCs),log(sigma_lnCs),lnell(5)));
    
    % Ψ(lnhf)
    psi_lnhf = nln(lnhf, mu_lnhf, sigma_lnhf);
    
    % Ψ(lnkappaT)
    psi_lnkappaT = nln(lnkappaT, mu_lnkappaT, sigma_lnkappaT);

    % Ψ(O)
    psi_Os = cell(numel(Os1),1);
    for i = 1:length(Os1)
        psi_Os{i} = nl_Bingham_unnormalized([Os1(i);Os2(i);Os3(i)], Qs, Okappas);
    end

    %% OTHER DETERMINISTIC PARAMS
    lnaf = consts.lnaf;
    lnas = consts.lnas;
    logitRf = consts.logitRf;
    logitRs = consts.logitRs;
    lnRth = consts.lnRth;

    sx = consts.sx;
    sy = consts.sy;
    P = consts.P;

    %% CALCULATE X_MAX
    Df = exp(get_val(lnkf)-get_val(lnCf)); % mm^2/s
    Ds_perp = exp(get_val(lnks_perp)-get_val(lnCs)); % mm^2/s
    Ds_par = exp(get_val(lnks_par)-get_val(lnCs)); % mm^2/s
    Lthf = sqrt(reshape(Df,1,1,[]) ./ pi ./ reshape(f,1,1,1,1,[])); % um
    Lths = sqrt(reshape(max(Ds_perp, Ds_par),1,1,[]) ./ pi ./ reshape(f,1,1,1,1,[])); % um
    x_max = max(10*max(sqrt(sum(Xprobe.^2, 2))), max(Lthf, Lths));

    %% LIKELIHOOD
    % Ψ(ϕ|x)
    T0tilde = ForwardModel("iso", "uni", true).solve( ...
        {lnkf}, {}, lnCf, lnaf, logitRf, lnhf, ...
        {lnks_perp, lnks_par},  {Os1, Os2, Os3},  lnCs, lnas, logitRs, [], ...
        lnRth, sx, sy, P, f, x_max, Nx, Xprobe ...
    );
    psi_nll = nll_phase(data.mu, phase(T0tilde), exp(lnkappaT), data.kappa_mu, true);
    
    %% POSTERIOR
    psi = sum_nl_probs( ...
        psi_lnell, psi_lnkf, psi_lnCf, psi_lnhf, ...
        psi_lnks_perp, psi_lnks_par, psi_lnCs, psi_lnkappaT, ...
        psi_Os{:}, psi_nll ...
    );
end