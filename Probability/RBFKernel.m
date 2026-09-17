function [K, Jac] = RBFKernel(X,Xp,sigmai,sigmapi,li)
if isa(X, "DesignVariable") || isa(Xp, "DesignVariable")
    error("Current implementation does not support DesignVariable type for X nor Xp.")
end

sigmai = reshape(sigmai, [], 1);
sigmapi = reshape(sigmapi, 1, []);

sigma  = get_val(sigmai);
sigmap = get_val(sigmapi);
l      = get_val(li);

if ~(isscalar(sigma) || numel(sigma) == size(X,1))
    error("sigma must be a scalar or have the same number of rows as X.");
end

if ~(isscalar(sigmap) || numel(sigmap) == size(Xp,1))
    error("sigmap must be a scalar or have the same number of rows as Xp.");
end

l2 = l*l;

% Pairwise squared distances
r2 = pdist2(X,Xp,'squaredeuclidean');

% Base kernel
E = exp(-r2/(2*l2));
K = (sigma * sigmap) .* E;

% --- Jacobian ---
if nargout > 1
    Jac = zeros(numel(K),0);
    Jac = addGradient(Jac, sigmai, @() sigmap .* E);
    Jac = addGradient(Jac, sigmapi, @() sigma .* E);
    Jac = addGradient(Jac, li, @() K .* (r2/l^3));
end
end