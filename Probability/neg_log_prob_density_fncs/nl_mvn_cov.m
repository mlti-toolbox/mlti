function [psi, Jac] = nl_mvn_cov(xi, mui, Covi)

x   = get_val(xi);
mu  = get_val(mui);
Cov = get_val(Covi);

% --- Size checks ---
n = numel(x);

assert(isvector(x) && isvector(mu), ...
    'x and mu must be vectors.');

assert(all(size(Cov) == [n n]), ...
    'Cov must be n-by-n.');

x  = x(:);
mu = mu(:);

% --- Symmetrize covariance ---
Cov = 0.5*(Cov + Cov.');

% --- Cholesky factorization ---
[L,p] = chol(Cov,'lower');

if p ~= 0
    error('Covariance matrix must be positive definite.');
end

% --- Residual ---
r = x - mu;

% --- alpha = Cov^{-1} r ---
z = L \ r;
alpha = L.' \ z;

% --- Mahalanobis term ---
mahal = r.' * alpha;

% --- log determinant ---
logdetCov = 2 * sum(log(diag(L)));

% --- Negative log density ---
psi = 0.5 * (mahal + logdetCov + n*log(2*pi));
if nargout > 1
    Jac = zeros(numel(psi),0);
    Jac = combineJacobians(Jac, xi, @() sparse(1, xi.indx, alpha(:).', 1, xi.rootLen));
    Jac = combineJacobians(Jac, mui, @() sparse(1, mui.indx, -alpha(:).', 1, mui.rootLen));
    Jac = combineJacobians(Jac, Covi, @get_jac_C);
end
function JCov = get_jac_C()
    % Cov^{-1}, computed through Cholesky solves
    CovInv = L.' \ (L \ eye(n));
    
    JCov = 0.5 * (CovInv - alpha*alpha.');
    
    % Numerical symmetry
    JCov = (JCov + JCov.')/2;

    JCov = sparse(1, Covi.indx, JCov(:).', 1, Covi.rootLen);
end
end