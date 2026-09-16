function [psi, Jac] = nll_log_amp(lnA_obsi, lnA_predi, sigmaTi, sigmaDi)
lnA_obs = get_val(lnA_obsi);
lnA_pred = get_val(lnA_predi);
sigmaT = get_val(sigmaTi);
sigmaD = get_val(sigmaDi);

% --- size check ---
lens = [numel(lnA_obs), numel(lnA_pred), numel(sigmaT), numel(sigmaD)];
lens = lens(lens > 1);
assert(isempty(lens) || all(lens == lens(1)), ...
    'Non-scalar inputs must have the same length.');

% --- core computation ---
diff = lnA_obs - lnA_pred;
sigma = sqrt(sigmaT.^2 + sigmaD.^2);

inv_sigma = 1 ./ sigma;
inv_sigma2 = inv_sigma.^2;

psi = 0.5 * (diff.^2 .* inv_sigma2) + log(sigma) + 0.5*log(2*pi);

% --- gradients ---
if nargout > 1
    grad_x = diff .* inv_sigma2;

    grad_sigma = inv_sigma - (diff.^2) .* (inv_sigma.^3);

    grad_sigma_inv_sigma = grad_sigma .* inv_sigma;

    Jac = zeros(numel(psi), 0);
    Jac = addGradient(Jac, lnA_obsi,      @()  grad_x);
    Jac = addGradient(Jac, lnA_predi,     @() -grad_x);
    Jac = addGradient(Jac, sigmaTi, @()  grad_sigma_inv_sigma .* sigmaT);
    Jac = addGradient(Jac, sigmaDi, @()  grad_sigma_inv_sigma .* sigmaD);
end
end