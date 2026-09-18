function [K, Jac] = RBFKernel(X, Xp, lnsigmai, lnsigmapi, lnli)

if isa(X, "DesignVariable") || isa(Xp, "DesignVariable")
    error("Current implementation does not support DesignVariable type for X nor Xp.")
end

lnsigmai  = reshape(lnsigmai, [], 1);
lnsigmapi = reshape(lnsigmapi, 1, []);

lnsigma  = get_val(lnsigmai);
lnsigmap = get_val(lnsigmapi);
lnl      = get_val(lnli);

if ~(isscalar(lnsigma) || numel(lnsigma) == size(X,1))
    error("lnsigma must be a scalar or have the same number of rows as X.");
end

if ~(isscalar(lnsigmap) || numel(lnsigmap) == size(Xp,1))
    error("lnsigmap must be a scalar or have the same number of rows as Xp.");
end

% Length scale
l2 = exp(2*lnl);

% Pairwise squared distances
r2 = pdist2(X, Xp, 'squaredeuclidean');

% Log kernel
lnK = lnsigma + lnsigmap - r2/(2*l2);

% Kernel
K = exp(lnK);

% --- Jacobian ---
if nargout > 1
    Jac = zeros(numel(K), 0);

    % dK / d(ln sigma)
    Jac = addGradient(Jac, lnsigmai, @() K);

    % dK / d(ln sigma')
    Jac = addGradient(Jac, lnsigmapi, @() K);

    % dK / d(ln l)
    Jac = addGradient(Jac, lnli, @() K .* (r2/l2));
end

end