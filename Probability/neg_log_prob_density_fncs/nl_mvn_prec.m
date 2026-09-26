function [psi, Jac] = nl_mvn_prec(xi, mui, Preci)

x    = get_val(xi);
mu   = get_val(mui);
Prec = get_val(Preci);

% --- Size checks ---
n = numel(x);

assert(isvector(x) && isvector(mu), ...
    'x and mu must be vectors.');

assert(all(size(Prec) == [n n]), ...
    'Precision matrix must be n-by-n.');

x  = x(:);
mu = mu(:);

% --- Symmetrize precision ---
Prec = (Prec + Prec.')/2;

% --- Cholesky factorization ---
[L,p] = chol(Prec,'lower');

if p ~= 0
    error('Precision matrix must be positive definite.');
end

% --- Residual ---
r = x - mu;

% --- alpha = Prec*r ---
alpha = Prec*r;

% --- Mahalanobis term ---
mahal = r.' * alpha;

% --- log determinant of precision ---
logdetPrec = 2 * sum(log(diag(L)));

% --- Negative log density ---
psi = 0.5 * (mahal - logdetPrec + n*log(2*pi));

if nargout > 1
    Jac = zeros(numel(psi),0);

    % d psi / d x
    Jac = combineJacobians(Jac, xi, ...
        @() sparse(1, xi.indx, alpha(:).', 1, xi.rootLen));

    % d psi / d mu
    Jac = combineJacobians(Jac, mui, ...
        @() sparse(1, mui.indx, -alpha(:).', 1, mui.rootLen));

    % d psi / d Prec
    Jac = combineJacobians(Jac, Preci, @get_jac_P);
end

function JPrec = get_jac_P()

    % Prec^{-1}, computed through Cholesky solves
    PrecInv = L.' \ (L \ eye(n));

    % d psi / d Prec
    JPrec = 0.5 * (r*r.' - PrecInv);

    % Numerical symmetry
    JPrec = (JPrec + JPrec.')/2;

    JPrec = sparse(1, Preci.indx, JPrec(:).', ...
        1, Preci.rootLen);
end

end