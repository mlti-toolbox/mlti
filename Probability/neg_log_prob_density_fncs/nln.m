function [psi,Jac] = nln(xi,mui,sigmai)
x = get_val(xi);
mu = get_val(mui);
sigma = get_val(sigmai);

% --- size check ---
lens = [numel(x), numel(mu), numel(sigma)];
lens = lens(lens > 1);
assert(isempty(lens) || all(lens == lens(1)), ...
    'Non-scalar inputs must have the same length.');

% --- core computation ---
diff = x - mu;
inv_sigma = 1 ./ sigma;
inv_sigma2 = inv_sigma.^2;

psi = 0.5 * (diff.^2 .* inv_sigma2) + log(sigma) + 0.5*log(2*pi);

% --- gradients ---
if nargout > 1
    grad_x = diff .* inv_sigma2;

    Jac = zeros(numel(psi), 0);
    Jac = addGradient(Jac, xi, @() grad_x);
    Jac = addGradient(Jac, mui, @() -grad_x);
    Jac = addGradient(Jac, sigmai, @() inv_sigma - (diff.^2) .* (inv_sigma.^3));
end
end